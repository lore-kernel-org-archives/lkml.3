Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaCGKhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:37:40 -0500
Received: from sauhun.de ([89.238.76.85]:41603 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176AbaCGKhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:37:38 -0500
Date: Fri, 7 Mar 2014 11:37:30 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-kernel@vger.kernel.org, zhuzhenhua@allwinnertech.com,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 1/5] i2c: mv64xxx: Add reset deassert call
Message-ID: <20140307103730.GA12274@katana>
References: <1393950521-4173-1-git-send-email-maxime.ripard@free-electrons.com>
 <1393950521-4173-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140307095222.GG21483@n2100.arm.linux.org.uk>
 <20140307100751.GN607@lukather>
 <20140307103433.GH21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20140307103433.GH21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Since RESET_CONTROLLER is not required for those platforms, it really
> should be optional - and I think the real fix is for the reset controller
> support to provide stub functions.

I agree; and I assumed it already does. Will resend a patch posted
earlier [1] to fix the issue. And still debugging why my build-tests
didn't get it :(

[1] https://lkml.org/lkml/2013/8/9/442


--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTGaFqAAoJEBQN5MwUoCm2aiIQALNJ3UVkUhX6WpZdiVuGk4lk
jW68GiRe++yFRidhVjRKvchJ/0D/8IPE7ZNIsEOeBkJDq4/AxWEGlZOL0bUn5Ou2
n3TP6tMn1RJi14mayKtaSk33Kqr6gMr+7PUcB6x8pEYoTs0WucnYWPgSCNehX+Hn
ducnOKa1m9iQ+d4KIkWF22pTfkPrJzZXfP7jc3XZcQ0xF+s9QIM+V1y1JJKN1mC8
erCcwBpb8H0SX6nN7tTLlFyYG8cnFLiHR/92Jfz+y5h23E73sDzLzmZwmg/yQXCj
s6BfBrWB4/xgv/4A6FLGlUKm05CmZnNguFzC2iW4NiqoJsL02VAr0MP8pgqaoFPa
xq2uUpw1fSVorjPR4X6rXOpbmOwHWjSUhfJP0bzYQeFJwKWM+dYGLIDY0l29G6Cc
1EXYi+U9Wf/hD4YQWczq/gKsjc2V79F3B0b/+XR22XhogzEkOvP4JUyunhswrbdg
TJbDWkUwxX0rIhdT5PAg8eKjrsAROX+LGV4PA6m9sL//xZJrb1FarlYR91n/2ST4
4FTU6MfZxQH+B8X4yEYMybNLXSUWC1fhKIFC7KocEhfoBY8m0dC4VXSM4z7nkbgf
GwsJQki5bleYP8tksIj9ETFrxXdFJZ5UBOD0u+bB91M5TiPOcmgXdEIn/S2IQJAg
NhXsyCRz0fhiG5twDYz9
=VYea
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
