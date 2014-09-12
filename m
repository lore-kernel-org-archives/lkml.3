Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaIMPjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 11:39:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39134 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaIMPjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 11:39:47 -0400
Date: Fri, 12 Sep 2014 14:44:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, heiko@sntech.de,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        huangtao@rock-chips.com, cf@rock-chips.com
Message-ID: <20140912134446.GT7960@sirena.org.uk>
References: <1410506806-15327-1-git-send-email-jay.xu@rock-chips.com>
 <1410507036-15442-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bxF9Dep5HzwGj9mC"
Content-Disposition: inline
In-Reply-To: <1410507036-15442-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: rockchip-max98090: add documentation for
 rockchip-max98090 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bxF9Dep5HzwGj9mC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2014 at 03:30:36PM +0800, Jianqun wrote:
> Add documentation for rockchip-max98090 driver, which is need by rockchip
> board using a max98090.

Can this use simple-card (perhaps after a bit of extension)?

> +- rockchip,audio-codec : The phandle of the MAX98090 audio codec.

Is the driver really specific to this CODEC?

> +
> +Optional properties:
> +- rockchip,hp-det-gpios : The GPIO that detect headphones are plugged in
> +- rockchip,mic-det-gpios : The GPIO that detect micphones are plugged in
> +
> +Example:
> +
> +sound {
> +	compatible =3D "rockchip,rockchip-audio-max98090";
> +	rockchip,model =3D "ROCKCHIP-I2S";
> +	rockchip,i2s-controller =3D <&i2s>;
> +	rockchip,audio-codec =3D <&max98090>;
> +	rockchip,hp-det-gpios =3D <&gpio6 5 GPIO_ACTIVE_HIGH>;
> +	rockchip,mic-det-gpios =3D <&gpio6 11 GPIO_ACTIVE_HIGH>;
> +};
> --=20
> 1.9.1
>=20
>=20
>=20

--bxF9Dep5HzwGj9mC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEvjNAAoJECTWi3JdVIfQMEcH/2MwyMjXfikA633FcaMV8Q0S
XpxALPyGNzLxoUZXz2jViYwOwAF/JKH/xig6L/jInUbELmWk1+oPArfeJsVNirpM
zAKGXuH6HjcykxaPQmT+cpM1akRMNdZtlNFPMCIdFnwrTwIRUOwXhpYrUMO/r/kK
xugIROnGZsBjuje2f/RhAsFXsQkqLvaH/nx8JI20oreq3ry2V78HaLLyYyZZj7Rj
b5YqP+jxy0XOQxyEHa138DX6FHdMmqZiqL6TDX/s05s//tiJYxEtJclCjZr3DOCk
hU1zhwDrXP3Dq68EtWdsdvgLWEjWDJ4PhnrbDuHDdnh3jjoq9Qi8AalJXLJn3/s=
=MKWt
-----END PGP SIGNATURE-----

--bxF9Dep5HzwGj9mC--
