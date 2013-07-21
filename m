Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab3GUXc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 19:32:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50430 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3GUXc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 19:32:27 -0400
Date: Mon, 22 Jul 2013 00:32:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Message-ID: <20130721233215.GX9858@sirena.org.uk>
References: <20130720192554.79b7061b@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QQ0dNM4HnH4+xgqD"
Content-Disposition: inline
In-Reply-To: <20130720192554.79b7061b@armhf>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: generic: add simple card with devicetree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QQ0dNM4HnH4+xgqD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 20, 2013 at 07:25:54PM +0200, Jean-Francois Moine wrote:

>  Documentation/devicetree/bindings/sound/simple-dt-card.txt |  18 ++++
>  sound/soc/generic/Kconfig                                 |   7 ++
>  sound/soc/generic/Makefile                                |   2 +
>  sound/soc/generic/simple-dt-card.c                        | 137 ++++++++++++++++++++++++
>  4 files changed, 163 insertions(+)

The obvious question here is why is this a separate driver to the
existing simple card driver rather than DT bindings for that?  I don't
see that mentioned here.

--QQ0dNM4HnH4+xgqD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7G98AAoJELSic+t+oim9rFEP/Rw/J+Hu8kr9ImLi7n1C3+93
gYBEcKGYmKQRofeh2c/sxnGdG1a4Vl6hUwnQdneHfGsddjDG/fm+jTS8pAto86nt
gnujTelG0VOqMzhq+sLzjVnKFbxpbhNcXDTLA5cYtN1pKF5p4LkFfzRXLxqk1bUA
0VgwfT7iG0jPDa41jCqzr/DqsdRcnIzwzn025tTvv0NsAhs6XgPxlBLeVL5rrzCM
76tvkCGFcNdqktS2dqL84VKb9E4qV2798xZIYOUJRSm0r4Q0mLGdo2I0ikVCUGus
xg//9wSlilLZscLnikN5VEfEWShJsUh5nERn8nGDtnv8uZu04jUoCmnBX71rkkdc
iPwk6T99a1VkW3+YpCJtE1b2pDliDUT+X76InrPxT14DRM4pC3XJDkjirXTPhN8A
e2l68nOHlVg64n8V8vp95z9IpDkR4vAqwv5EaLS1XFviSfqSpa0qGKsf4dM28m7/
xcBv/7c2RrN0aT6kGIwXIQ/L2BMEOJz1zkjofd41SLGTHl92mmVPVXOjVNq3+Wpv
d/p69WcoIfKHjtKne64kA3MlIBk0lX8Fed1PqwQFHiYvhi5VvSt+GoMhh6HmUODx
l5tjINTBWtSFW4/Wb4VKebHQ2xxoyHyJS5PK0271bpJCMlVkZw0kgFOXoqWALC29
ob5x7L2JAXuREvR2ZxYp
=mLpA
-----END PGP SIGNATURE-----

--QQ0dNM4HnH4+xgqD--
