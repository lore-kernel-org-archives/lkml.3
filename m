Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbaFTUdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:33:01 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:38407 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758AbaFTUce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:32:34 -0400
Date: Fri, 20 Jun 2014 22:32:30 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] ARM: tegra: tamonten: add the display to the
 Medcom Wide
Message-ID: <20140620203229.GB28814@mithrandir>
References: <1403184350-25403-1-git-send-email-alban.bedel@avionic-design.de>
 <1403184350-25403-2-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <1403184350-25403-2-git-send-email-alban.bedel@avionic-design.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2014 at 03:25:50PM +0200, Alban Bedel wrote:
[...]
> diff --git a/arch/arm/boot/dts/tegra20-medcom-wide.dts b/arch/arm/boot/dt=
s/tegra20-medcom-wide.dts
[...]
> @@ -38,6 +47,15 @@
>  		default-brightness-level =3D <6>;
>  	};
> =20
> +	panel: panel {
> +		compatible =3D "innolux,n156bge-l21", "simple-panel";
> +
> +		power-supply =3D  <&vdd_1v8_reg>, <&vdd_3v3_reg>;

Does this work? simple-panel supports only a single power supply. Both
of these seem to be always on, so I guess it doesn't matter all that
much, and if indeed both of these are required to power the panel then
this is the correct thing to do in the DTS.

Thierry

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTpJpdAAoJEN0jrNd/PrOhDasQAMEpZPdKD79zmvvl+Ug/b5MB
HS922ekY6+TtbvvST2IuLzekJCgG6d8FNEPLyeCODYNHmw4kj+7BY03HN3H0jmlI
F6jZRPXuQGoNIgkrw3YFfBNRvv+K2kvAQl1acf0KzRIZeb62oq706wFSzmzIm7oU
QQv2ggMPs6lE2cGRsUa5u7z7QuhYYUg65o2o3mY701eq0EC/JZvRdFhmFhkqbsX0
J/O6tVcK1CQ1Ku0f3xvy9X4PLAlogyyN8YnkA+kLDQoELbLFQVZ8D60mMUBBxqWU
htekOb3CIHBnMaaKd90G+mCyTKsy5bYrLoB/vYDvh4DdAxSRyAYHeWRFu8bmx5MX
sTGXyZWDWAB8COb+3c1E89KanaGVcAiif1Vm5QVreW0evh0zx0i0gCEtlOAg3gn2
mufqWnK37e3jinmv/bGlyGXyyhtmL+A8zaYaYL7ERJsNGTcqzyryJhHssDz+xBGC
nCVyOlvnIHJuI8Gx2kfQdvg/yQIn22jkCSSBtKAbTDagl1E1RUQbQ0q/G2FvwYE/
dhtcExqAeh8f4BflfeQzgFSCZ4RfY8Lqw20avCwTpIYLzTS0fvnFAMU1jji03NnR
AWgL39XYfXw5WRdDToeMhUNJewRbObvZmWjElB5uHCee/+NBz2eGZPT1XkC6Gef3
16RivhW64xWAkffphgxA
=GhRo
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
