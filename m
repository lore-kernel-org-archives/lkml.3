Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaEXMVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 08:21:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41116 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaEXMVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 08:21:46 -0400
Date: Sat, 24 May 2014 13:20:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "David S . Miller" <davem@davemloft.net>, Nishanth Menon <nm@ti.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-arm-msm@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140524122034.GQ22111@sirena.org.uk>
References: <1400875040-13269-1-git-send-email-sboyd@codeaurora.org>
 <1400875040-13269-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3ruYQ6qMoy8hLjT"
Content-Disposition: inline
In-Reply-To: <1400875040-13269-2-git-send-email-sboyd@codeaurora.org>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.116.200.249
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/4] devicetree: bindings: Properly document micrel
 ks8851 SPI chips
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3ruYQ6qMoy8hLjT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 23, 2014 at 12:57:17PM -0700, Stephen Boyd wrote:

>  Optional properties:
> -- vdd-supply:	supply for Ethernet mac
> +- vdd-supply: analog 3.3V supply for Ethernet mac
> +- vdd-io-supply: digital 1.8V IO supply for Ethernet mac
> +- reset-gpios: reset_n input pin

Are we *positive* that power is optional?  I do note that there aren't
any mandatory supplies for the device which seems very strange...

--u3ruYQ6qMoy8hLjT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTgI6KAAoJELSic+t+oim9jkMP/0apfcgASMOjnBDo9tRCv9WT
rKSTuqYvTTluzj3kNcdU4aJFg1Pb7hUnJHf5rRcpqvea54Nkg6uLHGI12Vratgxy
pgc2Im+ohA6ld+e7uHXRYP/UOTYxFQ/qOtT4rGjqaWx4RHLp1eXvkR84uYBWD6hE
7fjm0T2CultBNdbMFCTSXJve9oQufTkojTKrBNF/rVArDjXo+4PomjA9O3ccGGhs
OcZ28+j4kZLvdkVlOtCzvHrfLIgfa7po6Xa9pg0pVmM1mvraLMGcY50toDAFNHTI
65WkLrHwyfJ21tBupVSd+n7GF0iNQ0tZ623URygBkQpc8dq9wHFQKKD3Wwoy4HL5
n2ogGavSyl9WBmVhOhkvgdRnE0VHW+yUi3Omj7qTONaQQxJ9ZyPw/fm8/XJVTcJh
3T2CyzLXMESaljwe0wen4+jrKPSCkymJ0ib0EDBRXUsvATXEEicjg8ynY/BDOuzE
TY8l+UG2/ojwgCR0IwVUFwgRavA7RqfsL0E8d0P7PILCunX9NAMuqkTaXRKRKoDV
1CmcdpAHJEguQle3e5nF2JUS9Svptc1kZfB/RjMqVmJgkmrDDY/64qqyV7Y2/khN
AS3QZERBnfJHe1gcrviMMeFgK1hVZ0i6BSluidmLlsDf5Imd6NUxY+IamUM1Lynq
bbKnaOlxjDsG3Njafi8f
=EOOE
-----END PGP SIGNATURE-----

--u3ruYQ6qMoy8hLjT--
