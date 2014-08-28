Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936290AbaH1I3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:29:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37347 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934238AbaH1I3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:29:04 -0400
Date: Thu, 28 Aug 2014 09:28:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier@dowhile0.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <20140828082838.GH17528@sirena.org.uk>
References: <CABxcv=k2PH-BksYyWirAoL=DiVuy+O=Y1c+pMO=EK58XNKMsFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FtoCNUwdcqbKhyPv"
Content-Disposition: inline
In-Reply-To: <CABxcv=k2PH-BksYyWirAoL=DiVuy+O=Y1c+pMO=EK58XNKMsFw@mail.gmail.com>
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


--FtoCNUwdcqbKhyPv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 28, 2014 at 12:44:18AM +0200, Javier Martinez Canillas wrote:
> On Wed, Aug 27, 2014 at 11:03 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:

> This is the case for Chromebooks as well but the solution implemented
> in the downstream Chrome OS 3.8 kernel is what Tomasz suggested

*sigh*  This is not what you were describing, though most of what you
then go on to say doesn't correspond to the issue Tomasz was describing.

> Yes, AFAIK the bootloader (none of them because Chromebooks use two
> chained U-boots) change the regulators default opmode so once is set
> to OFF on .disable, that value is preserved on warm reboot. This made
> sense with the Chrome OS kernel since the kernel always set the opmode
> defined in the "regulator-op-mode" DT property and did not relied on
> the bootloader to set the most efficient default opmode.

I'm sorry but this is just really unclear.  Does the bootloader change
the mode or does it not change the mode?  You start off saying that the
bootloader does change the mode, then go on to say that it doesn't and
that the system relies on Linux changing the mode (which is consistent
with what you were originally saying and what you say for much of the
rest of this mail but not with what Tomasz was talking about).

> Also, other drivers have customs operating mode DT properties, please
> take a look at Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt:

Per driver things can potentially be fine, trying to define generic
properties is much harder.

--FtoCNUwdcqbKhyPv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/ugzAAoJELSic+t+oim9/eAP/31xRVon8OM6Xeh0NLiRpzDK
2n1JhH2YiDel5IsQzpPdwsX5E2sy0rlCYPxVe7Cf1e4JXN/dVUbGE06AEMx6JXvc
nbwgM57WOm1JqZifXuW1m+502PgkxagV+6TgUdHFXuHKfJDFnnPT/aAT8jMkKKGi
JGPZF//1VmdspHPmxaxB4Oxuj+Oo+BeZLWnOAuMHbu1y1dymfsostQwqHIjRZsYi
xsN+xDrHFS72tcWU/212bz6dhcoh7mCCH9dwFW6unPOV/hMqsZJG1BJVvKnyx1sk
wZQERWtHspZleEM/islsBIzcM234Q3YYUbfGmGH4LeMWkksaAsKrLY/UDLl221hF
hMWAlDigMcrpAXp9JTkiUgjU8/XJ0Q0fEXIBZJ7pxCZVfF7z8Kn272txJTFEf2gD
VSykBC/t1LN//antMv5/mA5hcMvRJE9RTAG2fuSUVjUVmKLW26eKdG88EijGuOSN
7CYv+6WC4Fh8f5zGGvZpHkw0ZwCwzP/C+3r5/ddT6GluTPOkIeaO9Z80Uy5DjJtD
0y77saLri493wTI7zlb+QY8nGKzHeiid5n4ArARXpWcQuZNZ25PeDHWLoY1SqJtt
A1JcN+ueZ66FN5+OfY3lda2CZqGHJ383fymI0ezwQasj6Uptgy7LHBDUhwfZOp7V
Xx4LBKOE5TqHShaYneKT
=PjJD
-----END PGP SIGNATURE-----

--FtoCNUwdcqbKhyPv--
