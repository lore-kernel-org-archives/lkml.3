Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaFCKGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:06:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51656 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFCKGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:06:10 -0400
Date: Tue, 3 Jun 2014 11:05:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Tim Kryger <tim.kryger@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@linaro.org>,
        Tim Kryger <tim.kryger@linaro.org>
Message-ID: <20140603100545.GT31751@sirena.org.uk>
References: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
 <CAD7vxxKT+Wq2ArH9iYLm2OUeBSqKvzORKZ1NnoyPcdcDH6wOKw@mail.gmail.com>
 <20140602125055.GE31751@sirena.org.uk>
 <CAD7vxxKgauFdEavebiZ3u7pXhjJu9QqwW0nMuLbEr7+JJWssfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e4Ac2VUIqaLF2Uxx"
Content-Disposition: inline
In-Reply-To: <CAD7vxxKgauFdEavebiZ3u7pXhjJu9QqwW0nMuLbEr7+JJWssfA@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regulator: bcm590xx: remove unnecessary OOM messages
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e4Ac2VUIqaLF2Uxx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 11:41:01PM -0700, Tim Kryger wrote:

> The real question is whether this change improves the driver.  To me,
> it seems like a draw.

It's not really for the benefit of the driver, it's for the benefit of
the kernel as a whole - the individually hand crafted error messages all
take up space in the kernel so if we just remove them and rely on the
OOM messages being loud we will in aggregate save some not completely
trivial amount of space in the kernel image.  Not a *massive* amount but
somewhat helpful.

--e4Ac2VUIqaLF2Uxx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjZ32AAoJELSic+t+oim9OXsQAIUWgTTw6iTM/LDmGf65SNQJ
t5Bl/Kb31OUgGdGR5j/usCMWzzXNXrtMeR1AjXReO7epOUR2K71MqOBJUxHIdasd
uNBSKOewqZWZK+169O54vNos6RwrLbWOY4GsWsXrp2hW7N0VbD8LiTFNYGZce0uW
LuA6rU0gmLWX4MG6BjX9lQhH/b1WFvZzc1L9C6EUFaN6JIO0+g+qLNvK/ZGIrm69
QdZnj/qlPGWSXTTfK2usSlR5omz0y8o7+Oi7UlHNR51B84rexqY9tTiKte2D8+SW
nkDHCPAQQyiOXUYkjXitX2BfVmpRqeSMoDsuADEvCfWPoM/HKzJtJNv58RqlUnPQ
uP4bDiXFcGkpSgcpjVN5pUKiX8WO3rgF1vJxTt6F7nVRo0RPdkgc2jJXPfneZIg2
crwpshfMcLFbrPCr5TnrFnSUR1PlHk+qczCIFEY9NfiFt3SqUuEBbJ8n66BYVD27
7PQZPUyoKzEzwjcqgUOCr9wVOgjymmTMO5keQwxYll3VgVeo/z8AHD1MD97Iebc/
DCt1cxcIoYwLZl87Op25JVyk7rRXOc7WrZVWIEfwo0eMmxSILgO3dPpAbT/zNEhI
bSYBwnMItkbZ2SKJiko6T0VImZKOQAPqmplyqgEtqclVb07A9t4f7gdNsXXXiw4n
hqrr+Z1DchwIS3G+zFN3
=SYyX
-----END PGP SIGNATURE-----

--e4Ac2VUIqaLF2Uxx--
