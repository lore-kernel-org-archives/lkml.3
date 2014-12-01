Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbaLATLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:11:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45308 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbaLATLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:11:46 -0500
Date: Mon, 1 Dec 2014 19:11:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lgirdwood@gmail.com, alsa-devel@alsa-project.org, pebolle@tiscali.nl,
        slapin@ossfans.org, Bo Shen <voice.shen@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Message-ID: <20141201191130.GI7712@sirena.org.uk>
References: <1417449472-13498-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lh8ebNKBZqiTXIxR"
Content-Disposition: inline
In-Reply-To: <1417449472-13498-1-git-send-email-nicolas.ferre@atmel.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: snd-soc-afeb9260: delete driver as board has just
 been removed
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lh8ebNKBZqiTXIxR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 01, 2014 at 04:57:52PM +0100, Nicolas Ferre wrote:
> During the removal of all AT91 !DT boards, we removed the AFEB9260. This driver
> is !DT and was only used by this board, so we delete it as well.

Applied, thanks.

--Lh8ebNKBZqiTXIxR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfL1hAAoJECTWi3JdVIfQwFgH+gO8f5/PtujTbPKTTgiwlrcQ
yjVSos+hGyg2J50IQOl6Far4rtMaeCf2NfwVJvPOkiKW5pcIkRswW+Vi+6ezWAxP
C1dfZVGbfbswE9oSTnsNiV59UK0vpXauNu2cZk4IRYQSiUl04EtLrlWduAyobHYP
N20pqQnDJ+Bd/707Y0r0hsm0Kkr3UCLuh69ZHSbfT+7kWTfcXj/hpx6muiPMx+34
v5kMYbvgvpu19QWVxi8pNU0QzS4X98ylGdao7iCPvprrGzgmX4ZUI/BAz+822doW
VDlV4re/gqpkDXXiYWsTbsw7GRxZHzfpKuohU2LE59KqQVDDmO+RPymhPIv7osI=
=wbYR
-----END PGP SIGNATURE-----

--Lh8ebNKBZqiTXIxR--
