Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066Ab3AZFG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 00:06:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33619 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751Ab3AZFG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 00:06:28 -0500
Date: Sat, 26 Jan 2013 13:06:21 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dongjin Kim <tobetter@gmail.com>
Cc: yadi.brar01@gmail.com, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] ARM: dts: max77686: Add DTS file for max77686 PMIC
Message-ID: <20130126050618.GD10580@opensource.wolfsonmicro.com>
References: <1359053177-17725-1-git-send-email-tobetter@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LTeJQqWS0MN7I/qa"
Content-Disposition: inline
In-Reply-To: <1359053177-17725-1-git-send-email-tobetter@gmail.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 25, 2013 at 03:46:08AM +0900, Dongjin Kim wrote:

> ---
>  arch/arm/boot/dts/max77686.dtsi |  156 +++++++++++++++++++++++++++++++++++++++

Why is this in arch/arm?  This isn't an ARM-specific chip.

--LTeJQqWS0MN7I/qa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA2Q6AAoJELSic+t+oim9rEEP/iI4l5e2VOpYAw4MvA5DcIUj
Hb/Bsjr5misb7o4nqmFC0/60gJceuB59B9vw5yAO1dUrlpp9Y7VCUP06nGGA42pC
zDxiawG6EDPF5ShEnRsMhHd158IMWpaBQ2q2JONxXAG3MdLeXTAfvG8RYOGvBqK7
j282Uv3lTtGm/rzzfBCTDIBTF+SEh2UnYDeeqwRIBDa7IFT6zs7N6Z0fUiQcl/V0
GXmavHqyYHVLxOVFmtW7+owmWJ66yBWb87T90lX+oKml7rrnsS6/juxrxmnL0Glw
ZhOiyq5hRQxEtsyaIZKwUV3Fi0nBQwCAgBcuwaXYLitD0SW9lvEbEfGeWE82a65y
eIcF2mzNPOF+yrG/oLf6MqESo7bfU/EgE+TRJLRwCK6jxE1z8nOHNs+4nvKszFI9
XwFWM5Q7ToTHuDDRWJNB866yCGsC2CrijUTsUix3OiIxwp2eqXquGDpaKpz8gkDS
56xDWnugKWwi1ZSaLEdlN8idjG3mc1ow2w2SwujF7pK6M7wrv8I0mH9Hne8ExM87
YE99ho702rXUsYXzvIUr7umajmJw97GZdGeHrwcpqsb4z+eXelM/zJLEh0dJrl9K
5kv09Us8e+9gvg2iAhslymTxjtqj9mI+FLRtRc3Fhf0O761P7npQ0sXTIBoAsHTT
Q9OfWOKZPGS4Qu6ZF/q1
=4/V1
-----END PGP SIGNATURE-----

--LTeJQqWS0MN7I/qa--
