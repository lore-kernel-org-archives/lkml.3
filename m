Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab3KPL2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 06:28:12 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59702 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3KPL2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 06:28:06 -0500
Date: Sat, 16 Nov 2013 11:27:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        Florian Meier <florian.meier@koalo.de>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20131116112754.GT15393@sirena.org.uk>
References: <52864BBC.7000506@koalo.de>
 <1384537403.14845.131.camel@smile>
 <20131115175155.GQ16735@n2100.arm.linux.org.uk>
 <CAHp75Vf3CJNgSiSjoZ6dYjRRHWN4bTpMxRTLG37+wwtEsQbq4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9pS2hy4/DrI8BQlq"
Content-Disposition: inline
In-Reply-To: <CAHp75Vf3CJNgSiSjoZ6dYjRRHWN4bTpMxRTLG37+wwtEsQbq4g@mail.gmail.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 31.99.68.145
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv5] dmaengine: Add support for BCM2835
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9pS2hy4/DrI8BQlq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 16, 2013 at 11:37:54AM +0200, Andy Shevchenko wrote:

> The reason why I was asking about I'm just wondering what we have to do
> with existing drivers. Shall we convert them to be initialized as normal
> platform drivers instead of subsys_initcall?

We should in general be moving in that direction however it does need a
bit of care to make sure that there aren't any dependencies which do
things like discard error codes, fail to check errors or treat errors as
hard failures.

--9pS2hy4/DrI8BQlq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSh1a3AAoJELSic+t+oim9bOoP+gLPtOaHguGjPBeFVlfJnf97
UkYHBcwA0rk2m2W/mNOxuO2ljwvyC2ijxhev9zgniQfLnAEVRYNMgPCvQUj6oHjW
DrCqVIN8AsiHSdDLr4DftRrFoUkyrcaYQv8JCdjGRAXPE+e0nDt36EMwnvtuzD89
L73mtvWThSMolA1dc4z5AUoEuADo4CC7pvBfhK+STTcwZe2OI+rgt1mRegNlWJHk
njm436bLhPsx+Xg2IW1GWE5fwa1T0kFnQznXvz12FSW1UihGTvRPccCsS0tgHpuL
jd+zrQAoP5rXsg9PjqXkHYJVZmMyD/GMNpIYuyO98mXyNUQH0vwmc5j86iMH5OT3
mU7d9/fvtUcnMcih2HBLVShieB53XsOLZnFX6D3NvXUkkdGZIZFdBGiTZ+cq8pdT
kxPO/1lKVZM2Oasl63j1AXbhwdEQhIgnfcaQZ1f0UZscOkjZjWMGJZCXEIGo464x
ialL1uiZx10XHyfujeoNfIhuwVinRkWLgllzmoNEreiRNNz3++VQ2YdR7wS1U6g9
hhQwRrNZVk8zy5hvgbVcVTKmsUrH29v2/1Pp5v+znkos7j23UpgXzIXntmsCqFN9
CHOnJssX+N75n5mW43WFIzqt+MBGaJET7BYUdt3/V7JrVDcr3L1yCRPbbVgAvg6b
xSdVgJvWhdc0G2gMD6dj
=wuL5
-----END PGP SIGNATURE-----

--9pS2hy4/DrI8BQlq--
