Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaBYDKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:10:24 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51272 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaBYDKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:10:22 -0500
Date: Tue, 25 Feb 2014 12:09:47 +0900
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: "Austin, Brian" <Brian.Austin@cirrus.com>,
        "Handrigan, Paul" <Paul.Handrigan@cirrus.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Message-ID: <20140225030947.GO25940@sirena.org.uk>
References: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140224113011.GE25940@sirena.org.uk>
 <B745DBDD-8A64-4B98-819B-72F8AFF602DE@cirrus.com>
 <20140224160648.GC6132@MrMyself>
 <20140225000027.GI25940@sirena.org.uk>
 <20140225023840.GB7229@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BvHHjgBzqS6ETPrS"
Content-Disposition: inline
In-Reply-To: <20140225023840.GB7229@MrMyself>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: cs42888: Add codec driver support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BvHHjgBzqS6ETPrS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2014 at 10:38:41AM +0800, Nicolin Chen wrote:

> Hmm...my words might not be so clear last time: we have to handle the dividers
> of ESAI in ESAI driver because the dividers is in the ESAI's IP, not in the SoC
> clock controlling unit. So it's hard to get them visible in the clock tree.

We should be able to arrange to have the ESAI be a clock provider
shouldn't we?  If the clocks need to interface to other things (and they
do) then we should be able to use the standard interface we have to
clocks.

--BvHHjgBzqS6ETPrS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDAl4AAoJELSic+t+oim9GP8P/imLCGxvTsElxeKwyG2MnRVl
8HvcyXUwrDBUrHU16QGBiGeVVQkr6JdNIHR1W4AGy7ZB0WzXrYY9V2wXx9A7zuLx
qGw4bS1hoDldaVQNcIeoa7OEUDiq0nm+D784fGjWLo5IQGJUUkH3NpQzzCFDIVem
CUTnqUuZmJ45uI9bBR91okGScso+cN0/lUzJE33tAHRYj7a+WKT9IHsri8+nttJd
+1ruSmfDBxXS3PkiRg9fPt1kX+7M4bt3bVM3zsp4HHokOWYmdkqfJKVRbVXJYmhs
hZoxR7CXhO2IKFKUI5cBO5uH4ctZT8gihwxJWzBi0dayUiFjSUdveSRdw6uJ+ioG
IHbauLHERnQC3XxdBV/bzRIbXMC7bJsjrgW9yMBMAjFbWe9l3I1+Tm5VQF1fVVta
HZACr7moMDUAgBmumdg+rt/cRlugzEBy/yykIsTxWCAY/1qV0Kw6aP2YKk1gOfCM
cZW+SoZr3tn5xjSikPwpnvXaxp1ONh249pwcmuscd7MXPmTxm7h3lRcpeekqIhOe
BbxQDble+SkYT6ACky/lJGwc9IUaeK15jorgw6RdQ004c2xzcs9qRSpoYHsgENYi
mtEyVOCdOfCsu7F9mVeFYNQVy19lJlMIpHfh0LwEGNqjzBUXFN1LojmInlsrhrMZ
2Yl1fsi/4ti1AoMR9LJm
=3ZVy
-----END PGP SIGNATURE-----

--BvHHjgBzqS6ETPrS--
