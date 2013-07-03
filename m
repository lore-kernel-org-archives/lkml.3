Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857Ab3GCSWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:22:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40708 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964792Ab3GCSWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:22:12 -0400
Date: Wed, 3 Jul 2013 19:22:09 +0100
From: Mark Brown <broonie@kernel.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, mika.westerberg@iki.fi,
        grant.likely@linaro.org, hsweeten@visionengravers.com
Message-ID: <20130703182209.GC27646@sirena.org.uk>
References: <201307021007.53590.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tt/ITYRGFe52qw7n"
Content-Disposition: inline
In-Reply-To: <201307021007.53590.hartleys@visionengravers.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 04/11] spi: spi-ep93xx: get platform resources early
 in (*probe)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tt/ITYRGFe52qw7n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 02, 2013 at 10:07:53AM -0700, H Hartley Sweeten wrote:
> Get the platform resources early in the (*probe) to minimize the number
> of goto's in the error path.

Applied, thanks.

--tt/ITYRGFe52qw7n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1GvOAAoJELSic+t+oim9uuMP/0UvwWPL+Pl84OyF6C4rYPkp
yKKRv2kixEDZ8GzsPMpe+AMZlq85C9vfx4ivX7JMQHTC3sgUXKZZTJl07vU+kRk5
x7K3/HxS3fBCpdsfPYJWs3w4KHF7KuFy3OI4IG5tEYlCVJWJT4vOiw/XSGeIYO/z
+u2eSw+2L0Ve36NPKfCUV0u8f4c25tWNBsLFaRthytgCWAyvZ+bbKNA5FH4VpNxL
PpSmEAVKTla4mTQvsUQ46qLexCDpwgCQEP+KT7YzsGDZBt1ENrMJfgL+8MqbhHLr
GcV7VLtXxcjyiRh6AdRn6cTU7MNLcah5t8qDjfVYslxaLS8jiXScWLJPxPX3y2my
eYZExFN9KSxJTS2cN8gqyY4vetkrNwWOhuHVj0zQxXf6wQkgyoxM6+5kBxHldGYG
lIRcZXwTes6gVmjC3CT+33mR/XbexkJFcSnx0Xb460pCdrL5ZrxNOMw4kzgyyLFf
obTp0S0kDXzLPXf8Ku6ti+LqJHBYbzYbNwsj3V2Lzr02GpioHgkAaFA4VMKvQPcY
Ykgsf5sO4kPmdgVS/rb2RwqDtSxOq88nuvzpL5BaRZmqzj80VstSXrDI64VQ5l/X
4xNV8BpNwaoPZ0R+wfl0iCDKO+ah8qgf412IrYJQhgcXjBLE/UKHmU247zEspA48
u+otIxdg0kaCCHdSfX+y
=Iu3q
-----END PGP SIGNATURE-----

--tt/ITYRGFe52qw7n--
