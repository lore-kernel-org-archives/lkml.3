Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946144Ab3BHNQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 08:16:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51078 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644Ab3BHNQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 08:16:02 -0500
Date: Fri, 8 Feb 2013 13:16:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, cxie4@marvell.com,
        ytang5@marvell.com
Subject: Re: [PATCH v3 10/10] spi/pxa2xx: add support for Lynxpoint SPI
 controllers
Message-ID: <20130208131559.GY8879@opensource.wolfsonmicro.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358850393-23111-11-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RLVVO53zhS75EYih"
Content-Disposition: inline
In-Reply-To: <1358850393-23111-11-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RLVVO53zhS75EYih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 12:26:33PM +0200, Mika Westerberg wrote:
> Intel Lynxpoint PCH Low Power Subsystem has two general purpose SPI
> controllers that are LPSS_SSP compatible. These controllers are enumerated
> from ACPI namespace with ACPI IDs INT33C0 and INT33C1.

Applied, thanks.

--RLVVO53zhS75EYih
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFPqIAAoJELSic+t+oim9yGwP/iD3Qi0Ip6yN7wpjkpt/NleV
BvM1kfz4K/QFPAXHMRjVKBYBbYCYY9JNmZg+S/gaTLBkbqvyNyVVta39kfSJy3ju
KTNqiO4QEbwx5h0NWf8c3h88xGWvnch52XszjGt4RBEv4yx7zewxq/H8h3qD0b6A
LotIr5bdZVZ28L19lS8OsrJ1GzH4mVNN+ur9GAQajlexTAAiBsUynaQ7XsKoLyyf
6Mdh4XpHsL8nFXcDVa/PuXTCgshfMumg9O1W/gd6GCH3E+P4eQkzyzr1n8Ok+PGq
9+A8iCtHU2d/zFRORjLU0FSNBY4vkGtBwiPLHGhkEQPP6AP/Cd8/TcI/qyVuYVAw
OJr6vHYUOeCXeOuiRqZEfbSPjE0R8a4Xaro1XlbQgupC4+T5ia0PjTzJJBJ1IZQ0
SL0B35qH3K2fuL8giVjf3WMMQf8w2wQuhgAVkIu5CO9p+uTg+wX1LrYMwl4VoCSD
IfqtjZx/bpFp+k6sibPNvCRdWnec1aSJ7cWmvYnvyIvJaWfSbq2OAsFfez/7FTe4
oi3Avfr8eEVKhoxRHrqDcZ+UhqYdgRpkSFhQkv18ptMeU4YkzibyxF5sbESOTPtB
KDeZW8yfDC1KqIBwLwGy0zYxLpbIuPkmQ3wFZuKTqns0EbmIJvtrYU8ajS6qw1BV
A3qznym+A6e6QcfJOI+W
=p7D8
-----END PGP SIGNATURE-----

--RLVVO53zhS75EYih--
