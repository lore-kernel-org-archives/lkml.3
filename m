Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3AYPAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:00:01 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54553 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab3AYO77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:59:59 -0500
Date: Fri, 25 Jan 2013 16:59:28 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: Felipe Balbi <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "tony@atomide.com" <tony@atomide.com>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 1/4] drivers: usb: phy: add a new driver for usb part
 of control module
Message-ID: <20130125145928.GC28379@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359109440-2195-1-git-send-email-kishon@ti.com>
 <1359109440-2195-2-git-send-email-kishon@ti.com>
 <20130125110141.GK3075@e106331-lin.cambridge.arm.com>
 <20130125111120.GP15886@arwen.pp.htv.fi>
 <20130125122943.GB16795@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uh9ZiVrAOUUm9fzH"
Content-Disposition: inline
In-Reply-To: <20130125122943.GB16795@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 25, 2013 at 12:29:43PM +0000, Mark Rutland wrote:
> > > > +   depending upon omap4 or omap5.
> > > > + - reg-names: The names of the register addresses corresponding to=
 the registers
> > > > +   filled in "reg".
> > > > + - ti,type: This is used to differentiate whether the control modu=
le has
> > > > +   usb mailbox or usb3 phy power. omap4 has usb mailbox in control=
 module to
> > > > +   notify events to the musb core and omap5 has usb3 phy power reg=
ister to
> > > > +   power on usb3 phy. Should be "1" if it has mailbox and "2" if i=
t has usb3
> > > > +   phy power.
> > >=20
> > > Why not make this a string property, perhaps values "mailbox" or "reg=
ister"?
> >=20
> > NAK.
>=20
> Can I ask what your objection to using a string property is?
>=20
> As far as I can see, "ti,type" is only used by this driver, so there's no
> common convention to stick to. Using a string makes the binding easier for
> humans to read, and thus harder to mess up in a dts, and it decouples the
> binding from kernel-side constants.

IIRC there is some work going on to add #define-like support for DT,
which would allow us to match against integers while still having
meaningful symbolic representations.

--=20
balbi

--uh9ZiVrAOUUm9fzH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAp3QAAoJEIaOsuA1yqREH0UP/ReIIcy0pLxMRcsSYakc45nk
vrqi7QpGU6moc2RIyqjpJXaxEG5HjMt+PXG/RXb1QDly/mXhlxKblHsME5ets4wP
NAh+uSb1oMMyPhCsHFA0B1kgfbzbF3yKWXBI0YkyhP1aOkeUcSd5tXSKW3YIb3gp
HoHRWvt7Er+MRMQxLklH7Si05eVD4Kf4WiMMq9fSbJjfV/DZOzF/gLyrlqBA36rh
ui7bA6kZze04+Buj1LLqzrN6eBMT7YfhGIYgvkbNut7QsZzaEInF1k13sfWjfCSH
rF4nHeKX6tADeJVqNVOFf1HzfPa3mwPznuKzgWrpxyR2Z8axWnHPbuW9WCjNURNh
C1dyCmW7a2BIxLtRlBIJ8GtEB9He8/henfvfhct7jvoCLgaj2GeEb0+gidTUTnK2
LPsHvkce+0HJ3quCPJLuIEVYN+FwMW+o5KTWmvSIYA2m2wVNhhuibuXJQZaRKDdA
kUKDmloWANpxl8YpNorSOAywdUoiyB1pukfjECH5ZbZmrZnhglYUtvm8ElYFajKZ
Djp+8cd9nJarDdOlmow45Q2XHTDMiOzpkKznpE9KGa6c0JiYH3ELPvnMsady+fEM
V5H6k9t2V7r7HGbJ++gIuT1wKdmX0C131kr8RxU71HnyWPvBAhOU7mgSDoUqYymo
QwIaG0K6Eh2s1OlB4u1s
=YVg8
-----END PGP SIGNATURE-----

--uh9ZiVrAOUUm9fzH--
