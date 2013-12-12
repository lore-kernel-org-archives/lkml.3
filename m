Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3LLMg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:36:28 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:34673 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3LLMgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:36:21 -0500
Date: Thu, 12 Dec 2013 13:35:04 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 2/2] pwm: jz4740: Use devm_clk_get()
Message-ID: <20131212123503.GI11524@ulmo.nvidia.com>
References: <1386436396-2307-1-git-send-email-lars@metafoo.de>
 <1386436396-2307-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2xeD/fx0+7k8I/QN"
Content-Disposition: inline
In-Reply-To: <1386436396-2307-2-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2xeD/fx0+7k8I/QN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 07, 2013 at 06:13:16PM +0100, Lars-Peter Clausen wrote:
> Using the managed version of clk_get() makes the code a bit shorter and t=
he
> error paths less complicated.
>=20
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/pwm/pwm-jz4740.c |   20 +++-----------------
>  1 file changed, 3 insertions(+), 17 deletions(-)

Applied, thanks.

Thierry

--2xeD/fx0+7k8I/QN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqa13AAoJEN0jrNd/PrOh03UP/3v9TmIjRrZ2vPwWHCaDFAWm
VoxY6AS/P3i/Mr+Z1iYN6y3IcADRalHBir3vnPYJgEEP6mhhtXgNdTClYn5zH+cJ
4rmna/TrXs8pltaQngEwDUIf8+eccmb40Av16lZlRgvAzB04Oqq2bqatcRMkHW0m
hdz9zrR5IKWa6ae69ux/fHuXKqW8ePy8M+bTMwxMsV78TM2J1nRfTRPSZ5pJsj9w
QvSIG0gVJbKGcM4XqY3/0y6WqvWoMxt+hAv4NoJhzWujVBCBUom0YHeLXVD/l/fX
FK02/7tEzJXiNfIPjp/ziDW8ShbPWTT1rGJxV/axAQFccUFHR2wJ557+/7k9whE6
wL2FS/xhugeJ9RjXJJI2PhVIIBmt/Ar1vLU1aU4Ut/ecu8ftuKKTP/ifb5+Djplg
iaxEe6a/oIhtzZfAcMUyGbE498uO3WdxVz7eDozkcppNJLb7yYVmPtdFIfJaoJuR
fPo9D+Dn8ETyMqKt0uunhX4IR+fVS8MoqrRhdofGMENaEQ5a44KWarZOhaRZUOYA
hTPc4uCoJLYa6dQRW32jkLneJntYklZKtNJN2xVyMu3FLjR/Q4YWj6pN0b/QMN8X
x4zznGJToShpgdn4rsPtykN7RQtWkMz14Y+tZoAPAF0ZC4KYVH+xHHlrZ6tSHAya
I8mnCzMrJvvvfel8BkVB
=JCtS
-----END PGP SIGNATURE-----

--2xeD/fx0+7k8I/QN--
