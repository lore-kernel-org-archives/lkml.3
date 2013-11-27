Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3K0S2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:28:47 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45114 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab3K0S2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:28:46 -0500
Date: Wed, 27 Nov 2013 18:28:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20131127182841.GF14725@sirena.org.uk>
References: <1385556677-5244-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131127132442.GJ3296@lee--X1>
 <20131127151639.GX14725@sirena.org.uk>
 <20131127152701.GQ3296@lee--X1>
 <20131127160707.GC14725@sirena.org.uk>
 <20131127164202.GX3296@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TvdOHkZ48FvYUU7J"
Content-Disposition: inline
In-Reply-To: <20131127164202.GX3296@lee--X1>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: wm5110: Give new AIF2 registers defaults and mark
 as readable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TvdOHkZ48FvYUU7J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2013 at 04:42:02PM +0000, Lee Jones wrote:

> I see. Well I'm not sure how. If we apply it to either ASoC or MFD and
> other patches pertaining to that file subsequently appear, then
> conflict is likely. As you know, the commonly used mitigation

It shouldn't be that likely, we're adding entries to the middle of big,
ordered tables - conflicts would be caused by something like changing
or adding adjacent entries and they're pretty trivial to resolve.  It's
not like a restructring of the code or anything.

> technique we usually employ is immutable branches, but this was not
> employed in this case for one reason or another. So if we apply it now
> to either one of the trees we will be hedging our bets.

Hedging our bets would be applying it to both trees! =20

--TvdOHkZ48FvYUU7J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSljnWAAoJELSic+t+oim9QuUP/jBi8W5HH9feoRpRSC+7gNUX
rWHxGGmXXo2l0INUKOc5Nf865FbZoFXt2GuyAf0xoC6mCN0/YRgFUEpy+Xo07cUe
5JYLgRm5bhVz3bBUXUfqM2ShIq6Dj8tuLCcBTHgjIFJr2wG7Zk/n5u6xvEwttVU4
TMGG45fW1M60UXq5+KK2N0o9dkw+r3ISjzeAOCtD9zrDPt69cNZCGzSqY2FR5+wG
s1vDRXqxMxeRPywJH5XFi4AcLqy2fdIhOfrQc4ISEU0kDszpvqIPzeg3Zo5Q74hF
6RlOs4RHwIwTtUAsS+5VIEhMfYtFVgs2xXeJHlyFFpmGhTmUmMByeoGi9gZWPYBq
KiFgTx2krMgyOVg9LiZrhyUNUTyI3ChIVQ5dccQx330NY/6NEDaHkoqp6jcuZ40I
482b9oAjM7GNdek/k0M3uhJ/ZX9Po1iAW2KLavVtnh1HTTlv4EBFD1YSXpi12FYA
TbjvqcTilxNI+jv/c5btMdYxiftl14Bb8O0XmHwwTbZcNCGCUjqMOxYKbowpoIZH
XEkP9HfHZ96qEyDuY7f6URff26GiThOwIA8qACYK89BVDQ3oVkDgDfPXVCdncKf/
x6pJlRwh3zAXTcWHeVXAkJnPBtlhRBYHgCkPce2U0Gn8C0wHLNtUKvydcmuYARW0
lnfCncCSYPFvpaTtQ+AW
=Yb3g
-----END PGP SIGNATURE-----

--TvdOHkZ48FvYUU7J--
