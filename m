Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161086Ab3DFUC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 16:02:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55394 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932570Ab3DFUC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 16:02:57 -0400
Date: Sat, 6 Apr 2013 21:02:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org
Subject: Re: PWM backlight build warning
Message-ID: <20130406200251.GO6597@opensource.wolfsonmicro.com>
References: <51606A7F.3050803@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5PFZVUeDPxlnBcQp"
Content-Disposition: inline
In-Reply-To: <51606A7F.3050803@prisktech.co.nz>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5PFZVUeDPxlnBcQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 07, 2013 at 06:33:35AM +1200, Tony Prisk wrote:

> The problem occurs because when CONFIG_PM=y but CONFIG_PM_SLEEP=n:

> I guess this would be a problem on every driver that has been
> converted to SIMPLE_DEV_PM_OPS.
> I don't know enough about the PM code to offer a fix, or whethermy
> chosen config is just 'invalid'.

You just need to put the system suspend functions inside an ifdef
CONFIG_PM_SLEEP instead of CONFIG_PM.

--5PFZVUeDPxlnBcQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRYH9kAAoJELSic+t+oim9NWAP/15Pp4lHC+lSVJOumOcY415+
ljKeYuTpQWmfldKUGHROPE8GJCSUIKYuAxRGKvPRR01sdKNm0/4cUoUaRUPJ80ft
kQLzsrZ4Na13a5AR/HEZZzeff/x5W3oAVSmKfsLnEC4wVW/NL25PHcmO3fqTtSS9
mfURqOakFk1wKu79bc/+w5CPIyM/9KkNdnDmcfQ1GjTwfDuWMiXrznqL8+s8azVu
GMhPJDVSGrWW8wEWBfZ4FY0x988fuq/hW5u8VRXmEOTJ6cb/g0Zf6R/pESbhCySf
MkCfkADY/FEc/R+KMvW85tDn06TRtj8yrBAfpbHBdtz5vyUZtWYDAexp6Fa00uA6
kRIuX10PxzLMo0uZw80Jsp+QgMXJQROnynj5lkvR/zsvcgBR6OLPoXKWktv4fCNt
3MqTZ/Uanhi2ydEqWD9ixR8m85hn0+1Vd+Z0T/PAUvA+KMBRf8JMhR//VySeGiLD
5euxlqW4zQT3l4DfhpJNu9ptmyepcpAlGSbMXccxyZtk1yKkP8369MqWL3D2WgkZ
7R4tfbDkjOcDO7vSzJDS5h7TbSz7E5URCxXRsVJ/rtt1Fwa4YcO1EZgf5bSaqGM3
qowP3GJ80v85AM8+PP70WPqTGVOfUYS/VhU3qXy0p9BNTETzBRa6PGWdO3K1zcWL
s3b2/D28Kd9TWwu/KqmU
=dIF8
-----END PGP SIGNATURE-----

--5PFZVUeDPxlnBcQp--
