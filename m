Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3EUR10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:27:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45891 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab3EUR1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:27:23 -0400
Date: Tue, 21 May 2013 11:39:45 -0500
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130521163945.GA1196@sirena.org.uk>
References: <1369130649-15179-1-git-send-email-fabio.baltieri@linaro.org>
 <1369130649-15179-3-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <1369130649-15179-3-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: ab8500-codec: Set rx dai slots from rx_mask
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 21, 2013 at 12:04:09PM +0200, Fabio Baltieri wrote:
> Replace hard coded rx slot numbers from ab8500_codec_set_dai_tdm_slot
> using the ones requested by the machine driver in rx_mask instead.

Applied, thanks.

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRm6NNAAoJELSic+t+oim9X78P/jq/09NFFLm/GpkDECSyymfe
bXWnrF/uHPM/V5mMh6WUVcnlXqwwR3JksbMpxdMrlmE69pQpa+v6iHVYqHacUEFZ
2l9E0Flvt6L9Fi8JTRXQctY7zB5EVJ/kp1xL2hytjreBjqwrXNPvVb0UJrT3ozek
cmeb1iGwfa94FFwEVedQYbZ4WQ1jMoktjJh2i/gExML44Jq74h5BroE7kpeufgc0
uL7BFtGyH/lnFXv+REXp/MUCZz1r4LXkmSao1mtLMh287YsSYc8x1DvDZ12+8c7/
7YYBbL6qncu9qMPFPoSMg4vD+Cw9FZ5YhD6OX9rFPuB8DjlpYUSvZ+/Ba8GlnFGx
xW72dgGoqqHY1SjEzs2LMLLRMBC15p8OU0nCOKjZwHMeJ7ugy+e9CtTLLmukrHQl
zuuhvaMwqYdWuqDUe0Bd9fGrhlsRL4RMTndJN6bGKGG8sKOwIIoUAkfZCvm6BxAm
h22k9ZJMMrFB9VAFltD6GKl2adt05yln+P2U/H69ZqVSciKhToldjTs8tExgNseT
e2p08nWyTWBSj6xBykgoFXm9kjuZbvTrTG950SZKgPV8ar6SPpy49J7zxlIhiyGU
vhElQCupTFAKB0jjtTfil/rMmwD/00fUNYwe6ZnpIdblIm4ffO8K9AWoQ+mnDky1
TMeaL4NtXMOHrJ1D1dIC
=gR24
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
