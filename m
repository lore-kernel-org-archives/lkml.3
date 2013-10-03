Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3JCUiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:38:14 -0400
Received: from sauhun.de ([89.238.76.85]:55635 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab3JCUiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:38:10 -0400
Date: Thu, 3 Oct 2013 22:38:00 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 0/8] i2c: Remove redundant driver field from the
 i2c_client struct
Message-ID: <20131003203800.GA4563@katana>
References: <1380444666-12019-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <1380444666-12019-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2013 at 10:50:58AM +0200, Lars-Peter Clausen wrote:
> Hi,
>=20
> This series removes the redundant driver field from the i2c_client struct=
=2E The
> field is redundant since the same pointer can be accessed through
> to_i2c_driver(client->dev.driver). The commit log suggests that the field=
 has
> been around since forever (since before v2.6.12-rc2) and it looks as if i=
t was
> simply forgotten to remove it during the conversion of the i2c framework =
to the
> generic device driver model.

Applied to for-next with great pleasure, thanks!


--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSTdWnAAoJEBQN5MwUoCm2YmUP/iibuIQXef2UeEPAuVBr4S/G
GX0ZBM947XqiUZ6c6KHYmsNuXKQI4KUrq8D+jqnk0pZmyTAQ9kyatNHZeXPnCDxR
ogjSqA7jVrp0lJqI/Fhw6v4v1LWhhcbBNvTnyHtmXkXuGyqyPgv2I2kpRG8P3WKS
qh9Xbk7kf1cw1HKnT1c3giGDr8ISvA/AHa02M8VbbBk1PFV4PmzAdXCx8b9Drju6
QfCJUKqoE1gRFn+wyYhBjQYkhrPPr47O0+1hoOCFtL+kBxRGvI0FoQ8eVuaa00Zf
2yb7Njr/5ALk/bgc0Odm8foFVD4QkFXpSZ5692hZutZhrifAVCOzpWFZhG2s98dw
K+6yuARazPQrQoth0XUULCY14x8n7sI4eFzN4UUlG0YgSkyHB3GXQgoR4M1ong1E
+vNTcr+lghurvlAt0NQcsXov6xC6XxV6L7aXsT9+E7FFe7b+I8roeK51NqJ2CaIG
aRseWEIuWhvaUU3J+IPLy0X/2T/5t1ktXQNMSPJECaAxsnaX5BcI+sQugnsCfAra
/y+sotn64DYD9D4yyNly2O+ytqvrV5jooi02BdNEV7mWZskxTiJHf6erLOTpctEI
sEpmygJtnIZ9GSTk1wfLRGNzhUkknz4xqrVvdRfmn4EEkTBYVQf8shy07rW8OWEL
bqVLYxEJ7w1CKmOgiDdE
=UFw1
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
