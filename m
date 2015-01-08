Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbbAHUEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 15:04:43 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45055 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbbAHUEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 15:04:42 -0500
Date: Thu, 8 Jan 2015 20:04:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Jyri Sarha <jsarha@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150108200421.GC2634@sirena.org.uk>
References: <cover.1420628786.git.moinejf@free.fr>
 <0084acea5a3475a77531d6a77483f36d3469111a.1420628786.git.moinejf@free.fr>
 <54AE99F5.1010404@ti.com>
 <20150108174257.557f7ea5@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJFyG9uzPui3fcuS"
Content-Disposition: inline
In-Reply-To: <20150108174257.557f7ea5@armhf>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJFyG9uzPui3fcuS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 08, 2015 at 05:42:57PM +0100, Jean-Francois Moine wrote:

> Examples:

> - for the Cubox:

> 	audio-inputs = "i2s", "spdif";

> - for some other board with I2S on the pins 3 and 4 only:

> 	audio-inputs = "none", "none", "i2s", "i2s";

> - for a fully wired TDA9983B (no driver yet):

> 	audio-inputs = "i2s", "i2s", "i2s", "i2s", "spdif";

I think that mostly works, though I do wonder if we need a way to
specify the ordering of the pins (if you can make pin 3 be the first two
I2S channels for example)?  Someone might choose a strange mapping for
board routing reasons for example.

--eJFyG9uzPui3fcuS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUruLFAAoJECTWi3JdVIfQnlIH/0UKnbIlsOmNDZ/HbhAVvaQO
oOdt2VBztvN6yIuRhRpVseGjLnOvq10eeI3YspLCSoz02DX2FVWEaDG5EXqy2+UZ
UrDPEJMei6hmq1pYXEu0sVvaklB4uQ7oN00Lw3zwVa0DPukikXAPqjfRvhYUgGv0
S4ZptpfWXRh1VD2mrEE53/U480XxRmY6LtIpCoDf/bBffRKerdDeFhHQIcNK+V9A
XZyVaYEGceo2+R0OTY8muTgtbcqHjFRHJEMaQDOaS18gQKf/nR8UVLZummU4xtkA
ksE+agV2KfXYE+0XGOkrvJjdRkxvjICOiVByMIyYwYo1gNK7MEsOQGJtHEHMLQ4=
=S+Zv
-----END PGP SIGNATURE-----

--eJFyG9uzPui3fcuS--
