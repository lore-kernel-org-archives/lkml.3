Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab3CaSO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 14:14:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:40393 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab3CaSO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 14:14:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,383,1363158000"; 
   d="asc'?scan'208";a="220977349"
Date: Sun, 31 Mar 2013 23:17:23 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dan Williams <djbw@fb.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20130331174723.GE10326@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mvpLiMfbWzRoNl4x"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mvpLiMfbWzRoNl4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi Linus,

Please pull the following two patches to recive the fixes for slave-dmaengine.
The first one is for making slave_id value correct for dw_dmac and send one
fixes the endieness in DT parsing

The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Andy Shevchenko (1):
      dw_dmac: adjust slave_id accordingly to request line base

Arnd Bergmann (1):
      dmaengine: dw_dma: fix endianess for DT xlate function

 drivers/dma/dw_dmac.c      |   23 +++++++++++++++++++----
 drivers/dma/dw_dmac_regs.h |    1 +
 2 files changed, 20 insertions(+), 4 deletions(-)

--
~Vinod

--mvpLiMfbWzRoNl4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJRWHarAAoJEHwUBw8lI4NHMawP/029RFILsUeZE9ZHEvvnKbNw
XwIXq2nXoy2fGBoyv0G7Y6W6ZYRFrrguqgh2eZJIwdnyJND/fbb/JuNwdayAsEtF
K7XGnwnSuH5dwG8yfLFygSCb+S93i0H5aF8kzcwknsaI1Xc5cWZr7iFKtl/M+q+n
IglwzuA6phJAYImxEl0rfIJOafkmiZG9j5Igo6lcQJ+fgIlnVHtx2ZgV4kh7WmAC
KWPSEgYbaJfLPL/8y3hSEtLrE2GPO+ymaddqmAQGSoIDn9KvlVoOJ0tIetbPB3S5
4mpeOonmJuhBvS8aLYWewn9H9aF+nac7Su0tHSCrUAKh4rt7T/c3Wf+yc1svh8ov
QqUOqLtIV2vGAjM5/9LjcS6xOS+mgd00UnedM/Ra3rVqAivDzD9KlELFuMmiC7O3
8DrSr4qZJiEg5bHHL4RinMOesdsmIdAeBrlY8WlgqMNqPqLyuXrNPRCQOlB+HI12
Q0AhVJOzMsojpgmLuK4nUVnmhflxmk5lVyvJDlSK/TEbEHvlt0PB2cyH9tKFNWXL
XnQ1b+euPh98Z/KUuy5bVDn19xR5t5+bKveYvGIqnGRp6/4JLlxP2lsiKvFAPIpx
ii7Zu+jWAjkRhOP+P0PiOzebSphOFk11M1mqv468n1tW04leZUsv1MCr1miu0vcx
fuJ5ZDucpvcmd7DruZJM
=v7yk
-----END PGP SIGNATURE-----

--mvpLiMfbWzRoNl4x--
