Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3AZEwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 23:52:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44313 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049Ab3AZEwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 23:52:16 -0500
Date: Sat, 26 Jan 2013 12:52:09 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 11/19] regmap: avoid undefined return from
 regmap_read_debugfs
Message-ID: <20130126045206.GB10580@opensource.wolfsonmicro.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359123276-15833-12-git-send-email-arnd@arndb.de>
 <20130126044219.GA10580@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
In-Reply-To: <20130126044219.GA10580@opensource.wolfsonmicro.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 26, 2013 at 12:42:26PM +0800, Mark Brown wrote:
> On Fri, Jan 25, 2013 at 02:14:28PM +0000, Arnd Bergmann wrote:
> > Gcc warns about the case where regmap_read_debugfs tries

> Are you sure about that function name?

> > to walk an empty map->debugfs_off_cache list, which results
> > in uninitialized variable getting returned.

> > Setting this variable to 0 first avoids the warning and
> > the potentially undefined value.

> This probably won't apply against current code as there's already a
> better fix there, in general just picking a value to initialise masks
> errors.

Resending with corrected list address; to be clear please don't send
this.

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA2DTAAoJELSic+t+oim9nLUP/0GiZKZT01PiKHD4ueUVqK/C
9Wu2bD2KqXflV5jNmJw/0aEVLEumOHotVdQv8Ot8p1V8O4kaGxjUzgH+CPEvROw+
NIs6A9r3egoQHpLpp6bwQVaRC1I/rbi7blC3Qjr/ZOo6flXSNA2FJFjBrOVvPyBX
MfDK/6zUAQv+xyU9booWStq1EgTfTbqIQpuKm5+XludaOh7osJqs7Dzcp3prGmjI
qDSpZ1Ttb80IrTSOZYFeT93lweozj3FdNxkN0p4w+9oVRyILXaNFOfY9nNBbabvd
L8bTeTutEbQywhy+Tsb5CbOjdrupk/hlR5/UODkWqIf2BnqInjpTYNqnW/YNho0f
cGc4wPqdUBIbfRi6sI7LTKIB1NfaM+gaeMaiWaIcHQKm6QmjLDuIJ1yJ7sVQVJ5t
sSYnrUyp7BH9a7yERehdAOinj4ex/t6NFRdxoo4+q9y9oOmmewoRIXuUExqPO7fi
fIkh9a6EZa6Opjx3L9ZnGuFuckmrIuTxO7QOy/15bvgeobEz92x6QThFAlQd3+4+
EGlFW+NLVDYzxnVoHpMOxVaRGI5I4K/8rm4TP3+lFqjkO/yuqk4hXs0gmDXoucw4
cBFSg1eyz770686U8rPX1FuVKgXsga9lYXPO8Y76BKiY6qRJJAXtXpd2dohLM5/s
OOmlcF+/yaV5mRm+w3fK
=Hs4L
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
