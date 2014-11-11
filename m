Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaKKMnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:43:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33006 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaKKMnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:43:15 -0500
Date: Tue, 11 Nov 2014 12:41:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141111124144.GW3815@sirena.org.uk>
References: <1415364314-30320-1-git-send-email-laurentiu.palcu@intel.com>
 <1415364314-30320-2-git-send-email-laurentiu.palcu@intel.com>
 <20141108104606.GH2722@sirena.org.uk>
 <20141111123808.GM5826@lpalcu-linux>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jH8DeoQifCS4QviE"
Content-Disposition: inline
In-Reply-To: <20141111123808.GM5826@lpalcu-linux>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: add support for DLN-2 USB-SPI adapter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jH8DeoQifCS4QviE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 11, 2014 at 02:38:08PM +0200, Laurentiu Palcu wrote:
> On Sat, Nov 08, 2014 at 10:46:06AM +0000, Mark Brown wrote:

> > You shouldn't need this _put(), it's defeating the purpose of having the
> > devm_ registration.

> Agreed! I used spi-rockchip.c as a template and I took it for granted.
> I'll remove this line in v2. And, if you think it's worth it, I can send
> a separate patch for spi-rockchip.c too.

Yes, please.

--jH8DeoQifCS4QviE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYgQHAAoJECTWi3JdVIfQzzAH/2tu/vUCCmp2kgdUHXo0uo6c
1//BSVKMzNypRVrTI8htGAo6Y0VSmV8EaEawlc51qVOgxuA4b6K+YCcFW0Er/zp8
EhtX8g+81hbGVJE0WxZuHqMhM6s6A/RV7QIUXbUoNrV8cZbiey2ZQNyjy61JKTm2
tp3SFd2jZq/D4mgdbEJ8VZTASPpSAP8Lo8ITjB46p8ytS4k0i4e6rzsDeWb3/Xrc
9zEFAYk7KGtJ4IY8zn8YeDQ7MApbJu8rJVAA2U3dP0q7E8l96bNTd3S1GwwKnTVD
mS5KC2AseLeZGzESt9fS7wkFwA5i1Ed5r1wsRonB6o24WykSTO19btCEsuHre9Q=
=TPB6
-----END PGP SIGNATURE-----

--jH8DeoQifCS4QviE--
