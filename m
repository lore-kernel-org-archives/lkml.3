Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3DOP4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:56:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57512 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118Ab3DOP4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:56:13 -0400
Date: Mon, 15 Apr 2013 16:56:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] regulator: ab8500: Fix voltage_shift setting for
 AB8540_LDO_DMIC
Message-ID: <20130415155611.GE15837@opensource.wolfsonmicro.com>
References: <1366015011.13029.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bi5JUZtvcfApsciF"
Content-Disposition: inline
In-Reply-To: <1366015011.13029.1.camel@phoenix>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bi5JUZtvcfApsciF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 15, 2013 at 04:36:51PM +0800, Axel Lin wrote:
> The voltage_mask is 0xc0, thus we need to set voltage_shift = 6 to get correct
> selector in get_voltage_sel and set_voltage_sel.

Applied, thanks.

--bi5JUZtvcfApsciF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbCLCAAoJELSic+t+oim9eOUQAITIuHBwqauWvhuF7R9lxMrI
myOZVV1C65fZqyoJax41vp3V/2CIvVBrViNA0kZypzyP6bTO6OmINf7WtazYWaiU
6S0M+MsdZUaBGvpnOt76YaG1JbTtV5jNJAxOUgysIowOK8u6c7jBgTuW69xVvMS6
foF81WULi4bE3JZHYf7yYNlUOX2iM8K59Psd8N1anveyoI7dh5xzv0g/CiBZyrxG
p5tQyApfX9pn2nUMjVynoGXMa4MYPATWRbEF3bXeojYj/2RxGNyhRgm6MLwm9JkV
WCjDu8Dejs/fPv1Lr+Uvx2qngNx0OJY0RJhvVvgD9+3qTApOnz+0/rRd1x98J1qq
yqCM8+jhWa5BJdWH7YpM0aF0tFuicO4EFN1EUTHV3BLI1RPI5gmOceeSJAnhvWB3
GCbK7waIFNtGSEUyz+EOXwsOHit01wPEniOcdLNxH9+R3cupvU+jQPt7Pqx/ENDY
UVoOnwPP0IDSgrAGwOJCjqU0tzxx/jNWoooPmpquYTkrFecQpTzgLStQ1YWmcsBk
frwfh+DuD9mJopb0fO8rPlkaLnby+4MJYxiwfTVjqXPQwJd1VBIkF/tFydHyxqmB
SoHuUwX4mY+O8T2PAGzR2m+kqurhEgHM5vZrsU+YiO/Y7RJNKnpkJewdo9P3+nmc
p8uRW/VIviL0H+cRxinp
=fFUr
-----END PGP SIGNATURE-----

--bi5JUZtvcfApsciF--
