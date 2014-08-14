Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaHNPVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:21:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35294 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbaHNPUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:20:21 -0400
Date: Thu, 14 Aug 2014 16:19:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Tim Kryger <tim.kryger@gmail.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Haijun Zhang <Haijun.Zhang@freescale.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140814151958.GY17528@sirena.org.uk>
References: <1408019940-11153-1-git-send-email-javier.martinez@collabora.co.uk>
 <CAD7vxxKvzxvmzgx=S5ZZn54ts99ca2TqBYFvY1SXZQZDkhjq3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mPodVEv4hA2Czmlf"
Content-Disposition: inline
In-Reply-To: <CAD7vxxKvzxvmzgx=S5ZZn54ts99ca2TqBYFvY1SXZQZDkhjq3w@mail.gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] mmc: core: Use regulator_get_voltage() if OCR mask
 is empty.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mPodVEv4hA2Czmlf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 14, 2014 at 07:13:00AM -0700, Tim Kryger wrote:
> On Thu, Aug 14, 2014 at 5:39 AM, Javier Martinez Canillas

> > Without this patch, the following warning is reported when
> > a FET is used as a vmmc-supply:

> > dwmmc_exynos 12220000.mmc: Failed getting OCR mask: -22

> > Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.u=
k>

> https://lkml.org/lkml/2014/8/12/377

For the benefit of those reading here=20

> Perhaps I misunderstood the discussion in that thread but couldn't
> this failure also be addressed by adding proper constraints for each
> FET in individual DTS files to reflect the range of voltages that are
> safe for all consumers of that supply on the board?

> I thought the main concern with your other change was that the
> constraints you listed in the DTSI represented the limits of the PMIC
> and not the consumers.

Right, there's two things going on here.  One is that as you describe we
shouldn't be putting constraints in .dtsi files if we don't know they're
OK for a given board.  The other thing is that on this particular board
it turns out that there's no support for varying the voltages at all so
it doesn't make sense to have to specify a range, there's only one value
anyway so the software really should be able to figure out that fixed
value all by itself.

--mPodVEv4hA2Czmlf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT7NObAAoJELSic+t+oim9LH0QAIPiwxTMEZ2VpPRjHzieTDOS
7d21R8FVjJTsoOALjOEiePRzTf0re2r7BsCqORVCoOa9mWJMf19lGnUrJW0oQk0r
uaZET4+OwsipA4gWOpc09DcxEEbdpNmNpuQtPZdUfpzIvp3ZG95WG2qdXQhtj+ap
u7nT8LHR3ga8hR85/0I1nWbTw3UfSsA6P5i0ILiQeIIB01tWDHETd3SvV0tGcLF1
FLxAOnwh2GZmttb8w1YypOhQPQK95K1mYaVaNMavRlra0JFD05F29n50APj+ZYn7
CoI/fHvYHmt3buw/rPCZY9r46/eksa9oQ8jUHnuXw0lxGPgJCFeA34My51gU+Cmu
oIbwin8xGLI1oSXuQOsC28FavcIfGjBNk+Ck9Quo7n6ueORFJnLcg7ZcDZNEa/gN
ccDQVDFk8q5FQXs67mYjBPXrS0DJS3IWZXcuHmFfZfgBENt+RDmBby6ibQOMoKWo
fdAjZwqZNLXDulZFgG9gJG/F6ftQy+U5HWt1u6VBpzqPasFgajRTE208AT3Yl/UO
xLGrL5dELU1Tm6L0EFpJZFXnuv3VwKz9mdTLZvR9Akk5r8NoFZ5grPt1g363Ydlv
/KAKbstRSywWGyNx/PPlJNLoavQngXu1dQqzw+uoNL8SWMweyGtnugk8ipyoNPaJ
FDWb3QVVxcDGz7DwOs5+
=CjFw
-----END PGP SIGNATURE-----

--mPodVEv4hA2Czmlf--
