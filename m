Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaBTAgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:36:55 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47318 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaBTAgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:36:53 -0500
Date: Thu, 20 Feb 2014 09:36:39 +0900
From: Mark Brown <broonie@kernel.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Message-ID: <20140220003639.GF2669@sirena.org.uk>
References: <20140218224433.337299968@linuxfoundation.org>
 <53054956.4010602@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4n+RFTT0RsAMCzk1"
Content-Disposition: inline
In-Reply-To: <53054956.4010602@samsung.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.224.205
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3.13 00/40] 3.13.4-stable review
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4n+RFTT0RsAMCzk1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2014 at 05:16:22PM -0700, Shuah Khan wrote:

> On Intel systems, there are no dmesg regressions: emerg, crit,
> alert, err are clean. No regressions in warn.

> On AMD systems, the following new error messages - suspect is to
> drivers/regulator/core.c - patch

> 3.13.4 - amd:
> > sdhci-pci 0000:02:00.1: dummy supplies not allowed
> > sdhci-pci 0000:02:00.1: dummy supplies not allowed
> drivers/regulator/core.c - patch

This is nothing to do with AMD or Intel, it's to do with if your system
has a sdhci-pci device in it.  This shouldn't result in a change in
actual behaviour, it's just a warning caused by the fact that we now do
provide dummies for other devices.

--4n+RFTT0RsAMCzk1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBU4UAAoJELSic+t+oim9rysQAIxH/zhmycBC/JBTOU9bI0V3
imBSbaSsgm50tNrLVQKW/+ibwJ1dZyU5sLQEjy11JvLKcIM7LMNiVm9pm8wkeMy6
mg7TDuNYe85w6rYil938u34lxbSzqZ5jwvajxh8f5Fd8KTZeKC1k0MO6uwshPgxd
oA1lHLbm6TupCm0k5ILo7A9PjOfbvCUpUle1FMZyTlwoX1z07C0UT8pnKg4LFYHM
dh2L++v8uDj1AHLZgSjOfqCR7iSySGmqYRTP8ppjL01TB386R0EqlrCHhOPqk3Xi
B4gD0I3srjopZESTMYl7iCRVpJUWmISH1fDURqzkha3T/iFh0rQYlt4UCwSj8I+j
82AqXabgKFJIR16isXXOu0RRSonQipHL+dBaOlOdARj/aI7U4GVAfVB5MmOmGO09
cxdRecwRZmS40+SLig2qv+hg9jOCprtOeY5cEx89FS0U/15CYj/yHaYV8lOkY4HV
nk9iQg+0W959WXKROmjLEgO5vdWH7nQW0hxz1t+X2MI6AUGjboJi9Ka7JR5PK8M6
sfq79MV5ut236Ee/XVAZIR8JxUxG/MoVpA2qSU06mbTMsKx4TCu0q0VO+V9tR2LX
oKC/pvNyyWoSBi8771O0nnFtewhSpUpygNbu39KxVvGJtg5PcgVURjvm1WDTr+G6
IsgVxJBHe1haf2efl9vo
=eqTf
-----END PGP SIGNATURE-----

--4n+RFTT0RsAMCzk1--
