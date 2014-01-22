Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbaAVUGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:06:22 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58335 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbaAVUGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:06:20 -0500
Date: Wed, 22 Jan 2014 20:06:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140122200611.GB17314@sirena.org.uk>
References: <20140115113551.0eb13409@armhf>
 <20140115165156.3e49fb84@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YfTVQqw/Zaey7fPo"
Content-Disposition: inline
In-Reply-To: <20140115165156.3e49fb84@armhf>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 7/8] ASoC: simple-card: simplify code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YfTVQqw/Zaey7fPo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 15, 2014 at 04:51:56PM +0100, Jean-Francois Moine wrote:
> The platform data structure contains information which is used only by
> the driver, and the driver allocates platform information fields which
> are of no use.

Applied, thanks.

--YfTVQqw/Zaey7fPo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4CSwAAoJELSic+t+oim9VF0P/1DpgNDzvQ5syQXQnq8CigLJ
D7+4NspG7k7XSN3MSsPblqDuvRMrDbfu9ywRdTcRC67fXyFW1ct4MxNt++q7oteH
gvRYMgwP1uXuBdMxppH/xnGL9+WpHZFzXHAGOQkuc/3FNsK3ATAK6iWdu/OHXw1A
4qS6eLpWSX7SdtDkgrI1ngo8Z6XWBrhXImLJS6UDIS8j8K3UXt2MGWXzBUXIsziL
kcb/tZhOUV24ol8bPbMwdCqdaTyVA3X7Hifb/fFyye8iGcEQlr1DPmD4SSZfn6r7
Y10zCjexYAwMq7+E5Qyp+79LrTIluDif048EgPMzGwnpbe7QWCkL2tVo+Hg94jK8
zVxuXa3+O+nEtxSaJ6D0JYlPfeX33cLpOSVkdoZgiIJNxwnWa6l9gqdm8aoKNzGB
QWtSmTdkS9EyLCx0QEPhnLysyF8JZG2kUc+amOsLcB5carIa/UqH9tD6s/AJxBuM
2ZvygNU9HCGYtctcmuyV8FGi1aGKfdSZt85IDYzM0l959yErJQuDBtVop19wD9tF
QsvZCYDxMTW9+dw/IJFdqDx/mHLS2vLNdK+l9Jj46FU8sKQ8+amOyQc2xJEVM1H6
Cq4unLUS+N7n3QFE417L0BLdQMMdr/DqHQxxtjeuZkbWoIddphlMpDmj9G1RZk56
eG0BQhp2x8/qrM6WFmaU
=P+XU
-----END PGP SIGNATURE-----

--YfTVQqw/Zaey7fPo--
