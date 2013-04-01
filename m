Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab3DAVWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 17:22:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43538 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756876Ab3DAVWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 17:22:24 -0400
Date: Mon, 1 Apr 2013 22:22:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: codecs: remove hidden prompt
Message-ID: <20130401212213.GA23065@opensource.wolfsonmicro.com>
References: <1363118918.3137.143.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <1363118918.3137.143.camel@x61.thuisdomein>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 12, 2013 at 09:08:38PM +0100, Paul Bolle wrote:
> The Kconfig symbol SND_SOC_OF_SIMPLE got removed in commit
> f0fba2ad1b6b53d5360125c41953b7afcd6deff0 ("ASoC: multi-component - ASoC
> Multi-Component Support"). But that commit missed one instance. Remove
> it now, together with the prompt it has effectively hidden ever since.

Applied, thanks.

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWfptAAoJELSic+t+oim9hVsP/1im8Tjraf8Wt62eDJi4p1TQ
20bCaz6gmf8Kw1640gSazCjMuTyOnfTR9XhZkYd8MEGZgXHlH5k0hY4JmdzNSHnj
pdoy28IKeb6tnAQ+xKXolKGoHqcgqJt4OMLsKlb3yLx0oxot3cB16CwJwONQxUPs
jCkofJqqblSECFWGXLUULB9E3KpslDNYRHWK1JxQMqs9GMFmXwD1hIKPnIaldZS5
vtN48dVnjrl25no+u+/UKlyWrE4HrFrdePAbjnM2npqCYPk8clwrpZ0y8PWodfNz
adj8Gz+ow8o9hgHVLuz4qboKZEgj9C/JHFUMuFjQxZ8AUu7/KVt+IrLeU7QzWFk4
FqY9BzxQVGHvtovs6bZGb60geE/CKTOJzkLi4su02nbwoYcyKccFGapeG3K/SWU/
aBoUhnkgWhFwBmz9CKB8o2QEmb2fnPEnWN/mCTXnOc+Cwt8Ht6Tha/Aaub89K6DU
/izq2vXF7j4FxkJtjx69LyXhogBie3SD3DVUSKKB/uvbRFrrco3Uy1kDhumzYIdk
0YOppSblfwX1/ZFiK7mshbOvH8l2z1iNap2S9lgCsOmU+tSnBjCduqTVT3zxEfo7
SifQkfXVs+9JUHBZScTgNTyxsSnsaOYOE7qzhLjGI2i5G/kL++9YgR2UnMkDVD+o
tmVkrwL7rwOLtRatk/fE
=gUcG
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
