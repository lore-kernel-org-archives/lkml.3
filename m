Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab3IYUec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:34:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44596 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374Ab3IYUea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:34:30 -0400
Date: Wed, 25 Sep 2013 15:33:33 -0500
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: <balbi@ti.com>, Javier Martinez Canillas <martinez.javier@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Tony Lindgren <tony@atomide.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <freemangordon@abv.bg>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH usb 1/2] usb: musb: Add missing ATOMIC_INIT_NOTIFIER_HEAD
Message-ID: <20130925203333.GU10746@radagast>
Reply-To: <balbi@ti.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <20130918164816.GN21559@radagast>
 <201309181903.33243@pali>
 <201309251017.39014@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4QzzFpAwbwI4hdN6"
Content-Disposition: inline
In-Reply-To: <201309251017.39014@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4QzzFpAwbwI4hdN6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 25, 2013 at 10:17:38AM +0200, Pali Roh=E1r wrote:
> On Wednesday 18 September 2013 19:03:33 Pali Roh=E1r wrote:
> > &twl->phy.notifier is not initalized
> >=20
> > Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> >=20
> > diff --git a/drivers/usb/phy/phy-twl4030-usb.c
> > b/drivers/usb/phy/phy-twl4030-usb.c index 8f78d2d..efe6155
> > 100644
> > --- a/drivers/usb/phy/phy-twl4030-usb.c
> > +++ b/drivers/usb/phy/phy-twl4030-usb.c
> > @@ -705,6 +705,8 @@ static int twl4030_usb_probe(struct
> > platform_device *pdev) if (device_create_file(&pdev->dev,
> > &dev_attr_vbus)) dev_warn(&pdev->dev, "could not create sysfs
> > file\n");
> >=20
> > +	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
> > +
> >  	/* Our job is to use irqs and status from the power module
> >  	 * to keep the transceiver disabled when nothing's
> > connected. *
>=20
> I sent above patch week ago. Did you already included it?

look at my testing branch.

--=20
balbi

--4QzzFpAwbwI4hdN6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQ0idAAoJEIaOsuA1yqRETvkP/00qKMIHusJX8O7XH/vSHkwR
+POrDoU06Cay14nUS7nWEVjNCH7N1shqK46Girevrbo4urlMZoDJhN0I1Q8lgenv
IZsihUkx8Q3AOMNFt0um80vbLL456s9dr4/4PwVXFHK2dkdfUoJqm90JNXGK1Pi4
QHxG8PVO1/6wFBtFgwj8YL1qZwFC6rqlwJCL/Q7orfS4AS6/TDy5p77wnS4md5Hx
ehcD22VrPAo7CcAufw24Y8yYUuIOJK/+F1PUvSVya90D42g5Rueh7V3jxt/GJwDx
ifTD23ENhNzvIU0GwOvLgYQYqDN8Gnx0FkF+UVQh5YrTZLIM1HB3UrHd7waIxNVO
UezaPxv48Ez60/t3tb3SU2dNDrEc89mA/jVD59+fysyg4RJwLbAlROjwOJRXsKQ8
cpuXRI2zH49JKkOuMvf0zhQxjlJvIuwyvof6wDc3iNuyXPypwRyUIgo8TxnIslgt
mIle9yxd+nVbZBrdFUmt2bVW7LuYHZy6krL4HR914b3Mbyd2uOccR92v0n2fRJ6f
cK0QHrocxVyXj4CyGTPyqRl2de0UYBkrlgkvf+n8tm1n4flylcBT7yhyNDkbHGQi
D4KzVabaZHvkBVlaOR/xT51Ttrm1T1MpgPywY4McLnTO0RQ8cxqAzSWRJXCZF61J
2F1KzfOEnDAazyl5qSRB
=80Pi
-----END PGP SIGNATURE-----

--4QzzFpAwbwI4hdN6--
