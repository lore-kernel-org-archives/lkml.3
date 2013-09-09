Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab3IILGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:06:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60746 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3IILGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:06:45 -0400
Date: Mon, 9 Sep 2013 12:06:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <20130909110640.GV29403@sirena.org.uk>
References: <522BC27A.5080303@att.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DMefDzZywwCHZelG"
Content-Disposition: inline
In-Reply-To: <522BC27A.5080303@att.net>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: "Virtual" Interrupts -- Need help please
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DMefDzZywwCHZelG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 07, 2013 at 07:19:06PM -0500, Daniel Santos wrote:

> So do i create an IRQ domain and then call generic_handle_irq() from
> my URB complete() function? If so, which type of IRQ Domain is
> appropriate for this? Unlike typical platform devices, these are
> dynamically added and removed throughout the life of the kernel,
> adding to the challenge.  So, if I understand correctly, my base IRQ
> number needs to be dynamically generated.  How should I manage this?

Unless you have a particular reason for using something else you should
be using a linear domain - that's the default, it's very simple to work
with.

> I have some secondary (and less important) questions about how to
> integrate this with device drivers that want a DT / open firmware
> config (which I know almost nothing about at this time), but that
> can wait.

Could you be more specific about what you mean by "integrate" here?

--DMefDzZywwCHZelG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLau9AAoJELSic+t+oim96wUP/09mfCGPZvabHN4C+vgZYLtD
SqfpqyrDQWch3CrfKVdvveGcfKcmegsiDCM66okzO2Y9A2+B/kAvmHkdGWh+IcXA
gEKhukQTMUpyR16kC+dUXFDWj7eAmSMH2ZVdB7EaHxBapcswXnQmTlUjOZFpZNnQ
BjUmNDXsEoQ+yzDvupsuLEQevQV0vLRIh+G7SJXHYRjF0TspL+x+MB7LxUN/0H15
SF1HhKdykY/W4Dkjq90euDHmHJV3Wu5c5syqePQTxTHqyuFuJsjrDLrItbFYG5B6
rXLzHA3LrEYqLgB5t/bh41AssE6h9F90gMq/H54pG60wOhN03rFmi9VLQUEMaiTp
NaCKI0HwIiBclllVBggAU8VX16sisleRsohpLBIiMcy593hUPtMOheVPJfl1Fx4M
oZUdFNUhpEqa2nNLQzdwOPOcWk6MmPjkR/waPqbAyTvGwzoiIIWq7Cc5AHk1agAd
I+VAEMlhW9kIswO6yFF/qpPBA/U7+b4Tb4pYXOn36Jm8Uh1oB1Z0nt5FRiLCrS5l
9ONKAPipgVplYnLC1uAsHHPocvm3exIPO6c3Lqf/2Vv6p//NxuhRT+nkAGJtHmu/
0n9/KhmYCrP7+zyIOw7PKNvly0Lct2DqTsMQrRu+wvXO2BJxQ+aQybJ9kVKCfzAR
TzRiFFmgghwcxB88/PIy
=JDp2
-----END PGP SIGNATURE-----

--DMefDzZywwCHZelG--
