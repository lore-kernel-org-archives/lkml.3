Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab3LMFcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 00:32:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:52354 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab3LMFcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 00:32:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,477,1384329600"; 
   d="asc'?scan'208";a="423996715"
Date: Fri, 13 Dec 2013 10:03:33 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, dma <dmaengine@vger.kernel.org>
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20131213043333.GQ29580@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here is the common fixes PULL for dmaengine. Dan has been working on fixing=
 the
build issues in bunch of drivers. Here we have one fixing s3c24xx-dma, along
with fix from Russell on pl08x. Also we have Kuninori rcar dma fixes. The
s3c24xx-dma which was added in last merge window missed updates to usage of
DMA_COMPLETE so converting the last driver

Thanks
~Vinod

--

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:
  Linus Torvalds (1):
        Linux 3.13-rc1

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Dan Williams (1):
      dma: fix build breakage in s3c24xx-dma

Kuninori Morimoto (3):
      rcar-hpbdma: add max transfer size
      rcar-hpbdma: fixup channel busy check for double plane
      rcar-hpbdma: initialise plane information when halted

Russell King - ARM Linux (1):
      Fix pl08x warnings

Sachin Kamat (1):
      dmaengine: s3c24xx-dma: use DMA_COMPLETE for dma completion status

Wei Yongjun (1):
      dma: mmp_pdma: add missing platform_set_drvdata() in mmp_pdma_probe()

 drivers/dma/amba-pl08x.c     |    2 +-
 drivers/dma/mmp_pdma.c       |    1 +
 drivers/dma/s3c24xx-dma.c    |   33 ++-------------------------------
 drivers/dma/sh/rcar-hpbdma.c |   11 ++++++++++-
 4 files changed, 14 insertions(+), 33 deletions(-)

--=20

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSqo4dAAoJEHwUBw8lI4NHhzoP/ilnTRDtgSatGcd1uSGGyRX4
PmD93hBr8Ch2SMwCh7CM82fcnIFZqMIc0cE3jOZuWZ1Sae0wZvNNDtR7KefUnwET
kHhBb8vUHALnKHU84wIK/3GA1H89sCq7ywOUCzeLeJ0qWSdBvZ/+cipI1oyH2gU3
w9kd/oJXBxa3+kstK0RxuaP1iAQKc44/ZD9asBmW+CBfxV9GGTFSNtodQilPdlM5
2q9BL1YGkBmUjRdU2EiTfXsMR6zftvgTyXDKo900W8bZdtqB1kBvV3AQt0x8U7Yh
7dcY4hv6PvfyU4BavEqPse+LWUzi4hCtecKUUfF95hvWGxzBVCBmm1S/0f+68xsb
taQ4QmHfMhiTgoX0FPQeBNVpORtcoJ2vaN1ee1ipLHXKkHhnPeUnu1IFHN5etb52
m52CdGR5g7uqyu8yLae2Badfm5Hq4SjrGcxaCBL845XonTOb+uDghk2TZL2IMqL8
uT0ytmgVQwpnmdNhbe4c9TCXRngb0Ugf0FDbEOA4PkwCC38HdJkHM2VdN5ch85zN
XSiQhF1u9kAhHyqEleXG0R7+409YM31ilyEkay18NC+GTNDo9eK90/NUQesDdhOb
ykUm0DejFnqyByrEj7nF8tsko7m+b6vXMWXOIklmGKF4J6/57N1GQCg3g2yZX1ln
8qr1T+TKo7/wSA3tpYAf
=u4Yd
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
