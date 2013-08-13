Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3HMKRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:17:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50100 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab3HMKRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:17:21 -0400
Date: Tue, 13 Aug 2013 11:16:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, swarren@wwwdotorg.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, rob@landley.net,
        lee.jones@linaro.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, kishon@ti.com,
        j-keerthy@ti.com, ian.campbell@citrix.com
Message-ID: <20130813101648.GQ6427@sirena.org.uk>
References: <1376380392-19723-1-git-send-email-ldewangan@nvidia.com>
 <1376380392-19723-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LOQ7DyX4IjkXnFQm"
Content-Disposition: inline
In-Reply-To: <1376380392-19723-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 1/3] regulator: palmas: Update the DT binding doc for
 smps10 out1 and out2
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LOQ7DyX4IjkXnFQm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 13, 2013 at 01:23:10PM +0530, Laxman Dewangan wrote:
> Palmas regulator SMPS10 is splitted into two regulators SMPS10-OUT1 and
> SMPS10-OUT2 to match with hw behavior. With this regulator's name got
> changed in driver.

Applied, thanks.

--LOQ7DyX4IjkXnFQm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCgeMAAoJELSic+t+oim9DVYP/ie8UpA3ekp1bY4psslPQhtX
vXCVv2kh5FxTb8kJPQYQ3ThVFoZPyQXb/jVOW/67d1wpN9BNII4v8N3ZU2TJnWrR
yIF4sio2HOGRPK4OicRr4Fb9lSU4JDHEWvscGMmbz1sSbltVyqZsd1AJgOW877gY
pLY7tQTX5KinJt/iHz2gSc/p9vQak7xtISmLEtMZedYio4pKElCWoLR6qLBy+IIY
NGHw9pby9Va4D0VlOlCodZ0jgR9aZXZ6VkxhOJ/I3kUzhjv5iZKseVb7vXynEN59
6f62bfqxKnOWIc8wKZRf0lRij8bES6lrDbPAsTaRVsZCRMRkwxl58d//T7+tYZGh
/Sw6KaVREW+THuR+wYcghydTtcQUreYPTzHcQ2+Pls3nUiby1+K9k3Nkzo/kqYv+
nQstHqS//9NueSM4luCHVY0JkWQakwg/khVo9ZM9YfaxJhgBY1+PzWpriKWAgJRY
leLXWcEazstWB6xxyheb3UUZz3oMDJ/PHouElYTkjiYCCfy3ZV762KavauY5d+4Q
faX9SToE1OaOwhJ3R9XsBmB5KcKICuXieMjPG0bngqWjGTLK1RLvgXCiXFGlGQIU
swlf3GnwrpP1atThJd84wCZkCDegDkY4HXEPOsru+QNqNJkqFyF/j3D8XC8+XoDM
HwvJyKZP61mISOdMd8jN
=4mf0
-----END PGP SIGNATURE-----

--LOQ7DyX4IjkXnFQm--
