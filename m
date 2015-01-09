Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbbAIRzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:55:24 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47343 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439AbbAIRzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:55:22 -0500
Date: Fri, 9 Jan 2015 17:54:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>, Jyri Sarha <jsarha@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20150109175459.GN2634@sirena.org.uk>
References: <cover.1420628786.git.moinejf@free.fr>
 <23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>
 <54B0123C.9070800@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yS2QJoX5Vl2MmcUM"
Content-Disposition: inline
In-Reply-To: <54B0123C.9070800@arm.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v9 3/4] ASoC: tda998x: add a codec to the HDMI transmitter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yS2QJoX5Vl2MmcUM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2015 at 05:39:08PM +0000, Andrew Jackson wrote:

> In the light of our discussions elsewhere [1], shouldn't this
> be constrained by the number of hardware channels that the TDA998x
> supports too?  That is, the maximum number of channels should
> be the lesser of sd[SAD_MX_CHAN_I] and number_of_I2S channels=20
> (or S/PDIF channels if so configured).

Yes, that's a good idea in general - we should do more of this.

--yS2QJoX5Vl2MmcUM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUsBXyAAoJECTWi3JdVIfQazgH/0plBowsIMWRwsEapQBO3mSJ
+AhpyNiWBoOpCtbEhgQVxJtL+mZ2OT+LqE1RPLOuGdjukQlOCz5q1dx1q/q+PrmB
OGnCov6TIp1k+5qW9GeHhoJgEsaSXFys45dXT9egpgMI7UuqeQswZVHK4cfD6Mpd
byU5MxgWgNzG2S6EWOr4MaHVsQNTDr0WFuo/ZjouK3FiEUj80P7A/0mPxeYfzPC6
/iiIOyvAM48Q50ppXPzDboUhyopbeszQd++M2/5tv/y+DfqA9DO44fdHxrwApB22
+UZyrcwdNeuKCvO/1Q2Le1xj6MinPTxEYC4XVekeAiylOOLTSAimPgqcnrbjiyI=
=l2kO
-----END PGP SIGNATURE-----

--yS2QJoX5Vl2MmcUM--
