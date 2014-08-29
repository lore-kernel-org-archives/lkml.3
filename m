Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaH2VzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 17:55:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51203 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750889AbaH2VzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 17:55:04 -0400
Date: Fri, 29 Aug 2014 21:45:03 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-sunxi@googlegroups.org,
        Varka Bhadram <varkabhadram@gmail.com>, rtc-linux@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend v5 0/2] ARM: sunxi: RTC support for A31/A23
Message-ID: <20140829194503.GJ15297@lukather>
References: <1409025296-6342-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="te1vED83xZIPpfwV"
Content-Disposition: inline
In-Reply-To: <1409025296-6342-1-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--te1vED83xZIPpfwV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alessandro,

On Tue, Aug 26, 2014 at 11:54:54AM +0800, Chen-Yu Tsai wrote:
> Hi everyone,
>=20
> Resending the sun6i RTC series, rebased onto 3.17-rc1.
> The DT/defconfig patches have been queued for 3.18, and therefore
> dropped from this series. Hope we can get the driver parts in as
> well.
>=20
> The A31 has a new RTC block that is separate from the timer block.
> It has separate interrupts for each of the alarms, and a different
> format for the counter alarm. The driver has been tested on the
> A31 Hummingbird, and the A23 tablet I'm using to work on sun8i
> support.
>=20
> Patch 1 adds the driver for the RTC.
>=20
> Patch 2 is a minor cleanup. This makes rtc-sunxi depend on sun4i or
> sun7i, the 2 platforms the driver is actually used on.

I'm quite happy with these patches. Are you?

IIRC, you prefer that we merge these kind of patches by our tree, are
you still ok with that? I'd feel more comfortable having an Acked-by
=66rom you on this.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--te1vED83xZIPpfwV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUANg/AAoJEBx+YmzsjxAg8LUP/2L5kaijkU9LBUINwF1JDSTx
fQzNTY4oiQG74NrEgJF4QYH/TKbHzuJVy6nktAjfqLYK+Mn8urUHAJVK7+nnctXp
mpSuhmlREkVfAHPb0dXpUEyi0cXJxjW0j4/Lq2qTXR4U36WkFF5M4sVD7IFZxUUA
7udX9CUsJbPthU7niwVbk/jCLS6/fkF0wbMcBF67eEVqpmNTy0X9GFbbViU1wDZt
wsrdCwPCkMXBWN7m59TM4+o9wHD5bncbyzNl0jCqpo5porDJekWVGQcQ08q+RPKU
XeZrSEP8b9vlnjRf1m2OjBiIxFZkCCc/goyKq5Vce+7FfaH3fkSoubBR0UWrdZFO
pMCZ/JXtol9qxp6CwF7eML5pxkVGZ+OXmJB+HfXPDR9lFJb5m9fj9Szl3EV0gSF9
dzCypc3lN8uyX6cGqSSmIbFU9hE70wm6jB9xp7D2MhyyBxS3LjkU91qZOUf3egbv
W7ZZ/1FCsd1sCFZwL2+5C9niMLP0cvas2ktRQUYRS76IpJS0M36+ajPEr+l0JZdV
ev7S8ykenBoe45oFaz8WpA0strdVzzmfL3e9r/17zcxvnwDtAxUPj8VBwfZRCQ/B
PppwTFLmyXPTwqWCtraoghjesAQETCnP8QlpjXSLyM4oTJ8MmNPsuxHWtubrGkAE
CaZ9IcJGQjTrQZQOPiSJ
=DYAg
-----END PGP SIGNATURE-----

--te1vED83xZIPpfwV--
