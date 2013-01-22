Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3AVIB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:01:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56887 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346Ab3AVIB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:01:26 -0500
Date: Tue, 22 Jan 2013 16:01:06 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 33/33] ASoC: Convert to devm_ioremap_resource()
Message-ID: <20130122080105.GG1766@opensource.wolfsonmicro.com>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-34-git-send-email-thierry.reding@avionic-design.de>
 <20130122074824.GE1766@opensource.wolfsonmicro.com>
 <20130122075552.GA28158@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zq44+AAfm4giZpo5"
Content-Disposition: inline
In-Reply-To: <20130122075552.GA28158@avionic-0098.adnet.avionic-design.de>
X-Cookie: You have taken yourself too seriously.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zq44+AAfm4giZpo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 08:55:52AM +0100, Thierry Reding wrote:

> It's probably too early to apply this yet since the first patch in the
> series, which introduces the new function, hasn't been merged yet. I
> seem to have handled this poorly, as David Miller already pointed out,
> by not Cc'ing everyone involved on the first patch.

Oh, well.  Dropped then.  Acked-by instead.

--zq44+AAfm4giZpo5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/kckAAoJELSic+t+oim99D4P+wbeTHschG8CAbN819VyFiAY
YPz5XUexd9wKrDP0DQcThW4hp+hYGqCq4UsYBeq9Q9xoASGuWTJaI+TEGvelhN01
046mOAai88f6+kWkaC4/VCxV5VFia96q+SGgUJbQ2O95yEY0n7b0Q63d1YOm8p3F
j/q3B18rmNqQkigu9BYzNcCM//j9PAngp537+HG7JTTzedwDCQYY+V7bS45/gsOo
0D0uojKMj1Omx+eNOgFHJjTcNsqKHyOXNodg6a0pNRQcKuDm3aQaJeQSAvsqhYUS
SrgAzWLtbCPLiCFdnAy0Lo/qp3r88KRHpHyOu1QTACa1KWT+Wz8NWUfQdRQYTCRX
c3XBtroT5heZiU1HCiLUfpxghLQVoIMbnfeC2AKsJzGU/CpESMLF5rBMkM5szIpR
pKleJZsZw7Si2og+bHuoASR6VbEwyIg7BFvi6KAtpdLtOFW1vVSwWPG3RnoSJEgo
0mqAXpcTp3y/kV3nn4TDlf+/Yy0P9z4bUqvnkk8juYgXjBt+mAkyyvDgdYjNgDvo
tZMsfCeSowtRvzMuC6I3tOxyV6ClHboka1dOrnC4j1g2lHhCxv3EM8cVPumqgAIn
tAeMOBrsl10UcJ0qUzQAQr2SiRQlCbSgTpftPWB6L9m4eefpOXv2tSr1XfWBwW+0
7q8r56xp3qQl3JdB0Z+j
=PPyf
-----END PGP SIGNATURE-----

--zq44+AAfm4giZpo5--
