Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126AbaCURsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:48:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45027 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbaCURsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:48:22 -0400
Date: Fri, 21 Mar 2014 17:48:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140321174814.GE552@sirena.org.uk>
References: <1395384848.32206.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zaRBsRFn0XYhEU69"
Content-Disposition: inline
In-Reply-To: <1395384848.32206.1.camel@phoenix>
X-Cookie: Contents may settle during shipment.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFT] regulator: s5m8767: Convert to use
 regulator_[enable|disable|is_enabled]_regmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zaRBsRFn0XYhEU69
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 21, 2014 at 02:54:08PM +0800, Axel Lin wrote:
> Since commit ca5d1b3524b4d
> "regulator: helpers: Modify helpers enabling multi-bit control",
> we can set enable_val setting for device that use multiple bits for control.

Applied, thanks.

--zaRBsRFn0XYhEU69
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTLHtbAAoJELSic+t+oim9C1MP/10gfb4+nVAlJxkKFO5kerLC
t9hXHvDGv+Oz65H2sEcVkY3ZHRhJRLgSEScMoWqU7PRvaCu45kp24iWMsHccSf8e
C9F/O5NYGdW2/ReJzqpENmO1SHgX5ZfkH3TufcCPaZNvM2bdLirSokxurY4E+9Ev
Tc3mJl82xSL7GNCEOD/6wPl3Ueua+V3YL6+i9u9QedRVOaLE9erxeJ+hiKCcXafK
MaHo7yWtyMxOj0DQf5bkFQ/SGTI63UuvA6LelFxLA7Nj06hW764tZTSmXObMMTX6
NqhB6sMXqJCD7SRG/BKnlMh/U4OZvmJIunqE4gZrFqln6LATiRMKa2kt8m3gclya
/uwMFdu7aEyoIt9WI5WR/W2nxhLlwBcsSL5HiMtls/7XXC9bjmPG0MXv/OcXNzgC
wVDBe/k55MtDwoJUD2UZhymlWxWHNOISIQY6iZf19buKlAPvkKtgvRZwIi3sEbf5
jKIAuU+EX2G/bp6C6kFFE9h3OaISGip19R/JtMxMx1qKb8W392GSfZ6SKC33ghaQ
Ew2ajiS6h7tTYs8J/D62YqCKZx89vfa7bL/ZHH36T+AJ3PS8LRqVg9wVdvlYXUqo
EX4uOCqxTwYoPiktAcXOjEYL1xJW/jaf/PDoTA/DwVGMkVh39vbLZ/QVrkJ8kxKN
6OaMU0eQDZxU4EF8UzwG
=ZQTv
-----END PGP SIGNATURE-----

--zaRBsRFn0XYhEU69--
