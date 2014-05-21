Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaEUKQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:16:13 -0400
Received: from 8bytes.org ([85.214.48.195]:56908 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbaEUKQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:16:12 -0400
Date: Wed, 21 May 2014 12:16:08 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Fixes for Linux v3.15-rc5
Message-ID: <20140521101607.GA25600@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed May 21 12:16:09 2014
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 537c7ce920868610413445
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-v3.15-rc5

for you to fetch changes up to 2c16c9fdacbbf3bd8ff6390e12c5d28b3f2c78ac:

  iommu/amd: fix enabling exclusion range for an exact device (2014-05-13 12:33:12 +0200)

----------------------------------------------------------------
IOMMU Fixes for Linux v3.15-rc5

3 Fixes for the AMD IOMMU driver:

	* Fix a locking issue around get_user_pages()
	* Fix 2 issues with device aliasing and
	  exclusion range handling

----------------------------------------------------------------
Alex Williamson (1):
      iommu/amd: Fix interrupt remapping for aliased devices

Jay Cornwall (1):
      iommu/amd: Take mmap_sem when calling get_user_pages

Su Friendy (1):
      iommu/amd: fix enabling exclusion range for an exact device

 drivers/iommu/amd_iommu.c      |    2 +-
 drivers/iommu/amd_iommu_init.c |    2 +-
 drivers/iommu/amd_iommu_v2.c   |    2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

Please pull.

Thanks,

	Joerg


--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTfHznAAoJECvwRC2XARrj1fIP/24CFB/ZO3WSbGcA8KiL9+3K
rMxy758v8vgWgU4n857a37bBOtsz5UQud6uglO7aCzokAGSHKCtFH6K9EFotJVbs
xWz3iHEywQiqFupkZIwIPz7ubljq3Shl2G8a3Ae1x0q0ZFLDhQV4L/Q3zXDbAoZz
w5KadA76dwvogXlMQcWLyXaap1n0QNESEeubfqbplRCpaOodojgwhHXB17l+eIcQ
/R5gbNKbSauc/mqOkemducBWe8+1+mbcG14wuqtdg4BxVxNMttWKsruqry1yPJNI
tz/YfFgXMYA2UP4RvO8fKvELAMDk308iiyRkZVB2iEzwUOaJHdRqg7MPJ5gqzhr9
3MScnt+Hy/MXLqJRuWkBdiB6W925FjAEJy6Ul82DBQCFaSLjPw9ytulFD4erfgCR
Zd+e9SM35AFYygQ9YW30XnG1aPFrwU4J4Ay9n02VEo32q+2dtddxYT/eAHBlHyye
5knKWlQg6eAmsdKTPVxZMxNRFZs9+qSi3jpoQAaIi+GmuslW0cpiwBUYW/iUGAaV
KLLunmpEOY7LBEFO6WDkVOSTu4O9FUjsDh6CPe0eyq3tItYyPTEcreR1GkQOI9ew
MPfm4qh/6iNfwEXqmrMvXJKhBc/zBnlRZdi4CaCuddSUsLbZv0B0L9pGHi6kc8Ds
vR+KZT9N7DM1S4qoqBlc
=xC8T
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--


