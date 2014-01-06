Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaAFQc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:32:26 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47964 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbaAFQcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:32:22 -0500
Date: Mon, 6 Jan 2014 16:31:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140106163158.GH31886@sirena.org.uk>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
 <20140106131920.GT31886@sirena.org.uk>
 <20140106161001.GJ30156@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kuZFCdxJs1xgWibf"
Content-Disposition: inline
In-Reply-To: <20140106161001.GJ30156@lee--X1>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 00/11] ASoC/MFD: twl4030 codec local register cache
 removal
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kuZFCdxJs1xgWibf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2014 at 04:10:01PM +0000, Lee Jones wrote:

> Are you planning on taking this in for v3.14? Only we're on -rc7 already.

Yes.  It's a driver change and if it's buggy we've got a couple of
months of integration to fix any issues.

> It also depends how closely knit the MFD changes are to the ASoC ones.

> Are they completely dependant?=20

Yes, they're tied to each other.

--kuZFCdxJs1xgWibf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSytp7AAoJELSic+t+oim9y3YP/0odtulVWmZAahBGny5LZWVn
+cg7eJsM4GfP5mUil9HMaEr5feOkaBPtgwxRubVaG33CfDqTG0GHORkBjcx/tthe
7m+8m09rnhZLGWsw2o+SL7/Ogu+l4+7Ljv34iAKC4i/GrzmKn4y1rVd4s2WgpMyZ
crpbDJTibaUI8df2v4HI0cupe5+m9HlDdkdNnHjDjH440siNErKG4pZid3aiMLO7
+PlTkdc3kYzepXKr8/wmEIuDno5TpIXPCDkGMZ0R41PesPhR9pxUH3WQxLO1RZco
3hdOIelFeEJ6a3kIFmYp1Cow97DHCi6LK3XvaZW9fP1b0GpuoLdSr2RHhHsdeiR+
+6QDmdHkPXNcXNaRYUcSbKYcV2J46JsTJbtacM5Oc9OMWmkbCwcazYAcUqHqkUVR
uLahdyaE6gZxR3SY68/2rOZl7AkhQuIWWijYoCMbMamqvjb8YnGy2vUCpFmTBg2n
XqtTx7Bxhqwyw6c5QW1zZGcKxuMgvRXUVcAlj/318qtBwlFuJTw1dbHxw2P3ivvq
yGuuY7YkOLWzxIGJ071IZgGKFlSpcucbOSVw4nvF7I9pti0/kbJNCdyD+brhxN7y
ai/FOxGwZL35vPbWJvWpRQMmdiEELQhIPsq/57v/PFiDJOSI/6o13oXyVRhgBCxi
YgMybhaYFZWpzYPKXoFp
=agmE
-----END PGP SIGNATURE-----

--kuZFCdxJs1xgWibf--
