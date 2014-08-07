Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbaHGLT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 07:19:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51345 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaHGLT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 07:19:56 -0400
Date: Thu, 7 Aug 2014 12:19:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, timur@tabi.org, Li.Xiubo@freescale.com,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, b42378@freescale.com,
        b02247@freescale.com
Message-ID: <20140807111941.GH17528@sirena.org.uk>
References: <1407223925-29678-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Va8DSfvMR3bM4AuH"
Content-Disposition: inline
In-Reply-To: <1407223925-29678-1-git-send-email-nicoleotsuka@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Add asynchronous mode support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Va8DSfvMR3bM4AuH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 05, 2014 at 03:32:05PM +0800, Nicolin Chen wrote:
> From: Nicolin Chen <Guangyu.Chen@freescale.com>
>=20
> SAI supports these operation modes:
> 1) asynchronous mode
>    Both Tx and Rx are set to be asynchronous.

Applied, thanks.

--Va8DSfvMR3bM4AuH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT42DJAAoJELSic+t+oim9Y6EQAIWj1A+/REEmCFveYNytG/KU
ZTNjv3KXMmX8j6yRM4XaWoM0ZK6C2Mn0Lz611Xl4WVA1hlFmqzBGUQXuOqBig0rJ
hxGRYS2DmcB3Aq2IugEtyHRkdhBc+wtgVToMRHKDiaVNDBgXU8zVmp0/n9ZH3wz9
svhR4vwd1JVhl4kkn13rWTEdQdsMAbQT+kl4gQjIDRNmm8jB8XF3q6ADyQ2SqNW9
VcFnCZ0CIkReuHURw6vxNSHhLKdZD6CcMUr4f2ZujiBBcSStxI9s9jl8Cnf09XwI
h4w9SLc5SfiV+gtHCeni+j6mv7YljgnEMXibUe3/P+dhIJkzUR9F8umX6FtcHUTa
qsTjfsLGNdOFmu9aXfiBEWtEJ3E4HEl745XsixwDs4nzMtjyz7E4MCzmHfW4/gXv
Qd2vrRo69e9oAVO9hCdOv+JMFZbX8sZPKdn8VZelyK1BImf+NTgjDrWDlBVIncjd
6FlTkGZVnQs2JDIK72Ic+76NfFYuubtdietksjyh3vwbLBUgKqgk/bXf/LzuIzkC
eWU5ZhDwAgem6WTdD41cul3uFM1KAfI1ylqIsxHjQC2pfvhnD8oMQ9ZKPkB2YGrz
06IOeERo3UlLzZPgDxK0mRpA324IwhjRIMybkrh6AZR41lIZ081UeCdYxcdS/Ek7
38BqAyxYaaQkAFV5eXTU
=/x+C
-----END PGP SIGNATURE-----

--Va8DSfvMR3bM4AuH--
