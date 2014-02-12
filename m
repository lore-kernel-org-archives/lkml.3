Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaBLSV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:21:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41008 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaBLSV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:21:56 -0500
Date: Wed, 12 Feb 2014 18:21:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sbkim73@samsung.com" <sbkim73@samsung.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "patches@linaro.org" <patches@linaro.org>
Message-ID: <20140212182148.GK28112@sirena.org.uk>
References: <1389266554-23463-1-git-send-email-sachin.kamat@linaro.org>
 <1389266554-23463-3-git-send-email-sachin.kamat@linaro.org>
 <20140212181043.GB23630@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nQ9468VQnrzpS1Lp"
Content-Disposition: inline
In-Reply-To: <20140212181043.GB23630@e106331-lin.cambridge.arm.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/3] Documentation: mfd: Add binding document for
 S2MPA01
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nQ9468VQnrzpS1Lp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 12, 2014 at 06:10:43PM +0000, Mark Rutland wrote:
> On Thu, Jan 09, 2014 at 11:22:34AM +0000, Sachin Kamat wrote:

> > +Required properties:
> > +- compatible: Should be "samsung,s2mpa01-pmic".
> > +- reg: Specifies the I2C slave address of the PMIC block. It should be 0x66.

> Is the slave address not per-instance in I2C? If not why must is be 0x66?

I2C devices tend to have a very limited selection of addresses they can
support, a small number selected by pin strapping is common but a single
fixed address is also common.  Each device on the bus will have a unique
address but there may not be any selectability.

--nQ9468VQnrzpS1Lp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+7u5AAoJELSic+t+oim9DEoQAJrOnp/rr3kW+BpLaQej6o8J
Ln8SL2kE+C7usfCSDRJO3HM878J9OlT+dBGJ2BL5ZsS+57sCaJ29zBtbFeBHCH71
GRQjdI7j4ZaoS4IsmzfYM0h71JCQ5pY0eoa82eQejKNwW1O+5DHULHGYf7x65Buo
NYluP711QHSgzdMaPT4KxKBG6VVT7L5tGi0+6YxXMPVqYlTsJP6jqmmf1saREwwo
5Vz8h5I5Q2Wtrdb3/dHAtE+cA8Hk/lADmeVEkrK2W6vh4Y4H1ZabCtVFXnli7mka
1H+AruLZeGok53IZzZtOQ7wIZOdRSWJZCkS2ezmyYibqqIYQup137HDQhO3Ss5qm
VgBuQlZWtjsNXXgx62Tcq0u93sm75vkvCd3hkj2T6cC8kB+No64qGJKWPbi9d2Uh
GGcV1tYIXdu4c5Nizqw/WVyE2LHczVKc2Wj/10nfmZQyzp5/Pn17nnwg/bzVLFOf
CWbqNpE80FCfUUIJ1JtDjw7R0fQYT6FUPB39Za3xvPfF5MbQmN0WmXoIpqF4LUun
P0Yxghu1tX4wLeus769tMR7i6aUeRwxosVcr2yUJ6+Rq8+Y1Qoq7dBLUzbslcx4U
orZONue2aPB/f0jLt9PcioeaxJfGPYC8H/BVNp9rJvoeFaluuNfySr5bqhIwKatV
lJKSF4V7YOTEQX8mpqj3
=ZM50
-----END PGP SIGNATURE-----

--nQ9468VQnrzpS1Lp--
