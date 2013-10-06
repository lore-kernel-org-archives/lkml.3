Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab3JFG0Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 02:26:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:29447 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab3JFG0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 02:26:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1042,1371106800"; 
   d="asc'?scan'208";a="303745544"
Date: Sun, 6 Oct 2013 11:04:10 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Dan J Williams <dan.j.williams@intel.com>, vinod.koul@intel.com
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20131006053410.GF2954@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Here is the slave dmanegine fixes. We have the fix for deadlock issue on im=
x-dma
by Michael and Josh's edma config fix along with author change

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:
  Linus Torvalds (1):
        Linux 3.12-rc1

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Josh Boyer (2):
      edma: Update author email address
      dma/Kconfig: Make TI_EDMA select TI_PRIV_EDMA

Michael Grzeschik (3):
      dmaengine: imx-dma: fix slow path issue in prep_dma_cyclic
      dmaengine: imx-dma: fix lockdep issue between irqhandler and tasklet
      dmaengine: imx-dma: fix callback path in tasklet

 drivers/dma/Kconfig   |    1 +
 drivers/dma/edma.c    |    2 +-
 drivers/dma/imx-dma.c |   31 +++++++++++++++----------------
 3 files changed, 17 insertions(+), 17 deletions(-)

Thanks
~Vinod
--=20

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSUPZSAAoJEHwUBw8lI4NHm9YP/iGb6KqUwWr8Opc70K3iy1Wp
+WYzSoPNC3elVsjxMTF0kpzgbH60a2hDSahjFEaJuciFldfv++pImlj70sEYnUV4
iT/E8TU07qOrggpFvEkbUkXamgYQYrMaw6xGDwQouMZBmk6g9dzyCJGqth9G63yQ
Yf1UDfjsjgPlk2JPjTNeUMjWPbBMmv+NQ8u98tgRwIeXKovK1V1WjWzRasdvAGS1
D9axDxP3DhGTjENaFY82VFqqc+1F3o9xGoycSGDYvh0gntAw9Oh1xFmXNcpVCH5T
3EspsIUYEQfu3reT+bZTwDzyDqPtcCVFkcoXAQSHjGCn7zgDOgD2Y6F/0CeXgFQc
+8FcPJZ8wX7v4DT2+U/zmxZILCY8c7PuT8PUn68wYlQUbMz7+CKxzawj5HDw67qh
LY3DDsm54tVpag9Ww8O95wsL4K8vWBP2rNKVhgZ8jOLGjZPnKyL+RuAoC+979fT2
jgrFoGx7esPAmQLfmaHDC+7zAoNOUlaVoRFQXgMHZ2NNVWvcHOtpduDafAyITyQb
s6LI2w0r7pINGWQIrk7aVVCKyO/UKjqZxm3oBVGrtfPmDT4QEusWY2YewsrrmPuP
qA2c5Um5G/kYKUMIXRg+AEodtvfSJe9Oc9BX/jXJ82SFJHBKdc3nJWSWzMujiaSu
nBoeLfdziHWwIMiQkz2C
=WyCn
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
