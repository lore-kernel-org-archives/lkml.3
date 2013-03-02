Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3CBMVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 07:21:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38394 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975Ab3CBMVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 07:21:37 -0500
Date: Sat, 2 Mar 2013 20:21:05 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: palmas: provide irq flags through DT/platform data
Message-ID: <20130302122101.GB31872@opensource.wolfsonmicro.com>
References: <1362141296-15321-1-git-send-email-ldewangan@nvidia.com>
 <20130301124350.GA25302@opensource.wolfsonmicro.com>
 <5130A53C.1000600@nvidia.com>
 <20130301131633.GB25302@opensource.wolfsonmicro.com>
 <513102D0.5030609@wwwdotorg.org>
 <20130302033525.GD6610@opensource.wolfsonmicro.com>
 <5131ECEF.2080101@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <5131ECEF.2080101@slimlogic.co.uk>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 02, 2013 at 08:13:35PM +0800, Graeme Gregory wrote:

> Should these also flow down into the various drivers for the IP blocks? eg.

> compatible = "ti,twl6035-regulator", "ti,palmas-regulator";

Ideally, in case there's chip specific issues.

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMe5hAAoJELSic+t+oim9wdMP/1dO6VtfxVtAAg4nDvR4MeA1
MzHjJPyJ21jJwhjEiISnHtMFUQTi8M53TtUApC2V4JMuEF0RB7+0qyc6iUDAGas/
5fJLX/10PYoLFVDD0XxVyqsShETAKdWoBcgVC9SrGHL5KeP1Q58QF/v+urQACicK
hQfMb/VTPr4Zb1uIvU0Fqk+zWoTQvgSkQgi0L2UOafKvYASdeNhvIic0f/Yp6n+E
47QLXSLUJtl/sOjHdbo1QU0Fa5lD/WDQFi2jkDCR/XOxtFfMxHIBd5q7/gFqtV8X
3IBDj3oUX+UKm1/xUwPDdWlQxXMl8y95x1j+cLK8ZoD8EyjDIlmz2ndga2PLPo9Z
X1g8MvCkEC4Z8DoKhYi3qk1QVV1P68sC4tzfac+H5VsDPuib8nHCnWoFgUtLmne/
pZrb7UhI11uO0Y10y2iU7g/kd/cybslaYKkuSU/883Lh2uyrHK56S8Ak75tXOq/7
Rh288kP3duyuM5mP6R3Mn67kngHiRzXhdFJ4tHgZvoyy/08pDi+tt3YKNWmmTWnF
pHVRIRnJdiZMFTxfPRyxVcb1KCaXrlbMPH4J3lNDPNX/L8qG+Wla+Bjth4iKybMO
x/wtEfrb2zCru1gKcWMlCAEGBwfIwrp1JFqyuD2qWWBL3BiXhYj9+yF4Q3SdLIJv
RKvoLzhTHCov30vnQRCK
=KoX/
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
