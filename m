Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946267Ab3BHLNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:13:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57183 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946228Ab3BHLNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:13:19 -0500
Date: Fri, 8 Feb 2013 11:13:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/49] ARM: ux500: regulator: Use device IDs instead of
 device names
Message-ID: <20130208111316.GG8879@opensource.wolfsonmicro.com>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
 <1360148051-7560-29-git-send-email-lee.jones@linaro.org>
 <CACRpkdZyjmW5q8LWeqU658N4ftfkGyQeDJZgEe+jGCMy7n4Yqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UKNXkkdQCYZ6W5l3"
Content-Disposition: inline
In-Reply-To: <CACRpkdZyjmW5q8LWeqU658N4ftfkGyQeDJZgEe+jGCMy7n4Yqg@mail.gmail.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UKNXkkdQCYZ6W5l3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 07, 2013 at 04:43:54PM +0100, Linus Walleij wrote:
> On Wed, Feb 6, 2013 at 11:53 AM, Lee Jones <lee.jones@linaro.org> wrote:

> > -       REGULATOR_SUPPLY("vdd", "sensor1p.0"),
> > +       REGULATOR_SUPPLY("vdd", "2-0068"),

> Didn't you just add that supply with the funny name in that other
> patch I complained about.... Please merge them into one patch.

See also the patches I squashed down yesterday - it'd really help if
these bugfixes could just get squashed into the original patches when
there's no complex interdependencies in the way.

--UKNXkkdQCYZ6W5l3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFN3FAAoJELSic+t+oim9K2IP/1IaJGDYWFqVpiYC/hCR+1uK
WVfrSoJ7FkzWJqFydVOv3YmsHYj77qTikQ1a80CD87hZLZT9YEznqlGVS0tTG2x8
Z3SafRhSIrgz6mqkGFHFZg9Bgnq7dpSYsYAsr/58G+BTZyRz9UnXUgNtG6BhQqcz
R5Fv9BfUrupZNFj5Ql1tgi5fjLyEFveKzDF87m0MCXW5R+Z0JKBSoy8xBc6R0znX
o6n4bC1tdrorBrjZhLe788EoxqDODUgAmXwZYnL1lIex0WPpNU9Z5FT89NndSYVh
SvOKbbiNTNMBTdIPux1X+71MJ/wPCJwHZMf6GyLrhx9TZQBtJCa7/jHsie1npuIt
5b2QnyYMe1p6dxupwjY8YvpfhxZHGsVyew1U1XB+PgZOCFslEronvlGnhg1otVVj
2icOaDW6ygb9ZCcTZN/4ZT/cwQGJluriON+NLJljGGKK1sgjMhfXelLs99S2u4eu
B86nQK3zPdU92vPEW8y58IN4btYNONSjuLcgsnXGUewZ5BAVrCGxw2r/KBl/x8nW
O0B2Ts0nf+4RJ+xjx0y87HMa8Q2b8lv7HWWZ+k0TiJ4VO3Wvf9kPKLRtg8qtB4M+
j6Cjudha+Y00XoJTvFGlr6k8yWHQ+V9ESldUXT51glBAiXnNuN4mMPWLI5JI5h53
czvvya9zSgu9M7SukDzv
=RBDs
-----END PGP SIGNATURE-----

--UKNXkkdQCYZ6W5l3--
