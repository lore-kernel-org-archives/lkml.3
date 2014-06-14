Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaFNRUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 13:20:47 -0400
Received: from mail.kernel.org ([198.145.19.201]:46799 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbaFNRUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 13:20:46 -0400
Date: Sat, 14 Jun 2014 19:20:40 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Status of Power Supply Subsystem
Message-ID: <20140614172037.GB19606@earth.universe>
References: <20140516183812.GA17752@earth.universe>
 <1946020.rieJTheGae@vostro.rjw.lan>
 <20140614153658.GA13614@earth.universe>
 <1402761183.8165.57.camel@shinybook.infradead.org>
 <CALT56yNi9aqmRWCsBRuMLnLxcOP=1dHuEWWVpViT04vCurTNdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
Content-Disposition: inline
In-Reply-To: <CALT56yNi9aqmRWCsBRuMLnLxcOP=1dHuEWWVpViT04vCurTNdA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 14, 2014 at 08:59:35PM +0400, Dmitry Eremin-Solenikov wrote:
> Hello, colleagues,

Hi, welcome back :)

> On Sat, Jun 14, 2014 at 7:53 PM, David Woodhouse <dwmw2@infradead.org> wr=
ote:
> > On Sat, 2014-06-14 at 17:36 +0200, Sebastian Reichel wrote:
> >>
> >> I waited a bit to see if maybe Dmitry or David want to give feedback.
> >> But I haven't received anything, so I volunteer to take this subsystem
> >> over.
>=20
> I'm sorry, I had too much trouble on my work to be able to think about
> community projects. My work load is now getting back to normal,
> so I will probably have more time.

No problem. It would be nice if you appoint somebody to be a
temporary maintainer for your subsystems next time.

> > I've never really done much with the subsystem except getting Dmitry set
> > up to maintain it. I certainly have no objection if you want to take it
> > over and Dmitry isn't objecting.
>=20
> I'd welcome any help, team or co-maintenance of any kind. What do you
> think about patchwork?
>
> BTW, David, I remember several people (including myself) asking for
> a separate power-related ML to be set up on the infradead.org. Could you
> please set it up? I think it might help all of us.

I think having a power-supply mailinglist and patchwork would be
really helpful.

> > If you like, you can send me a SSH public key and I'll give you access
> > to the existing git tree on git.infradead.org to take it over.
> >
> > You can work in coordination with Dmitry if he comes back to life, that
> > way.
>=20
> I'm doing a scan over my patches inbox during next few days (yes, huge
> task after so long time). I'll just base it on your kernel. After -rc1 we
> can think about something sane.

My patch [0] was the only fix suitable for -rc2+ from all power
supply related mails I could find on LKML. I have sent a pull
request for that one to Rafael.

You have a couple of weeks more time to catch up if you are fine
with him pulling the patch.

[0] https://git.kernel.org/cgit/linux/kernel/git/sre/linux-power-supply.git=
/commit/?h=3Dnext

-- Sebastian

--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTnIRlAAoJENju1/PIO/qakFkP/2MwoJEho40Hl94YWz2oq9+V
GYWEtibqxSG/9fWpzCqdd7Mbi0yzKJSqHnT0jyaPyI2QWIK5tYqui1D/sm1r9thr
utr68PHeIN6yAeqfN/6QjIZaen2C/23A09FNXlQ9Ys5pDY/eN+HQlqD/NC71K5LU
XrEVusJltwuCNKThIanTzu7hpZ4OMIxbbdgf+0IRExlVnIUBi9ma9osM43e7I38w
dmNpWbtqaeNgX+INAIpk96JGg5iOeBBZYbtZNRKL94usPczBRT8XSL9LsVHYXlD8
hrO4DAMMAsJDpe+gybp/n8ZlTIDMEoliLDZAqenYdIdm9tiWAYY61bPZi+X+92EA
/xIXn6gaT4nahlpqDtURiKWNGfJCLJSHrNC8imr7RNgzP/eB3A74PBcbTaIHtihC
WFr0g+cVAGsv2TmEBqwmQmCAJ108YZNzIVQBCEA7AL6FFshB1PbZB9z6SE5IxtmH
kIQBB8ZDBIV7wA/oTiDJuDy3F+j+kmfGBKoJdk62l+0lTuwf+y9nseMIujI0K02R
HEWSr6LTDSu88tlF6yEo+u92KJQ5UhsERPqjVq+EN/RYnytCO2kaMq2rtpI+tyhU
5ouOXK/A/ka2E5876zyRKBP5ioI/eZT/PLly2iHrftGEQpD8P7pWQOu+/2WNjhem
57XnQam2QEKizB5bQMrw
=aTxZ
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--
