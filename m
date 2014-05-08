Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaEHCZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 22:25:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34992 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751469AbaEHCZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 22:25:14 -0400
Date: Wed, 7 May 2014 21:22:33 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH] spi: Force the registration of the spidev devices
Message-ID: <20140508022233.GF7047@lukather>
References: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140429183758.GH15125@sirena.org.uk>
 <20140430180609.GC3000@lukather>
 <20140501011811.GF3245@sirena.org.uk>
 <20140501223629.GJ3000@lukather>
 <20140502174048.GV3245@sirena.org.uk>
 <20140505042147.GE11606@lukather>
 <20140505191723.GK22111@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NGIwU0kFl1Z1A3An"
Content-Disposition: inline
In-Reply-To: <20140505191723.GK22111@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NGIwU0kFl1Z1A3An
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 05, 2014 at 12:17:23PM -0700, Mark Brown wrote:
> On Sun, May 04, 2014 at 11:21:47PM -0500, Maxime Ripard wrote:
> > On Fri, May 02, 2014 at 10:40:48AM -0700, Mark Brown wrote:
> > > > i2c-dev works great in these cases, because you always have access =
to
> > > > all the bus, and all the devices, except if the device is already u=
sed
> > > > by someone. The patch I suggested is an attempt to mimic this.
>=20
> > > It seems better to implement something like this at the device model
> > > level, provide a way to have a default UIO driver for anything on a
> > > given bus.  I don't see anything bus specific apart from saying what =
the
> > > default driver to use is and it avoids the icky code fiddling about w=
ith
> > > what devices are bound and the races that might be involved duplicated
> > > in individual buses.
>=20
> > Hmmm, yes, that's probably a great long-term way of dealing with this,
> > but I don't see it happening soon.
>=20
> Isn't the code in the patch that started this thread roughly what's
> needed, just done in a SPI specific way instead of a generic way?

Hmmm, I think I get your point now. Yes, we could do it. Let me find
some time to actually write something :)

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--NGIwU0kFl1Z1A3An
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTauppAAoJEBx+YmzsjxAgzaYP+QE/CC1jWhYSRIVAD10/qZhk
evBZL/A+xv4/GwpzGsSkGbBYyn1m0V1R4cj3+kYuBxzrdylnppqWaypauQbxKlnr
WRy+wLs4vOrLD92hF0kDN8f8ipvtRXtlBdHd1BVgOxQuGV3YagsXbTs+8z+D2szu
Zdw6hC7WqUMTJdxFjhl/BWIN4Ky9HgQRL5w1itoWUZZorHgQfdd3nbmRPnC6uLRy
G6P5lg01ylLJF8uUgle5g6TUyAFByUyZZUE+RgIVjiOQyhjN0NuTbtf9ovvNmNt4
MJq2Z1wMLWqjAczaAsJV8y/1nsqfB2zk+I4yYjGI1hKy6wRTSfxrUKtX6XB+EMT0
a0ROU7iNelmAXgSSrsRKwbMHQKKBLPS5jOuCM/l8R2qqzF05JlsUJsYd3cWalIC+
Yr5jyhmI4U2axChZZ6admbBWVNedWvuNpHZip7KrLqJCzshuvmPU4se122eHLqiW
VMdoAWN7ouqHgHghTECJY36d334ndi9KnPZnpOydA56zj3cgj5L79NnKzOvj1Dnp
+I/j2ZoNGNLm8PB6NaEs/5wRPBItpR6NmdQzFgaQIB3YIMZkB5xhRFvnhmbDXEUb
yl51XGPb2ceyUlhYmZrh1XXYi85aE+ynCaIxDetMEl/M1EmGbnzNgIZr6Ddyo+DO
XfSun1o6r0UZjWuNC1uc
=UOre
-----END PGP SIGNATURE-----

--NGIwU0kFl1Z1A3An--
