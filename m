Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3AXMRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:17:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35772 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752824Ab3AXMRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:17:39 -0500
Date: Thu, 24 Jan 2013 20:17:30 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stijn Devriendt <highguy@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>, gregkh@linuxfoundation.org,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        daniel-gl@gmx.net, rmallon@gmail.com, sr@denx.de, wg@grandegger.com,
        mark.rutland@arm.com, nicolas.ferre@atmel.com
Subject: Re: [PATCH 6/6 v14] gpio: Add block gpio to several gpio drivers
Message-ID: <20130124121726.GQ4955@opensource.wolfsonmicro.com>
References: <1358856404-8975-1-git-send-email-stigge@antcom.de>
 <1358856404-8975-7-git-send-email-stigge@antcom.de>
 <CAOY=C6H5xETt5UNXUfRkGW9q+bj0y2R3sXNvW87XXvQcYoL_-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DCA/C9WSnDtl50zu"
Content-Disposition: inline
In-Reply-To: <CAOY=C6H5xETt5UNXUfRkGW9q+bj0y2R3sXNvW87XXvQcYoL_-g@mail.gmail.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DCA/C9WSnDtl50zu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 24, 2013 at 01:02:38PM +0100, Stijn Devriendt wrote:

> As a fictive example, consider the i2c-bitbang driver, which you could optimize
> by using block-gpio with sda/scl in a single block. By offering the
> block-gpio API
> even when you cannot set all bits at once, you could cause timing issues.
> You might be toggling the clock line before pushing out data, for example.

> The same holds below, for a driver that has separate hi/lo bits.

If there's a strict ordering requirement on updates then I would expect
a user to explictly code that in hardware otherwise there may be
hardware level issues with unpredictable results; besides in general it
seems silly to force users to open code both versions if they don't want
to rely on this API.

--DCA/C9WSnDtl50zu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRASZNAAoJELSic+t+oim9Q5MP/1R9vJk2LZNFHHoAC/dh14L2
Hy0TLb73kDDOjLjgYd8cod6ukHultUaeLH3JbMpqzGhMBL/qoSX1doPFoEqXhbnK
Eq9di+gqQA8naP23+hmp/MijV2ua0I4FwGI1LjwnTw5uCbOMkJ9br3gq4m2kSjbX
5nIWNpa6BumR99qoJHwzplKrRaEGxN1ZHat/+sf1va/06JdqKAo9cNPR8jfHnwcg
h8dIEJx6zm5Iql+sZhqlqc+Bnf5IP4LjI35j4QNskaFF9EJm6Q36IbFatRXfCpLG
CzdIzlT0FDr/1sHDY3IZF931ca9t9Gqk1X+S15e0xlBRJ59dZq6moSoQmFPZyI/9
RDqUm/ODRVNdPXVNEtx6VZD3Hz9s4SxNF1f681YLJWYFEv7SW4sXc27lLDwq5+wc
Je59kiNKnGW5zkhFBv5v63liDSmOKRJM6vTPNtTIQ3o/VhGDF+q479bRJ7jSzyE3
UKgQ47LeXeZmWttvG6SoLaV1t4QFQY0bXdNjRkwr4YrUWmBJa1XjFtOHttw67M8T
yWsFvdyD3AU8IgMZz32kcg6Q4gYZk/zU3JB3aKvi3LGG71Y1oj7Jf6+uL5MlI/JH
PNnNAAahd7q0VDN7C1H6Cl+FOr2of9mkGtcMwTE0vnNHF5/ln3NZ9tUn1uHt4D0S
DMACQpb6nNQBpdnp85Qk
=AbYf
-----END PGP SIGNATURE-----

--DCA/C9WSnDtl50zu--
