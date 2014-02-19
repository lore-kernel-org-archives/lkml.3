Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaBSQir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:38:47 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57927 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaBSQiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:38:46 -0500
Date: Thu, 20 Feb 2014 01:38:28 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219163828.GX2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
 <1392720071-13503-14-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wG4uuBIBs7ARbQp1"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-14-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 14/15] regulator: arizona-micsupp: Remove redundant error
 message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wG4uuBIBs7ARbQp1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:11:10PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--wG4uuBIBs7ARbQp1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBN4BAAoJELSic+t+oim9XXYP/2Yhuw39ClwyIJpM50042s/g
6UxtlQJ5NzC/KDgNIjf4yKrQ+58atyfktavP52fAKlbUQ1C79H7SsxWDhZfZKU5n
nMdtSE5qmWwyOE9wrmMLxwz4t5nngT1EV1t5hyCMtIMW++LhenAoJdg2LJzmMb8s
yBVvwiNpeL/sJhZhStUT7NON1CPmeUt+oh/nj9fAJUsXfhde6RKi/QlxeZdxH6Je
C1XpTO2jwl62BTTThqB6VOs6xWc3bO626PDfKXYeplGl2oo+I+eTwXI4zT+6LmIH
nh6NK9tSNDhCsHjkscu1JGYPHWe/wcrusJ0MM/5kb+HTqgZ0s5gP7DEeOfzovfsL
+I74V3zgCXw2EI49OtAS6GNxOcIUtToepAmaJlUUkbrM0HaeFBDnaGf+/Zs+OC5N
7Ugt0yDWfwPjjSoLKaQourex0HCaQDtiUmaEx85HWUaVPiZ/UH5xa9UgflCgr9Qs
dXodqLpfuVrQe684dRxJgGAr5b3Qe0/nIDHtKVXrq8fW3FDDF+baV8n4hcaVve+p
8yUQuixPjQmPoKl4NJWxEIfBLZdS4o90xf5nP5BJl3lKDH4prx1FPSzvIiRT1iK8
3hsqJxEzZ8pcB11qrQPlcNKPpj7IGZainXUQfdQLeVK99MYYRDdVTNhjgH0OPMw7
bY5hMcuUfDUJkRj8dLD+
=cLx5
-----END PGP SIGNATURE-----

--wG4uuBIBs7ARbQp1--
