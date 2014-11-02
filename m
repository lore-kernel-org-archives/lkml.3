Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaKBLJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 06:09:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33606 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaKBLJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 06:09:19 -0500
Date: Sun, 2 Nov 2014 11:07:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141102110746.GA3815@sirena.org.uk>
References: <1414910081-2487-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <1414910081-2487-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Intel: fix missing mutex
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 02, 2014 at 12:04:41PM +0530, Sudip Mukherjee wrote:
> on error in block prepare, we were returning the error code while still
> holding the mutex. We are releasing the mutex in this patch before
> return.

Applied, thanks.

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUVhB7AAoJECTWi3JdVIfQcZUH/RoQnYrPMaboeP9/y82hei2r
yJLn7r5a3tqjyPOqUc4aZPCcaY7B50gtk2HhheVprHh4h1oe+iq1tSorP/u0g2ai
a+9H4/qmS2qH1oVBHJDmFLgl6csFzhvyQatvAdCEuCyvOuCiUamoocDqTHs0v6wu
iLQCjgdYM6HLHAlcB8tnR1cJccrqeFpN61bAxihUUwDJbz2zIHeMDbieFMduY5QZ
QVhJ2x+QGZZC0AzjvWj6RNnIPhxQQtBAtN/Pg4y06sHXTW1gI0gh+P6kqxjjgN8Y
CKzIxafBTurDDYd1NGEuWjuvpDVC6si+YRWvG+j+QK8RDWH3FDTHMSQ7ypfrP5w=
=9h1N
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
