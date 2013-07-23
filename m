Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab3GWM6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:58:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52921 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab3GWM6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:58:01 -0400
Date: Tue, 23 Jul 2013 13:57:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@vger.kernel.org
Message-ID: <20130723125756.GZ9858@sirena.org.uk>
References: <20130723104641.6ee0b9ec@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B5JjOzmn0Nsc+m1x"
Content-Disposition: inline
In-Reply-To: <20130723104641.6ee0b9ec@armhf>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ARM: kirkwood: extend the kirkwood pcm/dma driver for DT
 usage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B5JjOzmn0Nsc+m1x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 10:46:41AM +0200, Jean-Francois Moine wrote:

> +- compatible: "marvell,mvebu-pcm-audio"
> +
> +Example:
> +
> +pcm: pcm {
> +	compatible = "marvell,mvebu-pcm-audio";
> +};

This device has no registers or other hardware - this looks like a stub
device which shouldn't be visible in DT but should instead be created by
the I2S driver - look at how most of the other DT platforms using
dmaengine work.

--B5JjOzmn0Nsc+m1x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7n3RAAoJELSic+t+oim9dNUP/3IjP2kD7nXYhF3Q+lf0c6yP
s82/82I90Meg63GFu5XbnLEDrWxzkRC0OivNLNuQ3sOZ4U1szve8bA2mqtNMPY8K
CHVTV8U73mf1YrbeDr1MvfR7VqzQ5gBwCejOweX+7ufJ/0n9wibVyJziPohqGAU8
Y6JNHakNpeK3QxjikMwoysl0WnkES6qRumMmq4Z+S+dgn91Th9WKU6ioBZY49Lzv
W2gJ9HHMB2IKxkBd/KxFCSxqZfZepLOFPCJZ46uSzeL7Z8tBY7kf1nsmZWZcKeWY
QE00jpFl7Ccn0bhYMg+Cli6oJzQ5b32aWvTCSpU07AsmDXqLZDDRvJJMCcSvwkd6
21/mAyDJGNaNNULaYK6rm9XdAqzV2K6w0AFsyCl3VM7TQuVancA74+JoIcyBk5DC
UWoDS4Oi4Ya4Cjudp/wBvV+HgjNWlbvn40NcoOa+2gjPLp++d4SP3APmeHMMUi3/
w2OXJxgL9mmOrfeCfG6B+1Ab7xuCH+0y+KG+MALpqQrbZqqGP81fPzzNsN8gB3I6
YqXunumiH/9GhKttzlDpT282dMm63abv1VNF1qH/bvL+VPYZrDFOIt9uOdXp3Cav
bPF6Ey6JOEG/iNItBKuYkz41tMsay2aBn0c0eJRtEcG1n0y7PtL3Q6cD/OjIqCPG
qA/4F9rH7LpxqJuUXmKZ
=EhT2
-----END PGP SIGNATURE-----

--B5JjOzmn0Nsc+m1x--
