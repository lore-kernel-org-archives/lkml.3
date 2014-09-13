Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaIMQkw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 12:40:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39371 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbaIMQkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 12:40:51 -0400
Date: Sat, 13 Sep 2014 09:40:32 -0700
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Message-ID: <20140913164032.GN7960@sirena.org.uk>
References: <1410570281-23681-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bDDjztrZmyyMv72E"
Content-Disposition: inline
In-Reply-To: <1410570281-23681-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: rockchip-i2s: dt: swap tx and rx channed request
 number
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bDDjztrZmyyMv72E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 13, 2014 at 09:04:41AM +0800, Jianqun wrote:
> Reference to RK3288 TRM, fix an error channel id for i2s tx and rx
> Table 10-1 DMAC_BUS Request Mapping Table
> Req number	Source	Polarity
> 0		I2S tx	High level
> 1		I2S rx	High level

Applied, thanks.  The changelog should've just noted that this is an
error in the example rather than the code or the binding, I was a bit
confused about this.

--bDDjztrZmyyMv72E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUFHN/AAoJECTWi3JdVIfQEKsH/iyNtMEeMqY8VJWj+MMt5UbH
htKSMier02brv/RFLkxwPh83pn2ZkO23jxvQns4uZDjp/zsQ6R94jOdLg1AC7PAu
/aIgc+0VPLqJoyedCmTwWTkabeaELunniwmVNBUsTE2KTadEKCFsV9BmmOSBBAOT
lNErF+98kGgW97jl9goSUgjXYemKr5P9YRK8K/m4Gxk1ta1tD2acPDouuPzvVVYS
a1HFzYF+vQkTG+BAYfE/5FHy8SmjLTedEdaHyQjVjSofY2PpT9YmSx8vaDiqULAZ
O498lKdBS3reNCgd/fUkuyut/GiiTuCNYCGKfBlc6Y4fGSV+i5h4wPcuoY8sLGg=
=eFfQ
-----END PGP SIGNATURE-----

--bDDjztrZmyyMv72E--
