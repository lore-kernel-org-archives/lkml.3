Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3LMKpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:45:42 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49285 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab3LMKpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:45:39 -0500
Date: Fri, 13 Dec 2013 10:45:34 +0000
From: Mark Brown <broonie@kernel.org>
To: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "vpalatin@chromium.org" <vpalatin@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
Message-ID: <20131213104534.GU11044@sirena.org.uk>
References: <1386811131-2720-1-git-send-email-wenyou.yang@atmel.com>
 <1386811131-2720-2-git-send-email-wenyou.yang@atmel.com>
 <20131212165149.GO11044@sirena.org.uk>
 <B256D81BAE5131468A838E5D7A24364172EDB624@penmbx01>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NQqDiQVflaif2hna"
Content-Disposition: inline
In-Reply-To: <B256D81BAE5131468A838E5D7A24364172EDB624@penmbx01>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regulator: act8865: add PMIC(Power Management IC)
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NQqDiQVflaif2hna
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 13, 2013 at 07:10:36AM +0000, Yang, Wenyou wrote:

> > Please keep this and the Makefile sorted.

> Only this one confuses me,
> How can I sort it? By i2c interface, by regulator type: voltage or current?
> Where is act8865 should be?

By name - look at the existing entries.

--NQqDiQVflaif2hna
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSquVLAAoJELSic+t+oim9pVEP/idnredkXo+TmAKvgKALlFr7
jZ7p99q+AHtFpPgbfziUiPlU4rnxDx9fYOu7fqTKilm5K7nPePMXQSA1RvgTHvoA
r0KYpzSfMdVl101c8IKTHIlsLqkz0F7Lbn96d5Nf/ltQ7a8LOjk3gyTRGAxZV9Mc
ZSDZNwZOLssBdbeNElrS3SQAo449wG8J/6KIunz6QAWlWwkIpAL5Rq75f0OoZq6E
rrZcuL4p8PO2fv8uw9wNjOJVneSdY/w74DqxxH2A6grGYmiZ51O25zSs62AUBs2P
sHPd0W3TbXI33/S3FcQQ2zKUjLFkvGt970qcJwiaKoRsBRMPTpail3g1wPZoaUBG
vnI1LXzPt4hXVBYH0jqe1XWo1+p7NJNxG1dJis7K+rRTxqU4oJiCoUGBGB87ToBH
w3FrahqFbP9l6t0nIqe0JjdNaNiQHXjW6zme1PNe1gTgu+qIManKJ8p8+2QfMhhh
z34cblpf7fHGr99uZ0kK1cuFRd+xe7qNoMCA+MPp6TjaCKkYJ6Kgvtpo0Jilr6+o
ZQ9rkq6qS/g/eU6rJWQQmR4SNJF/V51PqTQaMiuDQz5fl/nSAAFH7CkTEs/g2okX
pNwMk7Gm8vzJ9Z6ktzkQSb8Pu4c7Wprhki7696b6rPw27eChUYQ9FQmVYO6gJxQf
WEG+1MzTku3XCgKpeH9x
=uXhv
-----END PGP SIGNATURE-----

--NQqDiQVflaif2hna--
