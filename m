Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaGCMDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 08:03:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44890 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaGCMDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:03:22 -0400
Date: Thu, 3 Jul 2014 13:02:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, dan.j.williams@intel.com,
        lars@metafoo.de, tiwai@suse.de, Liam Girdwood <lgirdwood@gmail.com>,
        joelf@ti.com, nsekhar@ti.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, dmaengine@vger.kernel.org
Message-ID: <20140703120252.GA410@sirena.org.uk>
References: <1404363116-10538-1-git-send-email-peter.ujfalusi@ti.com>
 <20140703093808.GN2296@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mFM6r0jQWo48NPCK"
Content-Disposition: inline
In-Reply-To: <20140703093808.GN2296@intel.com>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 0/5] ALSA/ASoC/dmaengine: Fix 3 bytes physical sample
 support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mFM6r0jQWo48NPCK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 03, 2014 at 03:08:08PM +0530, Vinod Koul wrote:

> Yes makes sense to go thru ASoC tree. Mark can you keep this in immutable
> branch, which I can merge to my tree for any future fixes...

Fine by me - Takashi?

--mFM6r0jQWo48NPCK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtUZpAAoJELSic+t+oim9Y8gP/RZMybSyBXdstsDp2vOnUZGA
+ORwyK1RhundYd/rYFuo2LDeukhkjUxak6XDIWrR8Wl7c8J5lMWZNq+snZwks8fx
/mNBCn3B4q/Seoq1/UZfMFsX0xT+6nYflJDXnxDI5vo7TmdyQWVnoZkvI7Byx/Co
JYNLfT2qgWIU6jG2uyZQcDFplepWcMBzolI8WxQox8x2DO/HyhJIYr+rYUTqJHZ9
uarWTzmoxdqNlqbVmzv7SDKm3Eq65apn1FuKHx1YmDUqSVen3BgBqv/YIvx4wie7
FAtifxCvnYI81+Dac0w1D0Rf3HBCt+S4JyEeO6H61cqdolUqbqUPTgMMCVeCVpkA
a338PC8cg4FKZjpfB1isE6tWfmaNrFQZV1XRUvyMjWIou2bt5Q/4ZG89Euc5dDYK
gyHlLlGl9qkob5T32566R9mrxMS8eWXekC1xrGrTfsNtS6Rc89kPMkWnZnHnLfSM
IdLNG7undAwCeY3rZXKM4hChW88ycV8FBo3jdOnE5/BXxhig1ZSrEFGoXEL8nZJD
cOLmDkPZuz+nCq4wGiK8OrvgInNhQoJaO7pI1E7uBGnhRaQwTPjiK19b46rVaDFi
R0HTKRP0fIO9FVlfLYwKivGRliBORTarNYQKXE3OPNw76OwbuRGMTiScQg37dCMU
oymmwOuyqIHNO1ylmB4w
=kbOW
-----END PGP SIGNATURE-----

--mFM6r0jQWo48NPCK--
