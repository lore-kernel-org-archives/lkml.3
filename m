Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaKCMLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:11:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35247 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaKCMLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:11:30 -0500
Date: Mon, 3 Nov 2014 12:09:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Message-ID: <20141103120956.GF3815@sirena.org.uk>
References: <1413891110-21059-1-git-send-email-jay.xu@rock-chips.com>
 <1414810698-5609-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eDB11BtaWSyaBkpc"
Content-Disposition: inline
In-Reply-To: <1414810698-5609-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: rockchip: i2s: add text after tristate for
 SND_SOC_ROCKCHIP_I2S
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eDB11BtaWSyaBkpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 01, 2014 at 10:58:18AM +0800, Jianqun wrote:
> For SND_SOC_ROCKCHIP_I2S, adding some text after the
> tristate to make this directly user selectable.

Applied, thanks.

--eDB11BtaWSyaBkpc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV3CTAAoJECTWi3JdVIfQi+IH/1mB2GQ5hxk5sSLsvQ3pILzB
ZMY0VAAFAl6d1O7Nn5WHBAvMrG5rYMNQGQ72ohfsZFeKu3aG602xByxFXoco4uJc
zPd/lOTH/E7Q84KMIuu3AbHsKz+YCnIKdKDT/ObmAkNfSDXZl9bsZWWGYHz217X3
KZ5jwcuR6rGyBiHGuEyZcpEizg89ezGTGU0tbFNLNGpncBuN7s5MiBCh+nAqC+kX
6viwuRZAkx02JImGNCxcutacN3fcgX5Kzt0y6jG5tZqxdPJ8eFfQu8prz3p0r2F3
knTvDbg3hiw6TPzj1XkmZ4KdPr5Ervd1fG6ihME+L6cysZ5CYP2ZZh84ujVXCbE=
=Ehcc
-----END PGP SIGNATURE-----

--eDB11BtaWSyaBkpc--
