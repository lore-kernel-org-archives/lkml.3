Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaLXMoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:44:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47217 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaLXMoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:44:15 -0500
Date: Wed, 24 Dec 2014 12:43:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Jianqun Xu <jay.xu@rock-chips.com>
Cc: lgirdwood@gmail.com, heiko@sntech.de, perex@perex.cz, tiwai@suse.de,
        sonnyrao@chromium.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Message-ID: <20141224124351.GA17800@sirena.org.uk>
References: <1419325709-15374-1-git-send-email-jay.xu@rock-chips.com>
 <1419413822-11539-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cyl6hb1YSGs8e3xM"
Content-Disposition: inline
In-Reply-To: <1419413822-11539-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.173.220.131
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 0/3] ASoC: rockchip: i2s: fix watermark to 16 and
 maxburst to 4
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cyl6hb1YSGs8e3xM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 24, 2014 at 05:36:59PM +0800, Jianqun Xu wrote:
> To make Bus DMA works more efficiency, DMA may work in burst mode,
>    we set the watermark of transmit and receive reach to 16 bits.

Applied all, thanks.

--cyl6hb1YSGs8e3xM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmrUGAAoJECTWi3JdVIfQtnUH/jlUIaFclxbl8kbSp3+66qUd
tZmX+3g/aZl5X0D+LrfEzi2AbpZkA39YO+8E9qUT2lITmRQ+ubq0NLcLp5DyTZqu
Hy4hsYkky+Rf3hCEZUfNteusKJAYZx46cebpYZTQh88CRv5OU/OfGNjyk8f8IVJr
EsDzXMcSOTxGWrjPgoPLctkRzOqLq1p0WHEGcB6xTSIYmQ7IWAf8TinGL97RXEYw
1SHb+i8L0RaWsrHSA35NxKk0wqCoV52QxCwUII7VIsRdtBC+PGEnufOvgrjtWNkP
1MjbSd2NguOMu/XSuFtb1u7MXVyGkirmE82mzHNOtp3SmHiED4MjLQR169+L5u4=
=9RR4
-----END PGP SIGNATURE-----

--cyl6hb1YSGs8e3xM--
