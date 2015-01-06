Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbbAFXa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 18:30:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38756 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbbAFXaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 18:30:55 -0500
Date: Tue, 6 Jan 2015 17:29:27 -0600
From: Felipe Balbi <balbi@ti.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Felipe Balbi <balbi@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        <pali.rohar@gmail.com>, <sre@debian.org>, <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>, <khilman@kernel.org>,
        <ivo.g.dimitrov.75@gmail.com>
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150106232927.GA18073@saruman>
Reply-To: <balbi@ti.com>
References: <20150106175115.GA19487@amd>
 <20150106202857.GB32308@saruman>
 <20150106205000.GB13902@amd>
 <20150106205730.GA6071@fuloong-minipc.musicnaut.iki.fi>
 <20150106220805.GD13902@amd>
 <20150106222717.GC6071@fuloong-minipc.musicnaut.iki.fi>
 <20150106224622.GA13752@saruman>
 <20150106225614.GA31990@amd>
 <20150106230415.GC13752@saruman>
 <20150106231341.GA18468@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20150106231341.GA18468@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 07, 2015 at 12:13:41AM +0100, Pavel Machek wrote:
> On Tue 2015-01-06 17:04:15, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Jan 06, 2015 at 11:56:14PM +0100, Pavel Machek wrote:
> > > > > But I'm mounting it from userspace (using builtin initramfs inside
> > > > > zImage), with a poll loop that waits for a device to appear. Mayb=
e if you
> > > > > do it from kernel you need to use root wait/delay etc. options?
> > > >=20
> > > > yeah, rootwait should do it.
> > >=20
> > > No, rootwait does not solve it. Try it. Tested many times. (And yes,
> > > you need to actually fool the rear cover sensor or close the phone.)
> >=20
> > yeah, just put a magnet or, if you have spare back covers, cut one so
> > that you "close" it, but still allow you to put the thing on a
> > development jig.
>=20
> Actually, it should be enough to kill a line from dts somewhere, no
> need to hack hardware for this.

right

> > Also, if why doesn't rootwait work ? You never have a new mmc node or is
> > the mmc node changing names ?
>=20
> IIRC node and name are ok, but the mount just fails. As I don't have

really weird. Specially since it works when you mount afterwards.

> "development jig", I lack serial console and this kind of debugging is
> not easy.

see if this helps:
https://wiki.maemo.org/N900_Hardware_Hacking#Debug_ports

--=20
balbi

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrG/XAAoJEIaOsuA1yqREAv8P/26a43/+JgVM49/AgZ7vfYJy
FmmBIIAB6LgyyJQcaGlJ1Xysw5bIDGBWvvcPtnEiYUv34DkfXhROXlY55mL4WFTO
/8FgMjBQY44MtusnK1Tr1K0nygK/kV7DC5bQsMRigEwHoQO1iarv9rvV0lGo7tBQ
Z1R44vFQuCsWAx0GqXINXBoaWTKzsdMlqKD+BkIW2x6e6rThTPWL9llxhKmI2Sh7
sZ7m2qf2Qk3FZwwb4ovi8x/qPw4PupAGoGD4P8FdRT0W7TNKzzu75wT9vkBgl460
XLqkD8COD2t4Sm18AVTLVsGf5XeD5UWDY8T2KvTsa5l4Cwe+X3Hg1yOxpCU/616D
OV0yJj0vn0alyaBUHdys6YTCMS+DR8rSro+Mu1UvxLRe+Z3nr+y5Ii/0PnuCiLwh
cbyXYigSxU2ipbhkWufKRnoF1z4TXH18gNsydx2MEqgEYOWdbJdXIRwnJdW/It6F
ML3R/Zzcz0TLFjWL7GaAuXWvJHkKnq+EEl+SxhxVtde9/Wj0S21rsc5g0v2FDDGi
kNp6k/W0enqek2UrxSmpxBCf4mP0COlh5oAazHEarxW+fS5ftyvsZT1nQrL9eELr
bcKV9AsCZGcUVvefgSqjJ1H8x8Y5aOrqudtFpvfSAXjRI1GzvRjq6R+IySrFL0ho
ky0wOIiWlyJANccnc0FO
=eVoA
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
