Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3GBPbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:31:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45849 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab3GBPbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:31:46 -0400
Date: Tue, 2 Jul 2013 18:31:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 4/9] wl12xx: use frequency instead of enumerations for
 pdata clocks
Message-ID: <20130702153113.GF7013@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
 <1372776948-24840-5-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K/NRh952CO+2tg14"
Content-Disposition: inline
In-Reply-To: <1372776948-24840-5-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--K/NRh952CO+2tg14
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 02, 2013 at 05:55:43PM +0300, Luciano Coelho wrote:
> diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless=
/ti/wl12xx/main.c
> index 1c627da..903dcb3 100644
> --- a/drivers/net/wireless/ti/wl12xx/main.c
> +++ b/drivers/net/wireless/ti/wl12xx/main.c
> @@ -1701,6 +1701,42 @@ static struct ieee80211_sta_ht_cap wl12xx_ht_cap =
=3D {
>  		},
>  };
> =20
> +static struct wl12xx_clock wl12xx_refclock_table[] =3D {

const

> +	{ 19200000,	false,	WL12XX_REFCLOCK_19	},
> +	{ 26000000,	false,	WL12XX_REFCLOCK_26	},
> +	{ 26000000,	true,	WL12XX_REFCLOCK_26_XTAL	},
> +	{ 38400000,	false,	WL12XX_REFCLOCK_38	},
> +	{ 38400000,	true,	WL12XX_REFCLOCK_38_XTAL	},
> +	{ 52000000,	false,	WL12XX_REFCLOCK_52	},
> +	{ 0,		false,	0 }
> +};
> +
> +static struct wl12xx_clock wl12xx_tcxoclock_table[] =3D {

const

--=20
balbi

--K/NRh952CO+2tg14
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0vJBAAoJEIaOsuA1yqREKRUQAJ73pu94CGu/7VONZrN80bat
GH4zZVV6q3bbm63/NzlUdZklonA5LwYUU8RUcRuF7xHBfkrt/iogHVfEtbtIrrgj
izP9hFLOWEM/iIkT8IIRMtIjsiIh10rH3JQ0s+WECz5/6G+B4hz1lRf9/bibNCxh
kyYCHD9ngHAtld0soEd2r7Yps0kzu4p1Eo+nmlTJg8pn9lB1eCPSOsMKfvATt32u
sawu3i+hwDlC6fG6x9GKidWEU9/6I31nNgyoKNXZgINp0P51h9cC2WoulboweWmy
SODIrBFfFfzp3YyCYpTxmD1bmN8vh8HCFTh+AdCiAG1rnN8/8m3qM0XfCSxWRO9b
zbYmrUlFQW4uIcrG62YTX3Cmv/z/4Wg2oNNR6FGJLdOK7xWDgdsWEedpUcOMJ7yw
MRed1iC7ve2Nk+iYv/T7jclfCIJYOpICs5VbwDca0eU1cu/vcKFC5/f13eR4qtdF
uMgkSTCoOTyQYeDSiVxy1Cwk5cDOTOWFpnxWbCaUlp3uVFM6QtDt8pZzQxupZJIv
bnd8LWXCvpktROTqJAeVZKOSaWRis1iJttgXF2j+cXaYIVe4cUVmYnPvbVYJsLbZ
w+ulUSiE3AIlEul5IGo4lA6Qrt8cmRDLJBz3hAUFADdKbb+WllUU6nw3O71uJoFo
Do6SpsKoCkxMoveFwq8p
=rKY4
-----END PGP SIGNATURE-----

--K/NRh952CO+2tg14--
