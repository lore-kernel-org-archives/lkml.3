Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaKEMt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:49:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbaKEMt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:49:26 -0500
Message-ID: <545A1CD2.4030407@suse.de>
Date: Wed, 05 Nov 2014 13:49:22 +0100
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] mfd: qcom-spmi-pmic: Add support for more chips versions
References: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="3bW1g6qLJVV2UXRiCS4FGmJrGsC6Dtguj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3bW1g6qLJVV2UXRiCS4FGmJrGsC6Dtguj
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

Am 04.11.2014 um 14:33 schrieb Ivan T. Ivanov:
> Update compatible string with runtime detected chip revision
> information, for example qcom,pm8941 will become qcom,pm8941-v1.0.

That's not what the patch does though?

>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  .../devicetree/bindings/mfd/qcom,spmi-pmic.txt     |  18 ++-
>  drivers/mfd/qcom-spmi-pmic.c                       | 142 +++++++++++++=
++++++++
>  2 files changed, 156 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt b=
/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt
> index 7182b88..bbe7db8 100644
> --- a/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt
> +++ b/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt
> @@ -15,10 +15,20 @@ each. A function can consume one or more of these f=
ixed-size register regions.
> =20
>  Required properties:
>  - compatible:      Should contain one of:
> -                     "qcom,pm8941"
> -                     "qcom,pm8841"
> -                     "qcom,pma8084"
> -                     or generalized "qcom,spmi-pmic".
> +                   qcom,pm8941,
> +                   qcom,pm8841,
> +                   qcom,pm8019,
> +                   qcom,pm8226,
> +                   qcom,pm8110,
> +                   qcom,pma8084,
> +                   qcom,pmi8962,
> +                   qcom,pmd9635,
> +                   qcom,pm8994,
> +                   qcom,pmi8994,
> +                   qcom,pm8916,
> +                   qcom,pm8004,
> +                   qcom,pm8909,

Please either keep the strings consistently quoted, or drop the trailing
comma to avoid any confusion of where it terminates.

> +                   or generalized "qcom,spmi-pmic".
>  - reg:             Specifies the SPMI USID slave address for this devi=
ce.
>                     For more information see:
>                     Documentation/devicetree/bindings/spmi/spmi.txt

Regards,
Andreas

[...]
> @@ -45,7 +177,17 @@ static const struct of_device_id pmic_spmi_id_table=
[] =3D {
>  	{ .compatible =3D "qcom,spmi-pmic" },
>  	{ .compatible =3D "qcom,pm8941" },
>  	{ .compatible =3D "qcom,pm8841" },
> +	{ .compatible =3D "qcom,pm8019" },
> +	{ .compatible =3D "qcom,pm8226" },
> +	{ .compatible =3D "qcom,pm8110" },
>  	{ .compatible =3D "qcom,pma8084" },
> +	{ .compatible =3D "qcom,pmi8962" },
> +	{ .compatible =3D "qcom,pmd9635" },
> +	{ .compatible =3D "qcom,pm8994" },
> +	{ .compatible =3D "qcom,pmi8994" },
> +	{ .compatible =3D "qcom,pm8916" },
> +	{ .compatible =3D "qcom,pm8004" },
> +	{ .compatible =3D "qcom,pm8909" },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(of, pmic_spmi_id_table);

--=20
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6rffer; HRB 21284 AG N=FCrnbe=
rg


--3bW1g6qLJVV2UXRiCS4FGmJrGsC6Dtguj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUWhzSAAoJEPou0S0+fgE/5eMP/0zmEwZJhpaMDqMZkwGouGxz
aB0AEJowJh1spKHN9RsmhmCt4yf8zdxEF9fGyITPRdTLZVzW7KUO/ULdV1Eb/jKl
192foPIxgoBTDU1TzJcLWFpvN6R66d+NRt1SaiyvicRyj6uO7fzmnfOf6I9NDIX2
upv7okSsNtWU91f+KMGkWNZpib9+azM+l9k1pAZi8m18S+1+YJewskxtzjNN0YeF
USmY239sfcgbxiAGiJ1uRfuVc/V2TQFO/xhiybiSA1xcOQDq4x7ei1vRdp3fe9A/
OxTaO1ov2GQiLR/o5/TMzVmv2W61V3xOPd3IrFFP69zEltzopmnrjVcuWv4K5EWw
saCvKZUXmTsszWnHFQCBc7VrH1GFrU9Ra22PPGF5PwzjwtFC5yt1mpI0gT34chnC
G6A4aDfiFzqaS/fndCTzJxKO0Nml4nD5fjVQDmH9VZhQwaqgkfqnpzuLwLjVqvxX
G1cyZAeZEN6hXWDsMWUK8zTwH6YEuz8VyuriXoPdSvcaCfNwEDbATNU2MxTpjIcH
dBpep614PEyvuFePlRs+N833IVMykIrq0gjk9PXz58tt3zYKg8swv5CmQCshx6Cy
WZMG2G4A0n+wTCW/GAwcDkOGP4nlqg/UrgRUIl7+c8AkEpbNx9Oj4zjpv9Kp3iIs
B521/LNLf5+07wIxG+kq
=opW0
-----END PGP SIGNATURE-----

--3bW1g6qLJVV2UXRiCS4FGmJrGsC6Dtguj--
