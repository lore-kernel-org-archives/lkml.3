Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbaBNA0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:26:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43441 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBNA0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:26:37 -0500
Date: Fri, 14 Feb 2014 00:26:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Gerhard Sittig <gsi@denx.de>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140214002627.GG28112@sirena.org.uk>
References: <1392302806-17267-1-git-send-email-iivanov@mm-sol.com>
 <20140213212757.GM4524@book.gsilab.sittig.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="llJsCJM40947MYJX"
Content-Disposition: inline
In-Reply-To: <20140213212757.GM4524@book.gsilab.sittig.org>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: core: Validate lenght of the transfers in message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--llJsCJM40947MYJX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 10:27:57PM +0100, Gerhard Sittig wrote:
> On Thu, Feb 13, 2014 at 16:46 +0200, Ivan T. Ivanov wrote:

> > SPI transfer lenght should be a power-of-two multiple
> > of eight bits.

> Are you suggesting that an SPI transfer cannot consist of e.g.
> three bytes?  This would be surprising, and certainly would be
> rather wrong an assumption.  Am I missing/misunderstanding
> something?

The check is supposed to be verifying that the transfer is a whole
number of the current SPI word size as I understand it (not actually
looked at the change yet but that's where it came from, factored out of
a driver).

--llJsCJM40947MYJX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/WKwAAoJELSic+t+oim9FSUP+gNc6TTk4cW2Le+ZA0SdSQEL
fzMiadebPWKliuFUuW5TCBB2cilbqGSDy8/6Dz5vC26opALVkXTx83CugDA2e5l4
6iDqtqhmf0ZDSmP4a/kOlTJjOKQ9508B34Ju8jzz6UhzjkBVF+jlMr3sFTgjnejT
LoTtHpsMizmmm3BwactQA9v1Ffjhp3mJclRvuN5wTnrrwRgVKB8msyklG7/OSQFR
O/xfLpa9INvASxXB6MatMrIi/rGlvtmH7ZUqZ4Rc2OdrvbC1mXpJe3XHHUanfBRp
BibLAozqBUqtrriDlLxEHJ6FeMlxEwICaPryFbbkr0A2ugbEnPJ3KeuK/shvLV+s
V4hZP1eNjCLUER1PJGZDgnzOPro4b/voy7KdRqscnQFgbPYtIk8KMIZVXf6z+9HM
7i3eApT4SoNELZHSMv4C2n+wS33llblPiIoF+F8UcB8QsBWPoXPkf/A0G42ME2nB
27PMFXUrOljkmUaLlRLKp5iUEfapR1BEg5MWH3IHIEJdSb+AVqmnkj7SS96/T1Et
v+jd3J2Vh82ZW9FAKIQasnmj40MiaRcQ5/vANcWKw//pM55b1mAE7OZnldAHi9CA
IWDQR57n+y+Q23C8GLZ3iNj4zHqfYf5kAaTk+BPoy4ARDGzGs7dWMBHTOb7IAIh6
ZzSXT0Gatj1pendnQjw6
=NX2p
-----END PGP SIGNATURE-----

--llJsCJM40947MYJX--
