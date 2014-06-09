Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaFISnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:43:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34241 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbaFISnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:43:42 -0400
Date: Mon, 9 Jun 2014 19:43:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140609184314.GB5099@sirena.org.uk>
References: <20140609150013.GA5229@opensource.wolfsonmicro.com>
 <20140609150435.GE5229@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DCmVMJei/gJT7wEg"
Content-Disposition: inline
In-Reply-To: <20140609150435.GE5229@opensource.wolfsonmicro.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] regulator: arizona-ldo1: Do not control clocking
 from regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DCmVMJei/gJT7wEg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 09, 2014 at 04:04:35PM +0100, Richard Fitzgerald wrote:
> Using the driver for the internal regulator to also control
> the clock frequency of blocks inside the codec is an
> unexpected side-effect for a regulator, and also means that
> the core clocks won't be changed as expected if an external
> regulator is used to power the codec.

IIRC this was deliberately coded in this fashion on advice from the
hardware engineers - there was more going on with that register than
there might at first appear and some actual sync with the LDO.  I
believe there was some different process to follow (possibly just
setting this mode all the time) when using an external regulator, though
it's also possible the hardware guys were just unsure at the time.

--DCmVMJei/gJT7wEg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTlgA/AAoJELSic+t+oim959cP/0/3jtI44v32TiiSfbOu1TJj
Mn3vlQNuNokV+TQt5TP7CtgsMibdtS+VB/wUAVOcDQfROYvczu2c4P2LAaF76UzQ
CXFMlGEI3rstB8WvkYgv+WNzmxdNU2z3XcgqEI82aW6fbTdqSDSfXeG4nlmQ4LLJ
V9eTjVqFL2Pvs7MARoc8IiU6eQ6JAo4QE064w7lKwYWc3pCzjg6LrT6Y4DY3ipUV
kCj66s4a7DNZOixYH1Im7z+UszEgkkEzCJpYCfVI7Ed9Q1/Ac6Bzg34rYF00SUl7
VrHakhWBQyKxy6XV5b7nzlkSfz9jETeP7W/SB7vCkDizqzVTw0y8n4qHEfFqq53k
HkcT5anVskZ3ePGYo670rAtHWDm3IPstfLZOAiu/3Dq3VhkPrnV0uPWDniuRRwMt
8sBP8IzRw8gGfJDySCih+p0rIzogHllfA/oG9Yvcwu8p5R9jffUjEot3pHdMyc/m
/zRAtvJ0mgWgjRm+7onIVprQaK6EIGZoW1GXVfGPJ9Oid/TOCG7LRzwGmnfUHgbR
45+aIfNB/xUI1moPuYya8FgltSxw0yWZxcaU68ZyjAbzl5mboLnQbYBkiuWi1KX/
L4wse07WI39W8EQih7odcYImTuFWBsbFWdyMANP9+8Ix7FNyY5elLQeJlA6ulDNG
UvBbwqFnBENPnkl7nDFK
=wJ7n
-----END PGP SIGNATURE-----

--DCmVMJei/gJT7wEg--
