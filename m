Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaKCPBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:01:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53964 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaKCPBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:01:21 -0500
Date: Mon, 3 Nov 2014 09:00:48 -0600
From: Felipe Balbi <balbi@ti.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: David Cohen <david.a.cohen@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>, <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141103150048.GB27425@saruman>
Reply-To: <balbi@ti.com>
References: <20141013192404.GB4034@psi-dev26.jf.intel.com>
 <20141013192632.GC29810@saruman>
 <20141013193618.GD29810@saruman>
 <CACRpkdYDiFvwsPwqACXS2bZU9peUyJEn-fpzVqZKYXseuEFGGA@mail.gmail.com>
 <20141028144249.GD8123@saruman>
 <CACRpkdaN5hNWFUOFbHLm8HgZEKVSETUgVF4Cn4UbMQxNEg46Vw@mail.gmail.com>
 <20141031132005.GB1273@saruman>
 <20141031162339.GA7136@psi-dev26.jf.intel.com>
 <20141031184509.GA2224@psi-dev26.jf.intel.com>
 <20141103092402.GA1304@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Content-Disposition: inline
In-Reply-To: <20141103092402.GA1304@lahna.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 11:24:02AM +0200, Mika Westerberg wrote:
> On Fri, Oct 31, 2014 at 11:45:09AM -0700, David Cohen wrote:
> > > I think adding the module exit + allowing this driver to be a module
> > > would be a good approach. Then we don't need to force generic x86 ker=
nel
> > > binaries to always have this driver. Unless Mathias or Mika knows a
> > > constraint to force this driver to be builtin only.
> >=20
> > It helps if I CC them when asking for feedback :)
> >=20
> > Mathias, Mika, do you know any constraint that forces pinctrl-baytrail
> > to be bool?
>=20
> The only constraint that has been keeping this driver as bool is that
> some machines like, Asus T100, uses ACPI GPIO operation regions for
> toggling GPIOs to get things like sensor hub powered on. The GPIO
> operation region code does not yet handle -EPROBE_DEFER so only way to
> ensure that the operation region is there is to have the driver compiled
> in to the kernel.

But that's not enough excuse to have every single x86 in the market
shipping with this driver. Think about a distro kernel, most likely this
gets enabled and it's wrong in 80% of the cases.

It would be nicer to add EPROBE_DEFER support, convert this into
tristate and have default =3D M if BAYTRAIL, or something.

--=20
balbi

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV5igAAoJEIaOsuA1yqREvFcP/0+WmyYRIAnUT6SRpixS7MT4
tV/K3eT1/5NTHlF836fVhmJ6yCXIWsNfLja1zPiS1ehdjzSTAKiULpV6Lcj4l6gN
eW9V6ivqCGJ+FeGhtaL7/zRYjZKAs2wjhlsst8exOSAwsHLr+nYG2EQvkJVbDxYl
jtq3vcXsPyloEPYIrA6WpGcct7HPDE5kFChDkJGI0Eez1Lo0cvsp3aPik6+Fx6R2
SpgGPMDwwqjH5twzwsBctVlIgGRPfPz00em7/lUd47FhOSnAXNKwV6VfyQlQx07o
MzRdPbUG4DusnTixoYDNCu+Ae6u58wCjQjXPCC7XMdnrCUE/0kSDsHrNo6YWnO01
LV0TarcPWS2d+7ESiyyihNAeVTY44DFtQfwBotp4MO2u9k1P2Tm6qH7bmoX9ddiE
jRdEVktSSnujBfArA4T+NphEkz8AYvjqWd5lPVfbcZhXl35jWg9Ic3rw0Wg9tqe1
xeoMbLRCRIpGtgNaPzLfEPLy/HEzwvqU8T8q6EoElqw1hb/Gc3AWv88l7MLfHft7
SGUfPwCrXlOGg1qfSbqag/oyJbKxn58ipIw/Upcf9bIO6aOCVZ+vD4iJL+x9wELD
qtbeD+tn7a1+AXhXrFDkMcsqshgvNeLEfnUtsOqK9jW+iXU0om9KlcbKchG+34Y9
0+WdhZs6YnD6rxjUL22E
=SCIl
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
