Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967965AbaLLNZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:25:45 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56759 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967664AbaLLNZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:25:44 -0500
Date: Fri, 12 Dec 2014 13:25:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Ben Zhang <benzh@chromium.org>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Bard Liao <bardliao@realtek.com>, Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        Albert Chen <albertchen@realtek.com>, linux-kernel@vger.kernel.org
Message-ID: <20141212132532.GJ11764@sirena.org.uk>
References: <1418271327-14710-1-git-send-email-benzh@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dD1ndss832r/QIua"
Content-Disposition: inline
In-Reply-To: <1418271327-14710-1-git-send-email-benzh@chromium.org>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] ASoC: rt5677: add REGMAP_I2C and REGMAP_IRQ
 dependency
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dD1ndss832r/QIua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2014 at 08:15:25PM -0800, Ben Zhang wrote:
> The codec driver uses regmap to do i2c read/write.
> The codec driver started to use REGMAP_IRQ since:

Applied, thanks.

--dD1ndss832r/QIua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUiuzLAAoJECTWi3JdVIfQl5YH/2Vf3rGrgUIyUh8Up83EQA9/
9W2BnAY77zE9SOiYFlDIisuExlH0HUkW9bzDP8/wAhzknLfmatg7s1HImf8iTdZS
sRfVcj+aVfwkDVnoV5KC+zBklPwdK295WNaWSDIiruaNPwNDB8e35iOnltto9quL
yjOAPT5XUzRpTFMGBZvghHXhJkMuMuhqIAziUDsVme4tPF9vIULNWkGzsyEX5vBO
oQoRhk+4w+Nb5f3cqYVJqHIGjAhxJikpCeyY0f1ssUInxKhE4rp2PQKvUY4NVfZv
+E32fD76noXAjInsX0hzJKxxOD/URYbgWv7rpINhYbY5mW4t4jdD/gmMakveAug=
=y3JX
-----END PGP SIGNATURE-----

--dD1ndss832r/QIua--
