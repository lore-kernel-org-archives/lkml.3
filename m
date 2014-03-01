Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaCARCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 12:02:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:16484 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbaCARCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 12:02:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,568,1389772800"; 
   d="asc'?scan'208";a="492178067"
Date: Sat, 1 Mar 2014 22:29:08 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        dma <dmaengine@vger.kernel.org>
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20140301165908.GH10628@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gj572EiMnwbLXET9"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gj572EiMnwbLXET9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hey Linus,

This request brings you two small fixes. First one for fixing dereference of
freed descriptor and second for fixing sdma bindings for it to work for imx=
25.

I was planning to send this about 10days ago but then I had to proceed on my
paternity leave and didnt get chance to send this. Now got a bit of time fr=
om dady
duties :)

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:
  Linus Torvalds (1):
        Linux 3.14-rc2

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Linus Walleij (1):
      dma: ste_dma40: don't dereference free:d descriptor

Markus Pargmann (1):
      dma: sdma: Add imx25 compatible

 .../devicetree/bindings/dma/fsl-imx-sdma.txt       |   16 ++++++++++------
 drivers/dma/imx-sdma.c                             |    1 +
 drivers/dma/ste_dma40.c                            |    4 +++-
 3 files changed, 14 insertions(+), 7 deletions(-)

--=20
Thanks
~Vinod

--gj572EiMnwbLXET9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJTEhHbAAoJEHwUBw8lI4NH0qkP/RO99JKPSSPi1vQl+tYN2/ws
P/SQCZRC2KKAcYHylIp7F68O0Zr9/pjm8ZU/srUBkjL8raKovk1j3nq6qES3X/sv
iEGlzCwafO5j2sfBdngr2LNMtbY9lcXc4cwrdZ5cXV1LcgyDiUOiYlgHVRpC8k1I
nXLauY810wukpoeYr8ChFut6JscJJ1TseEppR+67yPwEN0AhKuco+dvMcBywe8iq
N0QntM1CA2LxgtQdjY7wFTjwKs8bhv2pLKHnhMrIKNd/mq7pFGWHnpA1U1+UWMwt
BKKqeh/QO0A4gfVFe0lYd4/xKuaIFvP7H6KWuxbKV7b81lp6n+P4M5thVY8ujRFO
nGa5tOZ1qHtPUDAtYfx0/PlQqXHVWDHW2VFKTzTL1/GNST1XdaQTFRXptElGVZR7
pF8e0LTrWEIzlaOJ+OcU05216x+3njiXzbEOvI6yRTWjlu6P/DzcUdPSIwbmJHyO
1mRtH0pFCDOjlpMbhCcwMe+heIL/2MbczTq//mgENptrOoJnjLonkHs+PBGKGUu4
ZJdHOz/HWuqDZkJRrwcyy9fMWrXiJBJKCJOClEYQiEfE309LoiASTI+rpklsWhsJ
hXEWf9+LlV909u2ymguu46ce3AhduGJP1yzhhVGhzvRDJI+EIFkrj/AlWfulmRjH
CXJHQgajIcZf33pnpTzQ
=xaa5
-----END PGP SIGNATURE-----

--gj572EiMnwbLXET9--
