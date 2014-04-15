Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbaDOLTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:19:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33770 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDOLTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:19:15 -0400
Date: Tue, 15 Apr 2014 12:19:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harinik@xilinx.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        michals@xilinx.com
Message-ID: <20140415111903.GR12304@sirena.org.uk>
References: <1397560329-3603-1-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hw0FrjWlp+qkNlJP"
Content-Disposition: inline
In-Reply-To: <1397560329-3603-1-git-send-email-harinik@xilinx.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi: cadence: Add dependency on ARM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hw0FrjWlp+qkNlJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 04:42:09PM +0530, Harini Katakam wrote:
> Add dependency on ARM in Kconfig.
> This is to fix the build error related to _relaxed IO.
> Remove dependency on SPI_MASTER because this is already defined
> under if SPI_MASTER in Kconfig.

Applied, thanks.

--Hw0FrjWlp+qkNlJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTRWkAAoJELSic+t+oim9jf8P/jiVAxQb3dpKrKdsvUxym0Xo
jvEqpHekM7L/3OpGA8aWcF6XFiw2tVdbNSwkNsi1gd8lQ6kgzEqJOzBYyRUjR0qy
6TfW68stKaL/XG1LAzOdM+rsdnGFxfaEML/vRkOZMrD2hL52Sb/8pxXsbOL6sB5u
eg0YgdEfvB1PKeempPhNmzLw9wwGIDj1FfnjNr4q5XW+u5sQwxi+Gu+zYYGTaR0x
uYm32n/SH1z1y/T+RNsBjLYjlAoEovt5EP74jzPJJDjMT0/1m9Bd0a0wusp+diaM
PAVX0OJehExQRKRp+F45ma3bFTUOqS0y884Hfw17LoW7SPYL4oXBi5kR2hp+As10
DTiuOHqse5kjT1qPxRNRdijEyLFeRMGfXM0O7rcX2gfgf2HFV1gbkDunQb3lzw9f
2y/PDFHvp9vGHq72wqhSSQZ3SQxKJncMv7Kvuum0yD+DvAmXyRfK0MGiemiP3KLF
+FuDdUcJM3Fh4zk1SsCD3odTLl5WnpNkrCES/EOqJhiqfqXKt6vuZkQpLGc+0oAS
rSHkM51/2Pn8aXGSjKvhZwvYFsw72zcmr1av5X6xUSilpg4yr3SFOa/XOr4yzPJq
tg2cQobSttgkHki/x/JSIdGmBInNwbGdxeSzAoydLTTGpFipaGX3GgWGFw8Mze/O
6n2EYbV+gtY6a0ScUzTT
=iS40
-----END PGP SIGNATURE-----

--Hw0FrjWlp+qkNlJP--
