Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3DKQXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:23:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49074 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904Ab3DKQXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:23:18 -0400
Date: Thu, 11 Apr 2013 17:23:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] mfd: wm8994: Add some OF properties
Message-ID: <20130411162315.GF9243@opensource.wolfsonmicro.com>
References: <1365604763-13122-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1365604763-13122-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <5166BCCC.5020307@samsung.com>
 <20130411142100.GA24971@opensource.wolfsonmicro.com>
 <5166E21C.7080009@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DHioQtdaSVZskSfq"
Content-Disposition: inline
In-Reply-To: <5166E21C.7080009@samsung.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DHioQtdaSVZskSfq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 11, 2013 at 06:17:32PM +0200, Sylwester Nawrocki wrote:

> Anyway it worked pretty well! Just needed to add patches for the regulator
> you pointed out and that small patch:

Ah, great - just redoing the bindings just now for your other comments,
hopefully I won't break anything in the process.  Can you post that as a
normal patch for git am please (or I can fish it out by hand)?

--DHioQtdaSVZskSfq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZuNrAAoJELSic+t+oim9O6kP/io+/U2YrEZIcR+mLLITYVQa
0VkVxrYkYyMfkXujFvYqS5yEK2Jp7eG/AHq5IWLPJ44D+2bs5CArTH2Ix6dPTmR7
TGH+72Qxy3F9WdZPNCQUX2tLAczShMGBGqXFx38tCNhyMinLyqaPYqMY8E6BVqJe
DoBskhOMiYI3G8HXYGVHyWVyaWB7/Fbv3nQGtpay6IKoVk44Uc3SaU//XQLUKBfc
9520qIswhsX0mXvHsVKtKiL1576ep7UV5VMIhEzjWYukEL7y0cxSeh4mJOFbFjO1
vrdb6wl2BHAnSZyCtyLrrHUWbeclZMNDfcsRGONxXW2x2LsIrF7txu+QzyMxH/ou
Qygv062x5v20tmXqgvbqG2bVppiBs81uCkEqAy1W9MGLxvTB1M9Z1JmNsncVLITs
QSqjwnntTec7AqTUySGf0gxCk59PjCpSa0armmUAYr4tbcRi7TaP81G2nu8EQpjZ
6sxR+/jpuNw4UhAAsZneK1ITLSGxZGAzkuWq0k6v3dteYtDG3FRR5byLbVaDWe3Q
L5NA6WiM26AMdVBTytHQ0qDO1lh0jqbUFo6aLjtUH1KtYVyrqDEuZZz5BYfckGjy
H0+fKqOBbAp8F4aQF+jF0DKVnOFkt3UT0T0X3ir9ptgInQ0i76/xim4W7DZl9wFK
GfBB0iLx5dS9i4JIgs1d
=kHJ6
-----END PGP SIGNATURE-----

--DHioQtdaSVZskSfq--
