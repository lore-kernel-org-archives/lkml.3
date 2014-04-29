Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119AbaD2WXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:23:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51008 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755AbaD2WXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:23:36 -0400
Date: Tue, 29 Apr 2014 15:23:10 -0700
From: Mark Brown <broonie@kernel.org>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Message-ID: <20140429222310.GR15125@sirena.org.uk>
References: <1398694047-28596-1-git-send-email-sre@kernel.org>
 <1398694047-28596-4-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tV/+6PImfyFtriLg"
Content-Disposition: inline
In-Reply-To: <1398694047-28596-4-git-send-email-sre@kernel.org>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 3/9] ASoC: omap: rx51: Use devm_snd_soc_register_card
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tV/+6PImfyFtriLg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 28, 2014 at 04:07:21PM +0200, Sebastian Reichel wrote:
> This patch converts the rx51 ASoC module to use
> devm_snd_soc_register_card.

Applied, thanks.

--tV/+6PImfyFtriLg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYCZKAAoJELSic+t+oim91dUP/0R34P4VuZw/NvaI8G5IcwVo
nirBkCC3TmjksRwA11l+ouTJpf4Blmybssp6/vDCL0jDt+FCgFcgCsiqK8zGZQyZ
JR1O9OKgvHWThYVmIv2oJuDEikhtSzvc+SnPzv4VvXgbMtZXhWiJG4j5O0+PJA7E
vvZChiMOSRoZ2SpnylCNAw8KF1iDNdKvmO10Sb4RwhLqX+YoxLU/tSV1yE7zeD1z
2lMxEtr/jN9AUAqVQz4cTq3pI4muv8G2zLd4W0LOz91UgjXdIgc+MJz0oJKqoVjt
g1l2yzvGNTz61nark7n0sEaN4NG+2tAA+QBZeHKasn+FKaFIQ/TrOXlfa4P1e+pg
fDuhwlIzbmaXSt2+UEg/VkBBJ6T/jLY1VD0hUeP3JYgtpnTO+uQzux+aSOTGd6Vw
q1a0rrHh4PjlbGlyoDyZUiWixMLGlkt/w2nIhwQlAPnKMJ274dQ5f04ulMwRpk9W
uZUIhFm6i/MidN6il1D9OKWi/dD93RDSZTRhipSoIUE2YJSmemlYsJzCt5POS8uh
mZRHMes+hB2o99S6Tosht0RATdZlg0K3QHahiu292LIq9pEUI7yr3/R47MDHMDID
24PgMw6O5w1/bxwuii44fEOqlDCp+m3i7ZXfSOSB1/YzSx0OeWs8rlteWJI0Ci3a
yCWCMSvWvJHzx9eiQ6A6
=sabg
-----END PGP SIGNATURE-----

--tV/+6PImfyFtriLg--
