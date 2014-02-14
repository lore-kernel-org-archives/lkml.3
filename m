Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaBOKIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:08:34 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60421 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaBOKIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:08:30 -0500
Date: Fri, 14 Feb 2014 21:16:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214211646.GH4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-10-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WFYXJKyHTUiGqOmp"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-10-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/16] regulator: da9052: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WFYXJKyHTUiGqOmp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:19:56PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--WFYXJKyHTUiGqOmp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oe6AAoJELSic+t+oim99CYP/1HeZSt1VWFhbFS44TJsB9XP
7RauBJK4QLyHcHALyhB2NQ0/tzqknan+80kINO+LYz4RQJ6WcwGnvWIarQ8jwTxY
mPPsH5WlxzJ4DV7ZbfCtVoT0SenDGB7IdOSRg5MGU2TssQO2cBSC/39YOsSgpmZO
El6dwJMDnhZT/RTPvn+mIPpf1ymnGmI0qXGTqtNq74YtLglgIARqmESiFolqMrKl
iACVFQm1BKAU5AZ/9WF1U9rEPVZNfyNHbbJDFkgdU2CWHyUcdw2Vi7741SJOv7e9
pz9h65ZFeEffyQ3MYV//3GQgtt7jzlHQtbB+6ZC687FYJjJi1RrFgytjdFuXAKhZ
/wlBJGtsNnf7HmxqVdkDwmn4w9S9KN/R/wIOgeOgoJrh53Y+OXjhBKxi9LyJ0/Ga
A9qRp8RoXwgINDpj08N2c+7StMv+J1MGXnhN0PPPhbtZ9nqPebjoJMaYdv5M2J6n
8igUWAdQgDb+ebAvNoqJlc+x3YdWtkkhOwqaPqhn4U5St95toih5YYNQZiog+KWT
UhhhWWXHmSMm4fw2p7T3v1vlJlCDC312aP4C9o80kgC9RLAxzUBFJUxZxUkYGUPa
w6YkovYhaCUrPhJU0L8vOIGZw2kh/njfWUu8Pb+MPXth1QcxHDq00iva8f5wYCUX
luhKBqBeUDUyFlZpVohD
=yBVk
-----END PGP SIGNATURE-----

--WFYXJKyHTUiGqOmp--
