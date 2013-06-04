Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab3FDQqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:46:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59689 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab3FDQqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:46:19 -0400
Date: Tue, 4 Jun 2013 17:45:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Guodong Xu <guodong.xu@linaro.org>
Cc: sameo@linux.intel.com, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@linaro.org
Message-ID: <20130604164555.GF31367@sirena.org.uk>
References: <1370356123-22357-1-git-send-email-guodong.xu@linaro.org>
 <1370356123-22357-4-git-send-email-guodong.xu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hk/xWDG3xnLTY+FR"
Content-Disposition: inline
In-Reply-To: <1370356123-22357-4-git-send-email-guodong.xu@linaro.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] ARM: dts: add dedicated dtsi for hi6421
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hk/xWDG3xnLTY+FR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 04, 2013 at 10:28:43PM +0800, Guodong Xu wrote:

> +	ldo1: ldo@21 {
> +		compatible = "hisilicon,hi6421-ldo";
> +		regulator-name = "LDO1";
> +		regulator-min-microvolt = <1700000>;
> +		regulator-max-microvolt = <2000000>;

This all looks very board specific.  There's no point in names like
"LDO1" really - the goal for names is to provide something which matches
the schematics to aid diagnostics.

--hk/xWDG3xnLTY+FR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRrhm/AAoJELSic+t+oim9PQwP/ju+s8N1JrK8wU4BK/WwIMQx
gKfGfYHqqGRVPrgijaeMQaGugjkkmXxhJPmXRm3sGrollx6hb6DVWrE3jdPiRs9n
W2CxKNbs8nug96u7aAqsv/AriLeDE0+FD+ElhOJfnH75wUTS9hyD680+hNVDKTiM
drj9REm0VJe+m6daMu2GA1e12sXrKw49+FGsHzoQWpUVkZdSJaiyxDy2F7IwuYaB
JoHdfTZG2nHNhhgnHzqVRyMwnZjM/UVvaXSrAeN/sRWyorN97mWBtzjwzd4Vlp8H
KWi7lwCFGBD5FF/rY4NxctCBggr5Dpnwqk8eIvzjQHKVcKycOjtbsMgkf2v1PRSx
yPmSbyPrtFqaXCE1PGT+bhfGJX0MHRTTF299Mxtu9oWFU1Tj5/0ML0dEoDHr3Njj
FVFuTpzPoFXHPlaIKmw/vbCUtIQbf3E6305KBgD7tG7qB4PACvm4xYjw6hSV5v2u
QP+dC5LfBi+ejyPNuS46m/Itx8n6OJuloCBvC+DU4RHDXy/T8VwUBMiXLNuvYN5x
q1Rplj9HqrXM+nSjSO532ybLmuzJpxMlL+E2ZQBVDvmWuOBh27dlpNKJTwxJzp4i
mOEQj15QrlI0FFAcn7Rz0wAYxEVx7PKlgR0QHt6Ogo/T9E2A7EuFqg0pdv6T9YZs
ZQYxEFRgqRHgmnIsQlQp
=sMpM
-----END PGP SIGNATURE-----

--hk/xWDG3xnLTY+FR--
