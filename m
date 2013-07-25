Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3GYJci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:32:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36189 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3GYJce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:32:34 -0400
Date: Thu, 25 Jul 2013 10:32:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: shawn.guo@linaro.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        rob@landley.net, lgirdwood@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, s.trumtrar@pengutronix.de
Message-ID: <20130725093209.GX9858@sirena.org.uk>
References: <1374723198-9716-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6ISAYjCz29ajFyjn"
Content-Disposition: inline
In-Reply-To: <1374723198-9716-1-git-send-email-b38343@freescale.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5] regulator: pfuze100: add pfuze100 regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6ISAYjCz29ajFyjn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 11:33:18AM +0800, Robin Gong wrote:
> Add pfuze100 regulator driver.

Applied, thanks.  Fixing the language about the regulators being a
property would be good, please send a followup for that.

--6ISAYjCz29ajFyjn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8PCWAAoJELSic+t+oim9iIwP/jzxQZ6aPor+AjsWN9c4q20i
mr3ajfxGc70RPw2HUcXCU3joGgXUotGhNK4wTrIWKDsGAni8EC/kdR8BVH4vVHQE
VKI+a6Dt41yQQX2hbgGxAi6bctmXl6FrJMbmawWsAqGsFS/E8s/OJ4cCeLzqQjYB
lXxpiQtDH2V5BYvISR5GX3uH5C4+IDjGfEiRjTtG7jAmnZ1ktIpefZ1+jZWzPmAY
VorVe+nh3XZv92tBJuHCPykNJST8lRoWp1NL4WvDPjUjwLpv1wzEceXANuuMGHZ+
7cXBq9+48mJKTkz3LY0bV4/DrBdPZ8vn2FXfdJGSza/cF/NuBK1gp2z7z6sWF8eK
XRz8seIjr/J3wYJ60w3JZLc4LqjXCK1Vo3WeAvG9oYdzwdCX6FRVniCtXWYlEOXa
V1/Me+RxGL/6iH6XE1pAjSfYAsWp2E3TTwUtKfNoH+XKVdSwgwAW4KNNoLgtInQ7
mHvkd03mLDIJqeuY9RvPhOh6b6KvMNHQ2Ge6D0+HgbzhTQove2zs2ZczTQS7ZBD3
S4Czmj/d4BcTY1utDiGp4HhBPkK1FGeRzOkbU+xdpkblYpg+lhuP7TSATQ/QYZU7
S/m3dE+VNcxRUxt4u13YX5PiGbnMRdROyBBNqUdoAXrNL8Erc7RZLoR/7hTM1OtS
pdwthLFm0JZdmVJxVc0D
=zSAA
-----END PGP SIGNATURE-----

--6ISAYjCz29ajFyjn--
