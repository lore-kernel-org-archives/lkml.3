Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbbAFWD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:03:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35749 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877AbbAFWDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:03:55 -0500
Date: Tue, 6 Jan 2015 16:02:30 -0600
From: Felipe Balbi <balbi@ti.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Felipe Balbi <balbi@ti.com>, <pali.rohar@gmail.com>, <sre@debian.org>,
        <sre@ring0.de>, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>, <khilman@kernel.org>,
        <aaro.koskinen@iki.fi>, <ivo.g.dimitrov.75@gmail.com>
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150106220230.GG32308@saruman>
Reply-To: <balbi@ti.com>
References: <20150106170433.GA5408@amd>
 <20150106172545.GK6502@saruman>
 <20150106175115.GA19487@amd>
 <20150106202857.GB32308@saruman>
 <20150106205000.GB13902@amd>
 <20150106205413.GF32308@saruman>
 <20150106215744.GC13902@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HB4mHL4PVvkpZAgW"
Content-Disposition: inline
In-Reply-To: <20150106215744.GC13902@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HB4mHL4PVvkpZAgW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 06, 2015 at 10:57:44PM +0100, Pavel Machek wrote:
> > > > > > > In 3.18, sound is nice and clear.
> > > > > > >=20
> > > > > > > In 3.19, sound is unusable. It produces nasty tone when it sh=
ould be
> > > > > > > quiet, and there's at least as much noise as is sound.
> > > > > > >=20
> > > > > > > Unfortunately, list of mixers also changed (and there's cca 1=
20
> > > > > > > settings), but a) it does not work with the old list and b) n=
othing I
> > > > > > > could figure out did make the sound usable. Some setting resu=
lted in
> > > > > > > even more noise.
> > > > > > >=20
> > > > > > > Any idea what could have caused it?
> > > > > >=20
> > > > > > $ git bisect start
> > > > > > $ git bisect good v3.18
> > > > > > $ git bisect bad
> > > > > >=20
> > > > > > that'll help find what caused it.
> > > > >=20
> > > > > Telling someone to do hard and time consuming job that probably w=
ill
> > > > > not succeed, instead of actually providing help. Very very funny.
> > > >=20
> > > > you're getting code for free, you're getting help for free. Not many
> > > > people have N900s lying around. Running a bisection is just
> > > > politeness.
> > >=20
> > > Now you are speaking for yourself or for TI?
> >=20
> > why bring my employer into the discussion ?
>=20
> Because you are speaking of getting help for free, and I don't

are you not getting help for free ?

> remember getting any useful help from you; so I'd like to know who do

how come ? I gave you a very helpful list of commands which will direct
you at finding the root of the issue you found.

> you speak for.

for myself.

> > > Thanks for your very valuable help. I know how to do a bisection,
> > > thank you.
> >=20
> > then please do it.
>=20
> No, sorry, I don't think that would be reasonable use of my time at
> this point. First steps are "confirm it happens on other N900 boards,
> too", ruling out config issues at my part, and "try to get
> verification from other development boards if they have same
> problems", because most other boards are easier to work with.

you don't want to do due diligence with a bug *you* found, then there's
no way people can help you out. Sorry.

Good luck

--=20
balbi

--HB4mHL4PVvkpZAgW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrFt2AAoJEIaOsuA1yqREqjMP/3Gl4GjT2v6ztCq4HXCmn9q2
9eajVrkNHmM6mYi0jwdJRCY5R0qR/HZdDLvG7S25QxiOxOT1ed4TO5z4BwTrC0Az
QEbYTaXDErV213SD4AkB9zU52g2De6jp2T3429sA96Vwcoi1Yjt01XsTUZ6z9VsR
Se7SwaZGlhHzgAaPBVywGnl9eXTPV14DlXWoyJAvUmgHgH5xd+tFRINJ9PbcrAtv
zn+bQaL1kfbRCChD0laDSDbXj/dAW1oTmP5Ne7us/bOYQA+YZR4nT74TuYlmitDG
TeSN9YRQ7jbs/c8JpekEi42m00xxyhaUDQPg0oacYCbgX7K5wBans5y829jJWTCF
U59fipHAc6S+ZcDRFRkpNIG+fWwervWxb8oAlSYqiAh7eIOEjCtf9Tde1V5GyT5e
XH5zFFVz8uUM3Y2mgkbmbDOuvP7Uj21CM12u2WOp/0B4OYulcB3ys5p5ql/kOggC
4TQe2qZnH5072pwIjrlWho4CCYUMRpRB9Lvp6g08Z1obDweC3ZxeSQt9U+C9z+g9
O0orIS7JSCs3Pf/TC0ROMU2uEUgNbSluaMz70D6lXVbjHaT6sh7wtMQUYgkLPY2m
FzBwNoW4CeACle318PKLPC5RtDG0WOJWaDEjd7NeHMaonJaGlOFSZlbpM2ZVX2IT
Ld5R9Ec6I+bNh+w/fVfq
=xxZw
-----END PGP SIGNATURE-----

--HB4mHL4PVvkpZAgW--
