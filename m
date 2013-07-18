Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab3GRJxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:53:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33571 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383Ab3GRJxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:53:54 -0400
Date: Thu, 18 Jul 2013 10:53:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20130718095337.GD22506@sirena.org.uk>
References: <1374132753-15206-1-git-send-email-b.brezillon@overkiz.com>
 <1374133720-27362-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z2IdzX9mnvzeYuwT"
Content-Disposition: inline
In-Reply-To: <1374133720-27362-1-git-send-email-b.brezillon@overkiz.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 5/5] ASoC: atmel-ssc: remove clk_disable_unprepare
 call from critical section
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z2IdzX9mnvzeYuwT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 18, 2013 at 09:48:40AM +0200, Boris BREZILLON wrote:
> clk_prepare/unprepare (and indirectly clk_prepare_enable/disable_unprepare)
> may sleep and thus cannot be called in critical section.

I'm missing patches 1-4?

--Z2IdzX9mnvzeYuwT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR57seAAoJELSic+t+oim9aLgP+gO7MrB/96YV/rjr2xH+/DW/
KaEKbn8wU1nm/ASlki1u4OE8KxW4yfGKAnU4UUbkUnsbPtZ3YuB1Os0Uwj7mAQUR
On1hwrbHmpeTvEtSwEdzVCgoBWaGbgVjyh9BOsFm6/meEK0cgbI4r1RC1bgX1UJN
uxLngjQIyM2/0K7jzLwojJcoNyfsgjRwf8lmdG8Kk/LSR1zQK2G/yN0K7Cb5DNZ8
cKDJRO7txZzd8yczDPzyQqgs/d0E2CSqfVkwcOWAxsagn4CE04lI9KWn3zFSBZkn
pmtyIPVNIrgSOFXDCZJZdgPHFHfVbmucml7/KEgzMTFXg7zwRK2Zr7tUF9yMUR1y
KoEsXmnQlasuDq/bTlcf86KzPeRu4rHX8jyBl2dIw1RWtn2RcBTHNiydRkYJoHfS
/RZ6yFO78KvwZIBQQkv77fAG7369hJ3I7446+i4yYTlvspclC0clpBGu22UMbLiP
QsnHZGMisF5nv6ZklzatsplWY+5ThGV3h2FAmT2xB9SDHGn5pzd6Qs6SrEMeLzGw
KSo6dEbCX0+at3G53GysXqMwagGQVaFvW8zZwWMOLjC+2yMGfFJOE6Hy/w9/Pypo
xw1qiqiLRsRjBGXG2DXsSXMGBq59+fzA18VocmKYXCq9u9Y7/YaujcUQtucwo+gH
hCy9HH13Wd1wzi/0Wugm
=0VxO
-----END PGP SIGNATURE-----

--Z2IdzX9mnvzeYuwT--
