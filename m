Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaFXOuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:50:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56251 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751821AbaFXOuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:50:09 -0400
Date: Tue, 24 Jun 2014 16:49:54 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog
 driver
Message-ID: <20140624144954.GP19730@lukather>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399430664-29091-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140507213318.GA2105@roeck-us.net>
 <20140515091123.GQ29258@lukather>
 <20140519150422.GA27329@lukather>
 <20140522203444.GE27329@lukather>
 <20140522211207.GA28704@roeck-us.net>
 <20140623103142.GB19730@lukather>
 <20140623211323.GA28120@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o6HUWsywbRjTg5uW"
Content-Disposition: inline
In-Reply-To: <20140623211323.GA28120@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o6HUWsywbRjTg5uW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2014 at 11:13:24PM +0200, Wim Van Sebroeck wrote:
> Hi Maxime,
>=20
> > > > Guenter, since you seem to be the only responsive, may I suggest th=
at
> > > > you start merging patches and do a pull request to either Wim or Li=
nus
> > > > directly during the merge window?
> > > >=20
> > > I had prepared a pull request for Wim last weekend or so, but then th=
ere
> > > were more patches piling in and I got distracted, so I didn't have ti=
me
> > > to actually send it. I'll try again this weekend ... the kids should =
be
> > > busy learning for their finals, and I'll have Friday and Monday off
> > > from work, so I should be able to find the time.
> > >=20
> > > As for sending patches to Linus directly, well, Wim is the watchdog m=
aintainer.
> > > I manage to upset enough people, and would not want to add Wim to the=
 list.
> > >=20
> > > The patches _are_ in my watchdog-next branch and get some coverage fr=
om
> > > both my auto-builders and from Fenguang's build robots, so while they=
 are
> > > not in linux-next, they are not completely in the dark either.
> >=20
> > So, this patch finally didn't make it into 3.16. Great. Now, we can't
> > even reboot the boards.
>=20
> 1) For me the discussion was not ended and needs further
> thinking. (And I just read some good ideas about it).

It would have been great for you to mention it then.

> 2) You never mentioned you needed this in for 3.16 and that things
> would break because of it.

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/257690.html
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/259109.html

I thought it was pretty clear.

>=20
> So based on these 2 points why would I have to have put this in allready?
>=20
> > Given how it's just impossible to get something merged reliably
> > through the watchdog tree, I guess I should just start merging the
> > patches through mine?
>=20
> I agree that I have the problem of having only 24 hours in a day and
> that I lack time to communicate and that I am not good at
> communicating either, but I checked all sunxi related e-mails and
> you never mentioned the constraint to have it in for 3.16...  But I
> do understand your frustration.

I totally understand the lack of time. A good way to ease your burden
and solve this situation is usually to take a co-maintainer. And given
that Guenter already reviews patches, maintains some branch, and is
developping some part of the framework, he seems up to the task.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--o6HUWsywbRjTg5uW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqZASAAoJEBx+YmzsjxAgd9sP/RaSQVG5177Yzvi5H8pURzbW
uVdoLywiJ32l2GU9eX2onm6CKRyLn1uZoJ+VfAjYiooQ1j01Qj91jkb+MO4nLpEv
x1dDjjJ0/aN/ytjNKkYf0LJwWtek02DwyHOgrhLu5tVezgc7d79VP+lVq7D8scGC
ZSTPBC/E7XLGvVWxAIi+rNtrVUl2mdF3oS8PcPqipAjFmCjNJ6bzR74/08Wy0shP
q4WLcIbXVW8zuKMLI6LdfrklGAqYNWcWYk5YzMGCgePJ2e8vbq3Iq030+x7i42qW
jzIpdWmO+DhXLei01dD2BZQIC5nNfOCOYxmOnSQnxOqYo7BbunnWUc6DWhBxBOrz
X//YAwNLu+8BSSC9015XFUIzU6EpC5gPff/389RuUQYYHwoxUZKfK/IBSoJHHU5Q
F7KJgsxC5CT6oanPCUXTHEiLRJvbSMxIN/waH3HQSV84IRy8JbnO351JFY3gWz21
iZUp4etsHw+bJLwsxT9pIyrOzN7M53BWSmcA691Dna6yw5DyE0yVWVqW3TkRy0mp
YoeKr7EFeOwGoByKMtHqtxZ2A2zx6PKqU98yGLYo4mUa6M6sK0QohTRLGhBf90DR
PLCyS1h/GaA2yf5iY+NAVe0vrhrL1RdY/RNTyhlq/RGO11nP+6A8Rful4ddn3xjo
b8JgfEH11j0RBrjFzuZk
=d6l+
-----END PGP SIGNATURE-----

--o6HUWsywbRjTg5uW--
