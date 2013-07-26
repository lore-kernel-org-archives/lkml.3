Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab3GZQgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:36:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60101 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab3GZQf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:35:58 -0400
Date: Fri, 26 Jul 2013 17:35:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, akpm@linux-foundation.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        gg@slimlogic.co.uk, kishon@ti.com, Stephen Warren <swarren@nvidia.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Message-ID: <20130726163528.GS9858@sirena.org.uk>
References: <1374755343-32573-1-git-send-email-ldewangan@nvidia.com>
 <51F2985F.60202@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwXA+KufQS8ol7Xv"
Content-Disposition: inline
In-Reply-To: <51F2985F.60202@wwwdotorg.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] drivers/rtc/rtc-palmas.c: support for backup battery
 charging
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OwXA+KufQS8ol7Xv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 09:40:15AM -0600, Stephen Warren wrote:

> Given there's only 1 battery, I think "back-" is redundant in the
> property names. Since that shortens the names a bit, I'd suggest
> spelling everything out in full, perhaps:

Isn't there an integrated charger on the PMIC?  If there is then it's
useful to identify which is being talked about (even if it should be
relatively obvious).

--OwXA+KufQS8ol7Xv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8qVNAAoJELSic+t+oim9OD0P/jwcu1Kn8OG4dhN4NX1S44xG
1s/yXTl4jVmPkKy7M1x+tkzoJk0m4Qkb40QIv5QlI89Ni2mu0sJUKo+ATF8Gb2NT
+O7dDe/Ho2V0BdwkbT7dc8N7EvQTdTTq0YscwsqIZjOmYJ5qzWKrurcbHIlQAVte
TwLFPHgIU/6TsapdD56eVckss9oeYaqWdmxa34bt8nM2tacvqjX3Z/ZfkTJrRr75
FyEzVokphF5BX60ZBsWNqJt39juyRogL+yxA41FJ1JZT83H4gWrJBqlCE3w+0ht8
rogD5q7Yoq9uRCDBeoxjxjXks6xUrwUkYI/JU6CYvjMh4Cn7FgclXciyxhS9Kl3K
1A94mIhpt0oaCFezy4CqHKKrTyAZQiX0EW0clINUrsPD5SdKWMVBCkl1GPFLOkB8
V1kZfXFZgvf79c+DYOfy+ENHvwPZ9rvmIHTO8SmrQqKtDNPI2dLYAh8GDZlgzr/E
mT3706XxLT5GPY++Y4cZ9avB//PDiLjp8Gmg0dNoUCpyEucTqINd+b8Pp62ElRHz
sdeEhXhz2ZqPGVlhm/Zxi1kfpmFayqoHvscj6ZrWR3NEphZpcAc2IVNrxfrE5TsA
vN2oc9s8y0eDFsknw2juECwoT8t5u2sdaflLO7K3G8NjmyxNSTT9MnCOKNj6JGof
morhUEPTCPPVnj1g7wA0
=naha
-----END PGP SIGNATURE-----

--OwXA+KufQS8ol7Xv--
