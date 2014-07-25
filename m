Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934824AbaGYRYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:24:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54896 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934542AbaGYRYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:24:09 -0400
Date: Fri, 25 Jul 2014 18:23:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        James Ban <James.Ban.opensource@diasemi.com>,
        Support Opensource <support.opensource@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140725172348.GU17528@sirena.org.uk>
References: <1405855175.27371.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y52ms2kKCoiSthOi"
Content-Disposition: inline
In-Reply-To: <1405855175.27371.1.camel@phoenix>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: da9211: Remove unnecessary
 devm_regulator_unregister() calls
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y52ms2kKCoiSthOi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 20, 2014 at 07:19:35PM +0800, Axel Lin wrote:
> Current code uses devm_regulator_register(), so the resource management code
> will ensure that the resource is freed.

Applied, thanks.

--y52ms2kKCoiSthOi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT0pKhAAoJELSic+t+oim9oncP/3wGq+3qF9ZkZiSHaslBYPuc
ZJVo4Y9iXkC+xYeFLbFGmovf/JILZwMjY5wAVBLX9bV8QQgPWE2hcsuPx1iEdh/d
OKdg3sF0AxvWy1U7XQbDTeQ4VkJnQ2nfkyfWjRPriJO21PIN4WBkxseRbc7dq6cP
Zpus8cJCWJ4/CqMHfENJ0AsJ8uM4BKGXkAQevi5Y+fHoNSwzYFfdMJk3txZqvHTU
+43w7XldiKJsyFpFFt1B1perkVZTJHi0r0LOpg1jgtWX9TrzP8QdgpnN6adnynUD
Sb5ymZrhdaI/TgPRsjNQuneWEb1h14gCaRE55MIsph+4V7iM7B7UfUZlpK02mHvF
jWgllUL/QrYYcv4LAkR3u/9GoO+DdZt/o6GaWTkukfhQcIh2mZablx7Nml+x8/7r
1C9tpU109qdQaID+v7TSO7u7jW7fOJxRsTDN5lxRWsr9WxOm+ZilpHyyFjxMKben
/2Ki0aTtuDD409tXVmNVn+wk7uKcWEakjskwOUkHMac/OmB1dXCbxEsJX4Pk9Xpg
6Yj+WfarijkYXSmavropwQfapuYrAwea0/7NORuhW5ZKh8uky0p8yB2EZrVegGDz
T5i0bzRc3t/5Kv69mJiVwQ+qW+GAprXx0+aZau53iE3Ccc1oXgXW2MaIDy04mNCV
9JnSDtvZ4ZE7QVn44CEE
=aT7y
-----END PGP SIGNATURE-----

--y52ms2kKCoiSthOi--
