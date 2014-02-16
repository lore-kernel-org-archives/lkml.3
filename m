Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaBPRCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 12:02:25 -0500
Received: from sauhun.de ([89.238.76.85]:51069 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbaBPRCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 12:02:22 -0500
Date: Sun, 16 Feb 2014 18:02:01 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <chris@printf.net>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH V2 11/17] i2c: nomadik: Convert to devm functions
Message-ID: <20140216170201.GA2831@katana>
References: <1392300547-23365-1-git-send-email-ulf.hansson@linaro.org>
 <20140215150345.GD2579@katana>
 <CAPDyKFrt6QJVSypP5iD_oVxRUvNhzxGcbZ703zR1K8gwJ5uCeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <CAPDyKFrt6QJVSypP5iD_oVxRUvNhzxGcbZ703zR1K8gwJ5uCeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Would a way forward be to let you carry all the patches through your
> tree? I believe all but patch 17 can be safely merged. It is only this
> one that depends on the changes in the amba bus, so we can put this
> one on hold for a while.

I'd favour this. Will do this next week unless somebody objects.


--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIbBAEBAgAGBQJTAO8JAAoJEBQN5MwUoCm2ncEP9RSXythepEDVP+IEvvdsG2ZV
1u4skawn7w050umqejqGs/9hEyoE1GO8CSIDoY5TetLAdhTAXAllusLUyh5jb7B+
hVbcl5QuGahz9RETA3D8uKr71PdMFpUJFnO+KJvnrFGCbjqWC+ixmN7eHtIBDGl9
dPskR69fqmMu3p/FxXcGfB2frGxS04ZVzdhHKLp92IVyIx9m1pj/fkflatsGligv
/gLgSV1MphonCqnfdlCo1wvQ69nmd2u8v1C8nbWQIGoRBWrYCZ8DbkHyjM/MBhR4
3bfg3ttHJKrFklhdOIpxmoM3nih0Ms8h/gLPAuUyOHkfhdtWHne2Z9POAI6bc2w3
Cs2omPqr0Ay/el717koJNh508wjeo0zMVdLuV1szAp/G7HIGDAnCOAYP2vYhIW3e
5TbjSn5bHNkjNf7JXXB0pQw2uVUaZ+HPmJg35oRNrsvmYnFD8ZoRLh93aQaj7K22
O3UwcqfW3WIMKSU2R+GbhHYvmPA6vMZ7PvWdNHbwmoxKNEZ3ZS/w6x4H7ALm8b8D
OmgGHi2U9Dd0FcevTPLdFguZw4I+66AyvpY7VBuVHdxJwL+nzILY2IYd2xzq1eCA
eS52sf07KR6yVnxB7C4RBtq08rahc00jOkjidYPLwQKBTlshtnek9o5qqkVViC0z
oFq2/lpUkYjUtikhDU0=
=NiiC
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
