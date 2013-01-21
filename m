Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3AUBNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 20:13:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48930 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619Ab3AUBNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 20:13:30 -0500
Message-ID: <1358730796.24121.229.camel@deadeye.wl.decadent.org.uk>
Subject: Re: sd8688 firmware location
From: Ben Hutchings <ben@decadent.org.uk>
To: Dan Williams <dcbw@redhat.com>
Cc: Lubomir Rintel <lkundrak@v3.sk>, David Woodhouse <dwmw2@infradead.org>,
        libertas-dev@lists.infradead.org, linux-bluetooth@vger.kernel.org,
        Gustavo Padovan <gustavo@padovan.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 21 Jan 2013 01:13:16 +0000
In-Reply-To: <1357771504.12030.59.camel@dcbw.foobar.com>
References: <1357689361-7969-1-git-send-email-lkundrak@v3.sk>
	 <1357771504.12030.59.camel@dcbw.foobar.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-uXqUd1VQnh/3dalA+dAN"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uXqUd1VQnh/3dalA+dAN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-01-09 at 16:45 -0600, Dan Williams wrote:
> On Wed, 2013-01-09 at 00:56 +0100, Lubomir Rintel wrote:
> > Hi!
> >=20
> > btmrvl_sdio and libertas_sdio both use firmware files sd8688.bin and
> > sd8688_helper.bin. In linux-firmware, they're present in libertas/ tree=
 and
> > (since 3d32a58b) libertas_sdio perfers loading it from there, while it =
is able
> > to fallback to load it from linux-firmware root. btmrvl_sdio, on the ot=
her hand
> > only looks in the root and ends up not being successful.
> >=20
> > Obviously, there are two solutions to the problem -- either teach btmrv=
l_sdio
> > to look into libertas/, or move the files in linux-firmware tree. I don=
't
> > really have a strong preference, though it probably makes less sense to=
 keep in
> > in libertas/, since the bluetooth hardware is not really marketed as "L=
ibertas."
> >=20
> > I'm following up with patches to linux and linux-firmware and I'd be ve=
ry
> > thankful if you could pick one (not both of them).
>=20
> So the BT part and the wifi part have different SDIO IDs; are they
> actually connected separately to the SDIO bus?  Or is the chip only in
> one mode at one time or something like that?  Is there a problem with
> having both libertas and btmrvl loaded at the same time since they're
> essentially the same chip?
>=20
> I don't really mind moving stuff to mrvl/ out of libertas/ for these
> devices, but I do want some backwards compat code in libertas for that.
> Unless, of course, Marcel was talking about symlinks in the
> linux-firmware git tree, which would be fine with me.  The important
> point is that simply updating your linux-firmware package or install or
> whatever *should not* result in a failed firmware load.

The general policy for linux-firmware.git has been that all filenames
required by all mainline kernel releases will be supported indefinitely.
There is already precedent for compatibility symlinks.

Ben.

--=20
Ben Hutchings
Q.  Which is the greater problem in the world today, ignorance or apathy?
A.  I don't know and I couldn't care less.

--=-uXqUd1VQnh/3dalA+dAN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPyWLOe/yOyVhhEJAQoWEBAAkkORCimt5qButJQ9ZoILUQBd7+Wqi3bV
YjCdlfkfqNl6m/7fCXc7SHBQmO7Lph0Vh3OXsVzDAbZEZ627xgYxwaYbPaL8o78M
fmBhKZHQjnYQuwQI2UcJicUgVYeo+TIHlNFREExwxr4RDxSgv+KhNGCbfiBnpx3A
7S/PmZ+y1xbULTLSJRJPIki9Q9bd/pAMTfxwT+88QZxpt1ULsfAOAsokuZ9N+ZQu
Oat54Arw29lbut2RGM1poODX8z3FzyIDOG/SMGtJavtbFeOkHBY6sang47KeFwX+
qzEuYhynr8a3Epn+dh/AAA9aHH/KuSvS/ZiujOu75HgT1+YGftC38/PQe/E3Qzkm
s+eUaai4VEvWdPbOu3GkGt0voqZjglzycLfVJtCM79AbZCM4JMXLrQLh8DYGsd5r
Wx20I49JB3nEM6FFWzoX3iM3Agab4japG8zJt0MeIxWxY1N4dmRShJbU4DzUIFy1
1Vx1GlCxnPUA6Yr+mQfz4r4WHy2hfQjS7wOhjoU8OhKnhCXC3KaeYuJKOkmU+RDE
N9NnJfizAvx61o8Tw+ZGGBGd+h4xN7NYTm8HKCnF+xkgksp3Odf+C1Q2q8krJPtc
kOrrJjLkbrXlSBbQPv9BaAoOzqvjOWKtmBp3Blfx8KerZx1bW0LdLaMtom8US7Xy
UJ+pG/beDfw=
=JHY2
-----END PGP SIGNATURE-----

--=-uXqUd1VQnh/3dalA+dAN--
