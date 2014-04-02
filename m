Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbaDBTul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:50:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50462 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669AbaDBTug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:50:36 -0400
Date: Wed, 2 Apr 2014 20:50:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140402195023.GL14763@sirena.org.uk>
References: <1396433349-31470-1-git-send-email-Li.Xiubo@freescale.com>
 <1396433349-31470-4-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8SdtHY/0P4yzaavF"
Content-Disposition: inline
In-Reply-To: <1396433349-31470-4-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 3/3] regmap: add DT endianness binding support.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8SdtHY/0P4yzaavF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 02, 2014 at 06:09:09PM +0800, Xiubo Li wrote:

> +	ret = of_regmap_get_endian(dev, bus, config, "reg_endian", &reg_endian);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	ret = of_regmap_get_endian(dev, bus, config, "val_endian", &val_endian);
> +	if (ret)
> +		return ERR_PTR(ret);

Actually, if we're going to be doing this for all devices then we
probably need to namespace the properties too.  Not sure what to do for
a prefix though.  One for the DT folks.

--8SdtHY/0P4yzaavF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPGn8AAoJELSic+t+oim9HIEP/0iAkrdBpw7BNOfrEvJNztgG
ZVjT9USb1BItvIwS8GZla64Awx5GCQxUTI2RKlENYnPo8RfscA8nTfYj7lllc0p/
AHUtJPKL06+KIHItS9ffQMh6X7vATt8q1l+QV4s5dXnqCnBv4wJgoZ3/h3kfpTSh
OgrTPkWQs7emc5KdXYgJdzjcFU36ZHUgXwTf+pH9B3X1I+gi77KUPW8QIuIueMhK
7dhzolIlIrVry9ZboBq361cxQpbZ456NCqcDPV3SHtvRUb8YxTEFxOFtsTwDrfRr
/wXOkx3sw5shoojxcQQwWlZn6n36/w0LyDWu5u/ZI4ZOIqedcJGeGWDuCPsrgQDa
RTo4ATyf8AY3MYXIow868BCiUb3OgBy/l4NjZMrhZk8Kz+ykNRCpFSAx7qHgWIFY
X9oYxsbthOZH86tnH/45rmL/nHCNX+D9fZhi6dcbXTd1qX1JNKd4oIgjFU29VOkJ
L82oAHyPvML3SuQPzZkRg8Yg94TmiMYR2djeXyZsBJxqVGaL22NoxQhtCKdFW9Bt
kzfBYZsnXQXd8IyCEkH1SdAUtILskY5VZOdOdJn0QNpP156AwalILTV9sMbuS2gs
Vna7osxCe1wEdw+1leyt7WK+sRbpYKEqHIpoH8n+jiOqjFe++z+pfu7o8FiXE6jy
G5uR5DoFlQ3p4q9tOwUJ
=4ciz
-----END PGP SIGNATURE-----

--8SdtHY/0P4yzaavF--
