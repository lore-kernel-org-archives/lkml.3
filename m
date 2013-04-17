Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966368Ab3DQNlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:41:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50577 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966186Ab3DQNlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:41:22 -0400
Date: Wed, 17 Apr 2013 14:41:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regulator: as3711: Use a static of_regulator_match
 table for of_regulator_match
Message-ID: <20130417134120.GK13687@opensource.wolfsonmicro.com>
References: <1366185682.26712.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bX/mw5riLlTkt+Gv"
Content-Disposition: inline
In-Reply-To: <1366185682.26712.1.camel@phoenix>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bX/mw5riLlTkt+Gv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 17, 2013 at 04:01:22PM +0800, Axel Lin wrote:
> The same table can be used for multiple instance of pdev, so we don't need to
> allocate memory for of_regulator_match table per pdev.

Applied, thanks.

--bX/mw5riLlTkt+Gv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbqZ2AAoJELSic+t+oim9Rb4QAJG4YNF9HNsexvO8e2vaXLHi
JzHysumF/Ohibk1kHyzYtGUMxcYk1xMqa/C1oQPD3fzMjJoTOXbM81Pp0g2uX3R3
7ov8XgDajuh8GRFFS2dEBfKJpqagXOrbjoqZjx+9fAAOpMkmbwBs7MZ0M+X1kpl0
C/DSFiIs+JgkB7jGMoU8U0fxPYcjjHpORctasHIhESdLifhN3wM+B6t3DjkgQaHy
A9281I6kxGbjEXEQ7JMV3+WHuAMrdWQxBdfmRb5uK9ssCPoU7q1ItvCD/IWi3f2W
8BVUaWFWEEWBRpbNmkFAlfYziHqQ69P1sPSXQqW28tOx+/PZjSnfYasxahGssi3X
KUNAVQzc7RLQskypmBnwjD9zk1kZKcDamEgObCLCDIXvjqrcWdzY4CDzAHigVkai
ciMjFXZJjCMjyWg3mG6tTntFBmWyUL7ME0j0qcluZ4EtdYvZro4JIah0Gx/cFrJV
sIjiRNfFqh11JMeP4K8jGs8sBbwmUo292Pii/48T62XjglmJ3aXgzysDvhdBANti
5DSUcpAavpIp0mGlEQ7CC2f8+uz3r7aMBWnzVTw8SL44c6RMIzJhIWRLG0aXdQHS
p/KIFUoxyhI/29ju7DDAWO3pQCbDBbDwQyAJ5jeVXPGkuiQn+DlY8SUMc/OWJYfu
v8y6NiNTWZEHKwtG6nUU
=NOad
-----END PGP SIGNATURE-----

--bX/mw5riLlTkt+Gv--
