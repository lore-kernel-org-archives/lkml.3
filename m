Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaIHJaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:30:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42037 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752846AbaIHJaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:30:03 -0400
Date: Mon, 8 Sep 2014 11:26:42 +0200
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
Message-ID: <20140908092642.GB20883@lukather>
References: <1409934969-11584-1-git-send-email-nicolas.ferre@atmel.com>
 <201409052325.11709.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline
In-Reply-To: <201409052325.11709.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Fri, Sep 05, 2014 at 11:25:11PM +0200, Arnd Bergmann wrote:
> On Friday 05 September 2014, Nicolas Ferre wrote:
> > Arnd, Olof, Kevin,
> >=20
> > This pull-request is focused on the work that Maxime did for migrating =
our timer
> > (PIT) to the clocksource sub-system. A big cleanup happened which allow=
s us to
> > be even closer to the point when we have only the bare minimum in our f=
ormerly
> > crowded mach-at91 directory.
> >=20
> > This pull-request goes on top of the "drivers" one already sent to you =
on Sept.
> > 01st.
>=20
> Hmm, I'm not too happy to see more uses of early_platform_*, I was hoping
> we could kill that off in the long run. This is only used for the legacy
> board files, not for DT, right?

Yes, the DT uses the usual CLOCKSOURCE_OF_DECLARE mechanism.

I wasn't aware that early_platform drivers were in the killzone, but
I'm definitely aware that global custom exported functions are, hence
why I went this way.

> Do you have a timeline for getting rid of the board files completely?

I don't, but it would be great if we could kill these in the next
couple releases.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDXZSAAoJEBx+YmzsjxAgFDcP/3srJgg0tLBMRj8rvKA+7aQE
FzMBL30NL7x+FTTiE3v5ycYQu9wdT5v3ektiHrwcrpMQ3KRpucsMmsLxPlGbEDku
8C6s9R9rxYz33un0YhxyVLlc17fK9Iqj6zIyFVzmGiiLHf0lj10ZkUTB9nYjVBcA
tPDy2V4CXGLxZ+nnF1rsDZTcL/OzEOMO5Z61GQyV13t5vvach/u8rqDkxHWYJaVT
KtNSdlBUknm8YVknOZXnmrtOjm9uCemkdOCWF97Wzrz3MuL3VvOgZLIXIrcC0fn3
20M4b+QShHsVique76UDQR+Ta1jE3pw2EakVBvezBUFPUI5LU/+cW3udqFL2hCX7
pKll6my44Mrsas0elbNLAxlmu4fzeCjg0pFydvTwYfjGl2J8GsvZlkNpGCNSU4Cs
qzKPNvujd5/Byv4etqWOE55p60EZVGlA3Opv3sjwx0brksQpbGGvmVxb/OEls9An
RfonrdG8kqUK2yreMs07/OpSg8TwwrdgzTU3uclXEv9xYYQkblpGKDOUxGTxk0lE
mVvkOYRFy95Xz13qwiKt7aVfL/qMveaciQ/eBRGLkyVdR2l0SEyqQeoyvSl61HfN
0HQwW+dGa4jWRKAO8Yn1o5DPIIk5YVvJPYCBTRQUP3Xyt+BiCEDb4jFSRAIYBalZ
ltHVEnSCdhA+143acPE5
=q6ur
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
