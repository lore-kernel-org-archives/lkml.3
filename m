Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3EFKbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 06:31:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46661 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767Ab3EFKbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 06:31:07 -0400
Date: Mon, 6 May 2013 11:31:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Grant Likely <grant.likely@linaro.org>,
        Richard Genoud <richard.genoud@gmail.com>,
        "Yang, Wenyou" <Wenyou.Yang@atmel.com>,
        Joachim Eastwood <manabian@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 01/16] spi/spi-atmel: fix probing failure after
 xfer->speed_hz set
Message-ID: <20130506103105.GB13472@opensource.wolfsonmicro.com>
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
 <1362626815-6628-1-git-send-email-wenyou.yang@atmel.com>
 <CAGhQ9VwW18LXY5Jn0FUFCaAzKxP1W3QADG=JBp9JbgaAwo=F2Q@mail.gmail.com>
 <B256D81BAE5131468A838E5D7A24364154236AB5@penmbx02>
 <CACQ1gAhZO3stjrwf5SiZf7jOO8T5bAJZiz97M7+7vwFmk2e65g@mail.gmail.com>
 <5182414F.1000201@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Content-Disposition: inline
In-Reply-To: <5182414F.1000201@atmel.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 02, 2013 at 12:34:55PM +0200, Nicolas Ferre wrote:

> Can you tell us if this SPI patch will be merged upstream using one
> of your paths?

I have no idea what patch this is but if it's not in my tree -next it's
unlikely to be merged.

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRh4ZiAAoJELSic+t+oim9RPsP/jxmLHu4wCW8hXusLkEBK8J8
SqrL4Q5MoDubi0aap6LjoW0U2KgV4+pGNzSg2ri3V/Je5Sy1/SpzhZVA4JwQHnzi
503ajmxGjy7/NFReEXR/3P1y6XUV8Mwk0eZHQCC0v3djid4PfJaWjBtk1kajdNXB
qfS0/ONULjFmM6/5BEHE7R4QQHrfuw1VyG/6oMrcX22yMP5DryLBjnvPZOhjCt88
ssf+y8rUnPJh/GexSEEgLdTfsNxwUWHkgPtlEVZmVSI7kdEFKNNs8f5Rs2va4fIn
dXHPviIOboP0CJfNVOtjr3iRl/oRTzzoGivvjNt1OruUcrDY09y8ho+M8POgWF5f
YgwjViRvubU4XkZzDflqT9Z4PPA73ryh9B3dSrStEzQlTO1yQk+6iSvZqU0Ua+9h
z/leGybASmFlsgMCmkeu+IVVFy5KAcN2jqoqEhKBZvSqaBjV6FJoVeoBLExEEbqm
oRK5rkdDC16N9eb0hka1MiDKi6BhaUr50pTRu6nRsQ/X/exB+vZNBhrMHxVV6Ln5
bJtTJb7xR2se6y54MpxhGAIp8G/txAzF75Jx4X4AW4VC380V41Q+/fX+pNOf5zPd
36LqVXuMfVsiKcHqa5GBiN70RIEbIwGGSlzK/t8RyTCp0ozlD5t+fFSJQmrKW/kT
4cfAV9DPwNMsbrSAbii9
=ZNp6
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
