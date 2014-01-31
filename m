Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbaAaQx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 11:53:56 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33438 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457AbaAaQxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 11:53:55 -0500
Date: Fri, 31 Jan 2014 16:53:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140131165350.GR22609@sirena.org.uk>
References: <1391089879-7342-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uWKIjLx9zRJNHvcs"
Content-Disposition: inline
In-Reply-To: <1391089879-7342-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: s2mps11: Fix NULL pointer of_node value when
 using platform data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uWKIjLx9zRJNHvcs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 30, 2014 at 02:51:19PM +0100, Krzysztof Kozlowski wrote:
> When platform_data is used for regulator (of_node of sec-core MFD device
> is NULL) the config.of_node for regulator is not initialized. This NULL
> value of config.of_node is later stored during regulator_register().
> Thus any call by regulator consumers to of_get_regulator() will fail on
> of_parse_phandle() returning NULL.

Applied, thanks.

--uWKIjLx9zRJNHvcs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS69UbAAoJELSic+t+oim9cXsP/3tKWcHDPpOqWzB4+y6QatBR
sklwK6llmuvz5bTgFgmp8eGxsBAbvimSO7MX61WFT/A9kr6Y4plTEYC1m92O2uAL
cXktOZm508QU9tY3v6ST6Va8DoFebuFPyZTXKz/swpDeHQbej+PHWwiUpYXUTNrU
izBQdrNxh0OKsuSecfxsi7WLKqp4KFHOv9ZP6RZcar3I6LZKRU/I7wMfRBnmzdLm
WLXXlHIxgZOahKzkgeP9q8xOdHCQXb1PUtshB4aYtEQH3QzvkskV8UnvVSCMPvLN
NBm3VpanNHofSuwA+LOFdDqbMaQo0NcBFPYnpbVzUiqKWYmdHcUVFXRs72Xe/eR7
O0WaLWXqRpAdNwAVm9DbMOw3V6OozuHVasAzWj6OJAJVS3fjhZcbQozx55gw5Zot
enVWcBqoVkJhthT8BN+c7fUMDnb1j5RB87MwWL8MdQpO5GaQM9LjdwxI6eBNP71y
0i9CUK1CpMP9y5wj88lmbs926zxRHjwUFIns4pRN6BZlHEI32CenU/mwzC7hvemz
uKetwy9ZngqeMwTVaZ3AJDPwhXoXKB3+Y+kYgW3UVei8IOeGAi+6GDbqnkJ4Wj1w
FY21851JVaMtpHO4SX3lzV3ynd1vmjAPyPC2wbWENqxJB+lC952nEuWfyEwGppk2
yZWYsLXG/gAKpYK4lgLW
=YH+n
-----END PGP SIGNATURE-----

--uWKIjLx9zRJNHvcs--
