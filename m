Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3JIS3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 14:29:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49266 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3JIS3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 14:29:41 -0400
Date: Wed, 9 Oct 2013 19:29:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Inki Dae <inki.dae@samsung.com>
Cc: Olof Johansson <olof@lixom.net>, Sean Paul <seanpaul@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20131009182905.GY21581@sirena.org.uk>
References: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
 <1380670860-17621-4-git-send-email-seanpaul@chromium.org>
 <CAAQKjZN_r-=-sj=Vb-o-KUS4ab5=cjCq1ni3VZeMeVc3NL=MMg@mail.gmail.com>
 <CAOw6vbLiJLLKn=gb1=j5TBeM0ijEK13+goG-=mw7MZTyNT1kpQ@mail.gmail.com>
 <CAAQKjZPwyKCpju4Ndd+MB_aN24-zA5xTHFsFsun2617h7YT6dw@mail.gmail.com>
 <CAOesGMgKastzdFHYQzyL8gxkBN=86wFZ4jbgP8BHxfkOuZvJxg@mail.gmail.com>
 <CAAQKjZMhovKLxNfnXnbF-6diM2zF1cWyi+xHGyL3v83vBh4p6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RJZzeD23Ed8sO2FB"
Content-Disposition: inline
In-Reply-To: <CAAQKjZMhovKLxNfnXnbF-6diM2zF1cWyi+xHGyL3v83vBh4p6g@mail.gmail.com>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] drm/bridge: Add PTN3460 bridge driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RJZzeD23Ed8sO2FB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 04, 2013 at 11:05:48AM +0900, Inki Dae wrote:
> 2013/10/4 Olof Johansson <olof@lixom.net>:

> > "If PD_N is LOW, then the device is in Deep power-down completely,
> > even if supply rail is ON; for the device to be able to operate, the
> > PD_N pin must be HIGH."

> I still think the pin could be replaced with a regulator. But
> lvds-bridge node has "powerdown-gpio" property - it say this board
> will use gpio pin - specific to board.  So it seems no problem.

No, don't model things that aren't regulators as regulators - it's just
confusing from a usability standpoint and causes breakage when the pins
don't behave like regulators.

--RJZzeD23Ed8sO2FB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVaBuAAoJELSic+t+oim9t9YP/2zdxi1e2TqVNIcxbbSYUvWy
LySnpmymlG/Sh3k86KJwkDd+2X7kq8xm8T2hfx6SgKPw/hNFBfMvJc5rh7r0Z9d0
Jb+kpEVEDNaLpZBHN9HN6yejQ3aMoy1NEIgkGlqmGNUG8NQmNq0nDBCmTysGpoA0
xes+miLMs5WXRK/kpA2r/J9FnOEhlNxM5i8budaqcbJAeLRTo3ePqavTW9AGPXWH
TLruZFFu71/UgLMDRYny42lOCdcagNZJn6/gDNEvreIaObDSZJ7kxHO41/F/to45
gEskdwyzgfZ25M+I7pMuFlIzaBWsGtjQlSc7PVJcplCVd7KOTvtfsN+FeOzhHVHr
s5oVn6q+kO97Hg1Al1B49wRtQFban0K42ZD717iV4nUEnMmeVlqdSz5AvjSvUK5g
Pc52RRManESWdaSB+R3/1ZctPQZxGZMy+fCjl51+3dfJnfsWUhxE4YJBkp4hNz9v
ooEVBPASa8VdD/KqObGyQzP74SpPuKHRfNRbSVf84I0TY0oERn/rS/xxJo2uhqWv
8dhkS3RzfJqxVtEHSLQxbgRgKcN2vfGTb6X/VVyikA6vyfR0luvUYbu/qK3g/9ux
JRS6HeZtkZLBN4FT08Mj46zPJMrqFSHfalXI8jY+oxPJwbLx5WifbvhlakjvjMKP
jtx5H7T/C1tB5SGc9y3f
=GFIi
-----END PGP SIGNATURE-----

--RJZzeD23Ed8sO2FB--
