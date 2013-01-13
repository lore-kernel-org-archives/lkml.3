Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3AMOhP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 09:37:15 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33644 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755172Ab3AMOhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 09:37:14 -0500
Message-ID: <1358087817.4514.79.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 224/241] HID: add quirk for Freescale i.MX28 ROM recovery
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Marek Vasut <marex@denx.de>,
        Chen Peter <B29397@freescale.com>, Greg KH <greg@kroah.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Sun, 13 Jan 2013 14:36:57 +0000
In-Reply-To: <1355407206-17100-225-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
	 <1355407206-17100-225-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-GPyQsOMYvCLWWLUywVJq"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GPyQsOMYvCLWWLUywVJq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-12-13 at 11:59 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7.2 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Marek Vasut <marex@denx.de>
>=20
> commit 2843b673d03421e0e73cf061820d1db328f7c8eb upstream.
>=20
> The USB recovery mode present in i.MX28 ROM emulates USB HID.
> It needs this quirk to behave properly.

Greg, this is missing from 3.0 and 3.4 but should be applicable.

Ben.

> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Chen Peter <B29397@freescale.com>
> Cc: Greg KH <greg@kroah.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> [jkosina@suse.cz: fix alphabetical ordering]
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> [ herton: adjust context ]
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>
> ---
>  drivers/hid/hid-ids.h           |    3 +++
>  drivers/hid/usbhid/hid-quirks.c |    1 +
>  2 files changed, 4 insertions(+)
>=20
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 9d9bb9a..5ddfcc7 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -296,6 +296,9 @@
>  #define USB_VENDOR_ID_EZKEY		0x0518
>  #define USB_DEVICE_ID_BTC_8193		0x0002
> =20
> +#define USB_VENDOR_ID_FREESCALE		0x15A2
> +#define USB_DEVICE_ID_FREESCALE_MX28	0x004F
> +
>  #define USB_VENDOR_ID_FRUCTEL	0x25B6
>  #define USB_DEVICE_ID_GAMETEL_MT_MODE	0x0002
> =20
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-qui=
rks.c
> index 991e85c..8865fa3 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -70,6 +70,7 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
> +	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGE=
T },
>  	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_=
QUIRK_NO_INIT_REPORTS },
>  	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN1, HID=
_QUIRK_NO_INIT_REPORTS },

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-GPyQsOMYvCLWWLUywVJq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPLGiee/yOyVhhEJAQrIohAAqskUUK87CHySpVMFBAO5ANcgx+wfTtRo
55Tl1+PVx+F1k3PbzVs07anHbr7RPo0690cSh+gPXHd630AvE9VjvWeDAcdSL4IH
wwDlB8uwvhmbzigOaujLj1fxMfCOslpG6GrxijYOGHoJDGMrhoy4926Gjqc+32d6
TF9uK7FtEQBMKFice04G8Upxy6zNtHDkQpiFJomYeQhq0JooQ6CvAubRN44y5kjj
m9hPUDvAKh8Et7BNB2OncaPBMaGQs6upmk+5dOQWR1RAuRkLoFsK8T8n3s/Qfyav
gMMq11ldETSkveKJuK04RjlTRCmMlmKDEFPpTDXbIKsRFr2Hp3rGPqTetpePyrCW
EGkrYT3TNQLmeBCaSq64+RUy3ecG5oDPljxjxeBg1ZiojUlTvmWZuUccNLB4KL4a
Sj4ySZkDlrtsLJqKZNsY/bd4hKjSbwTAfToodPNFQWw6hDSXHTdrMSz6iFknY9L9
jGxve4susEftlsUSuuCIo0Is4/Qxp97rZa0uTKi+VfZZIoHQfs7XVjY4WBfrEMwP
r2a59BnpfJYQMEN2kF9JrfVg1E6DqXwhx6/MuN3IjaxGupaFEMQvHui0sVr5Jr3P
4O4HsCGDKvnPy2JHylfYoLJ7MLit3FzZ00A2KoUFFhmt8eMPgssJMVec2LWMzNQE
A+SDi6CBtAs=
=ClNK
-----END PGP SIGNATURE-----

--=-GPyQsOMYvCLWWLUywVJq--
