Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaIJO2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:28:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45746 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbaIJO2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:28:11 -0400
Date: Wed, 10 Sep 2014 16:27:40 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        shawn.guo@freescale.com, kernel@pengutronix.de, linux@arm.linux.org.uk,
        perex@perex.cz, tiwai@suse.de, timur@tabi.org, nicoleotsuka@gmail.com,
        Li.Xiubo@freescale.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH 2/5] ASoC: fsl: add imx-tlv320aic3x machine
 driver
Message-ID: <20140910142740.GC16489@pengutronix.de>
References: <1410356809-26179-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1410356809-26179-3-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
In-Reply-To: <1410356809-26179-3-git-send-email-d.lavnikevich@sam-solutions.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:22:37 up  7:10, 45 users,  load average: 0.00, 0.04, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 10, 2014 at 04:46:46PM +0300, Dmitry Lavnikevich wrote:
> This is driver for i.MX6 boards with tlv320aic3x audio codecs.
>=20
> Signed-off-by: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
> ---
>  .../bindings/sound/fsl,imx-audio-tlv320aic3x.txt   |  27 ++++
>  sound/soc/fsl/Kconfig                              |  13 ++
>  sound/soc/fsl/Makefile                             |   2 +
>  sound/soc/fsl/imx-tlv320aic3x.c                    | 177 +++++++++++++++=
++++++
>  4 files changed, 219 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/sound/fsl,imx-audio=
-tlv320aic3x.txt
>  create mode 100644 sound/soc/fsl/imx-tlv320aic3x.c

Is it possible to use the simple-card
(Documentation/devicetree/bindings/sound/simple-card.txt) instead of
adding a new audio card driver? There are also DT bindings for the imx
audiomultiplexer (imx-audmux.txt).

Best regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEF/bAAoJEEpcgKtcEGQQ8FUP/1T8kBw9DpI+zwwwpLSehGQm
6Ji7FrbHkdebaT67xrOD4mtqepsmRdIdJ/Nj3epWLwwNjJMJOYtzPGOQzYvZxMiT
3PwhyRMmWrU86fFoZlK1rO8/mY/ZF0VmAjzMnvO6fQpO9f/sl+z+bTYJbzTzfp3Y
i2MQ/FF4CGCEOUZtFpu8Tth1YyKhAkI6HQd/px4JJ+PmuEy54xRZuu9k7COYvogH
faVBV0qaYGhBhMLN5UPVEuRjlaphc+WyD0dq9/F4HCODhhQK/Apsz0fDoFr3p5A4
isfxF05I9iQGOFbdx45vqUW87NXjXiqtfHgdt2W3cZjC80IVd469pbSTBkfW8ncb
nzoMV1wswMGTPcr5pVorVoOesj2DQ5H+lebem2aO4c82g9JF2nAZjVCcph5RSjoU
ZxzcWzjEkWBMZxXyP7n20pL8VjOVwOe6Qi64LYIQXxlFRn4ivlzLj69HC3wOMtG5
aP6J3pcoH9+2yOMEWxkSrhjcY72GY9Q3Nqe9U7unFtond/AM7/MAvOEe/kwrsYfr
1SK2o5InF4C07Twla6gV6xnJcx03OCEQsGfqHoSxyaXmS+XWtQ/pbUOoSV7Mm7DM
gDjPsz+8MQmCmhlWp7Q7OS52Ky55EPS7r9Hq9Hcvx9D7+ybb9HnxP5XFHY+n/Fm1
VDG9BEJrmQ5mKC4SHwip
=/Noa
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
