Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3LSKXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 05:23:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58053 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3LSKXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 05:23:43 -0500
Date: Thu, 19 Dec 2013 10:23:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: perex@perex.cz, tiwai@suse.de, kuninori.morimoto.gx@renesas.com,
        fabio.estevam@freescale.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20131219102337.GR31886@sirena.org.uk>
References: <1387425594-32469-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vvRocJ6whMXXNc9q"
Content-Disposition: inline
In-Reply-To: <1387425594-32469-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: Use devm_snd_soc_register_card()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vvRocJ6whMXXNc9q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 19, 2013 at 11:59:54AM +0800, Xiubo Li wrote:
> Makes the code slightly shorter.

Applied, thanks.

--vvRocJ6whMXXNc9q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSssklAAoJELSic+t+oim95vUP/3+XE0m7EClFC2iz2idjAeZW
VTUWF6a19t98jMnPTUnUeXmCCEyE54WeewzM26KVHHXim/a14GKqmxDzVEGw6deo
prXDzLxDRuKAsQGXCzmAeKYtvQsbM7xxYDQH1N/eWDxQmYV0y14FNdTyo+1Frm55
kIMUmbXl5WotHcn09LFjwfX1LxY+CVOhvJ6yIn6kW7HdoCAmyYoLiiNHXugZzURX
0RIXQb7vVYUuw5JZqBeEHn1DEU1Yy3HDC+kQsr+keXa/eQk6AYN0CQ5jG7rvLaqZ
e89EDOruMmyREm3h8PvX4rjWZzv+/O08QFgpz1anueaSNo4K3n+SG9WOAxjA1Xth
ohI70pOiqDU11phmOlp4Jp6Tv0RzamlrYWMAZTgEd/tllNshT8s5yIjVXO/V7QC/
tz66wbeuHDirr32CJl0V9sPBZHRvJYU7EpjH91jVyXDM7IUQf3wHaNmDjbu+aZA8
a0sYASIqHEHlOLWuNo4rYZgKJwipf9DRBxBRXrZ0FA1pnSBQOAOhzmeAcl4E1SEo
M97otwP5zmqNxdN8Mzzq75xx+nvTO3nWBnOxxsJwnWvhNSZKakJpGgZKirEKid39
NoV/scVvVYYv75FzPJEcw9fp0bpL4EPghVPLrMBQJYfR9n6piIh3JnEjPXN5G4yu
za2mOBcm4UFIHIs0+pv2
=SUM/
-----END PGP SIGNATURE-----

--vvRocJ6whMXXNc9q--
