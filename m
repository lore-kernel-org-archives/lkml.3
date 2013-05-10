Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab3EJK4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:56:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39839 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3EJK4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:56:44 -0400
Date: Fri, 10 May 2013 11:56:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Message-ID: <20130510105602.GP3200@sirena.org.uk>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
 <1368173847-5661-42-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v+Mbu5iuT/5Blw/K"
Content-Disposition: inline
In-Reply-To: <1368173847-5661-42-git-send-email-wsa@the-dreams.de>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 176.12.107.141
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 41/42] sound/soc/fsl: don't check resource with
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v+Mbu5iuT/5Blw/K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 10, 2013 at 10:17:26AM +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--v+Mbu5iuT/5Blw/K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRjNI/AAoJELSic+t+oim9mrEP+wZGhG/LMG1B/Oki5RlZWiTP
kkyXn1Db4WZjc6od5hHGc5oSXyolSezbl8wpu1kpTrK3l33EjhSHmHZE2dWYLg2K
bkzOqro+TKIu/tl5uNZZaYP7W5NXnhgtF622+KGMQHhNcQ91ugpPDzjeMPc2jN1J
wV24J4G0ktBWECGegsZDz7e384LjE2SxlJYBAT5Ig7BJiEOhgo3VkT+o+0De7Pdn
BA7JdJnLnUbbfIq4StK0kw/DjzYzxgPGRd8khN84dwzpz/7zofnhyZnLw82IfJ+P
UxVZMITJKCQPaJMxcHDLycm8C57UIHr687M4QVoJsM8mHdEAFtvvIl/oqUD/pEIX
Y6S+eLBbxaSo68YnjYxgIMQ37jPnD4vILN1km8Q6k/F3LkVu6vWzcZAyTEbUTo8Y
vOwqiw35sSuSW0LC5l6sHDs1u7vMGJSax0q5PATWrFIXQ1DELyoWbWM/tkAS27Aq
YwPp6UVgFPQZTl/MuyrIElmCqDTA2vjgyLXEVHEj6CgY6E80L+RrRKHNdt11nE3E
A46/DzGxljDT/S8bIxzrlByTEtGGr67LLdxQS1S46xs+vL6npERI1o2sltO3aNZg
l+u73Dzxb8065zOOorJsnZhndP5i4wghGSPzZrmYqXTSocH4/+SbYuwVOfHWcA1c
3PI/rCu4/ep67kZwCkxz
=C3Zx
-----END PGP SIGNATURE-----

--v+Mbu5iuT/5Blw/K--
