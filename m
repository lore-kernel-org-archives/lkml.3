Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbaAURAC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:00:02 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57602 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbaAUQ76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:59:58 -0500
Date: Tue, 21 Jan 2014 16:59:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Message-ID: <20140121165935.GB17314@sirena.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
 <1390208555-27770-2-git-send-email-tushar.behera@linaro.org>
 <20140120100530.GY15937@n2100.arm.linux.org.uk>
 <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
 <20140120214305.54f65ffa@www.etchedpixels.co.uk>
 <20140120231457.GZ17314@sirena.org.uk>
 <20140120234734.11b78578@www.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YLBcqQnAC9NQWYFL"
Content-Disposition: inline
In-Reply-To: <20140120234734.11b78578@www.etchedpixels.co.uk>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
 device probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YLBcqQnAC9NQWYFL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 20, 2014 at 11:47:34PM +0000, Alan Cox wrote:
> Mark Brown <broonie@kernel.org> wrote:
> > On Mon, Jan 20, 2014 at 09:43:05PM +0000, Alan Cox wrote:

> > The userspace breakage is that if someone has a static /dev that doesn't
> > handle any dynamic devices then renumbering the device will cause that
> > static /dev to stop matching the kernel.

> Diddums and you've only provided theoretical cases not real world ones.

I'm fairly sure I have some older boards on my desk with static /dev,
I'd need to go and check which is rather more effort than I'm interested
in putting in for point scoring.

> They should have followed proper practice and reserved their minors. The
> device number belongs to the Altix. The driver should just move.

They should have done that about a decade ago when this stuff was
introduced, yes.  At some point one has to accept and deal with the
world as it is.

> But yes I agree about the idiom, but a definite NAK to any attempts to
> plaster over this grand screwup by crapping in the tty core. Your turd,
> deal with it locally in the ARM code if you can't apply common sense and
> just go dynamic.

Local bodges being the first two patches Greg knocked back of course...
In any case, if we can convince people to make the subsystem better and
coincidentally also stop problems occuring on their systems that does
seem like a win overall.

> And please, after screwing this up twice - *learn* from the mess.

One of the things we've been trying to do is to ensure that the all the
driver code that isn't core architecture support (not just for ARM, for
everything) is going into subsystems so we're getting good review from
people who actually know the subsystems and aren't just saying things
are random platform stuff or whatever that we don't care about.  That
has been a source of problems all over, we're trying to avoid it.

--YLBcqQnAC9NQWYFL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3qd0AAoJELSic+t+oim9HdIP/0e6iP3BmAVkfhOOPBcT0F+A
lc8rTFXJK7w8UW1p7lqC8B6LKDyhqBkcpEYxN98uBH2N5X5bdigMABS7Fx52goyy
7gVdWKx8aKyAM9QHdEklngkdJN94bvLXlRPmOXFb34iq1LfilCSv75hPeqpJ5JaY
aaljl1kKHRqs5OWeGyM8M3MIPtP9j311SqmFR4BRG0nJcpoEc3GCKMPmkVKCW1Si
I/81+4zfUU1euPf740rq9amgmno7Y7uY3acAFE3ya2TvvBg2Hmblg6TAHect+V2I
6zh4jU0Zu1CC0DJJ+zN/io/OCIY4xKMieZu+7wWQKlR7+qvEbEhgrTh7W76ZeznA
6flNLi9tAJAyWuCKDcLkZP34QRoNghqUobIqw8gOqvULKZX2lwtUsDaTXEuAsv10
BNuBMx9MJ39r0x2njYzjFxV+y0YScMTw4OIDku/xxb/CiDc3BcYzrNGtQnbejeso
Bl+YRNjk4nCSzcP14g/PoCP0dPFUKf8hg4k4giwpl4xGk0Wv1nboBlyIj1p3hr5k
WNBJKYzY+QNu6PZ37XXpleuQilSpzuj3SSeAsNpNNND+NUEcSrzUc+mg3jonQgzm
84ShHydayUuwsu5ZT5G14GRnFw1lRMcjvWKx+l86P2nRKqYWAfcs+TmJH/lwMC6t
l/qHUm/JU5TCw2vyfKHK
=ySsu
-----END PGP SIGNATURE-----

--YLBcqQnAC9NQWYFL--
