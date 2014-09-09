Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285AbaIIJUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:20:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55186 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753413AbaIIJUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:20:04 -0400
Date: Tue, 9 Sep 2014 11:15:20 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Olof Johansson <olof@lixom.net>,
        arm@kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: drivers for 3.18 #2
Message-ID: <20140909091520.GJ3804@lukather>
References: <1409934969-11584-1-git-send-email-nicolas.ferre@atmel.com>
 <201409052325.11709.arnd@arndb.de>
 <20140908092642.GB20883@lukather>
 <26517543.McM8Q5P0vn@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Q2l3mYpK16UQ/iv"
Content-Disposition: inline
In-Reply-To: <26517543.McM8Q5P0vn@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9Q2l3mYpK16UQ/iv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 11:52:35AM +0200, Arnd Bergmann wrote:
> On Monday 08 September 2014 11:26:42 Maxime Ripard wrote:
> > On Fri, Sep 05, 2014 at 11:25:11PM +0200, Arnd Bergmann wrote:
> > > On Friday 05 September 2014, Nicolas Ferre wrote:
> > > > Arnd, Olof, Kevin,
> > > >=20
> > > > This pull-request is focused on the work that Maxime did for migrat=
ing our timer
> > > > (PIT) to the clocksource sub-system. A big cleanup happened which a=
llows us to
> > > > be even closer to the point when we have only the bare minimum in o=
ur formerly
> > > > crowded mach-at91 directory.
> > > >=20
> > > > This pull-request goes on top of the "drivers" one already sent to =
you on Sept.
> > > > 01st.
> > >=20
> > > Hmm, I'm not too happy to see more uses of early_platform_*, I was ho=
ping
> > > we could kill that off in the long run. This is only used for the leg=
acy
> > > board files, not for DT, right?
> >=20
> > Yes, the DT uses the usual CLOCKSOURCE_OF_DECLARE mechanism.
> >=20
> > I wasn't aware that early_platform drivers were in the killzone, but
> > I'm definitely aware that global custom exported functions are, hence
> > why I went this way.
>=20
> I don't think it has been discussed much on the mailing list or IRC.
> The early platform devices have not been used much outside of arch/sh
> and arch/arm/mach-shmobile, and those only use it for clocksource and
> serial.

That's what I found, yes.

> Now we have a new method for both of these, at least with DT, so
> my impression is that we won't need the early_platform support in
> the future.

I agree with that. I only see the early platform stuff as a temporary
measure for board files, before they're removed.

> One of the problems with the current interface is that it requires
> statically declaring platform_device structures, which is something
> that has been on Greg's list of device model antipatterns for a long
> time.

I didn't find any difference with how you declare platform_devices
compared to the old-usual way in board files, or was it something on
the list too ? :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--9Q2l3mYpK16UQ/iv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDsUnAAoJEBx+YmzsjxAgNTkP/RN6w8CW9UZ8Pv0TDcv7KDcF
fJppaijLro/4amW5fTJmv2nL+BH+rHxLsogKEjQcP/Q1h0CwX3ic7mdKEiHHm6Xv
Qu4i2X5j/s0AD/1SGbFzJ+TMwWqHEDt1nAD0lmc2l9oJdVujO+jDoQmKX2bCKXOU
pEXIKkWdBVdndf8k0ZqVgIkClHtXWqJPgUELTJI228fga4CsrVbnZj1FNRlarVPL
Cc6LrT7gmvYhKQ4AydsoXy+U27gMKlbrM0/BnZ3TcZxkIl32iwEKyGGWKfo8tuhD
xJqTnwpb/2zw2wQ2AdDm1BCEupGVgbcfvud5JPv++K1vQ17ERX4aTKrfFeyb/mi5
CxbErqbpDYn/fH1EiwqnJiGhDEPIRYAHCAtvQSdbX2KY3XulXusHvaenOODrYmSD
taMhR5OlPgsSd7BOAs8tWLlEozC4t8rYIUvezGH8yDlD3c2kpCW1geqbcORXeH9y
Y1MnnYUXivD/zi+yL/96pKLqG0jQ5o4agSq7xGIK7KPdNIYEHHVhkP3vhO5cevpS
3V6lhHNZfh93cOjEKp+CkjLCKEsmPKCbO0zB++nRqZxeNSu29QZJzuxSzdy0+eOM
Z0KuOVlvnOavsJyN7cBucBgO0ybc2DHgsIQQ3oQvty9Cj8UU/6UroctFBGV2+VNA
O0GzWZ/jx7xY2KqSRYoO
=dyHb
-----END PGP SIGNATURE-----

--9Q2l3mYpK16UQ/iv--
