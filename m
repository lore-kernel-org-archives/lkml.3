Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaDRPL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:11:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37957 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaDRPLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:11:20 -0400
Date: Fri, 18 Apr 2014 16:10:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Message-ID: <20140418151056.GY12304@sirena.org.uk>
References: <1397727612-32103-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397727612-32103-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1WxZ6PHs3mn95J2/"
Content-Disposition: inline
In-Reply-To: <1397727612-32103-3-git-send-email-boris.brezillon@free-electrons.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] regmap: i2c: fallback to SMBus if the adapter
 does not support standard I2C
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1WxZ6PHs3mn95J2/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 17, 2014 at 11:40:12AM +0200, Boris BREZILLON wrote:

> +const struct regmap_bus *regmap_get_i2c_bus(struct i2c_client *i2c,
> +					    const struct regmap_config *config)

Non-exported functions should be static.  Otherwise this looks good
modulo the register size issue that Guenter identified.

--1WxZ6PHs3mn95J2/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUUB9AAoJELSic+t+oim9P6gP/A4uwLz9Uwf0yITlhJFo+SSc
pFCCGXK77wngKu0EGEVX6GC9kjlDXRCeEaJW8irJj2KrGrdY6nmI56LrY9Et5jrA
VmBzgEEgNltC3KPqg0tXHaI6bN1PSFkKjIbjgCoQzMcl+pah2ykglltpgoGMN3dK
GeIhNee8tBIpJNHuy5TLyBDcGUeQpjBM7t2wcKtwsnnNEPjow8Tug7fmw+BlBfm1
WrUS5tNI/2dabf9G7ne9wIH59cHgVR/fUD7ZbTAl/T+UOk54cpYi8hrVxxXKnPFj
c2DK9LYVtqJ9dmPB1yxiopKx0l+niKpKfiAuAAiW5Ti2dDK03bp0NSQP9bNy/WBb
ShocghUNknu5DfLSQNyWKA4DX1mvQHpJB6h+CMkJgPUHnADlwTdxdhibDggHDOeM
2faA8vXaR1222RaAvVs/4YBiubkkKnCfxLiXpE3PeqqvlB/HT4cTYjQZLd3ji8+M
C/ATuADvBxo47q1UVFXKdBo5UpPz9N0cr+ZlFcVJyLbX/34j5yODoQFxk3y1mn6/
c7VsWtIDKDkV0cwbZEDpcJQFU6PkDNkHZLsDDzPY13gUrmzSvAY3JU7YUcmjtxqo
otbTAqMX8h5aJlnUpJvIuaci2WIopDlPVvzltTbpNzkwu4g3ZFtlf8tQs+rBGKYB
yAJ6cU4Y6D7ak4qXSTjY
=fDhY
-----END PGP SIGNATURE-----

--1WxZ6PHs3mn95J2/--
