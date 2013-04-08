Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935895Ab3DHMkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:40:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42154 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935297Ab3DHMkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:40:39 -0400
Date: Mon, 8 Apr 2013 13:40:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Enric Balletbo Serra <eballetbo@gmail.com>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        ezequiel.garcia@free-electrons.com
Subject: Re: [PATCH] spi: spi-omap2-mcspi.c: Add dts for slave device
 configuration.
Message-ID: <20130408124036.GI9243@opensource.wolfsonmicro.com>
References: <1364252415-3613-1-git-send-email-matthias.bgg@gmail.com>
 <CABuKBeKN+cPbsf95mTvDfzAwzOh4V-+bycp=sujNndDeMG2HMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JsihDCElWRmQcbOr"
Content-Disposition: inline
In-Reply-To: <CABuKBeKN+cPbsf95mTvDfzAwzOh4V-+bycp=sujNndDeMG2HMw@mail.gmail.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JsihDCElWRmQcbOr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 08, 2013 at 02:18:00PM +0200, Matthias Brugger wrote:
> 2013/3/26 Matthias Brugger <matthias.bgg@gmail.com>

> > TI omap2 mcspi allows the slave devices to configure the behavior of
> > the SPI master. This patch adds device tree support to the existing
> > options.

> Any comments on this patch?

Don't send contentless pings, and it appears to have only been a couple
of weeks since it was first posted...

--JsihDCElWRmQcbOr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRYrq7AAoJELSic+t+oim9NgcP/3wlpLfRu4KSKTkBpnnQIrjQ
sowdpbuJwcaZxQoWmg+G8BtwqCr0sZhUZDJt1+Ef0G99cV3d5GnXLsPWSIs5Zg06
GmeeRQW+QZye6K38VUJWYlQCt7+F3JAy4wDJVaFg8CChh4tYiYN+1tvXU5TaO48M
W8RQP14pnXbAdLYmqzwIPYVEOUAP3V2i8k5pNrI6NZh9kH57P53RvgzRP1LNt/iF
qj9B1MDE3+XoHu6RqkULPhucUuMQU/o60wJkn8lbeHQklP/AJMjdg2+knElGPsVN
fd/MHLnMmVtbiGL+nFUIBQZvlbUrGky8QeTZbT1qF2RKJ45yijEAehWSfdD2triu
q4oXygZZRt7X58c7qoy34bEDq2H3dzqElDFqtftKPT1Jcp2S/zy/f9UnE9p2bcRI
bsHhbg7x8m8pXM5+bEUEcxv0luFvfPa+jyVcqK07T3M9Iv6HpUyIYymi7vQIb7Pl
ZAObq5AgX5aBcKYgjSXtlsxbwNL5/0pXVX7N+2vbTniWtWFTcAbVn7vu4eDhmQc3
OFnyruUPvuqH4iX9KqY+O4o9d5DkQLMsKqCvU/FDWv8ZTcxAWdj6Y4PiCWAsfYgx
ibLOEqDcXsCcz8aJER8TV41V3r76nWT+pp6ru8283iI7kBksD1arxHsj3QisNbM2
OTLt5Kq+UVoyIpVkgKHt
=0wm6
-----END PGP SIGNATURE-----

--JsihDCElWRmQcbOr--
