Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3GDOvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:51:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49656 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3GDOvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:51:51 -0400
Date: Thu, 4 Jul 2013 15:51:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>, linux-kernel@vger.kernel.org,
        sbkim73@samsung.com, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20130704145126.GB27646@sirena.org.uk>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
 <1372072858-6559-4-git-send-email-yadi.brar@samsung.com>
 <20130703180511.GA374@sirena.org.uk>
 <CAKew6eVs+D4Yf+9=e+0fj0UaZQ98gJ-1=CX30_H0p-xnF75gaw@mail.gmail.com>
 <20130704092249.GK27646@sirena.org.uk>
 <CAKew6eVWt==t3NZTwvULTBmWSHkAf6jNuPcj8p711st_7ZmRAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Fn2ULVzEyi3v7cW"
Content-Disposition: inline
In-Reply-To: <CAKew6eVWt==t3NZTwvULTBmWSHkAf6jNuPcj8p711st_7ZmRAw@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] mfd: s2mps11: Add device tree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Fn2ULVzEyi3v7cW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 04, 2013 at 05:13:46PM +0530, Yadwinder Singh Brar wrote:
> On Thu, Jul 4, 2013 at 2:52 PM, Mark Brown <broonie@kernel.org> wrote:

> > That's just an issue in the code if that is the case, you can test for
> > the presence of a property independently of getting its value.

> Yes, for that we will need an extra flag (ramp_disable) in
> constraints, to figure out whether
> ramp-rate is actually set to zero or its left (by default) zero if we
> do it in common code as
> now we have locally in driver.

Yes, I agree that makes sense for the constraints.

> I think its matter of assumption, so to conclude our discussion,
> please let me know that which approach we should use:
> - assume "regulator-ramp-delay = <0>" as ramp_disable.
> or
> - parsing "regulator_ramp_disable" from DT.

I prefer the first option.

--4Fn2ULVzEyi3v7cW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1YvrAAoJELSic+t+oim9p+oQAJCBZZPMrTzKMlLx2b33IPPP
xbI0XIJxvbPzaC+Z7r5ks0oVfWQrxW5It8iEO5kreQADRFxqdoczGaS0BY0Yo0+Z
slggDK9NFi726ksE+M5FF8axRLFGfdS11b8JsYvvwfR3V59c19ZDbdtHRSEHogh2
P47oPB18OX+Bv6B53aPcOfpx/+5Ddc0Dq+8qXv93EV/jcxE/6dBroGkGVqOoXM/T
onAx8x+SAIgvB+PHpfWjp7rbPVOOPcU1UUMSCuAjVqq99unfrtMM/FhhK+vGYJUG
NDXNoFBaO4c+rPYBzwuGV3dh+2Cu+LxecVs1A28geLJOMLdFQB2J3qyzzGkzRzFS
IvIqtZhP0rKR3Drm/k3P6gWKHQ3+LIvQhcNu/dn3BUmwjJBwNSj8nxDLGC65IVcZ
Pp44G7i2Rco8u6/e0tNhhV0SMo1sV3afY2iPNzEOK0ivJnaB1yCTFT6DEahdZx/O
ImKdzTlfj8XrMWvhIzNS421upGgK2ow1mnNnmgtDad67moMKoobE+w/VhmJVbRYl
9JVtHfXFCEmHQMT3wicgg1sDYgizB3yk3qaSHfWq8fQdQLHZrYVVLOCuDeV12PQA
XZhavN4gsYg/XmfUgvL8/vVehC2k2a0wY2II65sRwAM/JKlaVGIBAtj4R8+3ZkXW
oMc/e8MUtBijaao3AuFI
=xZJa
-----END PGP SIGNATURE-----

--4Fn2ULVzEyi3v7cW--
