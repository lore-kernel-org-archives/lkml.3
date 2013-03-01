Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750983Ab3CAOWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 09:22:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36170 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696Ab3CAOW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 09:22:29 -0500
Date: Fri, 1 Mar 2013 22:21:20 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Michal Bachraty <michal.bachraty@streamunlimited.com>
Cc: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Subject: Re: [PATCH v3] davinci-mcasp: Add support for multichannel playback
Message-ID: <20130301142117.GC25302@opensource.wolfsonmicro.com>
References: <1362064028-12666-1-git-send-email-michal.bachraty@streamunlimited.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qTzJm9l2qECmSDiM"
Content-Disposition: inline
In-Reply-To: <1362064028-12666-1-git-send-email-michal.bachraty@streamunlimited.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qTzJm9l2qECmSDiM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 28, 2013 at 04:07:08PM +0100, Michal Bachraty wrote:
> Davinci McASP has support for I2S multichannel playback.
> For I2S playback/receive, each serializer is capable to play 2 channels
> (L/R) audio data.Serializer function (Playback-receive-none) is configured

Applied, thanks.

I am slightly surprised by the TDM slots being in DT but then it's
already there so no problem for this patch.

--qTzJm9l2qECmSDiM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMLlWAAoJELSic+t+oim9g9gP/3mCBa0fa1AeNmyv7lBulC9n
oynUbe9M17fPI3emsTqBjPFk4yp0hx1g98xadZuwGe7F14Vy8jYv6IVEHvBBiq5d
tTplKQkuzriuWG1KlYP7tJ3f7O1B5dZqq58qId5fku8CuYzVKZOc7GijwBjdcBVw
kGw+IegKG/8/vfovKXgGVCkZ0hkOgJeCi846pICkW7kpvs/+Ek1vojLDL1F2CBJf
244hSBdW0Zyoh4u03Uv7nrpncfOwMT+MRKrA9sFogrURDh7vzeyQI2v6R2ik2Uxv
hXsgk9/+jmE3Z5ByLaM8OiG2/sdY7ulGS3wAfmVlJqVw6YG1fb6LTYOKyNRXoMMN
PBoloLrdcaxYN+z6sdpyxu4A1IImsz/o4/eSe8O/MjkK5Luqh4Lkheu1eISP7khj
eY/rMxwdJIml+7BPJy+34bfRhP1iATUmZm+uxMXsu1jO01nMOa2HagdPwpp6pnJO
Ov1V3QzMwP9yRAbvvnLH/uGeAlrJ2RJgs91rmmhVUm9582+dhxd2v8ytw0HrTGwL
aDtaQKyBjyNpEFBndixO6qckjBUY2mFQ5uqMc55FIjq1OTchDz24yjl9wWmLpH2Z
2C+DCGHkUHdfDn4jXMCB4eP0aIlru6iK9wmWTpBTraIA0hvr4rsvBl83C3cgQ+V8
iAJvUBO0CPV8+bJXaUBk
=rQ7P
-----END PGP SIGNATURE-----

--qTzJm9l2qECmSDiM--
