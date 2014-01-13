Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaAMKoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:44:14 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58138 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaAMKoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:44:11 -0500
Message-ID: <52D3C36E.9020107@ti.com>
Date: Mon, 13 Jan 2014 12:43:58 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
CC: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v5] video: add OpenCores VGA/LCD framebuffer driver
References: <1389384793-4710-1-git-send-email-stefan.kristiansson@saunalahti.fi> <52D3A1FC.4090706@ti.com> <20140113102006.GA30877@chokladfabriken.org>
In-Reply-To: <20140113102006.GA30877@chokladfabriken.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="Wsgi5nm9x1gNP24MS1CohjIkjMEIr3JWb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Wsgi5nm9x1gNP24MS1CohjIkjMEIr3JWb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-01-13 12:20, Stefan Kristiansson wrote:

> The VGA/LCD in the subject comes from the name of the core,
> the core itself presents a "vga-type" interface, but it can basically
> be hooked up to any type of display (with a bit of glue-logic in some c=
ases).
>=20
> That said - the reason why I went for the mode_options solution in the
> first place, is that when I initially wrote this driver
> (>2 years ago, time flies...) the display-timing device-tree bindings w=
eren't
> invented yet, so it seemed like the most viable option without coming u=
p
> with custom device-tree bindings.
>=20
> It's completely possible that this design choice should be revised now,=

> and I wouldn't mind converting this driver to make use of the display-t=
iming
> dt properties if you think that's a good idea?

I don't have a strong opinion on this. It looks to me that even if the
current driver is merged, it would be easy to add device tree
display-timing later, and still keep full backward compatibility.

Then again, you already have DT support in the driver, and if it's clear
that the DT based videomode selection is better, then I'd just go
straight to that one without intermediate steps.

 Tomi



--Wsgi5nm9x1gNP24MS1CohjIkjMEIr3JWb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS08NuAAoJEPo9qoy8lh71EEoP/jlCe+90pKMnPjsid76D5zrA
iwBOOxn3PpqOZymH66CHMQxBCL7Qfu2IsPGiAb03A29bvfLtJWJGmpvN1Dz6FdAh
4y+cMpGgRI3pHNV3+okqAzgzhZw9zrCkmtSl9fH7oaYKDW4tqzmC641QgLZ8RQoQ
B3O615hVZw8iAodEjmWJQYM2lVjN7lbl+OKLnZtC2HP/aLZ4i8LSiaLnygUUPYP/
mRlKg7ljjXjkHzBlsbem3SEs/CJgw9RFX3xtwc9l8DEMhEuenWGbzTAIH57a8yyq
626FLSkuxJK6kIIYSZXnWYOS15CSMwGlYzoOe5Td+fddUkStWIrh3/GXgGYSnbHm
40hQIqLYFcFYF3VUIo9Mza+3B6Ip1baIo870thOOJkgQ9YJBSwKKXKtb02LOi5M2
1oyqaJmbhk21ZmlvWNNTZ6Z4i9/UNPqRiInJ6y8OhbsrHjGTShBo6O2lLhsUFtZV
vcDSmSeIxF5cNlTibJqnIw5+JEP7FkUB7c12/nODSQCgqjqL7igsRmXz3vq2wOsr
ZvZaOVAZpKkeF+U3cpW3MEPwnsaTurV+CpxHIKdCMUam0t3i1tqpgtkqlbXtGmzh
o+m9Xr/upQ0zq/jPtJh+7gOCA0YGIzlZjI/Hc8Do2MgE/8lDN9F8XTS7P4u1aaXS
9apZPIFF19aC8GrSn7K2
=XVjb
-----END PGP SIGNATURE-----

--Wsgi5nm9x1gNP24MS1CohjIkjMEIr3JWb--
