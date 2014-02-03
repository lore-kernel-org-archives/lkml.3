Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaBCLDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 06:03:01 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34581 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaBCLDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:03:00 -0500
Date: Mon, 3 Feb 2014 11:02:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Guenter Roeck <linux@roeck-us.net>
Message-ID: <20140203110249.GA6392@sirena.org.uk>
References: <1390846075-17415-1-git-send-email-broonie@kernel.org>
 <20140203104141.40cc04e5@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20140203104141.40cc04e5@endymion.delvare>
X-Cookie: Preserve the old, but know the new.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Correct default return value for full
 constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 03, 2014 at 10:41:41AM +0100, Jean Delvare wrote:

> Can you please review / apply this patch? It fixes a real bug. I also
> think it should go to the 3.13-stable tree.

Uh, it is applied?  I'm the one who maintains the regulator tree
generally...

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS73dWAAoJELSic+t+oim9tj0P/isFAsLwznVw3Ll/N4UmoU1P
NuvTCth6NUL5TOySbCTQ/4Y2IxCmHfIZIqReMC2on6RqVOgUEZQJJyx+/EEDE1+N
lhoVGxRyHVY9oC2K2l0nGN3qgORwFNdcsLz1SK3IlsUsFzArBaO+2m68AuETLYJq
Xb21Ca+TmPL/X+HNeMX7+J+qMrBld3Y5ALjVItGMzqQeqzYtabLwGC0iTORd/Xz8
JA137NHCSDrEhOB+M5J0xelfbRjhp8HRVBeXoi54kNROtkMn4oSoFCxJJ8ChPGwM
CFePo9VMSrKSiyr5k3bJiRZ6P+WOjonvdYW3K4gOCCjR1KTPHxCLMygKqKm8SySV
ft67q+yKHZ+Ws3EegD8HP22MxaWARsCFt4Pee8XXZ8UfFndH473bFkf2DgBtcMB5
T7ktAk567qhc0ZIu+ed6V1FCF5WyCl92pKAR6DDDH5Wvtaiq78yLlfCRHTcYPEX2
/eA8uA3wCkvjR234IGotVxk8aeuk3NuRiGad3CwUel4fyTEHMmUXPnE26H3eZ8rg
b7QXkNveHqSaQ0HK+e1HrDzTbnhNdKHnmB7M/4rAOWwVH6EyhM/3gnApQuffAgZP
SM65HLTivLjJl2kwu5bRnle1IhG/or+IR+ahwOS8s1Ty83E5mX9l+yXCjMrUndH2
lMKvmDIv/ZF0tAYh0P5e
=TY0t
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
