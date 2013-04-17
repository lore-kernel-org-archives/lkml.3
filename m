Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966519Ab3DQODf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:03:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55179 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966321Ab3DQODd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:03:33 -0400
Date: Wed, 17 Apr 2013 15:03:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, gg@slimlogic.co.uk, ian@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/3] regulator: palmas: clear sleep bits if not selected
Message-ID: <20130417140331.GN13687@opensource.wolfsonmicro.com>
References: <1366191793-13934-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vDEbda84Uy/oId5W"
Content-Disposition: inline
In-Reply-To: <1366191793-13934-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vDEbda84Uy/oId5W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 17, 2013 at 03:13:11PM +0530, Laxman Dewangan wrote:
> Clear the sleep/warm reset bits when it is not selected through
> regulator platform data. This will make sure that configuration
> is inline with the platform data regardless of boot/POR
> configuration.

Applied, thanks.

--vDEbda84Uy/oId5W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbqutAAoJELSic+t+oim99YwQAIs6Vh9bHiQOlAXYH33DBN2S
K3ojPEEI+8PMT8Dlv8tR4zN6KSUrJmm7eOI3etMvS1YY998Ptupb93mJBa6o659W
Y794avwWYeYQNKOuTzK9k6rqOhRMHV9w2oyTeFCfNlyVxLOv7iVyqGNcZVDPibLn
5mUV+8TdqMe/LepDmJdeYxGgygLBOsoWcrDZZ8Zl8Edbpd0+9SIr2s/IkhMoElki
SH/SQHD120cF0XtnfXNw896YB2AeNocZTo9x/OF4jDBS4NtrF8nust+cqbk7MvrQ
29hcKGqabl1VuiXsWJ++QQLCUpq4MEdKuqM1J6DkWbS8DhDMukQ8B6ve1L/lKyDc
cKhtfnuJGB4h5Acvt9IQP+NSXgZ9qilInuNtwvqNmaC8NSV2sILeQnmWUOKYx9g3
+V4TtaHMfAhVkFfZfotUuoU0ziFDiTRhRssYUwHXrsxcAqE0NyYkVuDDFodBP1Qd
EyMTelALDc+LWz9hWBT4NBUJaTRWQs6WY1jtVZNJUbHDhwMn6w2uXVYs2AuW2Vnm
xvl+ezZN5o7xW4YxMTN6ybY5FyKqcSBGr4glcduqLCrGGWp8iG78Aov0YXAANUfF
uOACblRBpKpUnF+ZiNuA6pred77OVKDcPmkXQj16S+oE85ohipTykH7R5OcqbNtv
M8crdKFfwrouvpIp/6Tr
=Pm+2
-----END PGP SIGNATURE-----

--vDEbda84Uy/oId5W--
