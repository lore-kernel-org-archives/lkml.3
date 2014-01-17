Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaAQP5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:57:22 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56027 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAQP5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:57:19 -0500
Date: Fri, 17 Jan 2014 15:57:08 +0000
From: Mark Brown <broonie@kernel.org>
To: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com,
        grant.likely@linaro.org, mika.westerberg@linux.intel.com,
        grant.likely@secretlab.ca
Message-ID: <20140117155708.GS17314@sirena.org.uk>
References: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
 <1389689198-2641-4-git-send-email-rui.zhang@intel.com>
 <20140116122704.GD2617@katana>
 <1389877509.3010.15.camel@rzhang1-mobl4>
 <20140116194651.GO17314@sirena.org.uk>
 <52D8DDD4.10704@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZmeoGP/RI+eIV+cU"
Content-Disposition: inline
In-Reply-To: <52D8DDD4.10704@linux.intel.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] fix module autoloading for ACPI enumerated devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZmeoGP/RI+eIV+cU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 17, 2014 at 09:37:56AM +0200, Jarkko Nikula wrote:
> On 01/16/2014 09:46 PM, Mark Brown wrote:

> >This is needed for ACPI because we rewrite the device names to give us
> >stable names.  With OF for I2C and SPI nothing bus specific is done that
> >affects this stuff so the default behaviour works.

> Sidenote: actually this modalias/module loading issue is different
> and not related to stable ACPI i2c/spi slave device names.

Oh, I'd been under the impression that it was the rewrite that was
triggering this?

--ZmeoGP/RI+eIV+cU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2VLQAAoJELSic+t+oim9/IoP/jwV9eQlcNzANS8xR3W2qTzP
F44eYYTUYbgUffFQkSi1KrJZrCgn6x9/tqBj8+fwUMuahcIy+PIQX4GoPvvcpSh7
6lZZF6av22aPhecIkYN+NA/MdDS1WB8EJzWULruq8G7nCpiywTcZRkQDk295m/oR
cFMCpYq0PbqqXPrLWbsL+cCPuA4wv4vYwVHyIPTj5DKc66nFl6TOXOJxeL4V3ZMR
sdaYUudgn4YOxxVSeb6wS72EehecyXaP0ufOCgTyMpUzx7DF4icmhqkBrrfzuGqC
4R6Tojn+SJlZG9AN8iLFpsXyizGS2tnViPewN7ilgletimPelAnPisdwHI7ujPUp
mUbp8pSVW0DEJ6omD6tZo/UECfaWFpmlgJga+t+nzr6sq/KMcycxC2hl3f7HdSFI
Dzt8VZd4TAfA586nDTwJUaRsmLYv7oNJYeth+y0TodUWXLHmA7K6jbiJ0U1xp3r6
V9+zFnz3DFo0lFu35i3Cn7BZlmg3BVdz/aSFv+8jCHiNSamkQ47OrZNW96BTjLEh
5XZdm102m/l7of3WUV0UHxUkAk3kI7KkA3JzFvtOw0kEIi4hX2OVmIvvt7ucexhT
kPeiUXjbTXcnVXe9VdNk3+W4PL/c8pZd7vSveUeaoU6BhR2gqcJKVp+Vgavl6EsY
mxuJhPk0NehTlEiyVzjo
=FIsn
-----END PGP SIGNATURE-----

--ZmeoGP/RI+eIV+cU--
