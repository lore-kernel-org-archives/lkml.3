Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaBTMDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:03:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47336 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaBTMDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:03:38 -0500
Date: Thu, 20 Feb 2014 21:03:30 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140220120330.GN2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-20-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pJhtOc9NxSWHq38L"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-20-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 20/23] regulator: wm831x-dcdc: Remove redundant error
 message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pJhtOc9NxSWHq38L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:20PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--pJhtOc9NxSWHq38L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBe8PAAoJELSic+t+oim92sUP/0T++zIGClvhOweC/Lme0Osr
RX3KTnJt0pFmaHEVVfGzhtNi8E8/csCjh1GXa51jpUsNyAj0jlBSorBfC0F3f26y
v2dH0Zz0+ZFOZvgSi1X+m/LMKIl34BwoCig+neVOPyQxHzSW0BV5w8DnTG6Mpxp3
F4CEXM4VoqHQGNoxGOTZNOHn6oDnRFQGyHr0dU6njQZGR6Az7I3IGUwQzaJ0pMoF
E8tDCo1PdArtEzIRSqdAa2d5K7Dm2yZRFVE1NeR9cd5Ic2oFdNgWxcMHA6EzeiHV
o1PrZx+6Rb40gOpZTYKr9SUCi0XIG3MzWtEGT8D5kVCuiTWiTro/S8mNerdK85U6
hCGEcOJt6mHpLIRX4Hocdj6iL0TsEUckrEIBHbaEsnS6qlWErzl0Ov3JOiz+gz9n
Yl3hKrBFDN09jsurMC8cKXdBbj2Vtlz52b/YLIUZnHgxaNOGwcTqJY+Zkt972Yn3
kqbzqRlJCbVmX12mRfojN/LyBObNV6o4MJ7udmgBboYcpFHNO+Um0gKELrKnLK7M
M4gYaEqqT2U3DWS1zJlf5ICs4FSjp+LAcIjQzj6BJhKb78n3l3ELpkq8moHULKtx
5b+P7WEp91ceGE4Y+BhrErjJkVbpAgcPaAKuFgNZCiaJsvHFgDyQjTqfBOw/vChc
NwtGkAuDz7XGRFu6dQWL
=PZeB
-----END PGP SIGNATURE-----

--pJhtOc9NxSWHq38L--
