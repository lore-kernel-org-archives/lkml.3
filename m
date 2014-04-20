Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbaDTPCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 11:02:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:45664 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201AbaDTPCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 11:02:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,892,1389772800"; 
   d="asc'?scan'208";a="524314881"
Date: Sun, 20 Apr 2014 20:22:00 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, dma <dmaengine@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20140420145200.GV32284@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Back from long weekend here in India and now the time to send fixes for sla=
ve
dmaengine.
 - Dan's fix of sirf xlate code
 - Jean's fix for timberland
 - Edma fixes by Sekhar for SG handling and Yuan for changing init call


The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:
  Linus Torvalds (1):
        Linux 3.15-rc1

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Dan Carpenter (1):
      dmaengine: sirf: off by one in of_dma_sirfsoc_xlate()

Jean Delvare (1):
      platform: Fix timberdale dependencies

Sekhar Nori (1):
      dma: edma: fix incorrect SG list handling

Yuan Yao (1):
      dma: fix eDMA driver as a subsys_initcall

 drivers/dma/Kconfig            |    2 +-
 drivers/dma/edma.c             |    6 ++++--
 drivers/dma/fsl-edma.c         |   12 +++++++++++-
 drivers/dma/sirf-dma.c         |    2 +-
 drivers/media/platform/Kconfig |    2 +-
 5 files changed, 18 insertions(+), 6 deletions(-)

--=20
Thanks
~Vinod

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJTU98QAAoJEHwUBw8lI4NHGz8QAI3yU9KyuVEo2NQgf30GM7Qx
fJQDYHHMiz4le+mbKhyP0eJ4aUZLAwZg0kZWglqNmq6ChbZIJ7PAyTamq+C5dyI0
yaXaqjEr72Ongm9zmDMdGSergdhMwHzUSYTPvQOc6hFCKu5ZX7SKDdFZPfvG3l59
0/47Q+ZWUWmjVPu5pp/+90rMH39n5fpJwre8vC5lDviPKEXsPpgSG3T01KOzYFzG
xzo9cLn2ARXZ37fGbxLR7y9mWLRp+DuNzs5+PBvXoaypzV4kR6Gt0aWSns6rVVF3
bq6uoGDRiQmY05j4gVXGT5Wb5/fAU8tvwP+twiyPUygt8jVXE+FXl4G+jitYMnTF
K/7klm/ENiOJil1eii+Xg473MpfkYBrjjZ500sXOFBYFWTi6MZTeccr7hTz/Mcek
pEttxfIsnVCApkD2OgPT9SWmxyO+6qi6LcwPsbvwZz9wbesWRoYvxTVRr+EcIA+1
FkBQJHh/m+TgJ3vaYfOLHH3UD8NBRIQhYluoUp+FxEPeMTkueFTGGJohXgSGFE8y
NmyMMP6dGjjgqTmHDJ7DckaychwW+RSEvw7ZlU3JhcVS6xhsohFg/LhuGQ+tLXwj
7BH+Oqrc8JOqcodtRLMQvSr7UMSeWxG0E0vVqMclb26bor9q22JqyI3jKcAAUmpi
mxy2uDd+02qEojCiEpnu
=PUPe
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
