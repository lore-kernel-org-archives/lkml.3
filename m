Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3BDKWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:22:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36882 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077Ab3BDKWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:22:07 -0500
Date: Mon, 4 Feb 2013 10:22:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regmap: include linux/sched.h to fix build
Message-ID: <20130204102204.GE4720@opensource.wolfsonmicro.com>
References: <1359870614-23691-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7LkOrbQMr4cezO2T"
Content-Disposition: inline
In-Reply-To: <1359870614-23691-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7LkOrbQMr4cezO2T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 02, 2013 at 10:50:14PM -0700, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> This fixes:

Applied, thanks.

--7LkOrbQMr4cezO2T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRD4vGAAoJELSic+t+oim96CkP/3IeMv556/sRoeLQhHHp0zsg
gqS4jyF1N/8bGdWjl11pm30PCxBkjB21WuRdb0NKrjQrEucCQiFzVtFCW/1umQVs
GzW2M3OJYVAf//cx4hAKsz/gQqbVv+lTtx0l4LgOoWXiBH5XM//yyJNatRCbozMk
uvFfO88fXU0SdL7W9D9PzytHExO2Z8cnyne3ubGB5g4FAHLBhdxKB6YLYLiNRGQB
udHCg7pJ4wmDkqDFP+68tIGw5mkqnbGnxVLJafvTKCT6GHMoGK8SsyD10RG/2KXA
1eOpwHaZ5SBQOqgjGidsODIbLxBC3sCOdxEMO4AlQWaD2UPxLXB5UwsSZhGRCSHV
QV4eAMYvXWNF21fSsLL74vfZxTyp8ZvTKLWshvbbRSQ7GRSk4+qUKLRpjmLVCf4P
I3dROjG9//V1iZCMIKpOmIGijqOYzULKYpusrYs8nxqFHNhFObB3H7/Q+KmCyunh
wpqcraE+9Q3ESTqnSx79B0kVmWA5TkJryEWMT4oqN0H0RnPGXknTSViUsOP1yK7K
Pos6qVK7Z3usScQv+9wGMDC4WcJlLwRN4kAv309f4XM6UWSYokKlJ5TeBWr1B79/
0jSwlhhp7c+rQTTB8h8CywJNwOtc/sGk07jBjuH8jUNiopu2TTGnY4gdMf8Spj52
/IKxrRhST4mLT1XfFAie
=SWzv
-----END PGP SIGNATURE-----

--7LkOrbQMr4cezO2T--
