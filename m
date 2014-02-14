Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaBNS0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:26:20 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46223 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaBNS0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:26:17 -0500
Date: Fri, 14 Feb 2014 14:56:43 +0000
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Message-ID: <20140214145643.GA4451@sirena.org.uk>
References: <201402131031.s1DAVWrJ023725@swsrvapps-01.diasemi.com>
 <20140214093435.GI3403@lee--X1>
 <6ED8E3B22081A4459DAC7699F3695FB78F97CB13@SW-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <6ED8E3B22081A4459DAC7699F3695FB78F97CB13@SW-EX-MBX02.diasemi.com>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.51.37
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC V1] mfd: da9063: Add support for production silicon variant
 code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2014 at 10:28:38AM +0000, Opensource [Steve Twiss] wrote:

> The previous silicon was only sent out in sample form to selected custome=
rs
> and will no longer be available. I have been informed that the new silicon
> has been sent out, and everybody should have received the new variant by
> now.=20

> The new variant is the only one going into production and the previous si=
licon
> variant will no longer be available. Also, the production silicon of DA90=
63
> makes an alteration to the registers which makes the two register maps
> incompatible.

The usual thing if it's straightforward to do so is to keep support for
old versions even if the early revisions are not expected to be widely
available.  We do fairly often see problems with people still using old
boards for various reasons - the fact that new silicon is available does
not mean that the old silicon has been retired by users (even if just
for comparison purposes while new board revisions are being brought up -
"that worked on the rev A boards, did we break the software?") or that
the old silicon isn't sitting in an assembly pipeline somewhere.

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/i6lAAoJELSic+t+oim9H1AP/Rz+hidBjQgkbfxotQeOasQI
OXMHdKUH/shuzHXrfPYnK5gCxFx2aGg6jeA7bVBqvitr+YbYquTt85JeLp3MOJB9
0cZSfRE3EMnZS0AD002tY+GOKsYLU1NAtcWF+KSR6f0ytBkN+h/9bJhF8OUiX4zF
P0izCgX1PJKRdSlK66cU2rRhqs27A2hmdcDgEtvMstdfRz0wVRp2XyFtXXZpGy5G
xU9f0llwbYKag7VoTOE+nsOFsUooQP3HbIprxYGIHbN9TNFCcWXaE+wFCYmj0UA4
di/nh2Aopk6Iz0RX7ldTS3KCi4i8clJAwoByZvf6rxuWpZNjVEhZKXfzlBhyqLg4
NhwjmnoQB1t0+ld2+wSv3R6IqGP4UFNtFQM405aUA1iiCCexqtXYI0n8PVcT5Ydu
GGi32lzx6M3HwHsjpv0/eMzCb58FYM92AGat2l8WBDBemq/5v9URkjsYnRNX33cT
JLU3nfI2PNuSB8VYqb4eprZHVwqajO9H1VrzsbYHQOANJWFfIJd4WNSJUVskAyRk
g4mqMHyMazHQH272GSu9dJ6n/uW83awkJETEp0MA1YRfBdXDtySItnDahJg4KEo0
6+5g8RrKwDupVsdRRXi1cXRGzOsZ/rIxlXxk4OffaaJCvpaQEDWO0JOfqYcTyqCw
sl5xTadq5JJ9txYVY2DI
=+6kS
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
