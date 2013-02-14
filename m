Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275Ab3BNOXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:23:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53992 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753973Ab3BNOXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:23:53 -0500
Date: Thu, 14 Feb 2013 14:23:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] regmap: mmio: add register clock support
Message-ID: <20130214142350.GN13249@opensource.wolfsonmicro.com>
References: <1360835354-31740-1-git-send-email-p.zabel@pengutronix.de>
 <20130214115621.GE13249@opensource.wolfsonmicro.com>
 <1360845523.22360.13.camel@pizza.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qi3SIpffvxS/TM8d"
Content-Disposition: inline
In-Reply-To: <1360845523.22360.13.camel@pizza.hi.pengutronix.de>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qi3SIpffvxS/TM8d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 01:38:43PM +0100, Philipp Zabel wrote:

> Are you ok with the way (devm_)regmap_mmio_init_clk are added?
> Maybe (devm_)regmap_mmio_init should be turned into inlines.

Yes, that's fine - please respin and submit.

--qi3SIpffvxS/TM8d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRHPKPAAoJELSic+t+oim9oBgP/jXs19+rqWMnG6Ek/B8R3ttq
569PwDaXdKYq8Gtm4yhm0AXOsCGVLXEQg1SrcTNNBPa9jsmHoiF1Wi+FPYRwmJC3
2PrpRXctL2k5rJLgzGQEiBMNTWKjsKVwwRsg/PUfrRtrLCjHvm7VNRj/2MnMw2wk
/XbRKSVOa0BdNkkkOSywivxkyn9lfEBY3yXx5p/FbrqRvl8KOqCnEakvkdOKLrxX
3hA7mBk0F1q+mxbl/zOJNVraXFJB7lU4njKJcjVUFiZGkJtB6UH1CAd8mobMQ0A+
4AV0OWxUeVosh/PbhWTwe3m638HPRcv6w0i+dm0UfnmxTq11tUh0i7F/eArX3hCz
vQGJMMmUvJ8wRGpXM22LNTYV4VFZZa2m+GNUJ+itw+TkCV1YudC6NJ/Peg0Xl/O+
yftZfkeH7JcS4keCWKPZIn+g4UOWvP2nHW+MATIR6c6qyURUsYHqiktP9PAPqlgr
ij84ObvyJYpdo5zMkBcL/fjok1PiADIXDbmx/Kr6Ih8PIstSVdsEYGroD6fLvk/6
veyHB+mX38kzulUznixpfUP3DfBpzwdaZYO8S5M0jKjA47vWWEZ6/YJ9ufp9WA6B
7rRpWf188LjZeYl16KuQmrkfR8lGTAutkUks8PUZ1OkNPTlaJBQaPjjAXyqBFY9G
ElAfIfBhgoUbzt9THzVv
=tsj0
-----END PGP SIGNATURE-----

--qi3SIpffvxS/TM8d--
