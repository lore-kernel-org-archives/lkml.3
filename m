Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbaCRLP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:15:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48998 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaCRLP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:15:58 -0400
Date: Tue, 18 Mar 2014 11:15:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140318111542.GK11706@sirena.org.uk>
References: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1395139757-6907-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pXLKCnUjo+CxjWTT"
Content-Disposition: inline
In-Reply-To: <1395139757-6907-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/8] regulator: arizona-ldo1: Add processing of init_data
 from device tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pXLKCnUjo+CxjWTT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 10:49:13AM +0000, Charles Keepax wrote:

> +  - wlf,ldo1 : Initial data for the LDO1 regulator, as covered in
> +    Documentation/devicetree/bindings/regulator/regulator.txt

We don't normally prefix the names of the regulator data with a vendor.

> +	np_init = of_get_child_by_name(arizona->dev->of_node, "wlf,ldo1");

You're missing an of_node_put() for this and if you're going to use
hungarian notation please use a convention other people use.  Calling
things _node seems more common.

--pXLKCnUjo+CxjWTT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKCrbAAoJELSic+t+oim9v38P/AiAGDPAZrPMON3EkEkvcG7U
edq+Rzl/nB57PLiuYQNk8INZM7PK7iwJQTNrK4EmMo5aWyQfTAynwn3zzstQ2/hi
EfWu0rErhEYbQyY1J9BjGmV9gwN12EpMfHdSVWMlaZ7vrGtvWLVQqncyirw5Hzk8
nIXQRGpE3a2SHX5znh/+iSd/hIv+e3s5Gv5YSX6EL+vX7KFn09LzJ+Z4wPMrjwXF
gdeXCRrMTG4mWOVjh2AzSPIr/C2ItUu8pO8gFJTkGChJPbMV/+bE40zz/ECFFKO/
PiRuK6aCLU1ICu6AauvWPhr0bzhP7fNkmqSyvRJIN6zIw1q757u/kCfgf06EaPhz
9kJRGXomwtkOxp6PI3a0UY4qn/0R9M6h5TEV0u0jW5zpOye0ZBobdLQZX8qXqZb/
NiWWBmQZ//EmKUrOZ1eEtJzsZ6I11jmGtMVhgVwPBHOnqQNoEAjC6IrWFDyIRT0h
StuhnnIqt1QWgoguFQqz8giRNb1uhhehenV4AcHbvbTAACnZiGAV7AK0qu3qIMaE
wvajkbORIxgIWDTcfwAvQ5uoSVvBd3jSp6Cx2WLn65a4hh+5OW2AkAYQjyblHuWK
Qyd8J/HxSKdu5xlX7eXPxFsohX+vx9vTcI+X3/9IxXFXyQFp/xXaxaEogxx4EPGT
7Zs4Maa0H2KB58rXRVGf
=8LTD
-----END PGP SIGNATURE-----

--pXLKCnUjo+CxjWTT--
