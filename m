Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbbA0TpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:45:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:46178 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758523AbbA0TpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:45:05 -0500
Date: Tue, 27 Jan 2015 20:40:53 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Priit Laes <plaes@plaes.org>
Cc: linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [linux-sunxi] Re: [PATCH] arm: sunxi: input: RFC: Add sysfs
 voltage for sun4i-lradc driver
Message-ID: <20150127194053.GN7200@lukather>
References: <1422291516-24895-1-git-send-email-plaes@plaes.org>
 <20150127091829.GD7200@lukather>
 <1422352189.23189.12.camel@plaes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YC8Ek3FeOE8ywfXk"
Content-Disposition: inline
In-Reply-To: <1422352189.23189.12.camel@plaes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YC8Ek3FeOE8ywfXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2015 at 11:49:49AM +0200, Priit Laes wrote:
>=20
> On Tue, 2015-01-27 at 10:18 +0100, Maxime Ripard wrote:
> > Hi,
> >=20
> > On Mon, Jan 26, 2015 at 06:58:32PM +0200, Priit Laes wrote:
> > > ---
> >=20
> > Like Hans was pointing out, commit log and signed-off-by please
> >=20
> > >  .../ABI/testing/sysfs-driver-input-sun4i-lradc     |  4 ++
> > >  drivers/input/keyboard/sun4i-lradc-keys.c          | 49=20
> > > +++++++++++++++++-----
> > >  2 files changed, 43 insertions(+), 10 deletions(-)
> > >  create mode 100644 Documentation/ABI/testing/sysfs-driver-input-
> > > sun4i-lradc
> > >=20
> > > diff --git a/Documentation/ABI/testing/sysfs-driver-input-sun4i-
> > > lradc b/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
> > > new file mode 100644
> > > index 0000000..e4e6448
> > > --- /dev/null
> > > +++ b/Documentation/ABI/testing/sysfs-driver-input-sun4i-lradc
> > > @@ -0,0 +1,4 @@
> > > +What:          /sys/class/input/input(x)/device/voltage
> > > +Date:          February 2015
> > > +Contact:       Priit Laes <plaes@plaes.org>
> > > +Description:   ADC output voltage in microvolts or 0 if device is=20
> > > not opened.
> >=20
> > Why is it returning 0 when "device is not opened" ? What does that=20
> > even mean? You can't read that file without opening it.
>=20
> It means that something has to open the /dev/input/inputX device which=20
> sets up the ADC before the voltage can be read from the sysfs file.

It's a bug.

> > As I told you already, if you're going to expose this an ADC in the=20
> > end, the proper solution is to use the IIO framework, not adding a=20
> > custom sysfs file.
>=20
> My intention was to expose just a simple debug output, so one can=20
> press the buttons and read the voltages for devicetree keymap.
>=20
> If anyone can suggest a simpler approach than current sysfs based one,=20
> I would do it. But full blown iio driver is currently out of scope.

For this kind of ADCs, it's really not that hard, and provide more or
less the same interface.

> Also, Carlo's (ccaione) initially submitted (?) driver for lradc=20
> utilized iio subsystem.

And it was dropped because
no-one-would-use-this-to-retrieve-the-voltage-ever :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--YC8Ek3FeOE8ywfXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUx+nFAAoJEBx+YmzsjxAg03YP/ilITF33RttoZgRGO5YF9whf
KUawsMAgPqCjRQGRNDpSDJIcj6ERyEtv/yM8D1oYGrLRD/wonlakVe3xBfRxEQRQ
g3Hc/dfhxenEUGyDBvEYZposJoUiRvTY2dTs5TTdmcebR3OjoQR24DCfyjnqJgrh
MowIipHw7FgocrdWNHlsQ65ZoISTFuE1iPH/EnXx7bc5gducW/Gnjbdf/phVvg+D
fmEHWL58QlSRe7ELuPMfriUqkp2PggW7L+MZE3xllOrJXqD4PyRxKmKm4IinbG9A
MET4+gywthI6IcDLwz7Xp6bV3BD7nd8DGaY4HMj7pGoPoGSPmLUNWWYHaqkFfT+L
bdFNaWubptrYCwZWGOPKsevdf0oeWndu35I5sshX734XOXWsM/Qs2/CwgDYvdc/A
SQaA3AHKKBHgt0hyCWijI3iIBPtV1P3YR1E+NQycG7YFszwDMwNfAweAYaBjmNT8
H1h2wNOrdhTG4dwOikFF785JUAxpHTLS4MsTY8JIO4cBuMi64wgMddNo7/deKen5
179Ed/PvTgiHgx0WCaLOORJMBNnoI8G14XKoPTKr8aq1n9b/eFx+9fKwmgBcKF45
BP7m1gQiudlKNXBVcGtIAQ4yPKHaVRJt+z3J1IRKRgmMt59fGdERa8uxG3ANtRHm
hGVtNcQze4+TQjSAZ8ao
=ixHT
-----END PGP SIGNATURE-----

--YC8Ek3FeOE8ywfXk--
