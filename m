Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaAQSjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:39:03 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56096 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaAQSi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:38:58 -0500
Date: Fri, 17 Jan 2014 18:38:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140117183853.GD17314@sirena.org.uk>
References: <1389900750-27625-1-git-send-email-nm@ti.com>
 <20140117160821.GV17314@sirena.org.uk>
 <52D95EA1.6000608@ti.com>
 <20140117180015.GA17314@sirena.org.uk>
 <52D97260.1010304@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="80KdhljSN0pKc7w4"
Content-Disposition: inline
In-Reply-To: <52D97260.1010304@ti.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ti-abb: Add support for interleaved LDO
 registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--80KdhljSN0pKc7w4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 17, 2014 at 12:11:44PM -0600, Nishanth Menon wrote:
> On 01/17/2014 12:00 PM, Mark Brown wrote:

> > That sounds exactly like a system controller :)

> Hmm.. I have considered something like PRCM in OMAP as a system
> controller... anyways.. I think I miss your suggestion here. Is there
> something you might suggest to improve in the patch or take an
> alternative route?

What people have done for these things is have a device for the
controller that maps the registers and then have the other devices talk
through that to get the access they need.  You still need to specify
which interrupts but it's simpler with the I/O mapping and is needed for
arbitration if the hardware has register bits for multiple functions in
the same register.

Not thought enough about the patch itself yet, that's more a separate
thing.

--80KdhljSN0pKc7w4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2Xi6AAoJELSic+t+oim9a5wP+wYrCEO4+rXT/GJElb1X5bJ5
np8dUFliUsrBBePJHVdTKY4D7MIl54dH/0tiNDACpViubQmg4SskQe9We/Tzmx13
R0MDSlNYzVYT3IcsaIUIg2cNn+59XKkYJQ1sT2kbTu7wSFPPsMBm2YTx8RYiOI0a
QRRzuao5ZyOzMH9/R0+l2zt85q64xyrxnBtgy+5lUlINIfRxzD9E0hAAjEfDRaMk
QCS9N1+PjNw3gNLuEuijSjmnXCaffN3wLsz3FnbsVPQZn9BvrHvWU1AlFWkIwe5i
p8bkFNNxg0RCU/yYef6EbmT560E1DgfOEiyFeqxyBEBmtZPnnm2Hsy3Vwa6UWVUW
OFs4Xbl+1lhOdiAbfVKfGyoTP+fBj3dXIH0sSQwRZE+Cup7LYDEZDGtIPMEps/HV
ibq2T8T3zeg1sm6255Hz2aa3Q6YoYSAQm/zDYn7EfIJP3wh9b/f3ScY+5KtegRq8
F2TtCL3zAK+JkBb4n8I/DhrjhBi+E0pUz8G+3eGYJDfltQ+8vwLjSI5z51nhrDUX
fVQQ2R9UAFOeDuwRY650Z97b/rXT6/nysfzgOxoVZHjr6FqhoYtIbhXFRdqMqfFE
wHrPot2PLN2Im7LMm5oE8bl92m03AuavHnM/mq03a7GnRJT4/H/KHuK4gv7HJXNW
+VklGii1pUHmtmY7/h7K
=kxem
-----END PGP SIGNATURE-----

--80KdhljSN0pKc7w4--
