Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbbAOKwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:52:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60855 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbAOKwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:52:50 -0500
Date: Thu, 15 Jan 2015 10:52:36 +0000
From: Mark Brown <broonie@kernel.org>
To: jiwang <jiada_wang@mentor.com>
Cc: Fabio Estevam <festevam@gmail.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Frkuska, Joshua" <Joshua_Frkuska@mentor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>
Message-ID: <20150115105236.GP3043@sirena.org.uk>
References: <20150113215412.GS4160@sirena.org.uk>
 <s5hr3ux24em.wl-tiwai@suse.de>
 <54B625A8.8090406@metafoo.de>
 <s5hoaq121gh.wl-tiwai@suse.de>
 <54B63E4F.2010506@metafoo.de>
 <s5hwq4phbzr.wl-tiwai@suse.de>
 <20150114120228.GT4160@sirena.org.uk>
 <54B6679F.1030706@metafoo.de>
 <CAOMZO5AQEyb9in0hRn+7zcpE5r8zwVUFjCqAqNOmLMCGYka3Pg@mail.gmail.com>
 <54B744D1.3040809@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Zfao1/4IORAeFOVj"
Content-Disposition: inline
In-Reply-To: <54B744D1.3040809@mentor.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] unload Audio drivers while playback stream is
 active case kernel crash
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zfao1/4IORAeFOVj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2015 at 01:40:49PM +0900, jiwang wrote:

> Can we have a more generic fix to this issue?
> Or shall we set owner field for all machine drivers?

Ideally we should do both.

--Zfao1/4IORAeFOVj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUt5v0AAoJECTWi3JdVIfQpMkH/jTi8BFqSKGZcylvRb19hQnz
pEUPAQkbNQPL7EeJ9JE9KaZ1ffDzWf31Cbbr6A8F/HfhFcQxh0N74z2PIM0V9qlQ
yAyAgRrpe8uS3GjgjOqQs9qbzhxm+FnxVJofaBuky/dyY6CSLfjGgT7WZhamIg6O
Yw73UP22TrpnGG5h/JPRFZu6vXsZX4gWJzQrD3f/lW3+sW9dxQqQtzA0PL0y3ghx
ZT3/69RRsM1FLmY/AfHHXfwrK8NzYeeJNDOiiO/1eVx5Tyw9EZvQOfAf5iRSJVyr
SFVqDFZqxhKz4mn2WUqCcsj/6gr6IPoL+2zZDQjSO0jNWrbdQIA81odvwTZCkZk=
=bWFR
-----END PGP SIGNATURE-----

--Zfao1/4IORAeFOVj--
