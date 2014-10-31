Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbaJaSNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:13:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59622 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaJaSMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:12:49 -0400
Date: Fri, 31 Oct 2014 18:12:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Rosin <peda@axentia.se>
Cc: Bo Shen <voice.shen@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141031181210.GQ18557@sirena.org.uk>
References: <544A1121.6080900@atmel.com>
 <1414178759-7252-1-git-send-email-peda@axentia.se>
 <1414178759-7252-2-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2yGx+1UeQj0dgFI1"
Content-Disposition: inline
In-Reply-To: <1414178759-7252-2-git-send-email-peda@axentia.se>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: atmel_ssc_dai: Match the CMR divider only in full
 duplex.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2yGx+1UeQj0dgFI1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 24, 2014 at 09:25:59PM +0200, Peter Rosin wrote:
> The CMR divider register is shared by playback and capture. The SSC driver
> therefore tries to enforce rules so that the needed register content do
> not conflict during simultaneous playback/capture. However, the
> implementation also prevents changing the register content in
> half-duplex scenarios, which is needed when using the OSS API.

Bo, is this OK?

--2yGx+1UeQj0dgFI1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUU9D5AAoJECTWi3JdVIfQxq4H/0tmjB+/0YvxDhXsfcx44yaZ
wuRJ3ClOkzAPgfVGtj/wBX4U66E1uCZVBpYsqkqjk2rHjGcPDZQSz8ojqsu0n5bh
cGMKOygU3bN1RzRvYwgRIELWbI21GdPJc7XCORulhus3FdT5/Yi6t8XmtWvmDjoE
vGLf4LSBx34hezavMioBIOlPuO9Q8C0f44/kXjkL+1mhhe7CVjKX7Q7ZkVuP58Br
6TYBlLx53OlGpGZNp2XDeL+Roqdes5VJMQgF7WZ0nbniC5u4Egj9g2VVRfm+PCx8
+qBOOfaVt/+oTd7FViGjSmN0Xi1Z9V9ypHC8tx967f2iCCD4m1taBzd3sTjb7Us=
=uoBs
-----END PGP SIGNATURE-----

--2yGx+1UeQj0dgFI1--
