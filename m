Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbaCQP3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 11:29:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48743 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933310AbaCQP3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 11:29:14 -0400
Date: Mon, 17 Mar 2014 15:28:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Bo Shen <voice.shen@atmel.com>, nicolas.ferre@atmel.com,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Message-ID: <20140317152847.GI11706@sirena.org.uk>
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com>
 <1395049541-28128-8-git-send-email-voice.shen@atmel.com>
 <20140317115518.GD11706@sirena.org.uk>
 <5326FC20.9020304@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U3s59FfKcByyGl+j"
Content-Disposition: inline
In-Reply-To: <5326FC20.9020304@gmail.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/8] ASoC: atmel: document clock properties of the wm8904
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U3s59FfKcByyGl+j
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 17, 2014 at 02:44:00PM +0100, Boris BREZILLON wrote:
> Le 17/03/2014 12:55, Mark Brown a =E9crit :
> >On Mon, Mar 17, 2014 at 05:45:40PM +0800, Bo Shen wrote:

> >If this is a clock for the CODEC it should be documented as part of the
> >binding for the CODEC and connected to the CODEC in the device tree
> >rather than being part of a machine driver binding.

> Tell me if I'm mistaken, but doing this would implies a lot of changes.
> The current wm8904 driver does not handle clk retrieval and configuration,
> and I'm afraid that introducing these concepts would break other drivers
> (those
> connecting to a wm8904 codec).

Currently the only mainline users of the device are the Atmel drivers.

> How about adding CCF support as proposed in this series and think about a
> cleaner
> solution for a future release ?

No, DT is an ABI so you can't do that - once something is in DT we're
stuck supporting it so we can't do quick hacks so easily.

--U3s59FfKcByyGl+j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTJxSsAAoJELSic+t+oim9mVsP/2bBtrLwcabPJhC0LRrqF+OY
shd/AOMYOl4OxnBPEmSQ59RIpTEXA67xzCdUY5qF8EP8bJHA/SWgwPQUyROoDgAW
gwH6Kejpt7LnEUxJuDcJLnVPEDva+xI0Q4fRc2fyk6u/QuJ0/0nuJDKVdsHaCOqF
ziIUbmvMx1Romv8FpN2ghKMQ/JL+FMYEeCTIeOzQtc9Xqdrnee912kHLhEu6qDU3
QQq7EitZk+h85bmLgg7KoNSLWnYy1iNrjU6sfRyCXiJjWSVQIUXFJe/yhS4pUOwS
HF0rVQWag/OwzeExEIMlrwZHA07Xlm3621RMPxfnWAQntXtA+PQc+0DyXyQIKY4V
xmM7sdGHo9GqCnL5KDEMCQfRsshU6HRbArOZFVGl1YhxggGUVRdsQ6w7fe7TRM1I
cIkiDLG5KYxiugQriZUTNoGcun5q4txdu78JHHyfQDk3I9xHSQkjAdy9DPf/xALt
ZREvC2zDvp16ymLS0isVbymsu3aEy1DxbI5MDyAvkeL4SQzGYtAaFtL/rAAKj9ni
UEkKex1gDrWXzpIdS+ML0qNKyg5UhT81L6p3Su+OA4S7tW5d2ArEuNh3eAkpglmv
4kXygma0CNLqpd+uzFmDulueL2u3QzmawhZVQ1QOFN6fkHw+BYD7m3L+oxXdJHGf
XTrum79Xk7gZVOdAqweY
=WISg
-----END PGP SIGNATURE-----

--U3s59FfKcByyGl+j--
