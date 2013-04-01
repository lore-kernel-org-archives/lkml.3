Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab3DAMWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:22:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52418 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145Ab3DAMWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:22:38 -0400
Date: Mon, 1 Apr 2013 13:22:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Michel JAOUEN <michel.jaouen@stericsson.com>
Subject: Re: [PATCH 15/33] regulator: ab8500-ext: Add support for AB9540
 regulators
Message-ID: <20130401122236.GD18636@opensource.wolfsonmicro.com>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
 <1364487093-19551-16-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JwB53PgKC5A7+0Ej"
Content-Disposition: inline
In-Reply-To: <1364487093-19551-16-git-send-email-lee.jones@linaro.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JwB53PgKC5A7+0Ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 28, 2013 at 04:11:15PM +0000, Lee Jones wrote:

> +static struct regulator_ops ab9540_ext_regulator_ops = {
> +	.enable			= ab8500_ext_regulator_enable,
> +	.disable		= ab8500_ext_regulator_disable,
> +	.is_enabled		= ab8500_ext_regulator_is_enabled,
> +	.set_mode		= ab8500_ext_regulator_set_mode,
> +	.get_mode		= ab8500_ext_regulator_get_mode,
> +	.get_voltage		= ab8500_ext_fixed_get_voltage,
> +	.list_voltage		= ab8500_ext_list_voltage,
> +};
> +

> +		if (is_ab9540(ab8500) &&
> +		    ((info->desc.id == AB8500_EXT_SUPPLY1) ||
> +		     (info->desc.id == AB8500_EXT_SUPPLY2) ||
> +		     (info->desc.id == AB8500_EXT_SUPPLY3)))
> +			info->desc.ops = &ab9540_ext_regulator_ops;
> +

This appears to be identical to the ab8500, why do we need a separate
set of ops?

--JwB53PgKC5A7+0Ej
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWXwFAAoJELSic+t+oim9LgcP/jJADi56X2c6+JVZDUdXs6gi
No8DyV8SkuX8xhNlW3onhUAvF/2P2cvlTgSOpKSQjvG1hISTosfr3t74+LgcWtta
VNYeAo1vEPHU/KJztbNsYbuIG2IF7dZDrq7NSZzBZBuvIgTr6lmxLXVzwGLcMwoU
X5EffPcppmGRZdqpdGE+TxY1wq3WdhEYMiPJcV5fsLq14kVUO23D07AxoYzscX3k
Wq+DzZT8V34qQJ7RrfgU+AuWnAyZS+OETgkWyiE+mAl2IvCve8Q24303+o8J5N62
a+iPKOpDE8t4fX9snZFT3jKM2bNuoD00iYw5K6v14rl5zgzWmku79KCUH6biNgAp
YQuS/zZmNdqPUOniMeLtdt0+Tn7cUSVPAJXX4c40Y8RIBcwefoSOl/sWryz0IoEL
8I+QqFi2oWxC+tElbWElfrpOhoQnekhcRTySu2Xo8tnt+QV1BV6KynfRoGcc9NwE
SAr8+cW4Ec9sXlzA5b15Kw5WP7OBsZD2cDTg/Rq1zwdq9D2YNleF0ydASFfLdbYK
LQ0Vn2s7Lp+2GgtuyaacbQslduG5KYG77N7s8uaEK/1rvw19Ox2EsdVDgyo7RiLT
7pmYM6MdzMEUfiT/uOj/ibNpXoICz/FW6165/+QgqLSyTzXpqE+ZfyQkidk3nkD6
DP3knRVU6h95WDqiWUtf
=mvB6
-----END PGP SIGNATURE-----

--JwB53PgKC5A7+0Ej--
