Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaIXVSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:18:45 -0400
Received: from sauhun.de ([89.238.76.85]:43217 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaIXVSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:18:44 -0400
Date: Wed, 24 Sep 2014 23:19:13 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Peter Huewe <peterhuewe@gmx.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [REGRESSION] i2c-acpi: Fix NULL Pointer dereference
Message-ID: <20140924211913.GA1947@katana>
References: <1410548987-3558-1-git-send-email-peterhuewe@gmx.de>
 <1696265.yGhHYgE97A@vostro.rjw.lan>
 <20140924210216.GA1291@katana>
 <2180819.4Kky9hrQa3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <2180819.4Kky9hrQa3@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I'm dropping it from my TODO list, then.

Yup. Thanks for the heads up!


--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIzVRAAoJEBQN5MwUoCm2gFUQAKsZm4Tu3GJHHH2xHGb65fSl
Y4Xse9xH5sSywUse9Ljh0w9/UYxqdmvd3Z2Eex7CpLLq99zwNQvsZtnt3vuAB4ne
MkWLmSgrLRYqPwDkpK/mYIRvpRXiQRFB4nT7XtlxrBSrrVPEzQmRZXhbqDTDuClj
x7SxwiJuLljbad6RF2rqfm1V1qFXOSY3g+Y5AXozfaSqMhc2WYzeg0PFtjQ5yVb3
TP4rHzMB1yACN6fQnsCIAQrN9ffmH4BresFLk8S/7AbRBskrjgRVHuY+chxdtdhf
7eoleDfQBFnBwOD2Rlz+pHtWX+erYrKRghvwA5bmm5I+mLuAkv6BdMR2o3k7NtNA
c0eL2GTsg6HDtdDwhdr1EcpYqwQLHOIbtZmcBdv0eoNrpT0Aa48p3Zy8JdJzRe65
aGathy/4aThdyms+P9Iot1ThX/UVAMDkTtUualaAShMGqS2zf55TKp1nLo87hfXY
fssFM/aZVbCEhSl2uP911z47YBfRsWHNUN0tyAy4v4YZz17Hoi0vZvRF4S5PSUGz
gmy27qnlPyVQEkqADWZSlChIMFAI/GoE8dAAkKyqdpfCATgb9ZchqGJY77UAivSa
MC8M6q2v3K0UwWmvtf7HYSJjSEiPqbv7tuJMZX+JHAZR3os729hlNL56xwWeKt5V
7kLmvMqz/m9KQzXrdLvp
=2+KW
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
