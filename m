Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937080Ab3DIQed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:34:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41968 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937046Ab3DIQeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:34:31 -0400
Message-ID: <51644302.6000109@pengutronix.de>
Date: Tue, 09 Apr 2013 18:34:10 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Hector Palacios <hector.palacios@digi.com>
CC: linux-mmc@vger.kernel.org, kernel@pengutronix.de, cjb@laptop.org,
        aletes.xgr@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v2 2/2] mmc: mxs-mmc: add non-removable property
References: <1365166070-9370-1-git-send-email-mkl@pengutronix.de> <1365166070-9370-3-git-send-email-mkl@pengutronix.de> <51643053.7030302@digi.com> <516431F9.8010302@digi.com>
In-Reply-To: <516431F9.8010302@digi.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2VKTVBJXGHRJIFDEKIGHU"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2VKTVBJXGHRJIFDEKIGHU
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 04/09/2013 05:21 PM, Hector Palacios wrote:
> On 04/09/2013 05:14 PM, Hector Palacios wrote:
>> @@ -95,7 +97,8 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
>>          struct mxs_mmc_host *host =3D mmc_priv(mmc);
>>          struct mxs_ssp *ssp =3D &host->ssp;
>>
>> -       return !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
>> +       return host->non_removable || host->broken_cd ||
>> +              !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
>>                   BM_SSP_STATUS_CARD_DETECT);
>>   }
>=20
> Sorry, I missed your original XOR here, when merging my changes:

Can you send an incremental patch against my 2/2 with your
Signed-off-by, I'll squash your patch into mine and repost the series.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2VKTVBJXGHRJIFDEKIGHU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlFkQwsACgkQjTAFq1RaXHN5IACfdObCBUhProlxzuc3aC+XqXK3
6eoAnjJ3ZOa5VXc9N/QmCQj9X3e9Arl5
=YGNk
-----END PGP SIGNATURE-----

------enig2VKTVBJXGHRJIFDEKIGHU--
