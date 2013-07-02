Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab3GBPgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:36:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54159 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3GBPgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:36:01 -0400
Date: Tue, 2 Jul 2013 18:35:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 8/9] wlcore: sdio: get clocks from device tree
Message-ID: <20130702153526.GI7013@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
 <1372776948-24840-9-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3eH4Qcq5fItR5cpy"
Content-Disposition: inline
In-Reply-To: <1372776948-24840-9-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3eH4Qcq5fItR5cpy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 02, 2013 at 05:55:47PM +0300, Luciano Coelho wrote:
> @@ -294,6 +316,8 @@ static int wl1271_probe(struct sdio_func *func,
>  	/* Use block mode for transferring over one block size of data */
>  	func->card->quirks |=3D MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
> =20
> +	sdio_set_drvdata(func, glue);

is this move really necessary ?

--=20
balbi

--3eH4Qcq5fItR5cpy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0vM+AAoJEIaOsuA1yqREC0QQAJ6PUt5wCGYot1Z9OVllgCWy
4JvzQJKqDKB9TtP7/OpCJFjWiwxRmC/Vg6FxKwpetCOwFJW9sWPbgBjUWuyVKyZj
R3pZM2h6oCiJdOxMdoAlmrNC8IswXksivnjN/PEmUJUYDMKcSVWqo+v/ssk+2gYg
fyfSRgoPef2KbL9xDnRuft30CNRa8QaiaF+tpM0M9QLqlsmB2Mf/QjmXfcf5Gh+O
eMFCGNsfjZKrkMhZZo4QzeZUkA3fM0jGhI6EmmocOdW9I51mFn2Zg9+mrZdREd/e
Hf+3nZZ+KtusXrtzcQfP8mu5kTD+mzET/dvklKp4d2xQdc2zLiDl11lQDqgxs889
e7Oly32DHFMMyKgyOEnnOHt9AExR2mZ7qJs8/2Xf6DHK0wSaK9864n1mlSC6XuDT
izvKmNnk7kNY1ZPCwHa9yt85FPlcH8mq0l1TmH3Z10HS/NpTtOzyZ+PGyPs4c6FC
SjbiB71LRie3gAY43wTETKCFXQ/RGvNE110v6sVHH350orMTg+hGd+mwrtx+ovj7
5qvlWxAZ64QVpiAFDxl7F2L8pDnU80L+D8a6FcGoKU1PPtO2FNmkP+x6fe96Q2zg
4SCewk9i6SblMV0Rk8vSlBh0cVUrsP9rYJBe/QsnizC6bIUi9oqunIlP9zcSheX5
RDl7TCEZjO/o9oIvABby
=h1mL
-----END PGP SIGNATURE-----

--3eH4Qcq5fItR5cpy--
