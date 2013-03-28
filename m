Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3C1AKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:10:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41820 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754712Ab3C1AKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:10:37 -0400
Date: Thu, 28 Mar 2013 00:10:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 17/46] ARM: ux500: regulators: List the MMIO camera as a
 consumer of VAUX1
Message-ID: <20130328001035.GL18316@opensource.wolfsonmicro.com>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
 <1363881583-15234-18-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zP9Rf6JUDsnd43wB"
Content-Disposition: inline
In-Reply-To: <1363881583-15234-18-git-send-email-lee.jones@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zP9Rf6JUDsnd43wB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 21, 2013 at 03:59:14PM +0000, Lee Jones wrote:
> The MMIO camera uses the VAUX1 as it's voltage supply.

Applied, thanks.

--zP9Rf6JUDsnd43wB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRU4p1AAoJELSic+t+oim9s/0P/j0duliPlGpEXDeCU0z7eCpk
WU6DvI3+IAh9T/27wFAIoxwNA9/rbUXMkGOiTUJ0lS05LlqY/YRwwp5rZj5l53Sl
x/dfO3q8NIgtnh3IqrfR1BuDJfKfw2utv86MqwyrX1+p1jX236CvVd9fXcn0gLMG
BNCw9ZrlSE2rKgpXH0LO2Mb2SG+hh8VVx0q4v25ixrsVcUl1/owlSTmXGz2gibNP
CmGDQeZ8iu5R+wrHgWNLLH+/uqx2LazB4Jqqfrupk619p6NAN5bhSzWfjn5HT1e/
+tpKnPW7FKyg7vtJxx6jMZ51Gc3pfZZ66u5CjA8JV3RZ1SrDxO9AojPRpFGhvhTC
V2cqrs5pJRxFlYN65qBirrQjSzrO3WddZee2m9eZ3uXwfNZ20DN/ofdGIf40d6dQ
YTrSn47XCyu1bCiZwL7ilayBVkZ7b3XWm8SAPwpGoWgcEgZ2jjOUswI6w0/zuLQJ
BxPN9h+pYwOx30eSK7tq4+p9BArZUfr5SRrcGtEyW7TwkcK7htm20G0MAqlMumwo
kPCEz2PCVCD/3lEntbU+tzhH+avale2NyAvrIWdt2H2c0jYQkSTIfPHhoPoLpsJW
j/VVK3FN/ilmUZiA/TbIw+oHdjkEhUxCPVV5knVskO2PF9Z1+uaIfBp5L0Fsol6b
wrbrmQGvlRs9GkYTpNts
=V4i4
-----END PGP SIGNATURE-----

--zP9Rf6JUDsnd43wB--
