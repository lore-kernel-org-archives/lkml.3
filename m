Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaCEEeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:34:03 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56009 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbaCEEds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:33:48 -0500
Date: Wed, 5 Mar 2014 12:31:00 +0800
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20140305043100.GK13126@sirena.org.uk>
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
 <1393862536-9842-10-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x2HNTtYOBsOEDsnN"
Content-Disposition: inline
In-Reply-To: <1393862536-9842-10-git-send-email-tomasz.figa@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 09/11] ARM: dts: s3c64xx: Add nodes for power domains
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x2HNTtYOBsOEDsnN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 03, 2014 at 05:02:14PM +0100, Tomasz Figa wrote:
> This patch adds device tree nodes for power domains available on S3C64xx
> SoCs.

Reviwed-by: Mark Brown <broonie@linaro.org>

--x2HNTtYOBsOEDsnN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFqiBAAoJELSic+t+oim9tU0P+wUnf9exz59pc1DFtw67ycHA
ktV7mAR7VfZRc2hR7gnSg+JIeAslBeMZSZLqE73HxCFSwC+ks8OfGS0Lc5rFE5A8
GisUzU7oXqFjiOSYhe020v2/+FUKogEyR4SqSS1DYWBqRobpuT23Pj7qWd99i70s
NwShTjFOYtY3rrOy3l799BmAtkY+tSt/6m3TSIKOPWAHckcQRzp507qyqw7bwDbo
5yIEKif+xbTYnsTsxhD0FAdgmUKrZ+NMxt3BSnse/6Zj0VEEh2oUXeKevT1sYlHr
6GVuK2Lo7zKBtSiHE4uHyPzFiRzd6SFj8tPrej8vBgp1SDpzmh5TqzlnAZ4FbqUu
X33nKef+QDSmmoPqpyGaTsNWQr4Lr6/duGi8Ln1L7kq8RihuXz0THUnNoDbcdddA
XaG6tSTFz5dvkn61DWz0DmZ9bSYcUzXB96P+HbCrD+gYeLkdnWoCHnNL0w4hkJRT
dfHU57wfeARmU28z3DK6iLwSOAnR9LaodmJ+E/DancCC7mYzI+pBNq/+aa7CcbJE
0rdzXipI2Y16BNUJPmk/knuQP1Xae3fsEt9n3acaWszcNLVsp0rCZ9w/tCbwY8B3
/rbpxhK184QCNlDr+rRV6u79nUDF0nlknRuMVjBT+uF+gQxX4GhGhWmDJp+9iUeC
MC9745et8vMofgs13ZJL
=HqaU
-----END PGP SIGNATURE-----

--x2HNTtYOBsOEDsnN--
