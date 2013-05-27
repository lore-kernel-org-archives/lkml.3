Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3E0DnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 23:43:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39342 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab3E0DnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 23:43:18 -0400
Date: Mon, 27 May 2013 13:43:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the crypto tree
Message-Id: <20130527134301.f5dcfe3a17ac9914e35fe2ca@canb.auug.org.au>
In-Reply-To: <20130527021917.GA16087@gondor.apana.org.au>
References: <20130521114548.a7bc47b2247f39ec40c44e33@canb.auug.org.au>
	<20130524095715.GA1410@gondor.apana.org.au>
	<20130527021917.GA16087@gondor.apana.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_May_2013_13_43_01_+1000_qRO6c66Gm=ga/2U="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_May_2013_13_43_01_+1000_qRO6c66Gm=ga/2U=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

On Mon, 27 May 2013 10:19:18 +0800 Herbert Xu <herbert@gondor.apana.org.au>=
 wrote:
>
> Hi Stephen, did you get a chance to switch back to the current
> cryptodev tree?

Not quite sure what you mean?  I fetch your tree every morning (that I
build linux-next) so I got an update from you this morning.  I haven't
got to merging and building it yet, but it looks good.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__27_May_2013_13_43_01_+1000_qRO6c66Gm=ga/2U=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRotZQAAoJEECxmPOUX5FEiNAP/3fyTMbAGvF+tu9K2LbCY0PH
/JWGeHwGFsDdSC0EcsadCFPU+6lDeW0AGdvil5m/88eOw4E1qZ49pnYD/VJPAqk9
o0E0PLJb0gN87vuJe748xzlWcKJfX7Rs56fBewIXb7szEjSM0b4FfxOjmDVZOsOC
j8uuW6mdfUf6buTC8btysKktlbt43T3ievB2TFFWttikkyYLAwFDbW5qjJiFfPPT
sSdhN9XQoMPf34ZMZmlcbhfUY/3GggDvTeXGVzCDJwJmVCOaVy6KKGMm+Ss7N7yR
BqDr76LoPq0kVzfg3tg430UlrI8yOQoIeL571nBs1mN5Ik24wUwMAAJmW7B4kGrj
Dtbs/702DketKKCitdqVSGma0aAWdh34l09v1diQQCzQHXnLyqbF2zteN6yy4wMf
W6ejfH7JlmbDf9JxRgoIYZ2o0w1+SAkOcNNLfHk59i+j+c+Uxd4Jz4Wq7RYc0NwG
2jimE71F7+b3WJT26FgOiWkOiz6ZxMT9duuI7V4AyNl2/FP4/4v2SFbkF+FpQWUt
Sgvpe19/0r6YBn7figX8gwi+WtUDHi4xFaYLk6mdoV/O+WfNVJjtsIZe0RLV9R/A
vXi4SQJpI4kUhmCnTIDF2fDusfuGL2oZm+wyhcIstV8aQ7f0ceqs4+RfRNtAn4/7
K10qzcI4xSRtA5ABz/pn
=CCCg
-----END PGP SIGNATURE-----

--Signature=_Mon__27_May_2013_13_43_01_+1000_qRO6c66Gm=ga/2U=--
