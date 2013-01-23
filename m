Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab3AWP0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:26:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41325 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146Ab3AWP0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:26:02 -0500
Date: Wed, 23 Jan 2013 23:24:18 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V5] drivers/pinctrl: grab default handles from device core
Message-ID: <20130123152410.GA4565@opensource.wolfsonmicro.com>
References: <1358877374-1279-1-git-send-email-swarren@wwwdotorg.org>
 <CACRpkdZTwvdmRnDOAcOObj7NhkuUunACpYBvAE1bY65suroQiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <CACRpkdZTwvdmRnDOAcOObj7NhkuUunACpYBvAE1bY65suroQiA@mail.gmail.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 23, 2013 at 09:50:36AM +0100, Linus Walleij wrote:

> Greg/Mark: are you still confident with your ACK/Reviewed-by
> tags being added on this version?

Yup, this looks great.

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAABJAAoJELSic+t+oim9t5gP/0RqvcSOhV8eP7vhOiPJHStq
5FLt9UkXziL+5epSAucgjkDdZrbg5spuV+6Utps8AX4wCYxvtDf8gbJRJmj9vMkD
fATXVN/p3Ez+wgpahc4js6M/erbik7f2kCDEHDlS3b637tTqiiQ+c9b8sO+DVYM0
Ymq/dHI8EYjEoD/YGfBXw7+/mWH7zuF8L4nmvtHfQsE8B6tLgH0FqmCsdd7v7KAk
2HfTFgI2GnlbQrh0agy0IIuyfwspnu+DNuUSKIPz0GcVrszw7i+yk/a5TC9rqXRj
ktgN41f2Q/qx/VnDzE6kFhYBQM4Jw4ROlRJy/51wu8/7+Q0Fk6UkxTpf1qzQ50lD
LFSnvcAeIyCrJO9U6Rn7iyJ0oA9AfCw6Rovljw9jRVKltQyOTLI9QA5ixEKWEcdv
lSa8FI65L90r9tPMLM+5YcykzXZjpTXWYTiHr02Md3ZS96u5nCGo3yvr5R3F0UGC
2Ti2exo/Ao6EMDMYJ+sVVgLhdi1EcKbbTRN4h9rUFy/ryBm6hAyDpHq9qXa64yEK
Ih1++ZeF928FTobwCl0uu805H4EgLkkMs6RZExG/ptn03+i3sU7OL3WRmsQ651D+
A5lD9R+sBoLRb3W+QU8R1UPOBevNxpKTcPmnBu/DdFN7DdsvBRGdFg+f7ja84/on
S4roiPFIH803LrdCGuGw
=GfyF
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
