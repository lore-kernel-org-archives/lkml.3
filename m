Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab3CAHeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:34:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45381 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063Ab3CAHeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:34:36 -0500
Date: Fri, 1 Mar 2013 15:34:05 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@ingics.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] regulator: core: support shared enable GPIO
Message-ID: <20130301073402.GH25302@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998F792729E9@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIIRZ1HQ6FgrlPgb"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F792729E9@DQHE02.ent.ti.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIIRZ1HQ6FgrlPgb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 18, 2013 at 06:50:30AM +0000, Kim, Milo wrote:
> A Regulator can be enabled by external GPIO pin which is configurable in the
> regulator_config.
> At this moment, the GPIO can be owned by only one regulator device.
> In some devices like LP8788 LDOs, multiple regulators are enabled by shared
> one GPIO pin.
> This patch-set enables shared enable GPIO concept and fix LP8788 LDO driver
> as well.

Applied all, thanks.  Axel had a few comments as did I but these can be
fixed up incrementally.

--WIIRZ1HQ6FgrlPgb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMFnQAAoJELSic+t+oim9/mAP/3GGhQNk3dowtAJ3OqQOEFMt
bHyaFhPeE3/7gzaNRZGns4Q5tEWJnwUNRLDVc2oHLFyidiwoDRt27Oy2ooqm/Adi
vBfgMG/0Nnn/N6Acdn16iPaWRM6mrp7+Nd+vGe5zRWlrZSK67VWlCaupd1hlssZd
n5J3W+Lhk7+EuF4po9tZsDxnmiEWV7oliftQR4TdZhFK22URrl/y5r+ZXyuvsC4G
14KbDs8zktUyxi5Lh3TbaxsJUaEP0oNyNhO8ITkRzZtDKGLH75rGxhdXvofqlrdp
qaq77rk8mtH7aqlOWJm+4QNIHhPVzdJ1WssOWFQFVvgFXnKSUCprKBJ1SgmqoInj
g+BNljgVQ3GVJnHCn1S1x/Eo99ytKa7IC32zmPHtpECyYDwD6nvTJC9IlJSBQDAa
QqHSa9BTiFsbbTAXLRwIjjddJyzyJBqk1uyobE3KKycMnVhVlKyLMMKbWDi+bS7q
a3LTMooRHCOMj4rgnyU8N+ZfqWIEzQNdrcSL+mI3+o8qyRQUMFE9a3xrzwezAwqX
WXfqUaVj10baY98jr1rgPk/VdOOvM8RYxj2dj5CRf1bTGzWz/YrV2UuT7VhGBiWs
cYOui/HE81SjO1DT1iqRYSi8BNv+ErpLDPHhLSh91XBXiQlIC/84FnD51EDVfRdm
1rui+ALo2GkaHAE6ioc2
=zfXu
-----END PGP SIGNATURE-----

--WIIRZ1HQ6FgrlPgb--
