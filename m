Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab3DANxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:53:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51712 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757686Ab3DANxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:53:10 -0400
Date: Mon, 1 Apr 2013 14:53:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        richard.genoud@gmail.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 09/14] spi/spi-atmel: correct 16 bits transfers using
 PIO
Message-ID: <20130401135308.GA18636@opensource.wolfsonmicro.com>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
 <1363679279-4045-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cN+O50sc7gZAK+8F"
Content-Disposition: inline
In-Reply-To: <1363679279-4045-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cN+O50sc7gZAK+8F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2013 at 03:47:59PM +0800, Wenyou Yang wrote:
> From: Richard Genoud <richard.genoud@gmail.com>
>=20
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> Cc: spi-devel-general@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> [wenyou.yang@atmel.com: submit the patch]
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

This looks like a bug fix to the exiting code rather than something new
for dmaengine - it should really have been sent at the start of the
series so it can be applied a bug fix and sent to mainline faster.

Some sort of description of what was wrong and how it got fixed would've
been good in the changelog.

--cN+O50sc7gZAK+8F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWZE+AAoJELSic+t+oim9Me0P/2YP+8Z1bDcsySs2AnllbY25
eHTI+qk3tTW4Rb69nwhVJsCJL02b32sZHEaotJCLRqHtMFW63OunBx143rqqvgpQ
atMyMIAeN5+/l3nLaW8LWNFoM+o7i3E0MFVTiZuQ687L32vxLj1g6VRvC+fxj/9M
pYSWJMlhR9R5SA8g9KvfCIhFqL44cXeOR0yq3A4umq+kTNI3Re2oKtlj/cD8JW53
mfaHmHxkd+sh6CHOQHhY6FDJMVeTVxQp0oYFhyq2qXBY4WF1CCjP9WZ1T+p7bWDK
R2wQNM+EdyuixbplvtPLcOVdltfxyRdGx2JGikNbDkGVbeqpi0E+nSnMzFGJifLj
v09BLY2C5tSZkIUjHKDPEcqwgTMjb2NIIWWohv3vqfXDCFBdnaTTan96dWtrfr6Y
EB1JVdpJyYtDlZHWSG3Fi/lfjkWsRXOlRmvYI1Y0VC7K3TZQVGDKrK6I7BINkgJl
xVRmkByOXSmOhxTM5kG3B3NZyFiAJ3TAZG/jRk8iBktFcYqvFVAXqZI3gxKv7JvA
mLa1KiUAyz8/7RdD6QoBYcpdIWMJgUEqCi3uNKrmqGC9SykS5kivgGAGJhUNtSRr
g0E0JXySFlSjTucMobbmLi/qrr/MNjCez+cGlJyIN4hhsObpslbm97E1K0xc65cH
JP7GYf0GlYWpf2XsoMAe
=7m7T
-----END PGP SIGNATURE-----

--cN+O50sc7gZAK+8F--
