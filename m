Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab3IYIRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:17:48 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33863 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3IYIRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:17:43 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: balbi@ti.com
Subject: Re: [PATCH usb 1/2] usb: musb: Add missing ATOMIC_INIT_NOTIFIER_HEAD
Date: Wed, 25 Sep 2013 10:17:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Tony Lindgren <tony@atomide.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        freemangordon@abv.bg, Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <20130918164816.GN21559@radagast> <201309181903.33243@pali>
In-Reply-To: <201309181903.33243@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3714314.3tRJqkthev";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309251017.39014@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3714314.3tRJqkthev
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 18 September 2013 19:03:33 Pali Roh=C3=A1r wrote:
> &twl->phy.notifier is not initalized
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> diff --git a/drivers/usb/phy/phy-twl4030-usb.c
> b/drivers/usb/phy/phy-twl4030-usb.c index 8f78d2d..efe6155
> 100644
> --- a/drivers/usb/phy/phy-twl4030-usb.c
> +++ b/drivers/usb/phy/phy-twl4030-usb.c
> @@ -705,6 +705,8 @@ static int twl4030_usb_probe(struct
> platform_device *pdev) if (device_create_file(&pdev->dev,
> &dev_attr_vbus)) dev_warn(&pdev->dev, "could not create sysfs
> file\n");
>=20
> +	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
> +
>  	/* Our job is to use irqs and status from the power module
>  	 * to keep the transceiver disabled when nothing's
> connected. *

I sent above patch week ago. Did you already included it?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3714314.3tRJqkthev
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlJCnCIACgkQi/DJPQPkQ1KMzQCeIeAq4podweQ/jVyI4DQTQoV4
nMoAnRLhzlQLdiiPUjkl7/A8L7UNZWFl
=qonf
-----END PGP SIGNATURE-----

--nextPart3714314.3tRJqkthev--
