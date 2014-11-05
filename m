Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaKESLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:11:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaKESLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:11:14 -0500
Message-ID: <545A683A.9010301@suse.de>
Date: Wed, 05 Nov 2014 19:11:06 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Sangbeom Kim <sbkim73@samsung.com>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: samsung: Add MODULE_DEVICE_TABLE for Snow
References: <1415205892-5553-1-git-send-email-afaerber@suse.de> <20141105170957.GE8509@sirena.org.uk>
In-Reply-To: <20141105170957.GE8509@sirena.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="r3V1u0M1I5MEK3rM5npJAQx9ma9BChSJx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r3V1u0M1I5MEK3rM5npJAQx9ma9BChSJx
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Am 05.11.2014 um 18:09 schrieb Mark Brown:
> On Wed, Nov 05, 2014 at 05:44:52PM +0100, Andreas F=E4rber wrote:
>> This enables the snd_soc_snow module to be auto-loaded.
>=20
> Applied, thanks.

Thanks. I notice you dropped my Fixes: line that SubmittingPatches asks
for. When do I need it and when should I leave it out? I thought it
tells GregKH more precisely which stable branches are affected for
backports than just a CC.

Regards,
Andreas

--=20
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6rffer; HRB 21284 AG N=FCrnbe=
rg


--r3V1u0M1I5MEK3rM5npJAQx9ma9BChSJx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUWmg+AAoJEPou0S0+fgE/53oP/jVmzDeibIzjQ8MNQ8m1Imco
0htLGtny+vRwaK4Z6MgDP0ZJm+cBuVi2/cY7HSvWKj6CygAQSM3XN2fiylU7Q/PH
WGI5mvCcrK8evuJYmWAUzcMZq3lFqMgFrybvRfzBCxS+UYDMuPrisQ0F3vwcAuRq
yWZLoROXmlJJX2Ka0N4A3xss/b4HDE3Pvya4w3xstmUokXgOuuNcT2/69tN3zHdw
rz35gCLKXSdfNgeS7Q9KJ/Z22k+i8qUA9qye5Usyj0CubM6BvSgt/Na6Jb3G7dSe
K/EoyVomfRGKuB8NqtMOfCYPMrfll2U2XoNXi8IgrFDuU4Iw2DUOHzwzgbI8Gh+G
BHWYt3xGJWAXEf9eNZeH74gmZVn0jY+9fdeQaX7ScNO5c7uWEOHGcsGWECX6PhzB
sEgXZkVes93zELHAs7kG6Mb2CgaFmPwzF0p5961tdRGQ2WGDXfU/ibVavXU5fSm4
sM3GSkOh8bDjhyzyWRkpK7/cj4S7Ox+qNCDbI1szRTw6NnNgxE+PWU3wjjJqorB5
AMEfffjqcxaEyrBC2xkGHVuZtYJs3HGWcwwKywpDQScWaPeD5O9SwQCsCqoyUHWz
FfjpkmD9LcmOfs+aYvf9YV1oCBH998GSIjzPu0dCfswyFoL5hivSv9yPQN8qKBsk
lBE9OOOXryG6prc5da0K
=7ve/
-----END PGP SIGNATURE-----

--r3V1u0M1I5MEK3rM5npJAQx9ma9BChSJx--
