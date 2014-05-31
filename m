Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbaEaNsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 09:48:16 -0400
Received: from sauhun.de ([89.238.76.85]:55542 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382AbaEaNsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 09:48:14 -0400
Date: Sat, 31 May 2014 15:48:06 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: Make I2C ID tables non-mandatory for DT'ed and/or
 ACPI'ed devices
Message-ID: <20140531134805.GA3287@katana>
References: <1401452797-29521-1-git-send-email-lee.jones@linaro.org>
 <1401452797-29521-2-git-send-email-lee.jones@linaro.org>
 <20140530123656.GC2742@katana>
 <20140530133405.GB29731@lee--X1>
 <20140530174800.GA4917@katana>
 <20140530192516.GA4319@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20140530192516.GA4319@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Right, I read the function which provides the functionality, but my
> point is; I don't think my patch changes the semantics in a way which
> would adversely affect this option.  If you think that it does, can you
> specify how please?

Currently, if a driver would be DT only and does not provide a seperate
i2c_device_id table, then the driver is unusable with method 4. I don't
like to have some drivers being capable of it and some not.

> Does the sysfs method create a i2c_device_id table?  If not, how does
> it probe successfully pre-patch?

The sysfs method creates a device. Its name is matched against
i2c_device_ids only since it does not have a node pointer for DT to be
matched against.


--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTid2VAAoJEBQN5MwUoCm2hMYP/jKCgTIbnDG18sgyWdYlHw+I
CLQA0Q4xnfTxoKF5CvWUbGt93a356LIqzGIZF9J6dm9U7FCZ/GB8lEZnu98APIFD
P0bAw5OmSIg7cNNrwgeg4rNZ7AB3Hf75jVWww70BGp/p//EKMGt5IA77YRYf68DV
TKJUY4Mxl3Q2RDtSNKwFu5uEqF1bxAsFldlTn4HJgeYDsFlQ86UC+xhvApzTolBH
saf25xiDqb+o1AVYpWRfkORl+stK4SnDekDfxRbmo1Mczuwg1jgED1os9ARVtTJY
SiA9aQvVrwFPKaHWkjAqoMTr2gNmqmgwUEwA0r+j/aupWQBrJ2Wu/gxM5dLLtzdc
e2QEuQSQj+xQ4meEjETMZ/OQLE0XywYJjfYr0syFQbDBmMWH4XDqccy05rzXOWw9
WtiuXEqP/nzE0UgbnQJztv1ldtnqoV8jWI/G6JHoYY7lq586jB/XEa73a60WCJYE
r8ClFhbg1CPvozXgXXtyAf2MxABP9r4o5swwMW4tJxPLDNYDo36rPin3yKPHUoos
7QcSVN60yd4tzg3WaHrg7+5o31QYuwPCKHLl21WJxKoe/Sl86DzRKtw729sjXaNB
+I4b8A46FIYU3V+8p3bzFYUL9buHOZrsHqxDBNRxdD1EmKyiesNbNXye7AEpQ66/
6Nt6LpR/P80S0/0lJSpJ
=DimM
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
