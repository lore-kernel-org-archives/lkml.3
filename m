Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaBRCCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:02:00 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58406 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbaBRCB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:01:59 -0500
Date: Tue, 18 Feb 2014 11:01:46 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140218020146.GD2669@sirena.org.uk>
References: <1392627817-26957-1-git-send-email-sachin.kamat@linaro.org>
 <1392627817-26957-5-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KzTpGdFWKkiGyjCs"
Content-Disposition: inline
In-Reply-To: <1392627817-26957-5-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.99.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/9] regulator: max77693: Add missing of_node_put
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KzTpGdFWKkiGyjCs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 17, 2014 at 02:33:33PM +0530, Sachin Kamat wrote:
> Add of_node_put to decrement the ref count.

Applied, thanks.

--KzTpGdFWKkiGyjCs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAr8HAAoJELSic+t+oim9N5wP/2iDS6LDWkpzQvpAseI+Jkzc
TRSq19qSJAgo2qOnWRA+JbJGA8tr9b0rb+oTMkvuMOJ/PNNgcjcPy1tOxi1g/jAF
s3kuOhM5sSvK/dkM9bhsp68QRdPbOeT6pKxntynhm5n7qprPYSkIJsD8vk8Vb9UW
gG1EEPsSZnUFu9PEZFCQgpccjbXr4ueHiFB0W+jyXxtyYYSmORF8hQ9f9LWllxwD
nOBIY0Rgh17AeVqfoQ1HcTrDmu/FEJoBWXMECN1uxJSxwaaZVKsl2598tdTE+nA9
1bbDaqmFb6JJW/8ecVXgo/zQV/UEJHSpGG5vMEaqdmews0NXjQjo2g6FW627CHqx
iojjqb0ntcfHjvMI2/v5Oc0hHf4Pqc9DOcMDJkiI7hjzWMgmItqOF2ASIIvKIWNP
NPM6pL+6OZBEHSzBPm9cY0QUIiCrmN4AlXO97wzcCE4BFlaJ424XDrAuJEHGouM4
UDR5Kt8EEOQ2pxEtpYfaA7fS8FEjuzMFeM0qJaWbWW4CvCSrTbzEaZL3Y3FWsW+K
pNbpiRuZBVQHzRRW7l0zvmw30V6r7D9joKm6EXLxA6bz2eePyHH6HMdqWQIc5J5A
j2XrjYir5QgXWNkpABVfKx44KWZd6vQvicu6zkXP74qHvVqKzkd8OE7228DFQ4IQ
GWOeHfjXyfAJYNpKQl3/
=rOwQ
-----END PGP SIGNATURE-----

--KzTpGdFWKkiGyjCs--
