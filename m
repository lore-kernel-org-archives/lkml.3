Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaHQNzR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 09:55:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40915 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaHQNzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 09:55:15 -0400
Date: Sun, 17 Aug 2014 08:54:56 -0500
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org
Message-ID: <20140817135456.GE14537@sirena.org.uk>
References: <1408270138-29811-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brEuL7wsLY8+TuWz"
Content-Disposition: inline
In-Reply-To: <1408270138-29811-1-git-send-email-geert@linux-m68k.org>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regmap: Add eplicit dependencies to catch "select"
 misuse
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--brEuL7wsLY8+TuWz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 17, 2014 at 12:08:57PM +0200, Geert Uytterhoeven wrote:
> Add explicit dependencies for the various regmap modules, so Kconfig
> will print a warning message when another module selects a regmap module
> without fulfilling its dependencies.

Applied, thanks.  The second patch is a bug fix independent of this one.

--brEuL7wsLY8+TuWz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8LQtAAoJELSic+t+oim9bJ4QAJaNclTIyDOb68BMYHWZiKh9
rSnzGUaW9BYOct91EkWaFTSdvDXDpv8zNiVHFW5EfYAYe0cjN56WA7Fh6cs0Zegj
dgW6kPq+R1CAShnAuDYx4fur3liH8GiNGJtUbhu9nxFRuNxU/HklHnrOjM2uytxo
AMnx0CrpzV+/uymqt4OVsZIhrMqAWVU5QRSBIeWz2QALYYusVWdSL4xnrJeA4KSs
YnZIgrnuh/4dFnjsjTzFoNjr7mQr4IGNXbRqrrj9nvHLgHLTc+Wi8726TnVFbGGI
x0eUEYRxx/SUBXmrPU3HPVTW4OXl953lk6DxD1HV+b4ZWwIfeWFbjcmvHxv+7Dj4
YCYVlKD89bUZSpygXfENvey1EiyXwrLc46ujejJIAEQmXVFXkbh7auUYKkI+0P81
Xsm689WtlnUDzMtEO/WK4z4p0hNZ0M9GriEjpQ+4tGZg9wDOYNrfJY8Y35E7CHPt
/6DXxAongKar0n+nwPvF0oiA770RUuD+KC3V8ADk2mniy7Uc6Iy7kNpg7vQbU0CF
NfSFTrOdKP85CwXwV78Nhz9A/n7Piof2rL5G59OIxVsImzObwF1Uzm5cwfRdBJtQ
tbZ/aNui71K5LA6NOnyZAk91tWXRh3aMRDMpXpJirjT8GJiK8IaQIoLxHj4C3zoF
TJwO6iEO+vSZ0DaNW7/n
=XqZ4
-----END PGP SIGNATURE-----

--brEuL7wsLY8+TuWz--
