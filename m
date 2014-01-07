Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaAGPjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:39:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48386 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaAGPjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:39:21 -0500
Date: Tue, 7 Jan 2014 15:39:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, alsa-devel@alsa-project.org
Message-ID: <20140107153917.GS31886@sirena.org.uk>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
 <1387468508-12286-11-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FPqGZ4O2lLpGIU0+"
Content-Disposition: inline
In-Reply-To: <1387468508-12286-11-git-send-email-lee.jones@linaro.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/11] ASoC: ux500_pcm: Differentiate between pdata and
 DT initialisation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FPqGZ4O2lLpGIU0+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 19, 2013 at 03:55:07PM +0000, Lee Jones wrote:
> If booting with full DT support (i.e. DMA too, the last piece of the
> puzzle), then we don't need to use the compatible_request_channel call
> back or require some of the historical bumph which probably isn't
> required by a platform data start-up now either. This will also be
> ripped out in upcoming commits.

Applied, thanks.

--FPqGZ4O2lLpGIU0+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzB+hAAoJELSic+t+oim94IwP/AvZtPWjObdc1p7r56x2Uhza
e06psnWb1bd71p85DnWlknUwUG+yrDExBcy3dqS1PHSMbhxvfID2jVr+OGqvvrbq
XB3JYiQb6Wia+5cvQAT0SnC/i0S0vaRoiq7naCzmZ877kamuRkE7rTt+oLZQTxql
MmgVqSpQw2IDIYmAZ7R52MEuSaZMjbx1IdUb+gLsVeccI2xUXGo4Jv6gcVkOi76h
ru+1OdSMU/FQmOZW4PqO9DTfMw/L8g9vTJcyfUrwFzWKkLZVesQ87cySP8FlBdlM
l1Ja/WY26J1Fwj8iqB48q5C5CJalvQeo7JCH5MsiGuGmRGdMQQVzQxRQej6ppj2t
sWliImvlUDbOAfOVrm9rKK5oAmv+JC228DRwU13bN0NSwLuu1MC/2n887HsFgUta
u3AauF/iit1YgxZdavMnfIOMGpUaQGttdwUuBHPQVflAV2VSQEVHAFN7RjTj2EBp
eMdcIoKFz7e3XOmpkgCKM8v40WAOP9UpQy1kRGC2SM0SUXq7hNti/b3AItG55Oes
PDhzm94k1QX3OYfw+cu0kTLCQsdHpDRorZd2iHSiEsMhcT0rJo2d/RANR6e/S+Yp
3MFJIW7C1P6VB5I0m8rv+tUlq7Q32gw4ynxrYn6ZUgyOeHsOTHsVARzt5trFp2nW
9C4rBk5DGGsg/53yFOiM
=ern1
-----END PGP SIGNATURE-----

--FPqGZ4O2lLpGIU0+--
