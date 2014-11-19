Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaKSDKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:10:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57672 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbaKSDKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:10:33 -0500
Date: Tue, 18 Nov 2014 21:10:49 -0600
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH]  usb: gadget: USB3 support to the legacy printer driver
Message-ID: <20141119031049.GB24874@saruman>
Reply-To: <balbi@ti.com>
References: <546A829A.8030106@linaro.org>
 <20141118003028.GA11280@saruman>
 <546B5578.8040809@linaro.org>
 <20141118151753.GB8223@saruman>
 <546B874B.8060700@linaro.org>
 <20141118180039.GJ6179@saruman>
 <546BAF07.1050605@linaro.org>
 <20141118204708.GR6179@saruman>
 <A2CA0424C0A6F04399FB9E1CD98E0304844EDA05@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844EDA05@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 09:45:13PM +0000, Paul Zimmerman wrote:
> > From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kern=
el.org] On Behalf Of Felipe Balbi
> > Sent: Tuesday, November 18, 2014 12:47 PM
> >=20
> > On Tue, Nov 18, 2014 at 03:41:43PM -0500, Jorge Ramirez-Ortiz wrote:
> > >
> > > notice that the original PLX driver was still far from the theoretica=
l 5Gbps
> > > target (I was expecting to measure at least 3Gbps and could only get =
1Gbps).
> > > So 1Gbps should be the target to meet on the kernel.org net2280 - do =
you agree?
> >=20
> > this depends on a whole bunch of things. Mainline is a lot different
> > from PLX's kernel tree, I'm sure.
> >=20
> > It also depends on how many PCIe lanes you're using. Just because USB3
> > guarantees 5Gbps bandwidth, if you use a 1x PCIe connector, you'll never
> > get that ;-)
>=20
> Being pedantic, USB3 runs at 4Gbps, not 5Gbps. The signal transitions
> on the bus are at 5GT/s (5 giga-transitions per second), but due to the
> 8b/10b encoding, that equates to 4Gbps data rate.

I stand corrected :-)

--=20
balbi

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbAo5AAoJEIaOsuA1yqREzfcQAKR/sMk9WlhJK+1NWPk/LJ03
brwDyOQO/SGgYfZO/+EDpYqbgnWAhpFMCt5rcxmi1PFbsXLCIoEO55Xsjzd2m8aB
hUm7N0NNAxwqh3BXVytA2hjcjYeKXbgijOj1Rfzz1RYIyTVsKrwFk7QGMZxYi8d5
pCboMUt3z7CQwAMqUEiGndYh3eYdPgY+OsmCv+3NZAEqAOuxy9DE6r7txR8hyY4r
lJNeDJwIsVg8KxgIin7yBRWVDJltUMIpWlIqd4BILAOfj3TwLwRr/pjY0z+SJ+Kx
1/3t0l8Ol0PxPWlvAabsi2P/30WSmYSUGSriS8qpMO1rWtOSfjGcL+u4uzWsf3Co
3/6+YWdSMskvRiic/ct6WAppnO9zpHskSFs7OAkm9JgZ1VPy72VDI3zHZZ6oNygd
B9GTBOAifKp5L2FoFVardzpnT9p9XawCtzxHy8/sNFXpQPrg1OdMGDZN0ipkKvIa
qpGEEHRPYRW71vn1MYJcVRQbfqpswYdLBpaPS6GsFSC9UVXkdTMwW0UIed4s5Yba
NDW9lUdiZP+HZdUqiZ++7nPC+I4gWwpnIMFRuH1tgimggx4OF3TUU3n25gJgF+xU
329kfvWxUd8+7RW3e9LGTDfjbag59rNwZ8TV8+CLGXw88OlybOA9tbxO6crQq5kg
1QRTEPUx8AyXSLHjQAJB
=DpTt
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
