Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbaBTKyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:54:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47186 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaBTKya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:54:30 -0500
Date: Thu, 20 Feb 2014 19:54:11 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Message-ID: <20140220105411.GR2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392736948-26623-17-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A87vX0WQ/g4QfIpk"
Content-Disposition: inline
In-Reply-To: <1392736948-26623-17-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 16/17 v2] ASoC: pxa: spitz: Update locking around use of
 DAPM pin API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A87vX0WQ/g4QfIpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 03:22:27PM +0000, Charles Keepax wrote:
> The pin updates in this driver look like they are intended to be done
> atomically, update to do so.

Applied, thanks.

--A87vX0WQ/g4QfIpk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBd7QAAoJELSic+t+oim9w1MP+wT9I9PDraqF2JpTqhnyK1hW
MvUE+gWw48BpmrqDA1uDmo77ptE7NxYg1nUGWhrTxYYE44yKvwmDoPKF2NFS/iKc
kBGm7tvendbrRU/8z4MhFZOUOsmIOmE610FNfNZpaheVgvsiL3jPW9wAZzot3/tC
5kIdNzk0HAFaQjg+IXvu4Df1ucjnU3StsGy/oW3IyM1RdZZUfUvuFm+SGNy6v70M
zMnfk7AUYYWH3c5/f05Ax8WMUbldAIH503ByHfKsWFBJy0ZxCzhGi2IP0ov0rmJy
W70/ti1FXC1DvssXcCe6dlIU5S6Kz6atC844/OPLAVTeZ5gfwxMrapsn2YHvp8C8
QvMhgtOpHV8JgFWoD0FWn/Scr7tTnT8xlB1/Md2s/bdW/rZaIoTyCjEQp6Myxdyk
j3xaYNHJ0BAwdzH+5FXMwjNnSR0PscFL+39VlKIonSyzOR0/UMSYz/WSC3/GydRA
iI4ZQGUPrdTi6os94TQ7M89l9KIBB1gxu1wtqBHny6Q5lK+Dyicswf4cy9NLC76L
FV6y/U3z7Oqbqr9AvC9JHIFQxqZwfNaniFwcqd8S8Gzj7cVOZvJ7OYTd8kiC0U3I
EGSMLx0gy3hucCvQHCzlN5yg7vcyFlGDM5CwcmHWHBcDDvSBb8BH4PNwcYzFNt9t
axBhWz92/9R18MrUbcig
=8AnN
-----END PGP SIGNATURE-----

--A87vX0WQ/g4QfIpk--
