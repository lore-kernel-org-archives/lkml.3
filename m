Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaBMT2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:28:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42974 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaBMT2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:28:42 -0500
Date: Thu, 13 Feb 2014 19:28:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140213192835.GD28112@sirena.org.uk>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
 <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4TjORqrrURmsgxxJ"
Content-Disposition: inline
In-Reply-To: <1392282847-25444-12-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 11/14] regulator: s2mps11: Add opmode for S2MPS14
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4TjORqrrURmsgxxJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 13, 2014 at 10:14:04AM +0100, Krzysztof Kozlowski wrote:
> S2MPS11/S2MPS14 regulators support different modes of operation:
>  - Always off;
>  - On/Off controlled by pin/GPIO (PWREN/LDOEN/EMMCEN);
>  - Always on;
> This is very similar to S5M8767 regulator driver which also supports
> opmodes (although S5M8767 have also low-power mode).

What is the difference between always off/on and the normal enable
control?  This sounds like a fairly standard register control that can
be overridden by a GPIO.  The usual way of specifying that is by keying
off the presence of the GPIO.

--4TjORqrrURmsgxxJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/RzfAAoJELSic+t+oim9RU4P/i+tRT5wNiwRIQa3+RWeDix0
EiPWDXivGDWBjbx0oeGVKY3e0XZ/+evFtH8L5aG43sPMJ6xGF8Lxvk33Zhr1dmFw
H8TzH2Eq6Pwc5iIHXN60aC6ukgLva4Phuz6YiATbUBZaH1UXF3Uv/EuT2ciD0xNq
kSFCZwKuca6P+OhZO13IzdGkAk1A7SyYcPKrGArP4J0vnysMHYQFVRoOEII1Qxwv
l9gY3xkXgEp6zwSqybkHlArRGn2Z3w+b/8KewGg6ovP8RG5izcESWX3YmWL3mdvE
pk7S+j2svd6iYEwKuoeHx51wr+f+W1FBgYW4tpXavwudHYdygkij8UbyBlpo4zx/
l7gQ9R62IEeGOIxJaOJyWQI6ShEXUbJdTuB8MpU47JRA2KlFFiJq4BUoYwGXlC4O
Q2QwAdqy9053D0RmoVfiTwHGZ7BP1qkzq4gTIc/oESrrMTdCHzNlwuEM/q7UnG4n
EJbMFYJzVQTDcBqEjk7bpBV0Xj+xc35V14mCtAwhXSjW693AuLoZ91vs7o+E6ihU
Abp3UrR0kSYKmXnF+1ST3TXnEL/FfOTH9LuQcPKnkGS+uqMaOgx6E/L0jnhXjkM+
JdZrnZLGk2c0Xhp+1MJEotDUnEbRt3pACze5gKtw1Rn2+Ej0nS0mQ4/+EyOc4QLv
piBCoelZnyaAvCPNeC53
=x/Px
-----END PGP SIGNATURE-----

--4TjORqrrURmsgxxJ--
