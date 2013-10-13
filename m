Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3JMPYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 11:24:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:58755 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab3JMPYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 11:24:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,485,1378882800"; 
   d="asc'?scan'208";a="374123628"
Date: Sun, 13 Oct 2013 20:01:33 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dan <dan.j.williams@intel.com>,
        vinod.koul@intel.com
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20131013143133.GF2954@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q0rSlbzrZN6k9QnT"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q0rSlbzrZN6k9QnT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Another week, time to send another fixes request taking time out of extended
weekend for the festivities in this part of the world.

We have two fixes from Sergei for rcar driver and one fixing memory leak of=
 edma
driver by Geyslan

The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:
  Linus Torvalds (1):
        Linux 3.12-rc4

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Geyslan G. Bem (1):
      dma: edma.c: remove edma_desc leakage

Sergei Shtylyov (2):
      rcar-hpbdma: remove shdma_free_irq() calls
      rcar-hpbdma: add parameter to set_slave() method

 drivers/dma/edma.c           |    1 +
 drivers/dma/sh/rcar-hpbdma.c |    9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

Thanks
~Vinod
--=20

--Q0rSlbzrZN6k9QnT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSWq7EAAoJEHwUBw8lI4NH2LsP/32fAD3R+aGoHfLflke88EAv
2DNtj1jvEzEoQQjfJ2Bv7fAkEbRLnLnU/5mzj+i/OmgmhaN3V56MlH5TOZcHVPUu
E9+Ngoq2p6ahDyewttQsA9lcagIZCfpzsYCcl9+EwTrUFVzWQq2iTr0rM1Hgq6aX
FPn+mmuOHI9U15HfitYnRZpH9XZXTTnGT2LzlpxkTiEDF3SUiR7z74hsb+Feo5RX
7LNKSzBA7AfRvJiOsr0y3KSGjodHTcl3KMhj7gjwhnbDapTeN+dDwbZlzu0gpoFd
uM36VMKiPJqqY2NUTIAZex8sngdD8t0Cc50P+FsuCDuSVZ5x5FOBADsPlRjUgLXU
8Ame+89jUcpSrc+o5RP21XySXY1bAiooawIEsPE+ozRuXh8wpsy3jyzqYHWvHPZ1
JYilFTviCzAHKGD641d12sfa98K0xGBld5nCXipuYeQ9E0uk5gdq8UcJ5IUqp65/
F3yNczrcrqd947Y4Qvv8XI7g3l6KKuqXbkGjqNkzDjnpwy+BsBsuL5w/VoF7s8WP
2orXAc2V9uJaj27GcvtOP8RTa9QKywJGrvvgHUaTL9/ZdHylKOkwox+VXlAOGvU+
dBhIUJuCMrwGdirzxiaVEwnP8zkL5gYKi0wSVLQAPuai8tjin+DREQvW7f/fXbWg
QmWu8nbLBZ/a0+l15w7F
=B/od
-----END PGP SIGNATURE-----

--Q0rSlbzrZN6k9QnT--
