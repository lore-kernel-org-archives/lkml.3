Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbaGCOR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:17:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40397 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621AbaGCORY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:17:24 -0400
Date: Thu, 3 Jul 2014 09:16:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Keerthy <j-keerthy@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <mark.rutland@arm.com>,
        <galak@codeaurora.org>, <robh+dt@kernel.org>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>
Subject: Re: [PATCH 2/5] regulator: Add DT bindings for tps65218 PMIC
 regulators
Message-ID: <20140703141653.GH5814@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404395102-21469-1-git-send-email-j-keerthy@ti.com>
 <1404395102-21469-3-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k9xkV0rc9XGsukaG"
Content-Disposition: inline
In-Reply-To: <1404395102-21469-3-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--k9xkV0rc9XGsukaG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 03, 2014 at 07:14:59PM +0530, Keerthy wrote:
> Add DT bindings for tps65218 PMIC regulators.
>=20
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  .../devicetree/bindings/regulator/tps65218.txt     |   21 ++++++++++++++=
++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/regulator/tps65218.=
txt
>=20
> diff --git a/Documentation/devicetree/bindings/regulator/tps65218.txt b/D=
ocumentation/devicetree/bindings/regulator/tps65218.txt
> new file mode 100644
> index 0000000..6272a73
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/tps65218.txt
> @@ -0,0 +1,21 @@
> +TPS65218 family of regulators
> +
> +Required properties:
> +For tps65218 regulators/LDOs
> +- compatible:
> +  - "ti,tps65218-dcdc1" for DCDC1=20
> +  - "ti,tps65218-dcdc2" for DCDC2
> +  - "ti,tps65218-dcdc3" for DCDC3
> +  - "ti,tps65218-dcdc4" for DCDC4

"ti,tps65218-dcdc5" for DCDC5
"ti,tps65218-dcdc6" for DCDC6

> +  - "ti,tps65218-ldo1" for LDO1
> +
> +Optional properties:
> +- Any optional property defined in bindings/regulator/regulator.txt
> +
> +Example:
> +
> +	xyz: regulator@0 {
> +		compatible =3D "ti,tps65218-dcdc1";
> +		regulator-min-microvolt  =3D <1000000>;
> +		regulator-max-microvolt  =3D <3000000>;
> +	};
> --=20
> 1.7.9.5
>=20

--=20
balbi

--k9xkV0rc9XGsukaG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtWXbAAoJEIaOsuA1yqRElJ0QAIqGZiiOxf+7R7DkdtUhqatB
5TeEHEmJ7hHZtpJip62gqr1B1SMDlDJASFqgbtfKwxBPjj2ti055eMbTq+vkQYvS
VOyD7wHT1Hxjq47luT3LLbDqBYflH1mwG+DHXHEqmmmDtE5iG9tXQ5FCSH1cFB3x
c4ute1dpdHS183DH52vmbEyC5I3aGaVFSMP8ZPd6uQPqZdKhmxxBl67YI/CatdT6
wos5ZkMZqRmMp1YptHJzMBlADc975NLPoh0/sJoLe8OicHF6C4Zqbut1tyaPOWhK
xoG7pSSV8SIWDt+9QOXEeJ4QBlbz0t4qBpnUJdO8kFjTsMGNRs2tTgQXr+IyAOr/
ujqUwNyfQ59li9nfmaC7x1ZOI5NTg4iPjLqmn1FPVGkl9rg5tdQnsFVPybqUGH38
xyAiwAtT4kZbrc7712bUFQfwVIn8FeqmPeEYubMvIBFv2xPdggLfjtW2hXSs2PI4
VWYYUBIZtucpgOWj1Yjn396TTNt1onMZt0bEAptTQfd9SAg72K1wq0C+wewb80kv
d4pBJySALNfsF7EE8zikWO1g6bN6TvSltj2pNKTT2cTlKCo8H6UWQx0KY2/ctC8L
I+AAq1lLdW97Ro5GQsPClAICnub9CWgmC+YltRBopjHJ9hhpa13u01aETl+HkIlM
+VY6K7AKxu1w7lUAu9pD
=z7FY
-----END PGP SIGNATURE-----

--k9xkV0rc9XGsukaG--
