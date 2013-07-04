Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab3GDJXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:23:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55344 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3GDJX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:23:27 -0400
Date: Thu, 4 Jul 2013 10:23:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>, linux-kernel@vger.kernel.org,
        sbkim73@samsung.com, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20130704092324.GL27646@sirena.org.uk>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
 <1372072858-6559-5-git-send-email-yadi.brar@samsung.com>
 <20130703180033.GX27646@sirena.org.uk>
 <CAKew6eUGK+g1__m8QHFiz_miNPLwaMc0CG5ViwNGr2qQX5ESoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VDo88IHMZzDSr6Ba"
Content-Disposition: inline
In-Reply-To: <CAKew6eUGK+g1__m8QHFiz_miNPLwaMc0CG5ViwNGr2qQX5ESoQ@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] regulator: s2mps11: Add device tree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VDo88IHMZzDSr6Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 04, 2013 at 10:44:36AM +0530, Yadwinder Singh Brar wrote:

> Yes, it seems incorrect but in existing code based on pdata, its name like that.
> If you insist, I can rename it ? as It seems sensible to put
> "regulator-ramp-disable" as our intension is to do that(by default its
> always enable).

It seems sensible to rename yes, otherwise this code just looks totally
wrong.

--VDo88IHMZzDSr6Ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1T8JAAoJELSic+t+oim9u8QP/3ihxMD3lhE/JU5kWqpoTxHl
+7uN7Y52/kXzYdFADYsHgxIY/8ouJCSFnE1GByTXq0lFREvUXX8zH2/tGu1CFrUY
bW59A5Ivp60OIiy7Vc008PJmB7vBKYYACErH0BFggH87crhOzMEMCWTi1u5y8u9n
67+e4Nlp3zijUtX2LjEcnWpY3MHXpQ2BorkwzLd7V8sWBMcuQbjZqi5EPTg/gt6t
y4gFn9Lqh6ryC5Tal4Z9hZpaikbBiOFWnHRSG+ceQnO8xwd79it/YiEHkbKhVOZj
X6GG+JOBQumAnjrqH4HyO9UZqlYA1V2SOLdExwqTN/mdFSR8PTmQsvERhC1iMFe9
JLyX8XGeWHs9phDuZRg0iM66OWqUlt1HrPW5TfJVOCu9zk05qnhv8bu+YYSDflGM
tyITJJX6qENd7lKh9zbNkfewO3J5gpX/wTWV5feA5nKN1QhnyMd21QjxnRM1tWsa
7kofVHnADEGjBx7Mf3FogK8cDDBd5o+c1FIeBh1luazMFbtBvuXkiaIxDckP0iaC
ntDG+UP8AfYxWYp4xkZn9cpmHp+EzXnpWmxsUIQFXWw9Evsankvjc2QRKIWIWpjx
Whdkw9bKPQvXaKBYwEgWwxxHeD/QWlBn9zIzhxb/UhroeOLahev+zT8Z6EPPf7Qv
tbdo1/flmARl1hX79zJQ
=V809
-----END PGP SIGNATURE-----

--VDo88IHMZzDSr6Ba--
