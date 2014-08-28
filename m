Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965799AbaH1KCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:02:21 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37537 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466AbaH1KCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:02:19 -0400
Date: Thu, 28 Aug 2014 11:01:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Javier Martinez Canillas <javier@dowhile0.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <20140828100155.GK17528@sirena.org.uk>
References: <CABxcv=k2PH-BksYyWirAoL=DiVuy+O=Y1c+pMO=EK58XNKMsFw@mail.gmail.com>
 <20140828082838.GH17528@sirena.org.uk>
 <12F88867-EF9E-4BCA-9209-6879A39F3DEA@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OpZSSQvgLbAoe6V6"
Content-Disposition: inline
In-Reply-To: <12F88867-EF9E-4BCA-9209-6879A39F3DEA@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: max77802: set opmode to normal if off is
 read from hw
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OpZSSQvgLbAoe6V6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 28, 2014 at 11:59:16AM +0200, Javier Martinez Canillas wrote:
> > On 28/08/2014, at 10:28, Mark Brown <broonie@kernel.org> wrote:

> >> Yes, AFAIK the bootloader (none of them because Chromebooks use two
> >> chained U-boots) change the regulators default opmode so once is set
> >> to OFF on .disable, that value is preserved on warm reboot. This made
> >> sense with the Chrome OS kernel since the kernel always set the opmode
> >> defined in the "regulator-op-mode" DT property and did not relied on
> >> the bootloader to set the most efficient default opmode.

> > I'm sorry but this is just really unclear.  Does the bootloader change
> > the mode or does it not change the mode?

> I meant that the boot loader *does not* change the mode and is Linux
> who change it, sorry for the confusion.

Ah, OK.  Like I say that's a separate concern to the one Tomasz was
raising - he is worried about the case where we change the mode in the
bootloader but only on cold boot.

--OpZSSQvgLbAoe6V6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/v4QAAoJELSic+t+oim93NgP/3TjNBtUmbb8so98c8Si88pI
1v9+BE6Djk9geRZyQoeu9ndHoTMPQi/qqFGv8PtGAzSSiqXS4DVRYylKs4V3dZgx
49nNJV79wRtsHGO15UzRwABhnNX2IvKtP73rau1qUrY6mBWr+mRLIUwhqRWv54lB
PHANouhkaGU08uZA/b22qprQgT80sef1CJpWzFsCw5QOrmtKk1fhfzUjvKJ7ceYp
5WdL/DTpjN43VdguzUPgO2EllawNMlYq6WysnblKqfgsZCtAYzeMU6fNA0qYmeuU
ehkgRCnT1RMIky1AU4khLo1X0OOyquZYS5OiUpIQb0cE/sNZ1AW1wISNarM5Dwzh
vh/JzcPtZvDazPKKUrbsODI03JXaT5pbv/KGEsqUAue1XmE7+hLwgIlsn1XfmAW/
pBPLKwT4cQA/RSdyLLkIr67eWg4vw4X86v4S3CYTAkZ7LNjeB/DjwHgXxofITHYv
DbRyQHCZNblmGVt1KRDsAQBNanmw0KLPg6OWbFxzg9t2ZTf4MUE9ELSznQ2jm/Nz
x9ZOphbqAo0BzefjuHnI2jygewQrmKCY4yWSJjQQGonYsfVkawiWgO02wZyicFYN
8V1URIMEZZL95XI9fS7ZxkzFWneWVpyUtGU+uaru2guVjkvPeZsVMUZeHZMj96eo
jf03U3AKDBV1sTUzHprO
=Ltrj
-----END PGP SIGNATURE-----

--OpZSSQvgLbAoe6V6--
