Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3CMKXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:23:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50900 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755224Ab3CMKXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:23:03 -0400
Date: Wed, 13 Mar 2013 10:23:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: samsung: remove last traces of neo1973-gta01
Message-ID: <20130313102300.GC25610@opensource.wolfsonmicro.com>
References: <1363126175.3137.160.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Content-Disposition: inline
In-Reply-To: <1363126175.3137.160.camel@x61.thuisdomein>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 12, 2013 at 11:09:35PM +0100, Paul Bolle wrote:
> The (rudimentary) support for the Openmoko Neo1973 GTA01 got removed in
> commit 1ae5cbc52e7c6619a3f44b87809fd25370df31bb ("ASoC: neo1973_wm8753:
> remove references to the neo1973-gta01 machine"). Remove its last traces
> in the Kconfig file too.

The support wasn't rudimentary, it was a pretty much complete audio
driver.  Anyway I've applied this with a fixed up commit message.

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQFN0AAoJELSic+t+oim9DwAP/iQJhVjm91JrgipPMtlcxS2F
y7cs4SYGwMxFz/bmrhDRtnMuMLZvV4Vu2NcpRCEphrCPD50k2D/Ky6w1mbm7VaMv
cSPLL4m/rtH/1XkETBJjeB99je8NjdgcrwPQ5XstyGsiP7chtdaNjBn6Sv2cHbiy
VQouBtFHtcGrY5vr8WBzxA2d5Vt35IXo8r38AFoP/zArbbbSHcEjwvGY03S6yZS8
GSQguTDvSd0B7cr5e8pmZcHSyMydFajyozv1DDtEWifW/lwEroUoJQYWhEYz5ZJp
gzxi1k0m2avLjO0fS2l2ZoT/oKCocNkb5UQ7YzZGvC9wgeQ0ArjUw+5uDqxyboXQ
NNgKZ6Shp6WOoK4jKhqcV5cXNqN/m5VgSUn9DHOPNpimxSnHzxUizWHQN1pyQqv9
nsRm7gMXBo1MZiGh0dyUcxPMt4cfVCRwD74nJxWSc3LGivMYyz5JFznEJaeAARH1
4E5+VdE8Zxa+8x/Vssuy30od8wWiXm9YjFhpj3XKynya55OrNu/Rq2c8XnrESAGL
s4/SX8fIgvJCzUsR2l4aweTBRnPyQFcjFqwC5qhgB2ZVLvDTwNkkShuhNf/o6CeU
fwKzdWyWpMKTfmZMLyyOXeBRrLEy9DD6Tf3d+wft9RvRYMRO6o80Ws0LF6lsXQmq
Il8w5kmCBKs4ZrUImIwZ
=pAAo
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
