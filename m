Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3LRLGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:06:44 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59653 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab3LRLGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:06:41 -0500
Date: Wed, 18 Dec 2013 11:06:31 +0000
From: Mark Brown <broonie@kernel.org>
To: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "vpalatin@chromium.org" <vpalatin@chromium.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Message-ID: <20131218110631.GD28455@sirena.org.uk>
References: <1387258597-21866-1-git-send-email-wenyou.yang@atmel.com>
 <1387258597-21866-2-git-send-email-wenyou.yang@atmel.com>
 <20131217130653.GA3185@sirena.org.uk>
 <B256D81BAE5131468A838E5D7A24364172F18381@penmbx01>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9hzSyicXuByfNYJd"
Content-Disposition: inline
In-Reply-To: <B256D81BAE5131468A838E5D7A24364172F18381@penmbx01>
X-Cookie: Haste makes waste.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3 v2] regulator: act8865: add PMIC act8865 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9hzSyicXuByfNYJd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 18, 2013 at 03:11:12AM +0000, Yang, Wenyou wrote:

> > This is the wrong type for a voltage table but it looks like it
> > shouldn't be a voltage table at all - this looks like it should be
> > mapped as linear ranges.

> Change it, using unsigned int.

> It is not linear, can't be mapped as linear range. so using voltage table.

No, linear ranges with a plural - look at regulator_map_voltage_linear_range.

--9hzSyicXuByfNYJd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsYG0AAoJELSic+t+oim9VWUP/iMcMCHe4G6e7P/vth4syRMT
Y0UteAes4W9+QxKBg9qasjD6c8ENWuuynXUG+WcOjkE5hmRW6unY9CsZxgPSk7Vh
aWHIeVTdjkQ+BtqmgyKD/9y3PAPPW/FRkh5eKxSFn5Yj/qgi5Z2E/bIRAEiJ1OtO
PuZxqsmXOgGO/FqWG9Z2yC059goU/ieH0N/aTsCzgCrFM3KQKhwOqvq1IYlIusbe
GcL/IrW8Hly01scYaClNIw0cSb7xaLMEuul0Q4QXmX+8wW6LG0qCjPI5hCSkWgl3
KaFP6Z+ol3gU7xYljKBQYtGwlBneP+ir8tIw/o4+bENWRNToUoO6ZYp8xJfuAS98
uRKhYSA2Rud4CQRRfOx47g1+scUw7vlJdCmDwRU/EDvNsBBZXyjTPDRig0chZMBw
MyBQC1fiOpVOQsmZ5bgcxl3SgacXsHU4Q7+is4uVFmpLLoK544/7caEXB7gVy19g
nimkd3JyshmRQu9xiii+Q3QqSbM5yFcbaqvOskqPmmHWgtzYY7erm2iL4v1EdpS/
pf2ro0Gljs7O98PZjy3AGhshf3L2VGYndCOL4lzJb1uRt42PrAjCLu+t16VbzBS3
SEN4efeTuxc5TQ5FTxPpKPIJTCRlnKm93uJT//+3LW2jth51LITeylZSCC42L+ET
yCkrkStaXRHOhYZ/TVwG
=735m
-----END PGP SIGNATURE-----

--9hzSyicXuByfNYJd--
