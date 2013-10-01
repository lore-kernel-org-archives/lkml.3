Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3JAOX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:23:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57727 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839Ab3JAOXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:23:51 -0400
Date: Tue, 1 Oct 2013 09:22:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Felipe Balbi <balbi@ti.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Anton Vorontsov <anton@enomsg.org>,
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
Message-ID: <20131001142240.GR1476@radagast>
Reply-To: <balbi@ti.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <20130918164816.GN21559@radagast>
 <201309181903.33243@pali>
 <201309251017.39014@pali>
 <20130925203333.GU10746@radagast>
 <20130926000059.GA25716@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ma2pZxZcUUd0eybH"
Content-Disposition: inline
In-Reply-To: <20130926000059.GA25716@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Ma2pZxZcUUd0eybH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 26, 2013 at 02:00:59AM +0200, Pavel Machek wrote:
> > On Wed, Sep 25, 2013 at 10:17:38AM +0200, Pali Roh=E1r wrote:
> > > On Wednesday 18 September 2013 19:03:33 Pali Roh=E1r wrote:
> > > > &twl->phy.notifier is not initalized
> > > >=20
> > > > Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> > > >=20
> > > > diff --git a/drivers/usb/phy/phy-twl4030-usb.c
> > > > b/drivers/usb/phy/phy-twl4030-usb.c index 8f78d2d..efe6155
> > > > 100644
> > > > --- a/drivers/usb/phy/phy-twl4030-usb.c
> > > > +++ b/drivers/usb/phy/phy-twl4030-usb.c
> > > > @@ -705,6 +705,8 @@ static int twl4030_usb_probe(struct
> > > > platform_device *pdev) if (device_create_file(&pdev->dev,
> > > > &dev_attr_vbus)) dev_warn(&pdev->dev, "could not create sysfs
> > > > file\n");
> > > >=20
> > > > +	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
> > > > +
> > > >  	/* Our job is to use irqs and status from the power module
> > > >  	 * to keep the transceiver disabled when nothing's
> > > > connected. *
> > >=20
> > > I sent above patch week ago. Did you already included it?
> >=20
> > look at my testing branch.
>=20
> Felipe prefers you to go MAINTAINERS file for
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
>=20
> entry. After few clicks, you'll find out your two patches in=20
>=20
> https://git.kernel.org/cgit/linux/kernel/git/balbi/usb.git/log/?h=3Dtesti=
ng
>=20
> . So yes, it seems that after 10+ flames Felipe was _not_ lazy to
> send, "Thanks for a patch" mail was too much work.
>=20
> Apparently, we'll need  Documentation/HowToBeGoodMaintainer file...

I only send my automated emails after properly testing them. They sit in
'testing' for as long as necessary. After all the test is done, they'll
be moved to 'next' at which point you get your email notification and
they reach linux-next for the next day.

--=20
balbi

--Ma2pZxZcUUd0eybH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSStqwAAoJEIaOsuA1yqREAwsP/1FZp9Q04f3ZWw28tSd9flJ3
i8ioP4uhQGr3c6lF5B1fyMcl80R9yBslQudVS8Zc5o1/ZXCgsECXtHE2KyZAvahR
Jg3wfKCSFbIr3/ubuH0RRgyzPDzNOiDJ0T2a4PJHMSnxsFT4pdaJRMAvIaW7AuTT
PqDvN1+sHbR1/pTDyfeuXnKTu9Bu5IZ5G/NLDKqwW1StHhoWDCPxLI/ryLR9Lh4+
SPMirEszNGmnWGCL/DR4+cdC+WqvrxmttGavbsRAmB3yDh/8xbGnWJR3i+5cKIGR
cEcn6bBufltmJbu99nX1J/x0TJ9zqSBnM/nm9uPReSb0/SzRM62THLbuJ5i41Nph
rz0OIYl5GmV3PVjh0FX8KAi+8csCcNxCnHqIgSqk6t2JehN/BYBPO1cJ28We371N
lLxdkQGH6+uSN5z4Am6sOM3Y6jYOePnYSuVkt+Mo8gRzTEQwQjw3jXe59CGOLfZE
T+0eJzYpCdJNI84PgvqVDk7ofZUV1ezb+sO83C4FjfkeP8pDwRXHc61eHHx6hoDF
x/SA1uLKGCVRNQFnyUtzFv7GFBFEKjLPROuPtlmMYB35sE4YUYaDVkUZ45/3imu+
xux0snwUByRwgFcP1HVipkhpM9xAZF2L4CAhl0MeSbglAf1/KlwznZG30OD3Cdyd
3ONL9X+CFtxZ28o68Aof
=h3uN
-----END PGP SIGNATURE-----

--Ma2pZxZcUUd0eybH--
