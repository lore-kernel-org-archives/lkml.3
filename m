Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaB0ByO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:54:14 -0500
Received: from ozlabs.org ([203.10.76.45]:52980 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbaB0ByM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:54:12 -0500
Date: Thu, 27 Feb 2014 12:53:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the drm-tegra tree
Message-Id: <20140227125357.795646e8ee6ea60f79423162@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Feb_2014_12_53_57_+1100_0+8xSkHeTutKMwQ2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Feb_2014_12_53_57_+1100_0+8xSkHeTutKMwQ2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

After merging the drm-tegra tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/gpu/drm/tegra/sor.c: In function 'tegra_sor_init':
drivers/gpu/drm/tegra/sor.c:924:22: error: 'TEGRA_OUTPUT_LVDS' undeclared (=
first use in this function)

Caused by commit 765db82ce08a ("drm/tegra: Add eDP support").

I have used the drm-tegra tree from next-20140226 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__27_Feb_2014_12_53_57_+1100_0+8xSkHeTutKMwQ2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDprCAAoJEMDTa8Ir7ZwVZ18P/2gRHKXUtOZTBMLRMk12Re5S
fFXcSY7HCJUdRFAQqnCJDOpyIOH3qhZ3s6L3G1G6Z7ryHF0epstqsbCNzYP8PtUe
4S8Sj4R3Wr0/Uf20Z+p3g184O/wnNN9lcv8uv6CeW41VCTN64bFpetS/FlpOfjNl
sNEhs7hyQOjTqQrj3JPG6OLlWpBPneqgbAHCkpgM5guuMJVBCUSDkHB6Q3JRTXEy
YqAfXQQvUTvL9qJzkMDA4NPVldPn67mYBA9EgUD3F+lu2fl8FJmMf5qnTJV4tJYo
/waVVs/uPKPAe4QWGByV8NP/PfO6Qobgybxn+a0um6EKlhijHS7hz+bw84wHwSZt
qDhNUKsMu2N8xl+VCbfWesCmNMLI28oo95oPVftXoeG1fvK39n1odbWDpOKKEs+W
N+oAiOeS+WeLxwOoNdODScLUAOnkPgvLbYx+ZbQz0+VIAQagkjxt89BMyQr7C/ru
9XxjUG/Luel54TMm241rxy+2VugLFcBX/tHPT5OGgBHNTCr4VGFDytM6+YJXQF+p
LfwXxL3bLCiDa5ZGEur9BkYpv9E4kB4t4PlJ8kQABavxYt1mtm0etMWZcJk7FEhG
J51m15VBoCwg9GmHDFjRkuIlzs/9YGzhZO7EdBesbBuWtcawfFu+y7R+ZVWq54Cr
lYCysuokTBuhuH+fG6Od
=vKau
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Feb_2014_12_53_57_+1100_0+8xSkHeTutKMwQ2--
