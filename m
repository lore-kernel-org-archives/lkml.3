Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab3G3HRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:17:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54366 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab3G3HRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:17:13 -0400
Date: Tue, 30 Jul 2013 10:16:11 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm: omap: remove *.auto* from device names given in
 usb_bind_phy
Message-ID: <20130730071611.GD16441@radagast>
Reply-To: <balbi@ti.com>
References: <20130729150638.GD3063@radagast>
 <51F68A56.8060805@ti.com>
 <20130729175413.GC4964@radagast>
 <51F74BC8.7020903@ti.com>
 <20130730060134.GD9155@radagast>
 <51F7590B.4020705@ti.com>
 <20130730061830.GE9155@radagast>
 <51F75C40.4060406@ti.com>
 <20130730062844.GH9155@radagast>
 <51F7613C.5070803@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
Content-Disposition: inline
In-Reply-To: <51F7613C.5070803@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 30, 2013 at 12:16:20PM +0530, Kishon Vijay Abraham I wrote:
> >>>> the list of controller device (names) it can support (PHY framework =
does not
> >>>> maintain a separate list for binding like how we had in USB PHY libr=
ary). e.g.
> >>>> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg92817.html=
=2E In such
> >>>
> >>> this has nothing to do with $subject though. We talk about generic PHY
> >>> framework once all these PHY drivers are moved there :-)
> >>>
> >>>> cases how do we pass the device names. Also will the MUSB core devic=
e be
> >>>> created before twl4030-usb PHY device?
> >>>
> >>> and why would that be a problem ? We're telling the framework that the
> >>> musb device will use a phy with a name of 'twl4030'. If musb calls
> >>> usb_get_phy_dev() and doesn't find a phy, it'll return -EPROBE_DEFER =
and
> >>> try again later.
> >>
> >> I think we are talking about different problems here ;-) I'm trying to=
 tell
> >> using idr in MUSB core is needed for Generic PHY Framework. So in a wa=
y, the
> >> Generic PHY Framework series depends on this patch series or else MUSB=
 in OMAP3
> >> platforms wont work after Generic PHY framework gets merged.
> >=20
> > then you just found a limitation in your framework, right ? :-) I mean,
> > imagine if now we have to add an IDR to every single user of your
> > framework because they could end up in systems with multiple instances
> > of the same IP ?
>=20
> I raised a similar concern in the PHY framework discussion [1] :-) And si=
nce
> it's used everywhere else regulators, clkdev, etc.. it's agreed to be use=
d in
> PHY as well. Btw if PLATFORM_DEVID_AUTO is used even regulator, clk_get s=
hould
> fail IMO.
>=20
> [1] -> http://lkml.indiana.edu/hypermail/linux/kernel/1307.2/03573.html

look at Greg's and my reply to that email.

--=20
balbi

--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR92g7AAoJEIaOsuA1yqREY0IP/2rLJXtchwOiyow03vRcjVbv
tsWrWB2cGvtGAe3cnyAqaBzTIJ0RlA/N3d+gjy8qPWrShKrLTOgBXB+vcjpQZUcZ
9zfFef0pz1vz3/lXkDYj/mDNkIcIS6SslzbJ8KIfArniXgfB6Yj+T3xgtzc1gbKH
76OrAq3fTZJYPeoLFUVQX+Eh3z8O33QocWYLFHFXpcDO5wMTrz5B2lGmfhukd/FN
yPaZvh/34EqdOTNdt7xxcbZNj0gTzsGVyFPgrrixn/arkbX13Ffzhn/caGuHIrSC
SrTKJ6+GCuur+XFduYtOweV6mKs/DTxK7UCIqPKHbYuUnKJXmYppTRUAKqJ4fSWo
nBotOyRwS6JYl+1JRWrC1BPnwnZJ83ECXo9+Un5FwFjNoZ6oqTHFIgrzSlpIkNZF
eIU6GhDlXZGf7M08cHZ+ALsdA0eMgt7RYW2W+zlkL3L4OIHEPLD/UiWoAX/LEnGY
yAJLslgXBkvRwUa3UyABg9GRg1F+mhCzEI+Zq8lc+u98WcfQ5r6g4K64QImFJnBa
7IdK6t5IX8/T1FfCZA/Jfg7VMwPPV7meIar0gUQTSciex6/gMYuQlXM5txMuGbk2
xO1rUy1q6Zfw4DbPWS/7eYPT+WUBn2jZFPk9IfFU3AUPzJlNiGPE7kDaJ8ph/l21
Eix1XIq50wgErgvxv2c8
=0vRB
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--
