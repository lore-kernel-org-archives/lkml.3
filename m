Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaIMQf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 12:35:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39307 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbaIMQf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 12:35:28 -0400
Date: Sat, 13 Sep 2014 09:35:01 -0700
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Message-ID: <20140913163501.GH7960@sirena.org.uk>
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
 <1410568863-21723-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YWfczjhUm04al3kG"
Content-Disposition: inline
In-Reply-To: <1410568863-21723-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/5] ASoC: rockchip-i2s: fix master mode set bit error
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YWfczjhUm04al3kG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 13, 2014 at 08:41:03AM +0800, Jianqun wrote:
> Fix error format set to I2S master or slave mode.
> Test on RK3288 board with max98090.

Applied.  Since this is a bug fix it should be one of the first patches
in the series so that it can be sent to Linus as a fix, bug fixes should
go before any other patches.

--YWfczjhUm04al3kG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUFHI0AAoJECTWi3JdVIfQ4/EH/RDS9OC2Y7QhShmNh8uAqSKB
v6LWC0PYNnyRTxNtp5k1Ck5ZsXqO6lv6O0320nPMF6YpkWSjzb9vDfTUULt8mkMm
qI/HrghJgGhkfBwDtILp0qUKwI/mUZxr+v2uXEOCJdp9xySTmAgaVkfSfLTpOsIH
zJX32HHicVHsfkvBeb4OGlGAXqMNUgoPcGAdfGT2BGj9I4qsGOe+MBTnSAkexA2H
9YMqwMPOicJnTZ+EjKlEptEu0PMbGbl2drkaSIID6E003tzCcr+EY7hR80++EJoP
oMJIqOCM1rTvQNFlfMagC4YwgjzzlXku0fVbQXH32CQ7c7vNfuLNkJhLTx4Ygbg=
=yeZ6
-----END PGP SIGNATURE-----

--YWfczjhUm04al3kG--
