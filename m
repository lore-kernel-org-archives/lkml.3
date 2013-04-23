Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3DWSdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 14:33:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48003 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756508Ab3DWSdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:33:04 -0400
Date: Tue, 23 Apr 2013 19:33:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard GENOUD <richard.genoud@gmail.com>
Cc: Wenyou Yang <wenyou.yang@atmel.com>, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net,
        spi-devel-general@lists.sourceforge.ne, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/8] spi/spi-atmel: add dmaengine support
Message-ID: <20130423183301.GX5019@opensource.wolfsonmicro.com>
References: <1364968581-23700-1-git-send-email-wenyou.yang@atmel.com>
 <1364968759-24036-1-git-send-email-wenyou.yang@atmel.com>
 <20130403102332.GA4633@lnx-rg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JMKEfAmnQy+WzDHS"
Content-Disposition: inline
In-Reply-To: <20130403102332.GA4633@lnx-rg>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JMKEfAmnQy+WzDHS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2013 at 12:23:35PM +0200, Richard GENOUD wrote:

Richard, delete irrelevant context from your mails - it makes it much
easier to find the content you added.

> On [mer., 03.04.2013 13:59:19], Wenyou Yang wrote:

> As I did some work on that one:
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>=20
> BUT, there's one thing not working (at least for me !):
> With DMA enabled, using spidev.
> if we use the ioctl SPI_IOC_MESSAGE(x) (tested with x=3D3):

I'd been expecting an updated series with this rolled in?

--JMKEfAmnQy+WzDHS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdtPRAAoJELSic+t+oim9NVcP+gJOD4khMgy8thQ9im6XuOfj
6rmFz7wzd8Hq6xiJ2N8n2c9//RIhs6P5f6eGOXfifP1gVozdyDq8ju993f+fFkY0
b9UNSWshVAJskJr/nLgHZUpgJ/Nxw/S1/p/Fwxf0JMwfzxr1dvMLtQN+Gvy0/7IU
o76qn11fILbT9g2o+vO9tfUQzMkFlJpTas4gsQsnr7XYWfy+lC8orGyhJgqM5VfR
qYQ8ScGgUkvnLkE0N5zNhyyDw3EMpIkNlZrEA8nr2BTsn/xxBjcIqlPhksjAdoSd
dW01OtpVZ4QjtArQ809dzJuRHPTcW5i5YkWcVifDsxDyopEmU/19zlba0R9/A2Av
KZWZmv9AE2ILyWfAroKLyN1+yWc/UjRqH7OHLntBcjI8Hq6d/3OZBFRJWMLhVAoX
dy3Z7doixHETooUFlAckrLWaaXwHSLHXsN0PCZDiEGB3h81cPZN+qEhoXisbkbxi
gqJenhe7Sun0XrU1HfoZF/LQDXRk0gR7d0ByN+rrDPSMj4zV5iflHnUjt+4Jdvt0
Wu6unHr4ZFKzMrd4AJXfUe5+5On2R208BpkTnW0awfNk+eF8BBMs9C3x8PyEWTsY
MwkL6LYrOORbzjxJN+8x132e7Q8uEcDS0isatO9i3GTM2zUaC1hwVijl4TmwCt+I
yXk2J3tCIyQuqfi0oT2x
=0AkG
-----END PGP SIGNATURE-----

--JMKEfAmnQy+WzDHS--
