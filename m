Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaFFKXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:23:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56802 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaFFKXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:23:36 -0400
Date: Fri, 6 Jun 2014 11:16:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Alban Bedel <alban.bedel@avionic-design.de>,
        Stefan Agner <stefan@agner.ch>, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140606101617.GJ2520@sirena.org.uk>
References: <1401885843.15873.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XK4NhNJ9GVfup2vH"
Content-Disposition: inline
In-Reply-To: <1401885843.15873.3.camel@phoenix>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.213
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFT][PATCH] regulator: tps6586x: Use
 regulator_list_voltage_linear for dvm/ldo4/sw2
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XK4NhNJ9GVfup2vH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 04, 2014 at 08:44:03PM +0800, Axel Lin wrote:
> The voltage tables for dvm/ldo4/sw2 are actually linear mapping.
> Thus convert dvm/ldo4/sw2 to use regulator_list_voltage_linear.

Applied, thanks.

--XK4NhNJ9GVfup2vH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTkZTuAAoJELSic+t+oim9tdEP+wUgsB0JwXZktfAE4uj71wfi
Al0M9dMZrEkDCnhjfBv0OgaMizbXZBPEszB018uB7rHQdJO25FhtVuoq78NedyTq
RGPOiFQeBj6L3QWC9P4kuPzsoTbIAkIygHlG9eZVuCddcXMvlAu+WHHzgt0VvYB1
kkYLFeXICZbM17xdXIwniJ2W7BnuW+nKt0U3nZKVJhScgKWKZBMaw3HoOIQF4QnU
wZuY62MhGPaNEr0qOXBAVzpi0NK8EJTLSg+hpYmm9gRlyhMMgUObQ3ixr9IjUUWW
aTjkSfJX7Qbt+WUh6ZBCsS227zqrdKn6FlIyMZ36mi2JzqJnTdxVOB8aHZ+9lZzK
3MnTfsg1ugIpsZlDE10rQtg4QT0zRlUnkLij2j5vyRJqawCPTWnbPyG6Dvlzubw3
dfdjBQuUrJ/IaKdwVuusBtEpHOTupk5XCNjrjP32EbAxA82Dv/riLneMuDf1a6Mj
Wf5buyVUWyr+MSG+hzP3GbGMdXDqpOj+oWnyTr3lLJp1K2OTXOCa2mt8JW+kCJtU
vJ4j6yLuJciYe/3jPsrhb36pRliXX2fPfhGCB8ZtOagksG+7XV3+pu8QiEAqR2ie
g+SM0tXk0WHVAxJ4BsWoZH65XWU9gBoMA+X2x4eMT2Vv6bgT2Gy3Wq/0Iu+ddbxc
iJ0A9so5NJ2Fv9SWgxK3
=Ow0O
-----END PGP SIGNATURE-----

--XK4NhNJ9GVfup2vH--
