Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaBYM2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:28:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51650 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaBYM2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:28:19 -0500
Date: Tue, 25 Feb 2014 21:28:13 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        philippe.retornaz@epfl.ch
Message-ID: <20140225122813.GE25940@sirena.org.uk>
References: <1393327167-8526-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+oW2wFbbmfg2FKJn"
Content-Disposition: inline
In-Reply-To: <1393327167-8526-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: mc13xxx: Fix NULL pointer error in non-DT
 mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+oW2wFbbmfg2FKJn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2014 at 04:49:27PM +0530, Sachin Kamat wrote:
> Add a check to avoid NULL pointer dereference error when
> booted in non-DT mode. While at it also remove the additional
> of_node_get which is no longer needed for of_get_child_by_name
> and fix the node pointer.

Applied, thanks.

--+oW2wFbbmfg2FKJn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDIxaAAoJELSic+t+oim94ycP/RXTvu5HcLWgGC/1sP5u8UWA
Yog9iynv3n1K/3wicgiWz8ywjLmsN3cEyvEhR4AXECdWXG2gRDxQ+5rlsmbn62tG
OaFjij/uT7LxlNuPMatq6kIYNG+dygtG9chVba7WcXlCsWit2mCUYfQvyozxhjU8
a7P6v79vNeDUCr9V2kWSMpZxNKSS3IJSi0NBKftfM/MdGnxooeGkkaAwmM01rA3Y
WKTSI5WTdCkwVa77CojFEN97RD8g71iawV4NXTtMjdsvO5XnDYeW3ivZbV2N6EcG
3xDUk90esemc0HiAii+/587zMU4h6QdwjAPMlpIc3AsmQLKXYkwiAsrwMyNdZKVn
hJrSOlq+IpLttCtglHe1Zs8UDiEKRjGibt4DEeN7PwNo2lrhkF+0TqeRRvy/tf9k
HjumN0SWlhC0gE8BY8M/KMisc3uaQgmMI0HrasM0Vi8G9I6UuFdUIWBgrgRLzl1w
PtqYH9z4A/bX2+H7qfw1Y4208zxIFZToExMcYskPG1vZIRNBrD7Fakh7/M4++sGf
ZukZRkigQtiu4CBPvJE79D8wdeFegBU4fjggcrMiGE0wfmdHYShmazfaiZTlzEDT
9TYO2JJ9gQLmJ2y3zfPkn6byabWRNvHbRj/aOWZVntn9OZVoWivC16hPbA21hznW
Rz3a4cVM14qGd3ygd3/C
=OPio
-----END PGP SIGNATURE-----

--+oW2wFbbmfg2FKJn--
