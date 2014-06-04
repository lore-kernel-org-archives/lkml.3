Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaFDLTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:19:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52982 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaFDLTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:19:00 -0400
Date: Wed, 4 Jun 2014 12:17:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Marcel Ziswiler <marcel@ziswiler.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Message-ID: <20140604111755.GG2520@sirena.org.uk>
References: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com>
 <39a8704a4c8170d6b0620a1e5e44042eae6d8810.1401665237.git.marcel@ziswiler.com>
 <538CA24B.1010602@wwwdotorg.org>
 <538CA635.4050502@ziswiler.com>
 <20140602221627.GP31751@sirena.org.uk>
 <538D64FD.2010909@ziswiler.com>
 <20140603094537.GQ31751@sirena.org.uk>
 <538EBACB.70100@ziswiler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fnm8lRGFTVS/3GuM"
Content-Disposition: inline
In-Reply-To: <538EBACB.70100@ziswiler.com>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] arm: tegra: enable igb, stmpe, i2c chardev, spidev,
 lm95245, pwm leds
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fnm8lRGFTVS/3GuM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 04, 2014 at 08:20:59AM +0200, Marcel Ziswiler wrote:
> On 06/03/2014 11:45 AM, Mark Brown wrote:

> >When you say "generic user space access" you are describing a specific
> >detail of how this device happens to be controlled with your software.

> No, not at all. In fact I did not even specify neither the exact type of
> device apart from it being a SPI device nor any property of the software
> apart from the generic user space access thereof implemented in the Linux

You're saying you're controlling it from userspace.  This is a
particular detail of what you are doing in your system.  You happen to
want to control the devices you are hanging off the system with
userspace drivers but that's just what you're doing right now.

> kernel. I really don't see any difference to i2c chardev which is already
> enabled in multi_v7_defconfig.

That does not require explicit registration as the device driver for the
device in order to be used.

> >This is not a description of your hardware, it is a description of how
> >it is controlled with your current software.

> Sorry, but I really don't know what you are referring to. It's a pure
> hardware description of some pins being the SPI bus namely MISO/MOSI and the
> clock plus an accompanying chip-select pin.

No, that's in the controller node - the chip selects are described
there.  The child node references a chip select number that the master
has and describes what's connected to that chip select.

> I fear for some reason or another you have some affinity against spidev
> which strikes me odd. Admittedly it is not perfect but it is the only
> generic SPI user space access currently implemented in the Linux kernel and
> so far did its job perfectly for many of our customers.

It's a perfectly fine way of controlling things from userspace if that's
a sensible way of controlling devices but that does not mean you should
describe it in the device tree in that fashion.

--Fnm8lRGFTVS/3GuM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjwBfAAoJELSic+t+oim9g0kP/21/0pU2F2LXOmH3xpr0/hkV
emJkq4yant0EYn3b2iG3DJS6LKVu4rXKnV/TyHeAHjJnxROGA1284YlZdiTxasxd
Fucib/fvMQVFnEIiyMmwhb/RLQbd7Ieui8ViTP0o7hmA43ZKZ/G0yIMWXAVE3Uck
Te7w5qrgZXsEg6/s+w/j79SqGCeBwlY/8A2dQzdsgn76FPbDrHuqrVEz/SOKwPoz
7OcPsWYSaesjLq2uU0Amt/hDp13WgEZvO2F6CQXaQMlbxP2eVao0ayA8ElS+G4g4
4ZDyw6wLwooXIuJiTh07la7PP9JmmZw8ymTdRI/tgG8Y4Qoyfk1GMAosFmIhBWFw
o/71CJSil4OkuOJO7bvHBF2ei7l9ZksB+J1ZaIXju/oUelM4I3bT7HRysmmmNvCE
aleTkdpKFJVxwfvYeeHkE8BYb9BAcMmdjkA1Lspq4PAiXsqODzwdIFkakVwc/SRS
QH0eIpiaVggSuIH3F/eYE55jaBPSlJtMGrR5JyKIJpA1CYc3JILWir6BW3SWNzJ5
0dvYpWEeaP5SulTNiRk+EpZQ2LB0tpImF7aE1xVMLjFm06X89amqzgnCFuV7MAT8
KPogyqmoJmW2Nxcl+Jo3vcQzk8bMQhOqxeEh6dKOewL6bsDxMjJabDvYWqWD5X5B
2JUWUObJXL1Hz3UB75oi
=6UGA
-----END PGP SIGNATURE-----

--Fnm8lRGFTVS/3GuM--
