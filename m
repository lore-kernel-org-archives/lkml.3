Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaKRJlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:41:07 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47922 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbaKRJlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:41:04 -0500
Date: Tue, 18 Nov 2014 09:40:23 +0000
From: Mark Brown <broonie@kernel.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>, Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Takashi Iwai <tiwai@suse.de>,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Message-ID: <20141118094023.GG22111@sirena.org.uk>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <5469F4D5.9050908@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lHGcFxmlz1yfXmOs"
Content-Disposition: inline
In-Reply-To: <5469F4D5.9050908@users.sourceforge.net>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.128.185.34
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: ASoC: omap-mcbsp: Deletion of an unnecessary check before the
 function call "kfree"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lHGcFxmlz1yfXmOs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 02:15:01PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 17 Nov 2014 14:05:27 +0100
>=20
> The kfree() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.

Applied, thanks.

--lHGcFxmlz1yfXmOs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUaxQCAAoJECTWi3JdVIfQZU0H/356TKBrEHx9HSKrWeApVsta
Vyw6L73dZOV9Zaz6tW5YN4jFmgMY+ukFjXaNjliD0aWDW5CoZ7dL5cxa2Fh4p1UB
CUWrnBANHwWtuC9RnN8tjQufkon1+wCylbxFy7MfLybR3eAPaf1d0CKXGHLMshAV
eFElkPCOaxDUqOcdsOMW5s7iul46voFGAPnVzlE47SUHjGLlRWv7+fgblUO0amav
16KdKBnwVBwRkkQ1oXe3CnMB5XmVqVBw4akfQRTELPYiBfYKgpwlHOmiA04lXae5
X7lnWENrPDL+lHC0rSfQXuKAXQ/+bf1Re8W/+/OaXS6qiJg9g7DU8p9lPRfVgQQ=
=I3wy
-----END PGP SIGNATURE-----

--lHGcFxmlz1yfXmOs--
