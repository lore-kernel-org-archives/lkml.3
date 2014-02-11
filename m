Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaBKQjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:39:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40443 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaBKQjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:39:09 -0500
Date: Tue, 11 Feb 2014 16:39:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Arnd Bergmann <arnd@arndb.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20140211163901.GR13533@sirena.org.uk>
References: <57a9999d46c2e0703c95ee68a88f3c539bd10f9f.1392033580.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1GSL5ZULXUIqbbH1"
Content-Disposition: inline
In-Reply-To: <57a9999d46c2e0703c95ee68a88f3c539bd10f9f.1392033580.git.michal.simek@xilinx.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regmap: Check readable regs in _regmap_read
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1GSL5ZULXUIqbbH1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 12:59:46PM +0100, Michal Simek wrote:
> Check if regs are readable.

Applied, thanks.

--1GSL5ZULXUIqbbH1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+lIiAAoJELSic+t+oim9tF0P/2/LSAbE81pN1+ObjcNn/Fd/
cNgEH2NfD0U1n0Pzw323frMGrRIviOEAfKvCXBYgMhhtIl8aqzcEYYitmybZ8XOt
NHDJP2ZA+I1djQyddBYDDSh+sGps+9f+v5f1cqP8dzkCq/B2Jm1ZIEXyWM1XXH8G
ElCixw8tIyhuVM+6cuIPI98d9XjA82UeU4V0tAcaZ+4aq691WWjRNxDwIHUrU45Z
KmO/w+254vvCMJW42DmH9X6WBfL7wpekn7/8uN+sHZrAmSV5gFZKl9xiHA2sBsnG
JYCJlhYrqZaHCzhNZcrtLIQvcp9DO2/ieSUCMtGJ0v8XX9QtnUyCZ3FbqyCISjL4
e3CgrCjwC1ReKJZGEWKGTnxBC4wW9I7PJOz73szUTYCs2DnYs/Nq99ASj+EGq7QD
lV+DXZ805bXMjuUtcSUcy+dCcXCLxlk2x/CqgFT1pm9C+1qy8Kc3qYATFpl4z06d
STOZ+564c/R/OqsuF0/gkL/8ZmGT3tRTQzXfZ9aBI7kU4gVm86muacgKE8b7PP1u
OJQ7DMPve5J2AnimDVoiHTJcGzUrtz76jSS6hdjPZ8skWS+bgwV4XsTY0eO1s2sx
Mb2ch6zJDpO/+rlFtkMJz/M2091ISBzY0+hwymXfwJwLw5HcOhJiba/QOi5sFqxH
gAx3om5LYXXn6xG92qEZ
=DSg0
-----END PGP SIGNATURE-----

--1GSL5ZULXUIqbbH1--
