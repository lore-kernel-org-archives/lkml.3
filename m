Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaLVLq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:46:26 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43733 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbaLVLqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:46:25 -0500
Date: Mon, 22 Dec 2014 11:46:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Message-ID: <20141222114604.GC17800@sirena.org.uk>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
 <1419196495-9626-24-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
In-Reply-To: <1419196495-9626-24-git-send-email-wsa@the-dreams.de>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 23/28] ASoC: intel: drop owner assignment from
 platform_drivers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 21, 2014 at 10:14:44PM +0100, Wolfram Sang wrote:
> This platform_driver does not need to set an owner, it will be populated by the
> driver core.

This doesn't apply, I've already got a patch for it.

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmAR7AAoJECTWi3JdVIfQttQH/39ED1DLG383LTz4fAVImtui
Bkt0IxJSHAN6QLiKnMCaGPBZG1+ecgkilOBMB6pEqZS4VD2axIyHpMGzpjuOmW98
3C0mw+3H7Bk5nYw2kDyZFDKrS3/DnQoF+acUxS0dGRMiesyi1+BRhu5Agvk3tH3Y
+NbJXiFXxGKN9aQOuPSnC67b/qsSR3Tgc3wCiMWYdLipsoZ+0qXafMDxIO5Tvtqy
rX2Q3Bjyls06eIk2UW9QrBDYBlMgIQ2JoiC7VI74NLL3nYgXtkfEHJ74I1pkYjbz
LmuTQdbe1YO5wHGWAkv6JQ/RSAB0nNrCYncdvgzyxDI9uadJmC4qzSNmUCZZGe8=
=aagn
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
