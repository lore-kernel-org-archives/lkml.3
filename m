Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbaAVTDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:03:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58262 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755656AbaAVTDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:03:46 -0500
Date: Wed, 22 Jan 2014 19:03:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140122190316.GT17314@sirena.org.uk>
References: <20140115165128.479994c3@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q+oMmc1K1xhZpILv"
Content-Disposition: inline
In-Reply-To: <20140115165128.479994c3@armhf>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 0/8] ASoC: simple-card: simplify code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q+oMmc1K1xhZpILv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 15, 2014 at 04:51:28PM +0100, Jean-Francois Moine wrote:
> This patch set simplifies the code and make easier a possible multi-DAI
> links extension.

Just as a general thing about this and the other simple-card patches
that are floating around: there's a lot of them all working on the same
things.  It'd be good to see more peer review and testing going on,
mostly there's no comments from other people working on the code.

--q+oMmc1K1xhZpILv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4BXxAAoJELSic+t+oim9rRYP/2snpMzp//3GGy7PXbi+yHa8
d9dIsvhpI1rwlvzoJP32njHoh9YbwjjlqBkc+pTPeYRcBTL2O+8KpmSM2I7e7I8u
P6hYreDb1b0woXMBT75W/J3se5D7vAv2JnT7byk22x3GrXbDULnDakRzY5VBTCl6
pw2vYvL/AR7LpnGvpXwJyVCsuN12ayF2Jh1YtXFHhwF5s9aVIxBuHkqn7CtE8/H0
JH4Eg6sVXqyxKXKz1015jWIbk0IQ14Gv2lZg6qIVy3bOI6+HWbQCMhbxaaecAmx3
cCVuLxQr4ikCXxxmXWp4TKuwgZwqkHMwK2n0gUubj2YGmjtQ+SSwNGuqV+h6AZon
0KADwKBY/Ffgysl6uN3xlL3xtHO9waeHhfofqFc/UvIYOnRNgjvNz/p/WcWxUoJu
rbRkIJy9oso9uS9DJdQEpWjQlWFuirfEvg+4fwTsm9dQ385jGy6FRxNYG5NvhH8K
1y3IFZArYPBb9mwfxWAInG09jy6/3qzdHE8688ZexFaa5SDbOHl6jtoiG0b5IJ/u
FwNzNCpkF0dcDXEyUbLGVTmLjQYWrQmQ6GcsCXFDbv1yALU4Te6QvmnI/XAfQNnp
trkFsu4w4SMcGCvPyJS9aq12HFJJMeuiI8ATWxfoSQ4kCRtvCFBYp2A39CYzOwAC
z1NpzINgZDenwjRQ21CC
=ZXuV
-----END PGP SIGNATURE-----

--q+oMmc1K1xhZpILv--
