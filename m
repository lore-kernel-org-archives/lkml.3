Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab3CAFGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:06:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:63303 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab3CAFGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:06:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,759,1355126400"; 
   d="asc'?scan'208";a="293403380"
Date: Fri, 1 Mar 2013 10:36:28 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus <torvalds@linux-foundation.org>
Cc: Dan Williams <djbw@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <ArndBergmann@intel.com>, Matt Porter <mporter@ti.com>
Subject: [GIT PULL] slave-dmaengine updates 2
Message-ID: <20130301050628.GD28537@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Here is my second pull request for this merge window.

The Arnd's patch moves the dw_dmac to use generic DMA binding. I agreed to merge
this late as it will avoid the conflicts between tree's.

The second patch from Matt adding a  dma_request_slave_channel_compat API was
supposed to be picked up, but somehow never got picked up.  Some patches
dependent on this are already in -next :(

Thanks
~Vinod

The following changes since commit 17166a3b6e88b93189e6be5f7e1335a3cc4fa965:
are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git next

Arnd Bergmann (1):
      dmaengine: dw_dmac: move to generic DMA binding

Matt Porter (1):
      dmaengine: add dma_request_slave_channel_compat()

 Documentation/devicetree/bindings/dma/snps-dma.txt |   70 +++++-----
 drivers/dma/dw_dmac.c                              |  145 ++++++++++----------
 drivers/dma/dw_dmac_regs.h                         |    7 +-
 include/linux/dmaengine.h                          |   16 ++
 include/linux/dw_dmac.h                            |    5 -
 5 files changed, 127 insertions(+), 116 deletions(-)

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJRMDdUAAoJEHwUBw8lI4NH7WIP/2VkzHYGLCV/jr9PlkoflYyW
V5jcupO/ijOw/mim+66XNfm/0PaGvlcyrJe+5gHRwHLGZjhege+QDh3hdnVpTU82
5cesL/aMGZeXHJ3pekQdnLf26kmex2VvStmWeCTl73CxV23/YfEXErTChiJ07gMN
nXK/dSwK8J72Vp9HUTkaEsjEf3i9A60PVfAyE8l8ADExjAOuDe+6Gr4OPCeZd1Yb
kVwZi44tCCD3/v8FznurYpLEx4nRPffc/3M3u9r7OvFLFxVe3y4XvXbkoO2Ek4s9
Xl8tORoZuI7Ez1ydIvBmudX4qtQQ8wPDFbkMEm0qUyEizybUkTcJirFSPWeZGbcj
EV0B4PUj656cRErrDGg2RiX1/nh8xK0524jvjUrqb7LBjH460I+gOIca1hRMNoZL
qZlwieqO9nDjRwcfaJ0cywWCvQwoTjwjX4KmE+f0IYLq+e9p7fQguRbDKUu+TZ5o
Y4JZQyil/Ze+FwI2e3ZwqMNcXQU8h1LhlgLRiqoCyhtENpJM+lmigYikslPmur30
mdDr1AjaFt/TMaKd/StW5ZgzyZzzKiELywrdiqgMd7Dimhp1UjLKIvbgxwRCWRBF
kZye2wHENsh6kHM+BvOEH0zN8IIS072uP9IwZqqe2aBT6PusQjylebG+xRPWp2oK
7uOkhK+A8Q8oZ41lcgLf
=2ZSg
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
