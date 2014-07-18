Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761978AbaGRNiz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:38:55 -0400
Received: from 8bytes.org ([81.169.241.247]:47764 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761929AbaGRNii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:38:38 -0400
Date: Fri, 18 Jul 2014 15:38:35 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Fixes for Linux v3.16-rc5
Message-ID: <20140718133835.GA19087@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-v3.16-rc5

for you to fetch changes up to 3170447c1f264d51b8d1f3898bf2588588a64fdc:

  iommu/fsl: Fix the error condition during iommu group (2014-07-07 10:30:02 +0200)

----------------------------------------------------------------
IOMMU Fixes for Linux v3.16-rc5

A couple of fixes for the Freescale PAMU driver queued up:

      * Fix PAMU window size check.
      * Fix the device domain attach condition.
      * Fix the error condition during iommu group

----------------------------------------------------------------
Varun Sethi (3):
      iommu/fsl: Fix PAMU window size check.
      iommu/fsl: Fix the device domain attach condition.
      iommu/fsl: Fix the error condition during iommu group

 drivers/iommu/fsl_pamu.c        |  8 ++++----
 drivers/iommu/fsl_pamu_domain.c | 18 ++++++++----------
 2 files changed, 12 insertions(+), 14 deletions(-)

Please pull.

Thanks,

	Joerg


--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTySNbAAoJECvwRC2XARrjdbwQAKNKAk2C6fxyRLtiIE3ab8tk
U8utu5v0/1UcgFH62axPOt/NPoLVn3YoK7RQJyYc7P/dSE+2o18hhU+Hxn0jfYZN
RTLn8p7FzqbpK9XGmmYRCJLxCRD2k8xixwA+CLrux5RB9bMupuX2PlczkLu6SgPx
RuDH4lnUgXG9BCj8hU99QIvzqAux8ZllfUKVxmrfN1qHlmBGJUUfHFWAO8YE2/CZ
vjvbgvglcUkGKL/qggNJzXNaCwnBeHV8NB3V18ZipX4DdgRULX3e9DYI8MuDjFHn
7EOJ/XExA1U9OvFc/f39Xrdf4DlGfuytVoyy0yQoZXMrwuGTULzP6A8GoAi3fsGM
9ZFwNrA450mS7qBhmE/FLfAKT4pYL+v7z9M+ZSvn4PPjJ/xORyuZIra0HtKfaQ6r
tvCekndO62APyTVmrhcuvmT8BAH5hkj+yUVn+Fjdxb7cGB+S+yUbUJAmjbTOvDP8
iu5usXyovYz93MPcDvChvXGKd09VARFAFXJpBP2sguYUzC2vfzsK0pKSDHzxttj1
qZr+KK3shvyiCVn61HYoFsNKr4fLEKI+ls6/4d+m38rIjPdG0Q1XCqjZy0WwTsjJ
26Kcdakd/Hl/ogG5G7cJjO7yibeLfGOA6yGgAKLiP3I3vnFk90pVXk6wjjQSI9Cl
5TBrldo10IQQf5A/Bhzg
=vuJn
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
