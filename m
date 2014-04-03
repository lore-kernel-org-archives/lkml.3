Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaDCJku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:40:50 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50592 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaDCJkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:40:45 -0400
Date: Thu, 3 Apr 2014 10:40:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Arun Shamanna Lakshmi <aruns@nvidia.com>, lgirdwood@gmail.com,
        swarren@wwwdotorg.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Songhee Baek <sbaek@nvidia.com>
Message-ID: <20140403094016.GQ14763@sirena.org.uk>
References: <1396494710-20944-1-git-send-email-aruns@nvidia.com>
 <533D1B65.3030405@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FmdPcZLZZW6lDAYm"
Content-Disposition: inline
In-Reply-To: <533D1B65.3030405@metafoo.de>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: dapm: Add support for multi register mux
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FmdPcZLZZW6lDAYm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2014 at 10:27:17AM +0200, Lars-Peter Clausen wrote:
> On 04/03/2014 05:11 AM, Arun Shamanna Lakshmi wrote:

> >+enum snd_soc_enum_type {
> >+	SND_SOC_ENUM_NONE = 0,

> I'm not sure if NONE is the right term. Maybe BINARY is better.

Yes, it's definitely not none.

--FmdPcZLZZW6lDAYm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPSx9AAoJELSic+t+oim9yRIQAJZVoxnGGYZbJf30PHwLCyfi
FPgD0T6dOwQMTvXLYS/KM+vzKLGybOehspU1op1JnNPZEMCQZ1P2mGg/A8sZyGuy
YN7GwACLNRKR6G7q+nkoniQM5epqWgUmlDOeGV4rwkyQrN21YYFyl3zCtL767y3p
3toXyTaqhidMrcS5dyXzAse7evDSYxCRxvV/BVPQ+ZKTiZ04JwT+psWI4ywnjhWL
Bz2Cfw5NIqbq+uBEXisLb+SXJtsXVhL3EJa+w9EFFZu14ZIt6AeBUMuuB7A57S/R
AbVJ5NG7O7+j8h2zCJEJPLH7NdmvzkzZPRYf8iGePm3RZMnmZrVFXMFr6yWlsD6J
WiVcIJAMzXhFUqLWDX4mkvt6hTQKi4d4FQd0N7H4VjnrkbUj9JRU9rCImI807ePd
rZ725JiaSLOZdveL5ku+EBDEulE2saHPzd3ZM01dn/b5pAmHJO13HOQ4hRwjv20H
RdnTzGFMFxGGaJxNYzEdzj2Fj2Y5/3v4JnwVCXvAQ/CpUnaduam//0M2FT6pwDn3
K54VvRb7afrWy/btvGO6aqw3aPw+4GHDEQyo+J0bXhklb6qTWi9bzOyM/9sCYAkJ
Exx7sCL+/BQDjMcYtOKOR7UXHa4PVKmTNCqpHQM9gVXFceY4RZ3M3hoW8dRZs+MJ
T951ZJSIeZZuer2IVKhZ
=x3WF
-----END PGP SIGNATURE-----

--FmdPcZLZZW6lDAYm--
