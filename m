Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3FJQ0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:26:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58671 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab3FJQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:25:58 -0400
Date: Mon, 10 Jun 2013 17:25:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Message-ID: <20130610162548.GH1403@sirena.org.uk>
References: <20130610154633.GL20297@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="svZFHVx8/dhPCe52"
Content-Disposition: inline
In-Reply-To: <20130610154633.GL20297@gmail.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 00/10] regulator: ab8500-ext: Refactorings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--svZFHVx8/dhPCe52
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 10, 2013 at 04:46:33PM +0100, Lee Jones wrote:
> On Mon, 10 Jun 2013, Mark Brown wrote:

> > IIRC they were more involved and since you decided to pick a random
> > e-mail address to send them to that goes nowhere near the mailboxes I
> > use for upstream they're not going to bubble up particularly quickly.

> Not as random as you might think.

> I knew you'd left your old place, so I did:

>   `git log --author="Mark Brown" --format=%ae next/master | uniq -c | head`

> ... to see what you were using most recently. I recieved:

You should use the addresses people are actually advertising, falling
back on git only if there's a problem with that for some reason.  In
this case I updated my contact details in MAINTAINERS for exactly this
reason.

> I'll send it out again to your kernel.org one if it make you happy. :)

Well, I don't care that much - if there's not a patch

--svZFHVx8/dhPCe52
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtf4JAAoJELSic+t+oim9GpkP/0Yc+4C7CGhypfscLRKWF68h
PD8vq+K3zFKM0VE4QLh69HE3qiONRy3F/By1r/JLsWihLqBAG+P1kvAIMP4YH47Z
s7X/hXAv5+1HOtigkgkH7gV6nD33nkMFMugjLgGRov7O4hw2VNEg79geVd0E9EZK
1S9aN3nkZTSWV2AIGvctnw5wVK/hQASwlJqwwlKufqnNaEmChNxHQdSXbV64iswm
GTGy343jJuuoGyadIBGORWkc6AqLUrVTnmlU0W+GfuNM2IgRHgnDiqtXm14xzQT+
yfrag1AKqs9QWhEszUoHXSWzWm4wmbGZaEowePNlL6t29MIi+o/H6CcbLmgJxQAn
UFbIqgN8+B/TmFgUqL43URmE9SKpuFqyq7Vj8xB+F7Y1ZVxLNn5UI75Jkg++RqZe
/VYty3OyTa91rYCECjb7RgPQBrLbPmvZ9MwxyYRJ9LhQPCJwmXwiYJcKvGCKeXYp
muafHEiV/njjZSJkX/yVzYRCTmc/jOtW3Nc8EHwiH6EUpu5WJpGnewx/ehCOJf/H
qlKpuDcfyUaE0T9lmphE00DXHlt1nl/upGOTuyII8L1kxwec/CtFugsVRTvWxBvc
MkBMAoLm3Fu1MQLZHo7zNE4GpsfdQaKcQ5TqxGA0SAa6bYfUS1MH3P3oDquFHTuU
9tmyZR31JV65KgPwquqK
=G/4F
-----END PGP SIGNATURE-----

--svZFHVx8/dhPCe52--
