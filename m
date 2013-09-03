Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931Ab3ICLUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 07:20:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36974 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756396Ab3ICLT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:19:58 -0400
Date: Tue, 3 Sep 2013 13:19:54 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: oliver+list@schinagl.nl, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        andy.shevchenko@gmail.com, tomasz.figa@gmail.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCHv6 1/2] ARM: sunxi: Initial support for Allwinner's
 Security ID fuses
Message-ID: <20130903111954.GB2630@lukather>
References: <1378035019-9649-1-git-send-email-oliver+list@schinagl.nl>
 <1378035019-9649-2-git-send-email-oliver+list@schinagl.nl>
 <20130902080812.GA2630@lukather>
 <20130902161232.GA23912@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <20130902161232.GA23912@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, Sep 02, 2013 at 09:12:32AM -0700, Greg KH wrote:
> > What I wanted was a (pretty long, I agree) summing up the whole
> > discussion we had.
> >=20
> > Something like:
> >=20
> > /*
> >  * Be aware that this will generate a race with userspace. By the time
> >  * it gets called, udev has already been notified of the device
> >  * addition, and will never be notified that this file has been added.
> >  *
> >  * It should be properly fixed by having some way to attach a sysfs
> >  * attribute group to the device structure before the probe.
> >  * Unfortunately, this is both not possible for platform devices at the
> >  * moment and not trivial to do, so this will need a proper fix later
> >  * on.
> >  */
> >=20
> > And just like the comment quoted above, you can remove the useless fixme
> > comments you added everywhere.
>=20
> There's no need for any of this, including the "FIXME" comments.  I know
> what the problem is here, and until the driver core changes get merged
> upstream in order to fix it, there's no need to worry about "broken"
> drivers, as everything is "broken".
>=20
> I'll just take this as-is and remove the "fixme" comments, ok?

It's your call :)

We had a few other comments, that will probably be fixed in the v7
oliver just sent, so you'd probably want to merge the v7 instead.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSJcXaAAoJEBx+YmzsjxAgfv8P/1dl5SjWjCsVWP0POeyY6a/e
e73wRzFNsc9L+aX/l6kLQi2P2IZlCoNE2IthFdnN4Oz8lJ2FtLoFOL8yYprK7mOY
r2zkC57JZDW0Uya/pHps2G2+wFdJaFgmyIv9PVX8Sr69BEmLW+RgufOLcsN+/Nrw
E3zttGPmt5Sz/qVngAaoc/lBhvj3G8n17cpX3dnmx4a71wUYSz5qoIsKWbHQ0DDp
jdowedxcl1MToBsnnpzIl/BAO3jBcypgFHE5HRMrmjYQfrYBx71MTQHXX6HhGWUm
lkj9e0pehGkV1mDG2V+khsjvEqcOWd4ywSWJaQtwvZ/qVWNhrL2VN6McO9XVdh74
JAgTNvunPzsRk15CNvDFZGy+GSwlnl3UElxz/KAEd5A24M4PulreSCJpnmmXVpTQ
KS4xaFs3QJnBDJYKP556G3RtXnH6Bo0Xi6PLDEZwjAt+boqjneVkB4IfafO9X6Vd
NpKYLUcv4JXf/QitNUOE8ZcFpJHLew7c3oDmKliTkbcU66RPXHs8b9IeAcIMhPwF
to6Y4jK1R4dCnCuzQDEbY6vb3FaQxkIZuNpXb2m22y7hlwaxpfzBRFK+6tr/qpuP
qkeDGPyh6y1g/w7ymZuK610NX8YhrxKM5Pe3QNIokYcAYZQtV5F+kpKxh812vzTG
PtcTQc6RcESUWxnKrV7C
=EI0+
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
