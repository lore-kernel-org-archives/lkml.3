Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab3IQPvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:51:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60552 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab3IQPv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:51:29 -0400
Date: Tue, 17 Sep 2013 10:49:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: Tony Lindgren <tony@atomide.com>, Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <freemangordon@abv.bg>, <aaro.koskinen@iki.fi>, <pavel@ucw.cz>
Subject: Re: [PATCH 1/4] usb: musb: Call atomic_notifier_call_chain when
 status is changed
Message-ID: <20130917154917.GL15645@radagast>
Reply-To: <balbi@ti.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1378630239-10006-2-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7VkxxUl3xUvPtoxk"
Content-Disposition: inline
In-Reply-To: <1378630239-10006-2-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7VkxxUl3xUvPtoxk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 08, 2013 at 10:50:36AM +0200, Pali Roh=E1r wrote:
> diff --git a/drivers/usb/phy/phy-twl4030-usb.c b/drivers/usb/phy/phy-twl4=
030-usb.c
> index 8f78d2d..efe6155 100644
> --- a/drivers/usb/phy/phy-twl4030-usb.c
> +++ b/drivers/usb/phy/phy-twl4030-usb.c
> @@ -705,6 +705,8 @@ static int twl4030_usb_probe(struct platform_device *=
pdev)
>  	if (device_create_file(&pdev->dev, &dev_attr_vbus))
>  		dev_warn(&pdev->dev, "could not create sysfs file\n");
> =20
> +	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);

BTW, this is a bugfix, send separately.

--=20
balbi

--7VkxxUl3xUvPtoxk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOHn9AAoJEIaOsuA1yqREbc0P+QGn7Kr1TlI88D2PM0zG9BuZ
mQHBSecSTx+EoxzKF8skBQvZTXJ+ilnPLGt2RUmEJvU5NLGEkETfxA4fvf7Lg6ka
Sct26xjBS5lNlGjSgnOdisKk80ktRULAlY9ATLhcLzmdP+llsqDApOROBihdY0d6
QKa6Dx/HKQY2u4sJEOwNPwk0ThsysJijTIawkjJWAsuUFCP7kVEezVylG43OntI0
1cI6iW9D0o4BZin29f3yXyN9sgkYyqn8+UR3+wVukaPMLhhrPZ+tbDtqKweHtVgA
oSqVRzHFZb4TXEZy7TC7vQvNDeaqQcPCiutUKe/W2ceo8hfjhAcaBfbH7LfBJIjb
qfoXF4SZfhNrq3/SyDGt6bSKr7EnIBIpFgmCsFiP0Dmlchqc2TqXYdEABNYs3jas
/jkxiYGEyLsIyPy7VLIfQgwpecRyNuu9hB1lK68R5UZFfrgJc5YneLR2DVLDsWi2
U2VKJo2Y8CvpdW2sArepty+3yhxwwLeXZcNj6P08wSMwOC+HkGDaJlWjyWx5mHZ/
TUAHUjBU2T4CNGvC21l5m4kz40oP5C3/ZY9mpVk8Fz2oWzUpDp9Gm3WKd2qryrYL
JYVb/ix5rUc6A0k8SqHiEd6HNxEqRICWSFJFoPbwkAJNDsq1Yp3VNpJCsHKf2YLY
sf44YT8lXBxUHEWiBVPj
=6a2V
-----END PGP SIGNATURE-----

--7VkxxUl3xUvPtoxk--
