Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934261Ab3E1OU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:20:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52385 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933972Ab3E1OU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:20:56 -0400
Date: Tue, 28 May 2013 10:20:40 -0400
From: Mark Brown <broonie@kernel.org>
To: Chao Xie <cxie4@marvell.com>
Cc: yi zhang <yizhang.mrvl@gmail.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "jett.zhou@marvell.com" <jett.zhou@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yi Zhang <yizhang@marvell.com>
Message-ID: <20130528142040.GI3660@sirena.org.uk>
References: <1369224653-27150-1-git-send-email-yizhang.mrvl@gmail.com>
 <20130522161422.GP1627@sirena.org.uk>
 <CAK=oMXepj7tmZJ3=b9ja+E1N9eAPmsPhBefAzoswVyGWBXwNOA@mail.gmail.com>
 <20130525195601.GJ7660@sirena.org.uk>
 <CAK=oMXeCUgc5E1ZaXcbrbUB6XGD135a7zRD-CC5apEytx2j=fw@mail.gmail.com>
 <20130528100415.GE3660@sirena.org.uk>
 <AAD1C6EB06EE3649B35B7E026785068D2581253EA9@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X+nYw8KZ/oNxZ8JS"
Content-Disposition: inline
In-Reply-To: <AAD1C6EB06EE3649B35B7E026785068D2581253EA9@SC-VEXCH2.marvell.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.140.31
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: 88pm800: add regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X+nYw8KZ/oNxZ8JS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 28, 2013 at 05:10:00AM -0700, Chao Xie wrote:

Please fix your mail client to word wrap within paragraphs.

> Thanks for your review.
> Because structure regulator_desc only accepts the voltage table as constant.
> struct regulator_desc {
> 	...
> 	const unsigned int *volt_table;
> 	...
> };
> If we want to make use of the volt_table, and the help functions regulator_map_voltage_iterate and regulator_list_voltage_table, we have to initialize the tables as what we do now.

If you are calculating this stuff you shouldn't be providing a voltage
table at all.  The whole point is that these things shouldn't be using
voltage tables.

--X+nYw8KZ/oNxZ8JS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRpL01AAoJELSic+t+oim9NOAP/iSPY7vFXmEMSagKgD6OdWtW
/SLGY+zh9AD4Z+ajf7NvGBX6G5HlWBm36QG/Fccc0gR3sNMBv5ljdPQWvKQ5/aUb
GOSPnuIasAbKQW+mfl3fRO1IHaBUQDw/4B5qNgUTrqn+odowpxNq8qVaGyMVu7WR
yPUaB94abzPqirerRJC8LiJ06VGT08GRk5XvNKPhX9POS9b5hz4AaaDi2WbDqLFv
kRulH/1y1UD/psnkgs7tOPbWzW1ycGoihHHDAJdMuwqBK3/ml63/nrWPjQwsDltO
hoS7ZHLYnCDeLotILc0esuA8/RmHeEImX8WUukWybxaJ9f2hUhfnwn5JD1IvkCmi
DLiodoJR0PYJT/ZlgPZ8Eg+1rM7fbT/daX42tjSSWBCXNZj2v76JO0duKEgwkmgc
UoBOTHtnE+4Nw5JlwHDkBBAHnGVqAqgypYCuj/cG669ydlKOtFcFFgsF+KOUbSbJ
Vne2P6sObh1vYArlQ27BTC+/orOF8b6y/n4ARX/lnptEP4Ev0Kf0TBnBrsnfxRbB
usdbbVSbEUno2HlbisfEREwFeVHplBrZIR+mxZpa8SQ2araHkdjGG05oOuVoEXqF
5EWkakCfoPVB22i4y7fTBqQ/OIxXMcfpXL7SRuwRHZrAysidy86Nwc/qcgrdpGy8
9aiS4/6VK7Ppclq3i3zZ
=jEOW
-----END PGP SIGNATURE-----

--X+nYw8KZ/oNxZ8JS--
