Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbbAEPaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:30:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36366 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbbAEPae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:30:34 -0500
Date: Mon, 5 Jan 2015 15:29:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Cheng-Yi Chiang <cychiang@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dylan Reid <dgreid@chromium.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150105152958.GU11764@sirena.org.uk>
References: <1420457219-23098-1-git-send-email-cychiang@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pqKHkMk2SPBxSVyL"
Content-Disposition: inline
In-Reply-To: <1420457219-23098-1-git-send-email-cychiang@chromium.org>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: ts3a227e: Check and report jack status at probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pqKHkMk2SPBxSVyL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 07:26:59PM +0800, Cheng-Yi Chiang wrote:
> ts3a227e does not trigger interrupt to report jack status when system
> boots from warm reset because ts3a227e's power remains on during warm reset.
> Read jack status at probe to get current jack status.
> Note that if system boots from EC reset, then this issue will not
> happen.

Applied, thanks.

--pqKHkMk2SPBxSVyL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqq31AAoJECTWi3JdVIfQJZUH/0r75S/sWlc2xiFw+o+YS5sE
NPhUD3yYOMLK6eJLZqJ8z1yTKPhruVLDD+eYzmF5gPu187v97ZqAna/laB6vzapC
m7+U/+LqV3hTKvokvpPCnFPy7wKDRDBYoUhCLuBB5Zq+5K6/E4v/BLIAQmWczWI+
TZaiPOuPaLcrYDRywOntmqg6ZUWJ9ntUAQ1gxANlZSdW0WvuyErPenjych5C+ES1
jNyL5+CztxJm7StJ7Amsnoc+4FgYgJAgTW9Yf7X6cJZjiPF7zFQdPt63s2M8fKog
W+iGmMFBOhqySEBGiLrk+DFooFh7UQ7vSj8X+13kFag5GyosskbzNbjMNxdct24=
=cnlN
-----END PGP SIGNATURE-----

--pqKHkMk2SPBxSVyL--
