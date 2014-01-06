Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbaAFPhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:37:24 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47908 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaAFPhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:37:22 -0500
Date: Mon, 6 Jan 2014 15:37:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com
Message-ID: <20140106153715.GZ31886@sirena.org.uk>
References: <1388986906-32139-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TKxMeUgs2YHnbgRP"
Content-Disposition: inline
In-Reply-To: <1388986906-32139-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: fix the DAPM routes map parsing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TKxMeUgs2YHnbgRP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 06, 2014 at 01:41:46PM +0800, Xiubo Li wrote:
> The simple-card's DAPM route maping is optional. For example, the spdif has
> no need of this.

This doesn't seem to apply against current code, can you please check
and resend?

--TKxMeUgs2YHnbgRP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSys2oAAoJELSic+t+oim9jDQP/04lsa/nZ5ocRvhAF82oxeWf
FpwS8R3s554lbmtGJciZBTgDcJc58Mby5lYhjwbcAahqVeFi8vdnbfZhj7J5RVpP
8SKA4ufNc5QmQzMN3xvFsL42zIWZF9d3+hXYd5Iz4TbGJy9O03S0l2SqNBv8RWAu
t8qxtnnYpUPAL0VoK76laOOlNf8kZf7qOLZ+D8Pm4afCJYjZtGDOtszDJ5aPJSdP
Dtsf2BP5Xpu4yh/YwXsnGH5KLA8oqFKoQAGmxEDiARGXxXhVLCCQR15ujjh++dH7
o0ABlaE23fsvVqej2ztvnuQFo6mB2UvfppxpQQqwmnP3p2yW4Pzp97/dqT3j4UcE
ccwdurzym1PS7ceIIbCSbVpX0XMAIgRZfPbVqEjs2OKL8eAfzBYeDfXoxwq/dMPy
BsGZcGJ7d2LOcp2KKW02686wGjUqBgdT/7xnAWnYlBjQYx5IHHW8hA5s0pEAEwAu
W6H5wiK+EYH3p/82Ew+6HowA2hvcOgez3IWAcKhKPWtmErsX1qgabBYwfDpVi95k
7f8+iSav96EvvIiq8+XT0kCFxvJiIbK/7fwv+71tVkpHNi+6KV3MsS0qPx1O9bVq
QSUTMPIBfeRTSHF3RW46ahagBAXePjYTkfq0oAiX1z4vTQXSmS7jpPckqBox3cuR
2vn64W5y9oBVW9UPSO5x
=+bUx
-----END PGP SIGNATURE-----

--TKxMeUgs2YHnbgRP--
