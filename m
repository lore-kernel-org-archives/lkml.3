Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3JQJlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:41:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50863 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3JQJlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:41:16 -0400
Date: Thu, 17 Oct 2013 10:40:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Timur Tabi <timur@tabi.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20131017094054.GJ2443@sirena.org.uk>
References: <1380773722-1295-1-git-send-email-linux@roeck-us.net>
 <20131003155816.GU27287@sirena.org.uk>
 <525F4421.3090404@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="agVz1gqRg0BwYviO"
Content-Disposition: inline
In-Reply-To: <525F4421.3090404@roeck-us.net>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_ssi: Fix irq_of_parse_and_map() return value
 check
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--agVz1gqRg0BwYviO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 16, 2013 at 06:57:53PM -0700, Guenter Roeck wrote:

> do you plan to send this patch upstream anytime soon ?

It'll go next time I send stuff if it hasn't already.

--agVz1gqRg0BwYviO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSX7CjAAoJELSic+t+oim9ZvMP/iguM/JmDhW+NeRgbccLUquR
tGkh7Sr4EfaYAM80Z2jcRX2Z+WKB9zGZsNvT/y3sEM6UJnyyoY0Nhzfn0ZirHorJ
sNjvufySJvJWl4UwlPGekNo42Jp+8o0EFXzhDe5fThC2utJlT9F/Dtzqsh6veaCY
zz4LQkImJNjfx5OfjS1mfn4fqZnt/q/q1TJmFcwaJiU+2rYzVu0VWZqsIjFDxGI7
QD9jLRt1Y7IvZOFT/fbheR8B8pmx+5g/dh0ymdOVPJbLo2NmNPCMGimz7723R/Qh
QPBXIisyFkLJq9GjBXCYRlt4/fk8cIoynObJ2ihBOEXFGLcJ3qgUjmWaSd+hWumr
bHjLrgSB83mHU/yvBtcLsH7MUziVyyfg7JtvuenwAVVPfSha2N/3/Tz/vvQX/Rha
GC47KdnrH8+a69S0E/c6C5b9qK+BCY/lBGnWp08PR2r2NHc5Ob43QtsRBjCSK48v
sRbq+yXjV4BmWE1FHTvAFx2UbCQZCgkd/keTcQDDqcXClFvH31A4GY0VAyZXscqt
T5Xt23IAsSVf1M+fS728YBpPQ47DaLOZqvGqHxEBkk9SqjLUXpfCmxuWy1HZJKWy
e//AYo7jyi8845cCL97+vPG+kN/hO0VUpoj4sl/wgl2BwT4qGLW1u8OLwUCBixI8
bMfvi1xQmhyTzgI//y9M
=gIzk
-----END PGP SIGNATURE-----

--agVz1gqRg0BwYviO--
