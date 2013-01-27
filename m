Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3A0CwC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 21:52:02 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49334 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755288Ab3A0CwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 21:52:01 -0500
Date: Sun, 27 Jan 2013 10:51:46 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/19] regmap: regmap: avoid spurious warning in
 regmap_read_debugfs
Message-ID: <20130127025143.GA4650@opensource.wolfsonmicro.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <20130126100326.GK30594@opensource.wolfsonmicro.com>
 <20130126100744.GD23505@n2100.arm.linux.org.uk>
 <201301261145.36158.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <201301261145.36158.arnd@arndb.de>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 26, 2013 at 11:45:35AM +0000, Arnd Bergmann wrote:

> Gcc warns about the case where regmap_read_debugfs tries to walk an
> empty map->debugfs_off_cache list, which would results in uninitialized
> variable getting returned, if we hadn't checked the same condition
> just before that.

Applied, thanks.

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBJYzAAoJELSic+t+oim9nGEP/RxUqp9OX8JqpwE9L3m9Aj9J
vqrD3tWW4AsUrY5cqyf3J+zCMyhg1bxugG0i9+yDeeKGawcBP4h2P1EXYpktFhLd
G7BWCfvN9oquqV9fq9ycJ4+ADXE1+BqvNT6Bo/9F3kN7QbBx7snVlvpDUXcecHxJ
QPJEcAXb+K7r0uiz34gNHwDeIz4k+vOSq+LzuXxIM0YlfEmnidrkXorT+RgMv6DD
q1cKtoYsl/fKmAaN35u2KDMpogcNZsE2qkG2xs9iwdTPMRlJ3KNHPAOGeZOlohnV
Bcm5snO4yG5AaYL186gJl37LGditxpYgHG9CB4YrrE0myhNOYnYC7g4t0xJVD6cL
Gs0kMfalM6R5ka0tn2jNae5jsMgCyhEBkmreqxya53MK2wdS1ZG9eX5tvjvEvnX5
qOEFglo4087DjfStDZq5OY1eu7KouPN04aF8Tytnc3Il01G2tQHoGxvQN+bHy0jN
OTmvlTXZgIpl03pWV1Z9V+lFSQB0d051FWXJMKOKmllIE2lcZSv3YYNmplgHnf33
fZfonm/yPrZtHd1ikYG3HnSoRHO4P6OkUHbussU/ji52kXg+9nIQCqyQyzxx4ea5
JrS4Ryz+1XRcXGv+exsXRbwzh9+M88rssQe9K9V9i6cHlpBa7LChBf36O4MIQ7s1
Qb2SLvaCaPvlfeUwDUuI
=g+yE
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
