Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaFOUfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:35:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51432 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750993AbaFOUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:35:04 -0400
Date: Sun, 15 Jun 2014 22:30:58 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Nick <xerofoify@gmail.com>
Cc: emilio@elopez.com.ar, mturquette@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Frees gate after if statement in clk-sunxi.c
Message-ID: <20140615203058.GA22265@lukather>
References: <1402769508-3821-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <1402769508-3821-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 14, 2014 at 02:11:48PM -0400, Nick wrote:
> Signed-off-by: Nick <xerofoify@gmail.com>

This should be your full real name here.

> ---
>  drivers/clk/sunxi/clk-sunxi.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 4264834..6f4fc51 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -42,6 +42,7 @@ static void __init sun4i_osc_clk_setup(struct device_no=
de *node)
>  	u32 rate;
> =20
>  	if (of_property_read_u32(node, "clock-frequency", &rate))
> +		kree(gate);

There's a typo in kfree. How does that even compile?

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTngKCAAoJEBx+YmzsjxAg2dAP/j2liYVmpxPFlTv2MrHOM6c8
/0JCEeLG0Usr9zZZtf/TzFOP0gNU2KOswfycUcwkx5MLHSehJG7HDj8P5KfHT8i5
2VHrMG2pY4L6w3qDUlMO7vCHIkdJFqNe3IBmcmyjnu+8sZwE3e4nvet9Xx7l6awK
yMtqcEWd/yF868T6t/wh8VZR1xniSheRI4ZyrL9831zHDAfo5rhKYo86+TUWeUMs
ueRAAk+n66ZzRuZdB1Rj/8QeHfzz9perOCBVnLWjGymYJO2S6tdRAGbFSJ84Nzgp
2Cz2XzTwYGBLnv03G1TZ5AUwPy45LsHg/StqTjrF9TbTEXyP78MJ1jTHjPL3QNEf
kB1agr134dBdjmXkA/klKoEzBI+bUFp7MGvNh/epbqm5yYAO0p0h4F5i4+w8f0AV
6lBiF+J3eoEUkXGTNVDOcwGKIsjNFKKNuYLZKOwSwBEkWsT67Zvemue/imuhIvN5
m1a2ftEdtMycIdlpG41EXP1w/avprnGlGxWJG6Vea4KwB6AGph8lrDXfoQbRSCUC
GIxeFX3DcBkwAKlaB5q+M73Sd6lHGOVwld6hkMpwY1P9gdpJEeR7xyyVbWxK8P9u
uStvFMCtPzfTxyERCWKWiJjK4HLTc/niVN0f88c7FmTHBTmoHb/q1SFLzuJaM9PR
TjoDRfOzshc4NW8pzvUP
=qxJv
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
