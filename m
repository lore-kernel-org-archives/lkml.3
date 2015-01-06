Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbbAFRpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:45:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38930 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbbAFRpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:45:35 -0500
Date: Tue, 6 Jan 2015 17:45:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Bo Shen <voice.shen@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Message-ID: <20150106174511.GL2634@sirena.org.uk>
References: <1420536080-29181-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZElM7ipGqdpYifc"
Content-Disposition: inline
In-Reply-To: <1420536080-29181-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] sound: soc: atmel sam9g20_wm8731: remove useless include
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZElM7ipGqdpYifc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 06, 2015 at 10:21:20AM +0100, Alexandre Belloni wrote:
> A mach/ header is included but never used. Simply remove it.

Applied, like I say please do use subject lines matching the style for
the subsystem.

--YZElM7ipGqdpYifc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrB8mAAoJECTWi3JdVIfQcfwH/RbHc3HT2yXsp7bjTt4eCooZ
m7BTKd8CVmtTACNUcRuZK0a2RFXx7I36DrV1KlPBamZ2YaGJgHBWCbMmtKHUXZOm
3L+qH/4OYcObOjC7VsuwUcqym4vOsgqBgqbKN23+LLSuUFzJob9XfepSg+R5Fyih
D2mVsh7k+MqUahkAoXm8Dj+c6Jk+vjSk+GZwbJFvy6Cw44C85gTDHqCFJDU0huEY
TBaCpOicBOaLrIo1Z//GXHvP/pWQ8SI21NOiUdKmMYBLrThcSnYWzlagBduxXjW9
48RQUZ5QNLYV0Sql7+LayOFmlh0uP4OrUU6tQ/ehFXcwkZ6nOOAHcMyZV8ZoJ0U=
=94sL
-----END PGP SIGNATURE-----

--YZElM7ipGqdpYifc--
