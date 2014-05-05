Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbaEFA6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:58:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58012 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933119AbaEFA6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:58:13 -0400
Date: Mon, 5 May 2014 12:16:02 -0700
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Message-ID: <20140505191602.GJ22111@sirena.org.uk>
References: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140429183758.GH15125@sirena.org.uk>
 <20140430180609.GC3000@lukather>
 <20140501011811.GF3245@sirena.org.uk>
 <20140501223629.GJ3000@lukather>
 <CAMuHMdUWa1_n94sDvv=L_goc+SOnD9CAKi5DzifrY7GWYRdQmw@mail.gmail.com>
 <20140505041721.GD11606@lukather>
 <CAMuHMdWZ1rvC+tkT=CbfMwZtppyJ_KpzT7JrLd5k5P2oxzA+8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mPTHnM80CEnHQ2WJ"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWZ1rvC+tkT=CbfMwZtppyJ_KpzT7JrLd5k5P2oxzA+8g@mail.gmail.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.9.110.15
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Force the registration of the spidev devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mPTHnM80CEnHQ2WJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 05, 2014 at 09:10:43AM +0200, Geert Uytterhoeven wrote:
> On Mon, May 5, 2014 at 6:17 AM, Maxime Ripard

> > Not really, because you can't declare a spidev device in the DT.

> Yes you can. I've done it before.

> See also "git grep -w spidev -- arch/arm/*/dts/".

It is technically possible but it is a bad idea that should not get past
review - it's putting a specific bit of Linux implementation detail
about how we want to to control the relevant device at this specific
time into the DT.

--mPTHnM80CEnHQ2WJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTZ+NvAAoJELSic+t+oim9tuUP/1jdg2G0cYhlmZhdbcJYV5Aq
O470U76PXUzxP7qUh9VTogVOzYzJ+MvqYQfy5esPyScb+npZH9QgX7iAJtLg7xou
LPYohLA8ll5jvBf8ZSY56ZfJ7pssxVyl4YjfuTeKrYUL/u+jDOWMDwg3JzZS15Uq
C0BgxBZKuCPKufnKXMC1dl1r/0mWLNYRfH0QScgwO5FmzeSVARh9G3yXIP/WpRHt
M8QcaJoZXn7LEA2Bs/TyYhOldqcDYmhnDyK0PECN9C4HvlKcKlMLXXyopcp12D4k
nOw87G6zlaZZlJFFudEIdDSi8sCGTYwbNHzNRZvVQmfP4omFRB0+ZN/uNEMdK87Z
L4DFlFdcT6mNI1sQgaVelRT/5mvYKV9VD0/2niy8Zo6kvcHXpwP9dkyF7c/LO5TX
fZREUyexMXFdEIbgBK832Y4lZLUolR/QWm+WAVBIb4Gox61WeyOpYJGlKWIUm9Gn
qh9NRSzYa8I9mnxfG+yZhVS+qdaKfqO4vFMn4XavjKeFR55lefcb8TzlYiNJeBnh
RMHdqY4tqMdG/12ezkaTpFVIqbNtW1iZm69mAT6EsXIXhyPK+fOjxGBFYWwA1RYV
Q5iDs6Cmso18qAecbN6TuS55i3cvw6vOtuE6E5tQqB5213Ggx6fvnikXUMupufEi
sShe28xWprbOP6dpK+Jx
=RFcP
-----END PGP SIGNATURE-----

--mPTHnM80CEnHQ2WJ--
