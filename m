Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbaBDSth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:49:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35429 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaBDSte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:49:34 -0500
Date: Tue, 4 Feb 2014 18:49:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mmc@vger.kernel.org
Message-ID: <20140204184909.GT22609@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9LnWyBss4uQTlezA"
Content-Disposition: inline
In-Reply-To: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 00/17] amba: PM fixups for amba bus and some amba drivers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9LnWyBss4uQTlezA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 04:58:41PM +0100, Ulf Hansson wrote:

> The fixes for the amba bus needs to be merged prior to the other, thus I think
> it could make sense to merge this complete patchset through Russell's tree,
> if he and the other maintainers think this is okay.

What are the actual dependencies for the SPI bit?  AFAICT it's probably
the first patch needs the bus updating?

--9LnWyBss4uQTlezA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8TYiAAoJELSic+t+oim9pVoP/R8rI+1Ffz2UfTaJ72AcKLgz
gZxsn12hQIOOKoB/RXI2qF6zJj09JIsO5u47CkjJ5IaDAmCY1s5sJxqo1o1shwle
pTWRflDp7esLDdQeitkPlfyzfELmqteUN4flCZHq19bBjN7+lAkgFoAuctJPqN8N
QsY3qv1K35SkQ4lV6JRUpX7YS5tB6rTqOkUMct30wuDYgDqRGqt8gASl2FT/CIrG
9kC5teiCunSstqb5zF2jEury7HdeqovRXJA2bAk5jV3ephlyKYboNsDQ+cpRBhrO
lVzYRJ15g+8GZO1RXikum18YyRyfKPeD4RfQt5BV8ID5Z7S0JcqgmD+6vbBOJo7a
CRv2OFO+l1czH50UjVyAA3/RUGjiRvScnd6ARLfEqdyb3sXxwltbnxn2Ja71ZRXx
iYaGu6CKNmjhXL24JBDCDqs3biMwbGiYek8hLh4JSMapsdDnN1DhRV5JDOrHwGuK
Ug8rflPflwBitCS1fH476MUTT9FDVg93D/RnyvN8t/HTyFj8m8az/6ojurBUK745
t3UUUGZNvAsIQ/19yLG1Uf2WdUsVD7sLs3cvv95oYJCEd3cklR5eoBB5jqKX48aR
Saibmy7zsYn7awBLv6NUZBkTkhSbA/h4aAmhafAdLnP7pH8SKhzgCoDPh63LFCZc
phCnP+GmtkNuvKjagVW1
=xvOJ
-----END PGP SIGNATURE-----

--9LnWyBss4uQTlezA--
