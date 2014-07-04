Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbaGDRwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:52:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47191 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286AbaGDRw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:52:27 -0400
Date: Fri, 4 Jul 2014 18:52:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20140704175217.GF19453@sirena.org.uk>
References: <1404464116-21038-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ULyIDA2m8JTe+TiX"
Content-Disposition: inline
In-Reply-To: <1404464116-21038-1-git-send-email-nikesh@opensource.wolfsonmicro.com>
X-Cookie: I never did it that way before.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: arizona-ldo1: remove bypass functionality
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ULyIDA2m8JTe+TiX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 04, 2014 at 09:55:16AM +0100, Nikesh Oswal wrote:
> WM5110/8280 devices do not support bypass mode for LDO1 so remove
> the bypass callbacks registered with regulator core.

Applied, thanks.

--ULyIDA2m8JTe+TiX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtunOAAoJELSic+t+oim9LGIP/1/MR7dvAuHTac6R4WE6hwTA
6odbGgCgcUdyFPiI+4bveW8/O5pLQjEEnwx1dc+6hGwpuxSPgRFoO+yGbdWpYUUp
O9eLftxAHg8rDTRSBEg/IvlGVS2i9Ftl6X9q8P0wWQMxX1jrQpwJ2IC1D3XgdlWc
lRpDQp2EHVrAZ/ynWiNLsTRg/mjKMXbzmNsZBy5C3t4+usb/MVo/0HW9qPMpC8Ox
BbpjKjgCP+rQiLQtQMLiU2Z5iDE3EcTnl4mlbwLg5w5DTanFrZIYdhes0wfgSn4a
kd3IcB924QZ85Nd0LXDArGovvtKOCY+jLqRwH0Ms23MWVQM4WzdWvSeyaEmpYsSZ
lvttTFBGJTB8532seRY5GhdtQhclY+RLLCyWsknMDEOW7ZQIQrYnhJVY8SLb7I5v
mYTjeKfLWdxsInAU2iVFXZm9VSjL1vVPb61Oy9QEvIytwGlKa+B/x6/HYo/HZqio
9mdCG96GKXAzj2+e2tO9n5EAFn/y19F0wFjrVQWXZIxXYKr65ydSsxOYWw8f8Lh+
ai6pSuh+gVu7kPEHeQylIdLc3ttLeTPhnYFcPMw5/fGil0SYMJrNMvj9Yaz7hKGn
Dck2WZEh5nZ9MHSE+WwUPZX6L8s7zRX/f7kG7/LjW1crtaffCsiLh+NKyhXftnVL
JmFjqb2lB+NnDKqjo32k
=v0yH
-----END PGP SIGNATURE-----

--ULyIDA2m8JTe+TiX--
