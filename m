Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaAVTEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:04:45 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58269 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbaAVTEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:04:43 -0500
Date: Wed, 22 Jan 2014 19:04:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140122190430.GU17314@sirena.org.uk>
References: <20140115113551.0eb13409@armhf>
 <20140115165133.507595c9@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l2vDcU+jBoWlRij1"
Content-Disposition: inline
In-Reply-To: <20140115165133.507595c9@armhf>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/8] ASoC: simple-card: simplify code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l2vDcU+jBoWlRij1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 15, 2014 at 04:51:33PM +0100, Jean-Francois Moine wrote:

> The check of the mandatory fields is done for DT in its specific sequence.
> Move the global check to the non-DT sequence.

Applied, thanks.

--l2vDcU+jBoWlRij1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4BY7AAoJELSic+t+oim9I20QAJA2R3yahk4plEkY/Rg/It6i
iQM8Fg8N8dsm7/T9twTt5X0n68XcGMsAndHXI463Xu0RQ9XItF01tbtIAJv5VH4L
mxwchj8UEa2EUM0YhsmKx7Je9E5UTQMixi5xrLLH3vzsqBzOR1ybZHyX9WeTuAxj
9W5UK1zHeHoYTN0iZZm5TiBOZWqvD/LabktD+Y91I71a9+Bys3u9SFLaMpMhDpXq
iniRZzHpaX7mB78IQ0G/afOFX0CqAwV5wVOZyuWJqvRtihuja+kugxZiK2BKaV6n
H+3h0L7Ev5oIz40ZLyRp7FR6nUL8a4aFFhs1xBKDVEKC79+mRYgIoLcS+RTlYanG
u+JEnk0mT3yfP8EbRh+mh1AAkvG0qRpwlBgCSQINZwVM7vjaBIuV5URVNUkZYoAb
dC/8Wcc7Mw7ZP2VYaDANT+StpEcwsBGsitI0am02xU+OzY72hNici/S4PkPoFimR
NsdyH3HWJ7waHSh8/WTAiYRjgLPh3uwuimZJ4TRGqN4Zjf5HM5tue+LgiB9diMMn
fVLp82Mqj+L/XWha9xULxmfFXdT5ATJa16nGNEo39VUPIvgZuWcj+STUqycNv/Fp
W13zWGvmOBhAj6xO1NV6Z3ffykSQ6dc0XG1NO88teOzLX96Zcr7VtSTCVf/dndc7
x/J47J7Z/nVPRNcW8KPt
=sxni
-----END PGP SIGNATURE-----

--l2vDcU+jBoWlRij1--
