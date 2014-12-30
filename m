Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaL3RAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 12:00:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56001 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaL3RAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 12:00:40 -0500
Date: Tue, 30 Dec 2014 17:00:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Jyri Sarha <jsarha@ti.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141230170001.GO17800@sirena.org.uk>
References: <cover.1414053169.git.moinejf@free.fr>
 <20141229165246.GZ17800@sirena.org.uk>
 <54A19151.3090506@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sv7CUYPyUbxygwr6"
Content-Disposition: inline
In-Reply-To: <54A19151.3090506@ti.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v8 0/2] ASoC: tda998x: add a codec to the HDMI transmitter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sv7CUYPyUbxygwr6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 29, 2014 at 07:37:21PM +0200, Jyri Sarha wrote:
> On 12/29/2014 06:52 PM, Mark Brown wrote:

> >So, I'm not seeing *any* interest here from any other HDMI users.  This
> >is a continuing theme with HDMI patches and is really very concerning,
> >everyone appears to be working in their own bubbles coming up with their
> >own things and ignoring everyone else's work - what little review I'm

> I have not seen any significant new development since v7 of these patches.
> My comments for v6 were mostly[1] addressed and I can live with these
> changes, even develop this approach further if it gets merged.

OK, so this sort of feedback is really useful - even a qualified
Reviwed-by is useful.  Total silence could mean anything.

> However, as a general note I see a need for a generic ASoC hdmi codec
> abstraction and I don't think this is generic enough. More of the audio
> specific implementation and HDMI standard specific things should be pushed
> away from the hdmi encoder driver (tda998x in this case) to the generic ASoC
> side hdmi codec driver (or library).

This is something I'm expecting, yes - what I don't have is a clear
enough picture of how consistent the different hardware is in how it
models these things.

> [1] I personally do not like the hdmi_get_cdev() approach. I would rather go
> with only a library for registering from ASoC codec component under the HDMI
> encoder device or a completely separate device with only a reference to the
> HDMI encoder.

It does seem somewhat complicated, yes.  I don't know if matches idioms
for DRM somehow?

--sv7CUYPyUbxygwr6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUotoRAAoJECTWi3JdVIfQkfAH/AvhxX4Sb7Mf5MMIWLdFevna
F79I11qORhxkOPMVUrccJPrN6wzkSqbecH8N3b8wkjqBhlO9h3hI0rfXXKbmqpCd
RTrTBRhQYYHm0zlpy4LhW0HLA11icoj+vTeYEonjn/gr9Vnz3f9bmgDSKfIKjZzr
+j9uyXLGTDCIWG6AkwvAjVq3MZ0H8TtWoNLd/jlmxFJG8tURcW545WQiECUJyzMo
y0eC9j3UWS4oPGxIVx9wjDoBVelY/rtJICYqmYEDkcNOReS/TtZ2JFqQff5RvvD4
fSGao+eEaK9MpkfvEZb3+gRUXt/wznP06wi5FzXCYH0/BD9sHCXMlhcrhUqjeWY=
=uivE
-----END PGP SIGNATURE-----

--sv7CUYPyUbxygwr6--
