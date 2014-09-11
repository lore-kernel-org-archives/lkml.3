Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaIKJrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 05:47:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:50203 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbaIKJrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 05:47:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="asc'?scan'208";a="476846643"
Date: Thu, 11 Sep 2014 14:52:54 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, dma <dmaengine@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] dmaengine fixes
Message-ID: <20140911092254.GK3131@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull to receive two minor fixes. First one from Kuninori clarifying
dmas bindings and second from Lars for fixing dma descriptor completion in
non cyclic case


The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:
  Linus Torvalds (1):
        Linux 3.17-rc1

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Kuninori Morimoto (1):
      dt/bindings: rcar-audmapp: tidyup dmas explanation

Lars-Peter Clausen (1):
      dmaengine: jz4740: Fix non-cyclic descriptor completion

 .../devicetree/bindings/dma/rcar-audmapp.txt       |    6 +++---
 drivers/dma/dma-jz4740.c                           |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

Thanks
--=20
~Vinod

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJUEWntAAoJEHwUBw8lI4NHncgP/1mKVRA721HwMjOnBvquscO+
4QwibweQMw3i5gwEcx8w3vljmdnwYwbU5GzoaYewu/fU8tXCtPhdkpkPdSdijlPK
Fpp5avZR5HXioIdK7uNR0mL5nM31xgEB/AudZR1zWhuAwiGl6uWhP8sMbrsUqDYF
knl8WB6qVPti64e8Jh0jg3WEqJ5sVsAl0pZDV15CG/tTYMSVv2y0/K+rQ7VBwoAj
V4CL8P6pzHTzJEMaTclKXwbcLrq5IZCCRzwRinLGwlYa9/ALbbJ8pJkp+uWc2a/A
zC4uxoSj/oTqjIQu3FaBcIY5g315s7hBDQLuGKFe1w6TdchHrPNi5Mh3bTURzPNR
dEIw38tBlfB3ap6FEPjB3OfYJ2AzwE9Hdc1VqP/MfkrFt26daPpJ82AFT2xpQrWi
fNXB8WoUVEG+FCzjKRbTA0K8Q216YWm2CJgnbrwMf76fDZ4wq5Uubh42i5g74RPD
GT6asCmE6vwZd2NtxU+0kxqjdERq+UpHJ06RFW4svuh6ij+4e7i5ov5oVwHAYGhG
0sd5g7zghDmhqI+k1t3r3ok+U9jFHacaermsHBNksMCN2PnrCCFyqJ68qMCUJaW9
TvkAEDqKvhoWlX4pIvpGbqEKWOu78tTeVsEC11/NMz945J1OYuQ7nhVMHQx+AYe+
yb0Azwbz/BpM5C2ARTpb
=drfa
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
