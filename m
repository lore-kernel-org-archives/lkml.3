Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaE1SYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:24:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44845 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaE1SYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:24:22 -0400
Date: Wed, 28 May 2014 14:24:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: [GIT PULL] (xen) stable/for-jens-3.16
Message-ID: <20140528182414.GA22931@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Dear Jens,

Please git pull the following branch:

git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-jens-3.16

which has a bunch of fixes to the Xen block frontend and backend driver
and a new parameter for Xen backend driver - an override (set by the toolstack)
whether to expose the discard support (if disk of course supports it) or not.

 drivers/block/xen-blkback/common.h |  4 +--
 drivers/block/xen-blkback/xenbus.c | 53 ++++++++++++++++++++++++++++----------
 drivers/block/xen-blkfront.c       | 40 ++++++++++------------------
 include/xen/interface/io/blkif.h   |  2 +-
 4 files changed, 57 insertions(+), 42 deletions(-)

Olaf Hering (3):
      xen-blkfront: remove type check from blkfront_setup_discard
      xen/blkback: disable discard feature if requested by toolstack
      xen blkif.h: fix comment typo in discard-alignment

Valentin Priescu (1):
      xen-blkback: defer freeing blkif to avoid blocking xenwatch



--wac7ysb48OaltWcw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJThinIAAoJEFjIrFwIi8fJTPwH/jrk8+o0cltrBnaXvFjXcn71
J/FiZtjf8eLgi0Ur/AXMbGbviFY/++Nc1wBqma0+3rrypGGSci+hRMQJAa7s19xO
fveysiwTpDK2/pgm9sh+dV/etKya5veFZxisZ7JsR62T17DhhkjQSWMHvjCXgBye
V0QhKU20xLrs4j23Ua/5mqg2/8278/LtspGB71U/Ey8FAlNfrEMoJ/USB3Mmo54j
CAQZ5FzqZqKLbDsAUnvsj7lOtPOCocnQ6TKpTfoKGo7BsjjlHfodP+V65Qm06+ty
W7+MO6mgdB+B8toqN69ZouXjv5scQBCSwfDMEFBFA0q3jiTDvjgZQI/tACiuGMY=
=GA/T
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
