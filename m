Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab3JDOeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:34:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42613 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3JDOet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:34:49 -0400
Date: Fri, 4 Oct 2013 15:34:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131004143440.GO27287@sirena.org.uk>
References: <20131004010230.GI27287@sirena.org.uk>
 <524E50DB.3060707@roeck-us.net>
 <CAOesGMhc5WYRFcBVSHShg6h8hn4HueGZtGCFKkzfX4SQEe_5LQ@mail.gmail.com>
 <524EC658.90706@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eUJndGal4TJgqj0h"
Content-Disposition: inline
In-Reply-To: <524EC658.90706@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: Tree for Oct 3
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eUJndGal4TJgqj0h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 04, 2013 at 06:44:56AM -0700, Guenter Roeck wrote:

> Great summaries. Do you have a single builder, or several builders and
> collect the results ? Either case, any chance sharing the buildbot scripts ?

There's a repo at:

  git://git.linaro.org/people/khilman/build-scripts.git

(Olof and Kevin have been collaborating on them).

--eUJndGal4TJgqj0h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTtH9AAoJELSic+t+oim9a18P/RhcKmbkhbzQ0ie8oh4wkh/H
XJM9DA8+VGkukp+kpWJkAUcgvINw20uztHxHWF6Xvz7NqyZFN0rnsSyatC16vhDk
IxsS480kIHS81uUfA44nNoM1w1loc1c1n+RrP8K60vX7KzAyC+NBOvlA7/d6cRV1
ad7R7xqwZcEKARLKKMVMXCW7di3cx2sDDNRWHBB6uSVrv2BgMLogqzcxjCaoFTLK
OYe1yE3328JaIJcAEMaZZiQcUGO6J4dllAoplnEqAuzSrEXQRZmYcEgvWKltM3h6
TiU+jGVczk7oZZ7pUh8llJoJwW2KP9ZdPGe6Yvd9x6VJ6yCqHDnK8sMQxzA6Y3lJ
rAEZvvlXenx2dkKdMM8CGVG8X7Ic7+yjVZsMWht7rIV/4iuG2x49HUV1zBJB5VOi
/LKfT7PGlgzaaw6VqLa81bSm/9Uj64i/rEtjZg3B2nZj8mtT3ZDau1D4GxL9ftIc
4ulMe5TgJyJV8La7YnKaQ6IY8Wvf8aB2mvzMJgTaramnA20TmmeTINGu1MWPbDr7
R9OJPCn8piz5dm93rBAuRaodaxePOqKDfnkcFsaCLXNXqcrKKfuKGUOKNrSuI2c/
lBWrTlfGgom6T7u/al2ofrC0lzBXWs8yMr3fFmkdJk0MGVRhCkZqtVr9dWj4o1rR
rGWONTXQQHtoPNqVii8n
=mffX
-----END PGP SIGNATURE-----

--eUJndGal4TJgqj0h--
