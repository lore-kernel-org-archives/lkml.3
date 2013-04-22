Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab3DVNZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 09:25:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40121 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752846Ab3DVNZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 09:25:51 -0400
Date: Mon, 22 Apr 2013 14:25:49 +0100
From: Mark Brown <broonie@kernel.org>
To: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Cc: "Kondratiuk, Taras" <taras@ti.com>, "Menon, Nishanth" <nm@ti.com>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "Tseglytskyi, Andrii" <andrii.tseglytskyi@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "AnilKumar, Chimata" <anilkumar@ti.com>
Subject: Re: [RFC PATCH 0/2] cpufreq/regulator: Limit minimum voltage only
Message-ID: <20130422132549.GM30351@opensource.wolfsonmicro.com>
References: <1366372554-20866-1-git-send-email-taras@ti.com>
 <20130419162153.GA24066@kahuna>
 <F2EE74CEB87D4A44AC98442FCBF00207018E2E21@DNCE04.ent.ti.com>
 <B5906170F1614E41A8A28DE3B8D121433EDB23C1@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W4pDZ/VvazBYHhxQ"
Content-Disposition: inline
In-Reply-To: <B5906170F1614E41A8A28DE3B8D121433EDB23C1@DBDE01.ent.ti.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W4pDZ/VvazBYHhxQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 22, 2013 at 06:11:12AM +0000, Bedia, Vaibhav wrote:
> On Sat, Apr 20, 2013 at 05:54:10, Kondratiuk, Taras wrote:

> that the PMIC outputs can come is either 1.25V or 1.275V. Now i think there's
> been some confusion in the implementation phase due to things like board level
> IR drops and variations mentioned in the PMIC datasheets which has resulted in
> the tolerance being used both in am33xx.dtsi and then again in the cpufreq driver.

Note that there is support in the regulator API for putting information
in about voltage drops from the board to help compensate for things like
this.  It's just a straight linear offset but it should be OK for most
uses.

--W4pDZ/VvazBYHhxQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdTpWAAoJELSic+t+oim99AIP/2A3/88H1j0WU+/4HOgwMQFb
5oS22ytwV9VBQZURzTB0goQW7b59lkU5T+Rk2XPTnxgPzKa4awsgBGS5FPTqLb0n
hlsjYXTCRhpdzhx0XAYE5l6iboSDc26IXogfcF9aftFUULo87mh33FRgyo9Ptf8z
5WqRaf0WdZtYRPzdkXZYFzwXmXFV7bFmDY7BumbGvCWa9NBwZYN8Ar3SnX24j8BH
9p0vDlddjrM1qWgze1sE3r4qwml8UKdpPm4hAQBCuXwdcevfJEVOzso6FaHndcTK
15pT8bbOtEBrlxa55uRMTD6Z3chwGzEuHTcspeFRUT4hNSlcJGeqlxx9TDgj9iFn
SHv9aDXNO5Xl88MAyfxTjkmgnuT4C7tMkwb+FLS4fu7+aPNkFJD61jDoxeQItsr1
WTxCf445IwVFKt1gwZa/DyRn1nkXC+k//JRhDeZKVN2eZCI9+UkUWuPhSe3YyNoh
6+tABmHUMCDsGG0/Qm5inbtNT3OYfUg7qYeUmAu/JIE09fepeioBEiacV3BVwslc
a5xaaPFRXIJ/OJtlp1gntWaGRukJe4e/lNHS/YJb/xWuD2co/mgjNbLbv9Rqwi6o
iB2UPAtlAdobIg+MIzsU8aDmPKqxI9msLCsU90zh3pwRfFqgbBFatZHCXRwqXYBT
jTZZgdw01Ld2lQRd6/5e
=bY67
-----END PGP SIGNATURE-----

--W4pDZ/VvazBYHhxQ--
