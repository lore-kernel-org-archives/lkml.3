Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab3BSMSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:18:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37387 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932535Ab3BSMSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:18:04 -0500
Date: Tue, 19 Feb 2013 12:18:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm8994: add missing variable initialization
Message-ID: <20130219121801.GB23508@opensource.wolfsonmicro.com>
References: <000001ce0e3b$f1d99170$d58cb450$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <000001ce0e3b$f1d99170$d58cb450$%han@samsung.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 19, 2013 at 09:56:26AM +0900, Jingoo Han wrote:

> -	int ret, i, patch_regs;
> +	int ret, i, patch_regs = 0;

As with all such changes you really need to explain why it's safe to
just blindly initialise to this particular value and why this isn't just
masking a real issue in the code.  Initialising with a random value will
fix the warning but that might just be turning off the compiler's
checks.

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRI21IAAoJELSic+t+oim9GPEP/RxL66K5STGdedWKDBa9khzn
m33aZqcGKT8KKluvHBfFZWXo5lGqDv51Uw8b6u5HGa4+5845RlxGcE/jCz7JSQv6
sR1jDR5QPuq1DUWCGbC/Sufan3AA70gX8j1WLx5QhBna3fXaya4qEawI2x/VqYLi
ZPK8frbQMZjq4xWuqB6AXPM11vwJZ0QyZ6Z/FrlD6s/yPcX9tWSqJ2LHBYOU0CqQ
PTo6vB4NjiloEDHAZOv0Zqz4pyt450iRSk3yZHNVqG/JowLvxNRgLOxcGRVsbOwh
PbqXQ9/yGBzEoWIEP09pjjl/XNN/E2CJmlTaRcD5ggmGmH9tEcfAUbqcu7dLZNQa
qdzQcY3+5jNy6wJ97EJH4onyvucWL3og3E9NOlfN29OLg27yot5QL0wM5B58frTo
T3IZ/6ntiV8StG8qZJRXqhXiWhtbtqO+0lizYxxFG0XIvfhODwRv9+Y/aFznxhzI
Mpuu/d1VvXbg6kjWuOs8XuGboK9Q1bmcLvPlYJwK5ewvqZ/vc7poiUHU8WGNHPRu
JmZt5j0AX3rre4lyqGhb1gDdmOpLv+Fy6Gu9ibM0698diT/VuyAev1XPB+whmZlD
HCZiDiZaG7KDybSoIqRH4Wf6JWz0AUCU0Y0VbFcA0OLZVFhe1xeB7M5y/2t0kOn5
4acpDzbbBmjgWwq6WP+f
=nJkv
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
