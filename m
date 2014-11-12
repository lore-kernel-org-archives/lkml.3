Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaKLOTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:19:04 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64513 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbaKLOTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:19:01 -0500
Date: Wed, 12 Nov 2014 15:18:57 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-tegra@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 04/13] of: document new emc-timings subnode in
 nvidia,tegra124-car
Message-ID: <20141112141856.GA26488@ulmo>
References: <1415779051-26410-1-git-send-email-tomeu.vizoso@collabora.com>
 <1415779051-26410-5-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <1415779051-26410-5-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 08:56:27AM +0100, Tomeu Vizoso wrote:
[...]
>  Example SoC include file:
> =20
>  / {
> -	tegra_car: clock {
> +	tegra_car: clock@60006000 {
>  		compatible =3D "nvidia,tegra124-car";
>  		reg =3D <0x60006000 0x1000>;
>  		#clock-cells =3D <1>;
> @@ -60,4 +83,23 @@ Example board file:
>  	&tegra_car {
>  		clocks =3D <&clk_32k> <&osc>;
>  	};
> +
> +	clock@60006000 {
> +		emc-timings@3 {

Shouldn't this be following the same naming scheme as the memory
controller's subnodes?

> +			nvidia,ram-code =3D <3>;
> +
> +			timing@12750000 {

And this?

Thierry

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUY2xPAAoJEN0jrNd/PrOhb2sP/0tmY+HHUDM8YmTw6uMLnq7s
zyr/8IvsvcZtXcf1wfGFumjtvfZL7zxAjm4J7y8TQ21ugCVWG8hxIC/6gwdNKwcA
eJsqMmiRKI5q17aQrD9peDYoPL9K0XM6dddWGU7vd0UmtIFkygGQFbNUs1mw3U78
KEUlkmU16Fw1JykGfpbkF7QGtjC5v78y/aI330rt/3ePpAx31Oxo+LJCiNZfuNyJ
8hgRTDVE1uH88yBt6tUhz9movAfNlCLQBZgSoX5/Gp8PkpYnB/o6imLR02OnGNuh
3cnMrT7Jhh93KiMb9CLP9XByYypl8RbBz0Ub4TIaAfbxZQ8GD25J0/HA+T1SxQFm
FZI1AVXMQNoNiaO6Uc8cdohhbH4mOJEhRMIqVXr5UfbpMPNCcXMbISwNOEF3E6JM
tZLzuZp4Fha7S+SDGrKLJaN+kce048H2iEDqgsOyNLWIFHtsSgzRc7kQnlNY+wK2
ZOBXiPt/opY95JRPvyoMNWukqn/XiQPjAWWCgcn05ysSbJwqgcf2byOqPu2VTsvh
b6ubKIx3HK6RwYe76CeGE2cgs6PNtnHIQO0eJkkLRnRu1XDdxTivxSn6oxlV6Oqu
3tI4SfWWBhr3RBmywRdLgv24A53OFqxcu7vXicCEgkVqPiBQd4rsOz1o1wY8A8oX
beteYkD2QUYLmBUTR/FK
=/ygY
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
