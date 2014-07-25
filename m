Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934993AbaGYRzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:55:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55028 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbaGYRzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:55:35 -0400
Date: Fri, 25 Jul 2014 18:55:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Rongjun Ying <rongjun.ying@csr.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Barry Song <baohua@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Workgroup.Linux@csr.com
Message-ID: <20140725175505.GH17528@sirena.org.uk>
References: <1406092772-26371-1-git-send-email-rongjun.ying@csr.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dZoxY5VDSg+7Vbn9"
Content-Disposition: inline
In-Reply-To: <1406092772-26371-1-git-send-email-rongjun.ying@csr.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] ASoC: sirf-usp: Fixed a bug for playback and capture
 work at the same time
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dZoxY5VDSg+7Vbn9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 23, 2014 at 01:19:32PM +0800, Rongjun Ying wrote:
> 1. The startup function invoked when the playback and capture.
>    If start playback when capturing, the registers are re-initinitialised.
>    That cause the playback fail. So move the startup code into runtime resume.
> 2. Modified: If non RUNTIME_PM support, the probe need enable clock and
>    initinitialise registers.
> 3. Refine code.

Applied, thanks.

--dZoxY5VDSg+7Vbn9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT0pn1AAoJELSic+t+oim9DFMQAIws5eN0VV2xP7jYfK65dgA3
u3mBFQE1Hfo2gWf6YVdd45IW53mKC8nJRgUA5LzijQl0HSZZBFMqyLd1teRECxyU
Dry4HS4EyOVH2oMzf2CbfWSGgVVN3qqfkgew0L3VlZDA+AD4nJ9NzdtvytrEuW1K
SYGfuwBdpVKASE9HSKkwOfZ/DkNrVBPBozuepUne+WbfHmoWM0gelQ8HggAkNjpL
y5Ity/a6LZkmwtVr3kVqqEtcPH0kMNHs1xh1EkHOoux+Al2Euaw0Su9N69ZY8V7d
ftfH0r2/iZ+fOE+pqkwjHIe7LGwgEQYmH2ez+XEVoY+S2v9kJ0nf18RQAifggvvL
SCiKgHmQBHOOr6P0myE6R13uI4eLrBOMEdQ7fMIBbmtM5Ai8V/P4+gpDI9GGtjND
zNrx84PrzCMBXGe9Ew7kPGc/bYDR4iK5gTgiWGU3AkhPoGAqFu7zXt0ZsliYUUf2
FpYHH0D8kRoJZ7dvMJaNnWO95X3XjrIUAcAWexC5uYGPGOoqwR8AaOAXfzzKPgtt
fhVn+1tK0NcR5+BJQpU+EJP7+M82hfvlQqb6A9bfGQOeh+g1ee+4zWRw+p7a8Q0N
lkWui/5XOhrGg7MpSb8yQV36xo0zPeSdO4k5dD53kFDxoeKyA8dSVnqKnv6S96QB
SEvoksDsVzX3TbIMTjEF
=KquA
-----END PGP SIGNATURE-----

--dZoxY5VDSg+7Vbn9--
