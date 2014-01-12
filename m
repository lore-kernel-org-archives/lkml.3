Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaALTZL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 14:25:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53201 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaALTZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 14:25:08 -0500
Date: Sun, 12 Jan 2014 19:24:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140112192451.GV29039@sirena.org.uk>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
 <1389469372-17199-2-git-send-email-tomasz.figa@gmail.com>
 <20140112114717.GA31318@amd.pavel.ucw.cz>
 <52D287B1.3090106@gmail.com>
 <20140112185337.GA6810@amd.pavel.ucw.cz>
 <52D2E716.8040403@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FQ9/qgh0YgB02Feu"
Content-Disposition: inline
In-Reply-To: <52D2E716.8040403@gmail.com>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC 01/10] ARM: s3c64xx: pm: Use name field of
 generic_pm_domain
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FQ9/qgh0YgB02Feu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 12, 2014 at 08:03:50PM +0100, Tomasz Figa wrote:

> Also, there are multiple devices in most domains, so that would
> rather end up being "Domain_I (JPEG, Cam I/F)", "Domain_P (2D, TV
> Enc., Scaler)", "Domain_F (Rot, Post, LCD)".

It's not just that there's multiple devices either, it's also the fact
that the groupings are a bit random and probably more to do with chip
layout or something than function.

--FQ9/qgh0YgB02Feu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS0uwAAAoJELSic+t+oim9bewQAJjTIuiFETq+GORPtv/D882d
qwB1ahCgjUlvd34KWP6y2BfNzZLOIFPQMCGHxiI8aFVdXedwuwlYB2UeIAEP+XRd
yAxGHdojuergUW1QMYbe+9s2mt/3/kbwh4cR22ns41M1fjVug0DTI0EY5x/1lFGF
jG3rSyrqtdwyKSrkGbBfmmn/Q3X+jbBmB3VBtCStUCuNTvGBzSMPWkqxawNBuUD1
Y9KJ1Zi6p/YeFUkkkKJdk1j85PqRnRIj/y7EoN6DyOAm6MMQ+JxXu6sau/eFXRr8
Qv/PahL9RtNm+zQRkgV8Fwkn6zV46f6zOrBo/TfNxjp4k3H4r+SmDR3yuNbRCfOU
EtEaOW0DjGmkwZXE6uBKQ0mMgXH/XTLmrDPoccbx7+xE8XKqnMvw/iq3qwxbK0gk
paJrz2PcFtf32sE9AhkadoPUNy5cTDRMDWuOPrfFSKloSfAN0KviDB4PE2l6M2O9
pc7Zu4E7SDjt7VnoDMaVUjk70JzG5uaArtG+vuSbPUXFMZqngupdjzyQpjVRUdOA
5Cwr97nw75L8qBVOuhuleR1rtNB+may44G8yANHWhVjdQ8ETjpWxwn+D4AtSTPBk
gxzvdIQFthgRM+0OK+t0traMHjNzC6ZKcrfm0aaUxw1OtyIbMu1yZ3RiLznb4lBY
KxO5T6LHEJyEsfgpyLwq
=Wn9Q
-----END PGP SIGNATURE-----

--FQ9/qgh0YgB02Feu--
