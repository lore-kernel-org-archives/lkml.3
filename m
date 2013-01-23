Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab3AWQEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:04:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44496 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756361Ab3AWQEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:04:40 -0500
Date: Thu, 24 Jan 2013 00:03:59 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>
Subject: Re: [patch v1 2/5] regulator: da9055 change irq state to default
Message-ID: <20130123160354.GE4565@opensource.wolfsonmicro.com>
References: <C3AE124F08223B42BC95AEB82F0F6CED4313C7F1@KCHJEXMB03.kpit.com>
 <1358757312.11746.11.camel@dhruva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jTMWTj4UTAEmbWeb"
Content-Disposition: inline
In-Reply-To: <1358757312.11746.11.camel@dhruva>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jTMWTj4UTAEmbWeb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 21, 2013 at 02:05:12PM +0530, Ashish Jangam wrote:

> > What makes you say that there is a dependency here?  It's really not at
> > all obvious why a change to the primary IRQ signalling mechanism would
> > affect the internal interrupts of the device.

> Yes, functionally this dependency should not matter.However, if
> mfd/primary irq state is low and its components are high then it shall
> not look good. Therefore the term dependency was used, probably I should
> have written it in a different manner.

This logic doesn't follow terribly directly - looking at what you've
posted it in fact seems that the trigger type is irrelevant in the
function drivers?

--jTMWTj4UTAEmbWeb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAAl+AAoJELSic+t+oim9MuYP+wfg6d+9Uuet+WrRpD9CdXT6
ArA0tm90wr7aE3cGOqAoFBSU4v2F3nG9xTWyMGoTDs3R1GLSymn3DrbIg4eQsdL2
iIRa/fnM1P1X2y2m2cVWi/sVU7/u4/jKf/+OqLE/GXbkVxHIDDQz0yYdebpAKyy9
uzsHV4kmq7seP1eubixBLDc3O6BxXcqy0ydzYF00tAEgRkf8pRbMSyZxkVtzF146
ip0Ca+zgS6YlvM2vXZ+Qa+zrPOqU4DBBQZ2BaXSzjqnXRM8M4u7/MwDkBqB2f125
A3Nhezx43vWreYY7zRXo4U1TcdBkd0kWM9+EiYkZgXJkS4ijJ1GJLMdbu6Ps8W4M
RueBCS06TMr9YoBVPlx2EGqjNKrq4xkE8jumh1qqZ6JBdzPL+vqPz9giPRw0RK52
T3thc/XcwQbCPAXm+6hUBs2AMiALsaoSkvXhciUyJ8x0/NvAYnQ2U5ItPc8gyTPm
bg3USuDVqkahkbGU3Swq3hZIBMA4l2mi/kSI3VdAoHT8tHU9dkVXLBlvu4BJRqNW
0dKm0pQVKEMYqA8w3YiN65YNp72tdTZCuel/VuxTslA3zToxRfH803lt8IxjoZ5k
pKqyC4hNp43xs01JKzkSYUHflJH5fyOgC/8OULnPwYd8+50Zp6pEqF+p9ok6dbbx
aX/Kk+lfwZqoX6jAgPcJ
=/pz8
-----END PGP SIGNATURE-----

--jTMWTj4UTAEmbWeb--
