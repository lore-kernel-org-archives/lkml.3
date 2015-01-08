Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbbAHUFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 15:05:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45065 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbbAHUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 15:05:40 -0500
Date: Thu, 8 Jan 2015 20:05:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Jyri Sarha <jsarha@ti.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150108200526.GD2634@sirena.org.uk>
References: <cover.1420628786.git.moinejf@free.fr>
 <54AE99D0.1050205@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+GUUlqgaeopBXFm2"
Content-Disposition: inline
In-Reply-To: <54AE99D0.1050205@ti.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v9 0/4] ASoC: tda998x: add a codec to the HDMI transmitter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+GUUlqgaeopBXFm2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 08, 2015 at 04:53:04PM +0200, Jyri Sarha wrote:

> BTW, the HDMI codec is now completely unused, since my OMAP4+ HDMI audio
> patches were merged (it uses dummy codec) and my BBB HDMI audio patches were
> never merged.

Might those BBB ones turn up sometime?

--+GUUlqgaeopBXFm2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUruMGAAoJECTWi3JdVIfQjHoH/2oaAt473gReYyBehArdf4+w
6ZYuguD+XWCOkT7jc89as4OWImBrUEto84a/N176LvONHRzeXKEzgpMma3RZo9w6
x/dC5iojTUdwtfVM6tFjBu3lkca7H0NqDILjEOtiyQ8mJmqGmALa27s9dkHtjg5W
R9nNCjLGgO+dhXdsxc5/o6Su5NgwsGTkt76vP+nQegpe5nmvydUo57sPYJFl2Vy8
Lpz62Nad2O+kvX5WeQBdXbIKVowzBtCoQm2T1P7OtFrhHjRdVfHdc8f4yXCcdohG
wGFR4t8NW/mLqJsCbGuP+2zlFWepsSUnsdCWy5/5I5QLBR+Bfwm0DvOG+qBUg2E=
=NzMt
-----END PGP SIGNATURE-----

--+GUUlqgaeopBXFm2--
