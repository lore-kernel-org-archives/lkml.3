Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaKNJgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 04:36:04 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45696 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbaKNJf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 04:35:59 -0500
Date: Fri, 14 Nov 2014 10:35:56 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus <magnus.damm@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Joe Perches <joe@perches.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [alsa-devel] [PATCH v3] of: replace Asahi Kasei Corp venter
 prefix
Message-ID: <20141114093554.GC3810@ulmo>
References: <878ulzx6hr.wl%kuninori.morimoto.gx@gmail.com>
 <20140922130026.GK3290@leverpostej>
 <CAMuHMdX22z97SbGS1HDiYfJ1PXxyEN2S8D7w4sr+4bUwD+mJZw@mail.gmail.com>
 <20140922132743.GM3290@leverpostej>
 <87y4rfhmgl.wl%kuninori.morimoto.gx@renesas.com>
 <1415845309.4269.6.camel@perches.com>
 <20141113025105.GA16652@verge.net.au>
 <87vbmjhj00.wl%kuninori.morimoto.gx@renesas.com>
 <20141113110740.GE3815@sirena.org.uk>
 <87k32yd0bd.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nmemrqcdn5VTmUEE"
Content-Disposition: inline
In-Reply-To: <87k32yd0bd.wl%kuninori.morimoto.gx@renesas.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nmemrqcdn5VTmUEE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 01:43:03AM +0000, Kuninori Morimoto wrote:
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>=20
> Current vendor-prefixes.txt already has
> "ak" prefix for Asahi Kasei Corp by
> ae8c4209af2cec065fef15d200a42a04130799f7

It's usually enough to show the first 12 (or so) characters of the SHA1
here. git will show you the right one if you do something like:

	git log --abbrev=3D12 --abbrev-commit

It's probably useful to "git config core.abbrev 12" for Linux kernel
repositories.

Other than that it seems like you're being overly careful about not
exceeding 72 characters. Your lines seem to wrap at around less than
50 columns. However, making lines too short results in equally hard to
read commit messages, so please try to shoot for 72 columns for maximum
readability.

Thierry

--nmemrqcdn5VTmUEE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUZcz6AAoJEN0jrNd/PrOh184QAIyFeFb0JitxevXRKO/hbCWO
CzgVMRe6woK/rTnRHU0MCuLnj16vX3C3iwkle6zx//hIIb7PEojJWuI7Tt0kiCyJ
82O8UUiAUctE1El57NVbYnlQQrJz10Mk8mtbhdjmfjVnnw8+wjeVb/vKr0b5rTTC
II6N+4HNW+Tk8GjBFpzW7jm8tzYooWjlKuDX3rRq86nBKbjAcCaOPQy9osuN1+tC
qpC4mmXYgJPGLmsPYWiyPIBcg8T0fCnbmnXZ0S174SNjJ8CyJjKAjyqkHyueTZj5
kpCZ43yVcffpvUIHFtRXMlhd48nOrFIczlHriSb23CB1ouxwYSfyi7LcZlk/KovU
6DtN9qY95DZqtzvRWFi9S9SbtZTDSBJveyYvpugfe9zWuUVCqa4MPdkdT/UKWxim
BIFLYOmn0+ogrCAFGYOTBNpyB/HjUsvXkzZIUB2vlPr+oOL90iR0GQHtK3yrrkm8
6HhpUv0Vy6xALf+1vIL2yFMfwxTUXdYHKIqGqXRwTPO5E9eOBkdhRDMPdIKHOaE1
hxqDOe3Bh+bDTK5y1ap8wA0uDXsXcqDSKDVejkXP+/vcVx00laZNoWH1IgaryVr9
HufPUWblViM+kFrYHiTN4MaFQpP6/UQJ5VL/GwZbZZex98SMYUifY6Sv4KEKFEHx
yJ3gMY1BT34KzjqBz0uO
=3365
-----END PGP SIGNATURE-----

--nmemrqcdn5VTmUEE--
