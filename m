Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab3KEQ7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:59:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46258 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3KEQ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:59:14 -0500
Date: Tue, 5 Nov 2013 11:59:08 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-jens-3.13
Message-ID: <20131105165908.GA405@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hey Jens,

Please git pull the following branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.13


which has a fix to the Xen block frontend driver. For the backends that
don't support persistent grants, we don't want to use the logic that would
use copying (needed for persistent grants). That logic existed there initially
but with the persistent grants code added in - it was removed (so in 3.10
time-frame). This adds part of it back.

Please pull!

P.S.
Sorry for the late pull!

 drivers/block/xen-blkfront.c | 125 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 100 insertions(+), 25 deletions(-)

Roger Pau Monne (1):
      xen-blkfront: restore the non-persistent data path


--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQEcBAEBAgAGBQJSeSPQAAoJEFjIrFwIi8fJcvgH/2QNuUivV8m2eRUJ+ZpXjaIO
ej7Q9gWC9kJfxxnevSE385gIR4X/3JmdH/dcRtv54LNjpD/DREuPHkcNyFSXuyVG
j6RxIBKH0lQBZUVFkbV8vZDJmGlnLgWmx7v/p9xD00NBaQqnucW1xa8+YQ0vSEqi
HwZy6dhjTfE7QybvDJeCmWLQr9z4ikY+KH44vbXFsGbGWvtCFE0kr5/8lQcM01yZ
Ug2NfXEVa42fsdE4WL+xBo6wGpaDpfnEssSbpZc5f7/mthAVIQE4sjACBsKL8kz3
vDXgtHdMBh5fAst3NXJorz6Q0TB3uqcR7vEDVQurCBuQJhQQpULLyCrC/h39Z6Y=
=NhoT
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
