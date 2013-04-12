Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab3DLCZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 22:25:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:56057 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab3DLCZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 22:25:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,460,1363158000"; 
   d="asc'?scan'208";a="321189829"
Date: Fri, 12 Apr 2013 07:26:27 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dan Williams <djbw@fb.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20130412015627.GB12436@intel.com>
Reply-To: vinod.koul@intel.com
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull the following two patches to recive the fixes for slave-dmaengine
The first one fixes issue in pl330 to check for DT compatible and second one
fixes omap-dma to start without delay

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Padmavathi Venna (1):
      DMA: PL330: Add check if device tree compatible

Peter Ujfalusi (1):
      dmaengine: omap-dma: Start DMA without delay for cyclic channels

 drivers/dma/omap-dma.c |   20 ++++++++++++++------
 drivers/dma/pl330.c    |   38 +++++++++++++++++++++++++++-----------
 2 files changed, 41 insertions(+), 17 deletions(-)

--
~Vinod

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJRZ2nLAAoJEHwUBw8lI4NH5y0QAI9iXeVoqvxMOnFBa3j9Wf4K
1Ytdh/4V2ikdzk8bJBPgtedLS0fMqoYmWTk5V8J0LLIARCqkJc+Aj218duOmnDI3
JY6FOAxvRIqkhoeuibzCRie7Z+godS7+iUo3x7slcnp7pt9zKPfxw8HQgibxJzQQ
OpsPrXN7rEEoKzGoMl9PMfFqCLVnVzeKQ3MXhJQ3hr7Gk/YvUMVPVfxg8LaIw/5G
5z6thndaZZTj1BgsFf21NHu+PzSnrxc+wgAKs7iApVuYuYi27XyTZYVGDMalRNLJ
rMSLjb8whbkeGX8+7lmBjxhzO+HMJv8Ql0+hhOaR+ngwx/I6Kb25QDrKGgBypOwa
/4NSot9yde4MeRX8G23tkbuuhtS37tNLW3jIeIRVDqit7GOOtnOtOgD0w7uUqBZo
CSnYk4kBFmKlA9tzV+k78SuLxT3ogwIX6BuGxOIsALA4LSvWCnS1Fz3qhDSbkK7H
D87rynSOh/K/BMujfrFPnW/5Ug66oZc9/TDLlavxdRDN0fpcBI5BklAHeikkeHGb
xvotp+pBp2MvBxiMUsAOAg0iW1HMa9J32hkfuenPZsT9wttN0zYlg55KENa2KKT8
4uEIa9fo/BE2d2SPKSKFuDULqCv/tQMeRg2mDPNUzo8p7ylkdyJWligGGQOC5T6X
/Cfda106rINBh9Zspj+D
=GRTP
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
