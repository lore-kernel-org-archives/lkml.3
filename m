Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3JZEqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 00:46:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:54126 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab3JZEqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 00:46:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="asc'?scan'208";a="380266906"
Date: Sat, 26 Oct 2013 09:22:25 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        dma <dmaengine@vger.kernel.org>
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20131026035225.GE21230@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus

Here is the late fixes pull request for dmaengine while you fly back from KS. We
have a new dmaengine ML hosted by vger so a patch for that along with addition
of Dave as driver mainatainer for ioat.  Other fixes are memeory leak fixes on
edma driver, small fixes on rcar-hpbdma driver by Sergei.


The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:
  Linus Torvalds (1):
        Linux 3.12-rc4

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Dave Jiang (1):
      MAINTAINERS: add to ioatdma maintainer list

Geyslan G. Bem (1):
      dma: edma.c: remove edma_desc leakage

Sergei Shtylyov (2):
      rcar-hpbdma: remove shdma_free_irq() calls
      rcar-hpbdma: add parameter to set_slave() method

Valentin Ilie (1):
      dma: edma: Fix memory leak

Vinod Koul (2):
      MAINTAINERS: add the new dmaengine mailing list
      dmaengine: edma: fix another memory leak

 MAINTAINERS                  |    7 ++++++-
 drivers/dma/edma.c           |    3 +++
 drivers/dma/sh/rcar-hpbdma.c |    9 +++++----
 3 files changed, 14 insertions(+), 5 deletions(-)

--
Thanks
~Vinod

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSazx5AAoJEHwUBw8lI4NH6S8P/jzXo5bvzG9wOB/dvpgaTUTN
/v6oXY+yiANKDrQtZv0VWhDzO16zZe+eMYcAr9NlKfCg/3+L3yl7xkXO45ShuXxf
/Yl3+dIxjHl4cXdkPPANSOvXyeIX/wwfK8ez+OenK6rQJX9LyMHvLdwpB6tbVzUg
n34ecb6LMfsXncjGzYFSrNagC5HZWJTWQw1Hy3kF5LpXyPsHAJTFJ4bUEs2bY4d8
vENBcKHwxrNWSDnel4dL+jnXBT5v9RYM4SWyxx3Sn6tgQEUX+Gk1/gwumkibLO/Y
Y4WZ5O3cguFcA1sKyAPrT4qurWrkBKJTMP9mtxGiG1TBPsJ3BcG9WFnz6Nc7nWzQ
IprEUL/KMDURZLTqXAtMEL3jJWsI2u9O3Nfldo0GpWH5fdCGW75lZFvKdNnza/43
+VIsLE2hHHpnPXZt5cIvh5HlFrBWvyiVPYbOmAAN/5pz2QSHUPZTpq6xA30jfNUR
jluITi40Pqu8fuiv2vwbc9TdKcyrfAbue8yVyPpohV9+ioi94zgsDIxfupUQ1mVS
QVWH2xBfp5QP1Bhg2a3yaEGkQV/o5o7n8Ts9bXIfCnL7mL4Va6kns/iD+ZIkjtV9
ML65wFCwHLsNF0dvO/kuieLD4L6o7bqQy+Kju3SnA/xVa7K2wHdBPPxfjgNlSiOF
0oo7An8+yaqYxiwNZd1E
=zuW0
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
