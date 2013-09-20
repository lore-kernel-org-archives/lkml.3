Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab3ITRJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:09:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52555 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3ITRJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:09:05 -0400
Date: Fri, 20 Sep 2013 18:08:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, linus.walleij@linaro.org,
        akpm@linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rtc-linux@googlegroups.com,
        rob.herring@calxeda.com, mark.rutland@arm.com, pawel.moll@arm.com,
        swarren@wwwdotorg.org, rob@landley.net, ijc+devicetree@hellion.org.uk,
        grant.likely@linaro.org, Florian Lobmaier <florian.lobmaier@ams.com>
Message-ID: <20130920170847.GR21013@sirena.org.uk>
References: <1379680214-9143-1-git-send-email-ldewangan@nvidia.com>
 <1379680214-9143-5-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3nbTfX4V9Gs/5Yhz"
Content-Disposition: inline
In-Reply-To: <1379680214-9143-5-git-send-email-ldewangan@nvidia.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 4/5] regulator: as3722: add regulator driver for AMS
 AS3722
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3nbTfX4V9Gs/5Yhz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 20, 2013 at 06:00:13PM +0530, Laxman Dewangan wrote:
> The AMS AS3722 is a compact system PMU suitable for mobile phones,
> tablets etc. It has 4 DCDC step down regulators, 3 DCDC step down
> controller, 11 LDOs.

Applied, thanks.

--3nbTfX4V9Gs/5Yhz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSPIEbAAoJELSic+t+oim9xDEP/0nU7Qp6D1wCr/LbFIGcnfXD
56PAT7omsjQy0q7y6bOvnqK82HgD8PNCQq9sxoOOuCSYj7sf6sBUq7BPnQwJZRXz
0M3NwAZ+Ha8ZSN+Csp7qazEU7L3vfAvTAQZ42NXCwr27yJldmFR38mHuAuv0mxQ+
ASL4OYTrFyC3TbgYkqBZ3UIz5yej2wtLg86CQGojPjpcXtnB4xry1eTnJg6ec8Id
EpZQblgtzBHZbA3HxkMrnph2P+1pb6sVtpgcK+iPZA83xAJS9tzLsTb/yHPat3qu
HgSoBKFqfAX56YFT+PiLsgMNoxsnlqHhS89BrHnFKynOH6LorkT9e57IN42NdCTK
kAjz+qBn8R+LPtL2pgC5qweJ6dc4QWckV5c3w02HMNA/AOMGZzxmXlCiQ1VvWexG
rVvJQUzXVSUJxbSDB6qhWSFuwOc7Mc/wtlWOmBfygWsM3ntHaimC96pjCJQlEhmX
ZjHYAlUor1FTDW4SAxyBuiDytolW3Xga5jA1X0W3qYxlaMPhQLl2t5afvOUkhssd
DTfKIYuikIujJpOME0D4KtlP4y8I1ndUAyfsMlD0Gt2jCHXtkOyfLMQDwugJh2A5
8gnAZWThMaNdqVfzDekLJyuQ747v/Z3//zLKTOKw0wVrELIMjPRmv/Cm5aFAHE1p
DVIQ5jiFcXtZFBZsAQE4
=5t4b
-----END PGP SIGNATURE-----

--3nbTfX4V9Gs/5Yhz--
