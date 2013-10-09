Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258Ab3JILAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:00:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41761 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219Ab3JILAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:00:04 -0400
Date: Wed, 9 Oct 2013 11:59:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131009105950.GI21581@sirena.org.uk>
References: <1381264542-29396-1-git-send-email-wsa@the-dreams.de>
 <1381264542-29396-6-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gfpq6yKqvKwri7QU"
Content-Disposition: inline
In-Reply-To: <1381264542-29396-6-git-send-email-wsa@the-dreams.de>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/9] spi: spi-au1550: replace platform_driver_probe to
 support deferred probing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gfpq6yKqvKwri7QU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 08, 2013 at 10:35:37PM +0200, Wolfram Sang wrote:
> Subsystems like pinctrl and gpio rightfully make use of deferred probing at
> core level. Now, deferred drivers won't be retried if they don't have a .probe
> function specified in the driver struct. Fix this driver to have that, so the
> devices it supports won't get lost in a deferred probe.

Applied 5-9, thanks - if there's patches 1-4 you'll need to resend them.

--gfpq6yKqvKwri7QU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVTcjAAoJELSic+t+oim9xeQQAISdlk5LAlK3K/yZT53nyUpx
WhGF1p42vNNrEWHx3oDBwK2taGy1K6i9XV6SyJ2+LMhMfNFrziIR9mXAbsBA2z3O
FqzakokYsGG40qgR6+eG/9IqxponAjyshULcU4Tn8k4YI82fBw8Mo+tzBOSSIafq
f1Q4apeLglIQiqquGr9jYoknRIM9zdEeoEkym9gZ45WRPeNfhcfsPc8Eh+ml+e6r
eE4jkUmwBOE8UVp/QZEqZWAg7IxYgbGkTXVuaHiBHFRZx0kafDcMWvmInFchCkMc
UP7qOlLPPpvjwoCEIBENb1/1i9hQn+AugzYxeBjbHI1OOlbG4/vqPXDb0aZ4JoWU
zFuGEHrcp4RWP7EPuEHV3zJRpKj1f7HUDrlOsx13SdzsFv+KiNZyvyKl3G0mXzjb
VN1FLLOEnVLEFmxEFDb6sbsQLORoMbgxS02yzVRxznmNIzu5OeXF77ba04PifbVp
wl+ip0A26YqcW/xdMvWieYvQObfvoK1Ia9/zKHyT+fKAS9qgT9vZ7zBrKxWJwby1
5o5n3K7AQo4qUPXSgGSZxk6g1PD10uHW/sxbF+z64rz47yW/WB0e7aZ2qS1aLj0X
mGSk+AyPKofTD96qicz40q5FlxiOxfg0W+BpvtiPXC+eTU8r8yKx4Zl7yggpucdR
i88lXUGQDmEiaXT3ArF+
=YT7h
-----END PGP SIGNATURE-----

--gfpq6yKqvKwri7QU--
