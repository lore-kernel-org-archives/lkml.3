Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3IKBAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:00:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39482 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206Ab3IKBAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:00:18 -0400
Message-ID: <1378861204.2720.0.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [16/85] b43: ensue that BCMA is "y" when B43 is "y"
From: Ben Hutchings <ben@decadent.org.uk>
To: Konstantin Ryabitsev <mricon@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 11 Sep 2013 02:00:04 +0100
In-Reply-To: <522E3606.9060504@kernel.org>
References: <lsq.1374674564.753305150@decadent.org.uk>
	 <lsq.1374674565.595401652@decadent.org.uk>
	 <20130909180115.GC6276@home.goodmis.org>
	 <20130909183904.GJ7729@decadent.org.uk>
	 <20130909144642.7d61907a@gandalf.local.home> <522E3606.9060504@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-dHhfeE67t++znghG0/VB"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dHhfeE67t++znghG0/VB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-09-09 at 16:56 -0400, Konstantin Ryabitsev wrote:
> On 09/09/13 02:46 PM, Steven Rostedt wrote:
> > Initially, LKML would be archived on kernel.org, but that never
> > happened and doesn't seem it will after the whole security breach
> > incident.
>=20
> I believe we're hoping vger will eventually start doing it on its own. :)
>=20
> We do archive some of it as part of patchwork, but only actual patches.
>=20
> > But if mid.gname.org is a better link to forward to, then perhaps
> > Konstantin could update it.
>=20
> If it's the general community opinion, I can easily change that. The
> trouble is, "sucks less (most of the time)" is a subjective opinion that
> may not necessarily be shared by others. :) I have to be very careful
> changing such tools, as someone's workflow may be disrupted by the change=
.
>=20
> Therefore, for now I leave /r/ as-is, but you can use /g/ to direct to
> gmane instead of marc.info:
>=20
> http://lkml.kernel.org/g/5187EB95.2060605@infradead.org
[...]

Thanks!

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-dHhfeE67t++znghG0/VB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUi/AlOe/yOyVhhEJAQpHOA/9HAdwutDO9j/itJSK7J+VTLJ5+LtPfaBV
fTu3oOoj5Uc+thqrTWJD8KrO9itzULPKfo3dT09E0AWrEX45gYMHkHiuoyYvtrSs
LTuX2xL0pvAHoq6XAqjYQjO2qqxai0vX2H4Fi3yay8BUzEjQ8vO1klrtXgTN5yRE
YwANFoLX7ym2wMPGtczFBtTk7cw4pHyRMx12AsVEp+6fmY1nhCK/Epo+0Ui3USrQ
LdySo2Q++R7J1b0WtBluA4dTtgLg99DDWaGylegWqwhuSYY+zYowUxKgBockN8rF
GqsNRQZTVqTSsOPk6KPWcHXzxweeKu6Ds/nlGWXNC2sQgOoCs7T3h78zdbizGSGF
GRuFQJLx2t2JF9BLH+LpgJT9pyfXbDTvTERAOjXwV00hPYGjUgQhVhF2jBvvKP04
4gQh9OurFsoY4OsZ8ZgARDN+OU1yMrPbQ47U48e0vDoY4kwxjeK1Jb3h2Mp/lP6V
eSCAlnRQ5PFxheBfrfrcxTqP5aoUTY/hnXK0SjeIddbjU60d8JQdzrjYk0B2yF8S
HcdFoFLgWApeNaIu3GwyeOjrcmJiwFhESgZ/dz9AvMt6t/Wh8zEnqriv6xVrOhUp
8PJ9AyKkVjIEpgCST0wwXSCrlNXJxT3KWl6RZ5goWVDfkHZ47tjc7xh+llAIba0L
pwKa4Mi6DzU=
=ryw/
-----END PGP SIGNATURE-----

--=-dHhfeE67t++znghG0/VB--
