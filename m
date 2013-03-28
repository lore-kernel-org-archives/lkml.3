Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3C1AWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:22:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50627 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab3C1AWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:22:16 -0400
Date: Thu, 28 Mar 2013 00:22:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 46/46] ARM: ux500: Regulators: Bring the AB8500 regulator
 platform data up-to-date
Message-ID: <20130328002209.GS18316@opensource.wolfsonmicro.com>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
 <1363881583-15234-47-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f33Ugzijq6DmDAdd"
Content-Disposition: inline
In-Reply-To: <1363881583-15234-47-git-send-email-lee.jones@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f33Ugzijq6DmDAdd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 21, 2013 at 03:59:43PM +0000, Lee Jones wrote:
> Quite a few changes in this patch, including: supply-name changes, new
> consumers, initialisation and capability updates and new regulators.

All the patches I just applied adding consumers and whatnot probably
ought to have been squashed down into this too...

--f33Ugzijq6DmDAdd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRU40pAAoJELSic+t+oim96vMP/R3qdpHy5o2rjCAyrqDVvd0l
trrtSfaTGOYSiuHtwCKeG0hhdGGe4UrMv6m82+Xdv9Vxe47Aezc5ryvqImtFXutR
6PzAuu0wPIS2gH4yIK2MaYQBO/y9ZrgJvt5bT7kma3d/TYSxJNO1EzptEQGd6RBD
daQHiH0oTRyLZsfcxkfB79ZgBlOUoGSSkM7Nre/uBcADp5NWq4QX/E47lcbUmsqu
ApEBgJuu229JDOtWFq9YKtmh+SzZkgJW81c1vfuEckrrxpIFzi2ZwPEStVkzRrB6
dALZlCxIEKs6F0WYJ9nO2sDSe6Pc7T2vbJrz+pj9QNqvvvj9AuANDNmH9k42mio+
Kt6efteZQFNiacghI1cwAuf67ehUy7JxEnDkK1z674Ot4bCaQ8Y8AEaHRcTNkrkQ
YetnIJTdalr525dbhjMIU2YUHdg+5ZzJsPIBEuRIxe7HvVOrz/++f5UDGIT7Jgbx
LiLGLxy33QdCzUTHUjIfj98JG6oY8B5FnlNWOMfm2sxbyXa1boYLXm7Eg128qgSQ
44x1BzErFXYzXSJvD0q8Il8dBIBpP505KpjyQLbJh6xkWdcP0hzx6C59NJxHHZR+
9krrjVjzXz/OmLF3TLuLvYF36ILg67Zqspw4FkfmqsKWxxB5+d7EVbGNK7pnrrCE
veAy6GyOFiC06M5ECrGt
=wj2Q
-----END PGP SIGNATURE-----

--f33Ugzijq6DmDAdd--
