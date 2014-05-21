Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaEUQAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:00:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40883 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751658AbaEUQAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:00:03 -0400
Date: Wed, 21 May 2014 17:55:51 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        andriy.shevchenko@intel.com
Subject: Re: [PATCH v8 0/2] Add support for the Allwinner A31 DMA Controller
Message-ID: <20140521155551.GV27329@lukather>
References: <1400685357-508-1-git-send-email-maxime.ripard@free-electrons.com>
 <4828893.NoTbcUXQEt@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HC0F8i/BfMshQzR8"
Content-Disposition: inline
In-Reply-To: <4828893.NoTbcUXQEt@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HC0F8i/BfMshQzR8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2014 at 05:23:41PM +0200, Arnd Bergmann wrote:
> On Wednesday 21 May 2014 17:15:54 Maxime Ripard wrote:
> > Changes from v7:
> >   - select DMA_OF, since we're only relying on DT
> >=20
>=20
> I missed the discussion about this issue, but it seems wrong to me.
> DMA_OF is currently enabled if we have both DMAENGINE and OF turned on.
>=20
> If OF is disabled but DMA_OF gets selected by DMA_SUN6I, what happens?

Is that even possible with a multiplatform-based platform?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--HC0F8i/BfMshQzR8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTfMyHAAoJEBx+YmzsjxAgfyUP/2FloSzl3Zgx/aYaeCzv+sZi
ATUF/eM5PSJ2+g0apwRBJEuiqyjDeGkIYL2+rm+sBQJOmhVMqYb7VZJ15wZPzVXc
gLEjhvpjWNdT4dnjzZ6D7iQ4B1Dz9gJHDHLhFWfv9FgFBcTnN7ohjUOAxxfbszYP
E6yLDQb3SnHm9CEF+2hoUvPNiE+/GVl1mbb1LZR9bo2o1vAXu/QBqGwusmB+YS6T
336Nm4hU8RwKj1Zr4MdHuwNyVfZIoEI3V1xj1KYcLswJHwNyFmYCmCiyJKokojYx
XVEZvMIyuRZAf2/TF9oGuTWOXYrxvuVIFgCd1mspGw8DJXiPdQtJ02XusUWuXVQy
R0UzpmT/Ma7IeksGO0FMGer3fqH8Gb4FVT9LM7kJQvLcsXIj095HUf5X57Xp0098
jL0JCtEfLUKBz+0jjNYz5ESytWaf/Ai1M4HIH6JMFbM6U/ljjg0WTaTrZHXwjpge
meW7tnp/YP1fA5zeLzzKyjtu7Ko2Oqj9s6tigCQHnZEDI45P1HaGluc3I2tz7inG
m4kHXz5HQXUO3eXJEAPAShfrNQlfBSHaajTtSEywpS1oR5Q7+eDr+BE9G+BW1HIt
lApdVdULkNeM68y6J2oqGhv6bKmfvFf9m1uPNTV2j49RLPnAxS0Qm6u3yjU/55UR
9FPVAZ2MKqgzXqTxTkmg
=aEi4
-----END PGP SIGNATURE-----

--HC0F8i/BfMshQzR8--
