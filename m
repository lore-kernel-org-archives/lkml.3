Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaBSB3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:29:37 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56221 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaBSB3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:29:36 -0500
Date: Tue, 18 Feb 2014 11:05:15 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140218020515.GI2669@sirena.org.uk>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
 <1392627817-26957-9-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1RkCiX/UEfbG28Bk"
Content-Disposition: inline
In-Reply-To: <1392627817-26957-9-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.103.38
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 9/9] regulator: tps65090: Add missing of_node_put
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1RkCiX/UEfbG28Bk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 17, 2014 at 02:33:37PM +0530, Sachin Kamat wrote:
> Add of_node_put to decrement the ref count.

Applied, thanks.

--1RkCiX/UEfbG28Bk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAr/YAAoJELSic+t+oim9kKwP/jSWqgLDnbe5WVoqPybD98iS
6B7YVesUHxUwXKL6Z307J+kISwkcrpuUpjePMEFPXRdw2s97vaG+tdhrU8j76Y5c
5msgTBHA5bl5lp0Ne5iRiEH1E2IuqJoeZMSo8P2pP5oXVxOXn2QeiZKqzI3YXOMN
upWK1imf90rdxi8QxO0g4qkHYZ9MzobzqmPc1JeCwx3qWZ7zEr2+pozyeL4poFsL
XSajb0a5V1jhu5FuNUHfWBUFkvRqE8EV9WP/caKtV14lGYsFupMPxBXL5ZKNiz//
EKSdoc06Lmny3TddKquCUXlad1Y57fDwpJVvLAdQmfiXZvHikZfIx/WPbgn6aVDo
+QEIEE89FC9OoyydMORdkUDSufGeYTKsFwOrxUg/7BCZLOqw2QJR6tuAe8jds5KT
gqj2BU3N4Gw2vEl943XPX2JIx0QaIzJqht/OtVYPNdGg0B7IPW7SMib6HfOl71Nq
qgsKOKqeQe6+tcWa0UYc8hkHncrFnZyYDXYo4FT6pxZrooDfz9/nvslFv2GylZBc
7RZHqqal6tpze6GW5Npck0TLCBupyQBOpYRG5R1n1coQVl4avUmo6aR8pLixpJ/4
8l9a7i1aWLwN6eIGN8EoWcM11v9RnpONU0I+lj9rjCbDeq18JJckaheMYKPtoCKE
OSoDt4ZHiQoTGZxktGnI
=F+1s
-----END PGP SIGNATURE-----

--1RkCiX/UEfbG28Bk--
