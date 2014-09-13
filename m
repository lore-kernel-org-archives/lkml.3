Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaIMQhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 12:37:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39329 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaIMQhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 12:37:06 -0400
Date: Sat, 13 Sep 2014 09:36:48 -0700
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Message-ID: <20140913163648.GJ7960@sirena.org.uk>
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
 <1410568993-21874-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CZb08McUREi1kVi+"
Content-Disposition: inline
In-Reply-To: <1410568993-21874-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] ASoC: rockchip-i2s: enable "hclk" for rockchip I2S
 controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CZb08McUREi1kVi+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 13, 2014 at 08:43:13AM +0800, Jianqun wrote:
> As "hclk" is used for rockchip I2S controller, driver must to enable
> it in probe.

Applied, again this is a bug fix.  How did the original submission get
tested?

--CZb08McUREi1kVi+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUFHKfAAoJECTWi3JdVIfQRdUH/iqPYwP7J/RLSFv1aupWqYVx
HvAyuf6N5Bsea2eofmXwrRGpe64a7BXh/Be+8rQXCu1vFxf6Dd8D6B85E3uE5wyq
uU88hMSUciK1wijNZw9GoP9YvfRrLnaKyUIsxsEmkTWThd/btXZDKLmwsBB50DQ+
xAYh41usHWdkD6HW3hzK8FZWJglplPsc/0z36iY2OVwRsLYrFb2NnFKRiEsu+0SO
Fn0tqfNAId/cfO3ji/bmMW+e8cLkck4dzsd1wX/dBB/ErGl30CVbFBB62IQ2ilmM
mUSP3vtSYdV3NyK8nYSnsFFFL1JS/WwEjSoKAvhNxW+WgLyPGFv/y2qPfPEz3fE=
=0lEn
-----END PGP SIGNATURE-----

--CZb08McUREi1kVi+--
