Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaAPTv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:51:26 -0500
Received: from sauhun.de ([89.238.76.85]:55761 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaAPTvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:51:23 -0500
Date: Thu, 16 Jan 2014 20:51:15 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Benson Leung <bleung@chromium.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, khali@linux-fr.org,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Duncan Laurie <dlaurie@chromium.org>
Subject: Re: [PATCH 2/2] i2c-designware-pci: Index Haswell ULT bus names from
 0
Message-ID: <20140116195115.GD4127@katana>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
 <1382326010-4554-3-git-send-email-bleung@chromium.org>
 <20131021065804.GX3521@intel.com>
 <CANLzEksGqD30Cefh3r2urH-ToxWzkxAnTJZiY07yX2Py58FQPw@mail.gmail.com>
 <20131114180538.GK11022@katana>
 <CANLzEksP1nRfBaQ3-sSouOYL4C+oLKiE75eHfFdEzLmrQKn3dQ@mail.gmail.com>
 <20131126130959.GI7427@katana>
 <20140103155217.GG7132@katana>
 <CANLzEkvgYQtkEyOMNpPcS9BeYzX3zJn7hvtsyhFzbDpViS8-2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Content-Disposition: inline
In-Reply-To: <CANLzEkvgYQtkEyOMNpPcS9BeYzX3zJn7hvtsyhFzbDpViS8-2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9dgjiU4MmWPVapMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Our devices and our platforms have some other requirements which
> turned me away from using i2c_register_board_info.

Okay, so I'll drop these patches.


--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS2DgzAAoJEBQN5MwUoCm22TEP/3QwocSIiYTHfi2G+go0hlzi
raoUbSHZWeJnf9BWCN9DPVR6nxw9PCiaGIHBdHZTpMOyS7Gspu8wt7Jgdsl00Kzv
Sre2nGDQfuXMqsuOw+G2rvdi4yOIcbsNl1frgTc63nm5IuBbewdQqTmSCcg7rkwZ
mW5+1PMH+S1c4fmRLpc8zuEumEI5w4jINz7/mMHIZQEtr4VGMqdoj9i8jr3Jkbk/
k3JRW0cUA23aVka6dvMj/BLMn4MwLUNyfJUDyN9fQP7NNFm1EgRvJvoFXxELwVA0
NbXA5EuUPo+aTD6If5yT94eTjJKziCCPYssFvxwBA+3TRYGSO7yvkldoOg7Z1udh
TqCgPTjSw/+Ozy9ZUD1KPjjdRo2qyjSnnfK8RD4Al21LMxt/FPVMr/Kl9EbjtbkM
x5tQI3qp2J5EE7/Si6xhEKCP0y1BMGfeyGI/fgVgJBHjocYR/+jSt2LkfwkRBJF7
aONst2rU4zBoSn+gxMk2t5PnIBOHeX9kilGGjtLitCCW5x2E+LaS4N7KbAizOcX0
LZVu7S78iDWoVWEPqzFC6hZ7CFiG+YiYnmQPulB+Wxt1pi6Sy0WesyQMn/Fsg5Q3
yKapq8ed0NSB7OCgqE+EwMFUXscQzw1kTOPuWmrwuJSVC4bLjL3nZbwjks/gwqsB
OPBThC4eR5ZJU1tHzdsn
=nR6j
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--
