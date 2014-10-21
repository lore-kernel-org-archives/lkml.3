Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812AbaJUVYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:24:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40630 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376AbaJUVYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:24:14 -0400
Date: Tue, 21 Oct 2014 22:23:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-tegra@vger.kernel.org
Message-ID: <20141021212345.GA2344@sirena.org.uk>
References: <1413905609-23268-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <1413905609-23268-1-git-send-email-alban.bedel@avionic-design.de>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: tegra: Read and use the GPIO flags of the
 headphone detect
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 21, 2014 at 05:33:29PM +0200, Alban Bedel wrote:
> The headphone detect was hardcoded to low-active, use the flags from
> DT to allow high-active as well.

Applied, thanks.

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJURs7gAAoJECTWi3JdVIfQUkUH/2IVWvsdByMd4o1ne4x77BcC
+v5EfPMf4n1f7+aEZ99QRru5hsmVeysQbYZhbJlFwi24t4XKfCOFBgz7CuiZnchd
odpOnGdaJ/aQkcMypb9TJpACDTwDReGCBDx1/5s6xD51jmjAv5UMk+qJLaYnoaD9
B3FLIb8GqwifkeIwT0AzPgvq97zuTf11WnvB8i8kcMhts5h9h9+J5WE1zYNZKMwr
hNkUGUUyUlQ/yP6TGWXeNt1sBEiaAHO91QfXC8oW7SXZ/yGtQnhwvbxQkI/ATcUv
E5ra8szxLvD6dcqoGZuhlqc6qxoEnrBofuDYEFS8Hfz5vHJHxfa0sK4ZdqoDN3M=
=3Ejy
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
