Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3L3MDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:03:53 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50489 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3L3MDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:03:52 -0500
Date: Mon, 30 Dec 2013 12:03:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: lgirdwood@gmail.com, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20131230120327.GN31886@sirena.org.uk>
References: <1388023041-25785-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hND5PKUeuErErcgH"
Content-Disposition: inline
In-Reply-To: <1388023041-25785-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: act8865: register all regulators regardless
 of how many are used
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hND5PKUeuErErcgH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 26, 2013 at 09:57:21AM +0800, Wenyou Yang wrote:
> As Mark pointed out, the driver should register all regulators
> regardless of how many are used in the system in order to aid diagnostics.

Thanks for doing this but it doesn't apply against the current code due
to the fixups from Axel.  Can you please check and resend?

--hND5PKUeuErErcgH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwWEMAAoJELSic+t+oim96U8P+QEowlTYBYZ4bRMgxrIuXY+D
nuCZeV6azi6YntmJq7D5fzsRVvoVgnt/Cvkb/lT7j3I+8q3fLU+unfCWaEpFegju
X6dQY3hY6gGn+2vtzluyA+uCkSXcitIvNi+7IqMHuZ9cj7goWyHSzrGdAQxCgq6L
VL7LvLsWGUbVSs1nxK2tgRNeJka1fA30S6H2fAx6N/ceNFPk02efu6S0w3YLW7Hv
+89T4nMqzvit4xlko3R2n05xoiEq/PI052A5XS/KXagbv8tJGjy0VT1lO1qe3pYs
twz5kZSGrG+qTZfJM4MLSoB77uPf/AON3bTVGySxl9dFLaWMEHEYyfGxklPwgPCi
v1D87KcBDRznB4lriHlBWIlCoeECSe7t14DDQdQ7mPUTMOg6qNBlB9muvqkOuX1L
JQj4OTEDqH5dp9st0WgBxRKqf8aUi4pPHBvt6PfK8HCXO053ZeJl8kgHzgsrdCmS
lzynxNPajaqtDtsfFANUB/h6gQHcyUGC5w4xL78Iw2ZN3rtq5BhKUdZ1SDPKaH9R
oa8JpvMXWpHHF3WmOtH41s6rLoF7Pv6Kes9hhmLMv+T9UwOVHewx9rqOVOVUcpCe
r3WF8vXBRBz1oJyofzk21RuW/d84Co/f271VSPyDB562lcyRcWho/lCaCsbsOv+y
zqMT2ZKzqSLFtJpYPWkL
=u9ti
-----END PGP SIGNATURE-----

--hND5PKUeuErErcgH--
