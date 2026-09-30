PORTNAME=	bagatto
PORTVERSION=	0.9.0
DISTVERSIONPREFIX=	v
CATEGORIES=	www

MAINTAINER=	dave@freedave.net
COMMENT=	static site generator written in Janet
WWW=		https://bagatto.co/

LICENSE=	BSD3CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE.md
BUILD_DEPENDS=	jpm>=1.2.0:lang/jpm
USE_GITHUB=	nodefault

PLIST_FILES=	bin/bag

# define variables here
.include "${.CURDIR}/Makefile.jpm"

# git.sr.ht not yet part of Mk/bsd.sites.mk
.for account project tag subdir in ${SRHT_TUPLE:S/:/ /g}
MASTER_SITES+=	https://git.sr.ht/~${account}/${project}/archive/${tag}${EXTRACT_SUFX}?dummy=/:${account}_${project:S/-/_/g}
DISTFILES+=	${account}-${project}-${tag}_SRHT0${EXTRACT_SUFX}:${account}_${project:S/-/_/g}
.endfor

# This is so that you can patch anything you need to, not just main source
PATCH_WRKSRC=	${WRKDIR}

# It is really common for Janet modules that are wrapping C code to have a
# git sub-tree for those C libraries. This loops over the sub-trees and
# gets fetched code symlinked in place.
post-extract:
.for st in ${JPM_SUBTREE}
	# first remove the link at the destination, then link in the subtree
	# remember these are file paths, '|' is separator
	${RMDIR} ${WRKDIR}/${st:C|^[^:]+:||}
	${LN} -sf ../${st:C|:[^:]+\$||} ${WRKDIR}/${st:C|^[^:]+:||}
.endfor

do-build:
.for mod in ${JPM_BOM}
	cd ${WRKDIR}/${mod} && ${LOCALBASE}/bin/jpm --tree=${WRKSRC}/jpm_tree "install"
.endfor

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/jpm_tree/bin/bag ${STAGEDIR}${PREFIX}/bin

do-test:
	cd ${WRKSRC} && jpm test -l

.include <bsd.port.mk>
