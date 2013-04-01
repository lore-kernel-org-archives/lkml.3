Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab3DANlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:41:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49460 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757595Ab3DANlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:41:50 -0400
Date: Mon, 1 Apr 2013 14:41:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        richard.genoud@gmail.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 03/14] spi/spi-atmel: add physical base address
Message-ID: <20130401134147.GV18636@opensource.wolfsonmicro.com>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
 <1363679016-3761-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CJCg3p2l15m1juT/"
Content-Disposition: inline
In-Reply-To: <1363679016-3761-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CJCg3p2l15m1juT/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2013 at 03:43:36PM +0800, Wenyou Yang wrote:

> +++ b/drivers/spi/spi-atmel.c
> @@ -196,6 +196,7 @@ struct atmel_spi_caps {
>  struct atmel_spi {
>  	spinlock_t		lock;
> =20
> +	resource_size_t		phybase;
>  	void __iomem		*regs;
>  	int			irq;
>  	struct clk		*clk;

This looks like the wrong type?

--CJCg3p2l15m1juT/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWY6VAAoJELSic+t+oim9FhMP/AhJdtG8KaHzrNGMw/ll8WKb
9CK1fA8Amr7w2Rl/b/TlrFjrcj9X6AAenQhv+foppMNBY2XhGYClipwkjRE3ZpsT
qwL8Ydy47yzwWVzsGxqURkldIZYmY4M0dGC7sURUhMYPWWzmUE4SwfMVz18iI/PO
fOdrVR134XAevH3wX+IIe5GuyJzeY3MSs24B96Webl/UDHkrHPYMTb+T/pr3IPHV
w7ciaN8aYNuXLI2zjG4C4k2ITl88vucjtQRMRcDOg05GCjz8Luyg+D7JRTk1RQsY
/y0D0Xdzng8GzzAEtN+jyluZMxDXXl6cUiCK6uevV9q54cmXj3ELMkXC0+5+O4tx
3yRH3kLn4fENN9b2wlkXz7bs8YxhgmW/Wmqcjxq4de2ltLu2hMxCWpqTE6KQ52kA
AuT6r/eWOaDMNOwwxhocIqNjNvMg44qe8UlgPqVWKzLqZsKUdi2krkbAafwcjn40
+Pb1rZgz49KLccpdJdDVfv62F/1smscUgnAXIjo1lwz9KqDjYrSUbKqmjYVG+v7w
w4qAgz5zdTmx72QG4JqVFArbjeMmLD3miCK7ynHF+tykWnCy3Mk2i+f5myTQR1f3
PvEDOXb7FqGHRZk0aEIgCvQokqAtDMlPKfhYN/WtLH8FNr5HFibeus0yUmJBfdOU
k9wa2WUUPNV0yH1RNHEb
=aigl
-----END PGP SIGNATURE-----

--CJCg3p2l15m1juT/--
