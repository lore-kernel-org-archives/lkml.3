Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3C1ASt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:18:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45097 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858Ab3C1ASs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:18:48 -0400
Date: Thu, 28 Mar 2013 00:18:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Subject: Re: [PATCH 37/46] regulator: ab8500-ext: Adapt regulator
 registration for newly changed API
Message-ID: <20130328001845.GQ18316@opensource.wolfsonmicro.com>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
 <1363881583-15234-38-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2WoxpW+VkX+PCh3O"
Content-Disposition: inline
In-Reply-To: <1363881583-15234-38-git-send-email-lee.jones@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2WoxpW+VkX+PCh3O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2013 at 03:59:34PM +0000, Lee Jones wrote:
> From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
>=20
> Instead of using a long list of arguments for registering a new
> regulator, the API has changed to accommodate a new structure
> which is to contain the necessary runtime configuration. This
> patch allows the external regulator to follow suit and continue
> to successfully register itself with the Regulator subsystem.

This really ought to be squashed in to the earlier commits which won't
compile without this fix...

--2WoxpW+VkX+PCh3O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRU4xeAAoJELSic+t+oim9sVsP/jfSNojTOki1svuaxCTBvesT
pPY44biD2LMPjrHPwGdak+d++08O8YzTFxYqvb915s8gmNa3+6f+dQ3r4JYHdrZ+
n463j4JcwZ4w5ILPIHZtOr7dfdHdJyWVK2OSTHe6euPX6Bpq5EKChjiEAavrS8kB
5/0yIQsQWRV0owo0QcCwvhu0iCRhCtbRIvXqtI7bhnYw05mozSUwjejXmpPQL760
Fo/NFZteiyDIknHTz4pOFPs/pY5m80PHxDxUj/kqAhQKHVLPM9mE6mZNQdfpt0tS
NCQkQIwK64C0MmTKGmutpgfLfpb0LyZRAqNVp/oGZO59GioG1TrQkLsfWs1/TCpx
CtmVWkFojfzCo7LGx6UwMxQIqLI7iyG3xO/KG0SMrEUE5YDENifPsaCQKXN5o72y
CC+SPGt5VhOaRH/EevyfgMvSDvOBcf82rDEbOBixhqcG5LDE0p6Vhk6Lem9NYAsz
S8Pu5D+UZlZP1QkKsiF/rLDWXgZ7NhALvnyMmatwp9q4UjxAV5LWNDB9ElbelzMA
xvESjR9iK7TnDU/G91Y5cIXZB3ns6OsvjLaAsEgh6UxxLavF0Zyindjfj+zhW5uw
kvBlNZvAm2hxW9Ro8BPrdd3QO+ZPq06JQa/ztDBt073qcbaJEK19IZMfDfff3g3H
2fJ4jhCqgb30hYGJI/po
=raY6
-----END PGP SIGNATURE-----

--2WoxpW+VkX+PCh3O--
