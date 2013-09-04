Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762869Ab3IDPNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:13:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50036 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762704Ab3IDPNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:13:01 -0400
Date: Wed, 4 Sep 2013 16:12:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org,
        ldewangan@nvidia.com, gg@slimlogic.co.uk, yong.shen@linaro.org,
        s.hauer@pengutronix.de, marek.vasut@gmail.com,
        Nancy.Chen@freescale.com
Message-ID: <20130904151241.GB10849@sirena.org.uk>
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
 <1378276263-10735-7-git-send-email-sachin.kamat@linaro.org>
 <5227355C.1020205@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <5227355C.1020205@ti.com>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/7] regulator: ti-abb: Use devm_regulator_register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2013 at 08:27:56AM -0500, Nishanth Menon wrote:
> On 09/04/2013 01:31 AM, Sachin Kamat wrote:

> >  	abb = devm_kzalloc(dev, sizeof(struct ti_abb), GFP_KERNEL);
> > -	if (!abb) {
> > -		dev_err(dev, "%s: Unable to allocate ABB struct\n", __func__);
> > -		ret = -ENOMEM;
> > -		goto err;
> > -	}
> > +	if (!abb)
> > +		return -ENOMEM;

> here.

kzalloc() complains loudly when it fails, there's been a general thing
for removing the per-device logs as redundant.

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJ03mAAoJELSic+t+oim9c9oP/i1fcv1vkpX+Kec1uStQWcjq
FY5V3XJlOcj+3vs+LtkeefxMa2q1AdWcU2oNb2hfr5sJMvvBi6hv+chus50gByWM
DsdxU1FWSJlK1URBAp8ahgfkMPsDEA17EsF/WHgC6AkR/e02qWJZrdpCqWNemqBB
xI6WIvdO2h7giXpmKTfbpgt/O8f+UPY1Er9CzJ1SVNkjO3BPcxvLvUBhKt8yEpd8
7Kos7w64b18tdSpJ9bkXXanIJqJ8f1y+IlHV6JUFWkI1h6GK0YXjaOK7LY26iFEj
JdImtEvxhIbl8yuiXeOBciHSFm0SPiQqVPfJTl5SXepc7vnZmYxfBNOP9inojE/+
jTfkDI8q1aw4omwQS3L7tefIW+XjbPMLY4wwtrdqqzerclngcSkGdrkeFrgIlBPN
VF8fM84si9So9PE8IjQAE23qehrS0AuM4t4c00aXcSfMwL+zzXMHzR64qrRuLK1C
zWYXweCXrHHUu7akFD6mURm0Mehx9A+1RBDffJ3v8xVKdWl4w/7MvRI8B7ggrZna
YHW4rOH8bMAityd5gbUr8wj7vVDDaXrABwpcPH44FZIeaYXsTOc0dFgG8wPK8VZU
tmx1MKiHS/LW++GuCLjywXVmHMUW0GpvAscjzODRvVdj+th0uIVjPkYMBbJ5T5nP
5IIPwXKfDOay4bEKP9N0
=mD8D
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
