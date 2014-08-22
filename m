Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaHVO26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:28:58 -0400
Received: from sauhun.de ([89.238.76.85]:38267 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143AbaHVO24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:28:56 -0400
Date: Fri, 22 Aug 2014 09:28:52 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: Trickle charging for rtc-bq32k
Message-ID: <20140822142852.GA1545@katana>
References: <20140822131150.GA26724@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20140822131150.GA26724@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> _But_ this should probably be enabled using device tree entry, right?
> Unfortunately, the driver is i2c driver, not platform one, so I don't
> see how to do that easily...

Trickle charging is usually depending on the hardware setup, so
devicetree is actually a good place to put it. We'd just need generic
bindings so that they could be applied to various RTC. Just guessing,
resistor value would probably be one such property? We would not need
putting plain register values into DT.

There should be no difference regarding DT between i2c and platform
drivers.

You should add the devicetree ML for discussing such things.

> Or would module parameter be acceptable?

No, this is device dependent, not module dependent.

>   * Copyright (C) 2009 Semihalf.
> + * Copyright (C) 2014 Pavel Machek <pavel@denx.de>

IMO, such a small improvement does not justify claiming copyright on the
driver.


--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT91OkAAoJEBQN5MwUoCm2NxkQAKXsavr8KG5W7aKhJKLzlmSj
bAoTge2kV5thmC+Jg1ePHYmC+L5WnSrMbHgCQ7RcHmbzb9uO6BCJeDrOoSQsRwR8
OVs6fruuvhfF/3ASShKKa0P+JFBf1rCU0eU0pmd3Y4YLU1lnx6EbXAQnGv+jtaaO
tkq1nVOUMHf191GY+4fuCz96EplJ636eh/xtgREFnYQBGYI+JmCJgIaPYucUu1ux
/dL1MoCSHQzHAqNp8Hth1mdRrPRXArxpKRkiNpyJ82L4HhPcso6nNTBIK/DAHXM3
xtBmmtpw9TzI14xXO5bWuwZ1c2Es9gXGqnRz2aZf6giTIHCCHfi64kS0ojeBDK2F
KJebaBCgGaY1y8oZ2YzPLTxNNwnF5GY+reohgzM+qynNdGzEAG+dPziBHZfgahuW
OTulNubtpbijNwQ+xNAv7sR1rvY7uXYsGNt+rCj/07c/AQ8AVJKgFOv0xU5unE1I
2ZwFWhmIKUgxFJa9YTPx5mrNEEJZcwgGgisQ4wTZc4Fqsf4I455zpcOTKGHsFI29
fAxhGiwzqlte4RfeZkgMLVNzQ47tDCk6YAGhpF3tCKUw7AoFOTW6rLG692lDSWEZ
10lOdsrTVDz2bNqOjR+w+IPT65IC38X6vYie0NuAC7l1Jm/Q650b4GWUZSSD2IuF
J1QOtNzmk4Mpz45Sf1hC
=RglU
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
