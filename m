Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbaEPOdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:33:21 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47065 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381AbaEPOdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:33:20 -0400
Date: Fri, 16 May 2014 16:31:11 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Fix wrong value written to PLLE_AUX
Message-ID: <20140516143110.GA28338@ulmo>
References: <1400248220-16025-1-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <1400248220-16025-1-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 04:50:20PM +0300, Tuomas Tynkkynen wrote:
> The value written to PLLE_AUX was incorrect due to a wrong variable
> being used.
>=20
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> Tested-by: Mikko Perttunen <mperttunen@nvidia.com>
> ---
>   This fix is required for the (upcoming) SATA support.
>  drivers/clk/tegra/clk-pll.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Thierry Reding <treding@nvidia.com>
Tested-by: Thierry Reding <treding@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>

Mike, Peter, it might be good to have this go into 3.16 as a
prerequisite for the upcoming SATA driver (which presumably won't be
ready until 3.17, but in that case it would be good to have this
prerequisite merged already).

Thierry

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTdiEuAAoJEN0jrNd/PrOhM6AQAKrWkHgUrAkNklVW/pGxauVk
CMaw+mBnaeaBiNfpmli0c8h6b5O+Tq/71d98lKmLmcrrgXLy2q0T5n24XGyVFunJ
pr/mCx1GIpvqTU8t4W8kYaJHowMFrR8l9z156g2TxYe3vlT8/WeMnuMrQZY3YyTM
W7b46jYz8MTMPjv6XZFjiHOhI1rUwq+QNHKaLRKeGKwixPI2QCt31doQ22/IEz+v
ElCw/YxFzu5jxN10ey3WBgtOPt938fezfZIo+Qn6NCgdlGU1DLOnnT5roDDjlb8A
z+0RoX2MdYsIHZt8SnBr3d9Hdi7h/MTBtbhVpiY8vFBfkleexh/UvhYcWzgxudhm
IxSpXO6gZYWXL17hYPdZeUyt7AUeEyP0uqF77C1QtYJmIcpTb426Cup00e3vJoix
WMp1vSV5BvTJR6prBdzVSM1IyG83vFmxxIgWslHrdkQwIkobo9sh1fFq59TB7MRf
y+49t0al9kU4LIkpPZhkd384vhiQTHmCSm0NyZHpfImUecQfCo6DJ5XNHQi09xYY
SbAOYUSZfBiX0lDooqTSNJso0wOHFnTCVP71dFoPmYFebQE2x+U6OX3ORcIbMfEJ
mD9jYl0czxmefra4r8i4WP1KYkYw4cE0XhDDtjG/o/mjO/Vpsu8SZ7qdpV5pOOYb
xhbFLPLGv04Zv+L6cxiA
=bFZi
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
