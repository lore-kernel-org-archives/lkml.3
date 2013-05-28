Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610Ab3E1LAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 07:00:18 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:36069 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab3E1LAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 07:00:16 -0400
Date: Tue, 28 May 2013 13:00:12 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>,
        "mcrapet@gmail.com" <mcrapet@gmail.com>,
        Lars Poeschel <poeschel@lemonage.de>
Subject: Re: [PATCH 00/14] misc/ep93xx_pwm: cleanup driver for conversion to
 PWM framework
Message-ID: <20130528110011.GC11547@mithrandir>
References: <201305241619.52328.hartleys@visionengravers.com>
 <201305271720.08146.arnd@arndb.de>
 <ADE657CA350FB648AAC2C43247A983F0021DA666D43D@AUSP01VMBX24.collaborationhost.net>
 <201305271912.08882.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
Content-Disposition: inline
In-Reply-To: <201305271912.08882.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 27, 2013 at 07:12:08PM +0200, Arnd Bergmann wrote:
> On Monday 27 May 2013, H Hartley Sweeten wrote:
> > Ryan Mallon has also provided a Reviewed-by for this series.
> >=20
> > Will you be the one that merges this? I would like it to be in linux-ne=
xt
> > before I convert it to the PWM framework.
>=20
> While Greg and I are both maintainers for drivers/misc, he is the one who
> actually has a git tree for it, so he would merge it.
>=20
> However, I think it would be better to just merge it all through the pwm
> tree. Your current series is good, and with my Ack I see no problem to
> just do the conversion to pwm on top and send a pull request for all of
> it to Thierry.

While I have no objection to taking the patches through the PWM tree, I
prefer to pick up patches from my inbox. I should probably get used to
taking pull requests to make my life easier, but there was never a need
so far. So if you'll be pushing the series to a tree anyway I can take a
look at it and see if I feel comfortable pulling, but I'd still want to
see the full series as patches for easier review.

> > Also, I have a question about the conversion.
> >=20
> > If I strip the sysfs support out of this driver the conversion is quite=
 simple.
> > But, my use for this driver requires user space control of the PWM.
> >=20
> > Should I:
> > 1) convert the driver to the PWM framework and leave the sysfs stuff in=
 it
> > 2) work out a generic sysfs support for the PWM framework and then
> >     convert the driver
> > 3) other...
> >
> > I've been looking at 2) by doing something like how gpiolib does it. Do
> > you think that would be acceptable?
>=20
> That would be for Thierry to decide. It does sound better to me than the =
1)
> and I don't have a better idea for 3).
>=20
> I wonder how the arbitration between in-kernel and user-space consumers
> of the pwm lines would work though.

I've added Lars Poeschel on Cc, who's done some work on a sysfs
interface for the PWM subsystem already. It's undergone some review
already[0] and I think he's working on a v2 now.

Thierry

[0]: http://marc.info/?l=3Dlinux-kernel&m=3D136499756101273&w=3D2

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRpI47AAoJEN0jrNd/PrOhI1EP/2svuSctqLG1WbgSnz6BwSZn
Niho77gTn+ylhsQyXE/2qykdQ5UVFNkoLIZG/bsyqPIzZSavq42iqZbmyVW8v/re
AKEmn6mlqCfwIVnBBqDihBquGA1pdndBpFbeKBD8AoDlj+HBOcEffTkPdYzinKfd
AgA0nqWrOpvTwRZhlts3zCcPeqJ5NCtQKBiTZCJDJErFrhd82L+9dKlkfFFPTGBG
izjjpy2S3GSJcfc90+MjZ99wmGGJ3u1ziDo/iRNREHhq057aX4LG0HQzaC5tzqfQ
XkeL65qNvRFohy6baKC0AfslIlFgfQw6q/ML7U6eC2tqy0vDeu/MkF3YHQTgVe0D
3jxGsIjr0D3YYv8NW0TqjokRq8UtzC80hWZ2jkj2ab7xqzH2d8oTXvhBK5VXj8ky
8txyD4yWgdi9kmVBnvfIxrqxK4WrXFhQqSFHvdrDrJagLDQ186lgJz3LNbIIP/4u
nVXD7BvkXkYNAZWXQh9rNeIXW9PDD+LT6QpRs1CI9pT/1mMN8QYdUAiv4VxvaXPC
QzlXsSu0OMp9wTsq/00k1AzSXR7B1AWwc1A6ad+akeuxUbM5c9u8otejGWP5uKZL
T9rXoJckZjxyqA8uLV0zy+RTYEW9ovtbJCmuY5XpIQoGiQ8LoW5fqlYM1kTjxMah
wlxFn7iC3BTlWFTJ46Jk
=/fog
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
