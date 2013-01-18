Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3ARNQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:16:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34549 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab3ARNQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:16:28 -0500
Date: Fri, 18 Jan 2013 15:16:17 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>, <kgene.kim@samsung.com>,
        <thomas.abraham@linaro.org>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <sylvester.nawrocki@gmail.com>,
        <dianders@chromium.org>, <jg1.han@samsung.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH v6 3/4] USB: ehci-s5p: Add phy driver support
Message-ID: <20130118131617.GI4672@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
 <1357916550-11421-4-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7IgncvKP0CVPV/ZZ"
Content-Disposition: inline
In-Reply-To: <1357916550-11421-4-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7IgncvKP0CVPV/ZZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 11, 2013 at 08:32:29PM +0530, Vivek Gautam wrote:
> Adding the phy driver to ehci-s5p. Keeping the platform data
> for continuing the smooth operation for boards which still uses it
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>

Missing Alan's Acked-by here.

--=20
balbi

--7IgncvKP0CVPV/ZZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+UshAAoJEIaOsuA1yqRE8hsQAI1bHyPfRvgyfwVohST/KyVN
lEZQCpMWi7w94YDS8jhuZH88dQih34QVGxmMDs2U1QY86R23PeOkB7crj4Kl63nY
mpcgMPOb5ONYnw9dAPzNYWd6GlFoJo5OtOUawXbFWy+H0GbaUbQV51bULAb947TO
Jo2eXFUV7zfkCJsS/7MZVncXNqqpYa+Z7+AiTBzGEAbx6Ae9zTJ2lkR/Pcmqh0Jw
WKwLCp/Kt/jx0bpca+PAFP6k2ka4WVTUxrMoX97/EXG38aNKKPlYeE00QZJJivb0
WiJPg8IB5cqV9ixp8JhinDn/gZm/kGxsbiwnXd3ooU9we3iSknEkm8gR1B3mlwgT
JP2b/7o3/XNaOV9ssfizNj71GyA4UHbjXS8RMMR7FvCFl161ESGR/ITrXfKT6WqI
sJQBYGTOnoSF++h4hFz/iJw17Y4mKgCf2H6wIqqrWUMVx2ijgY/KRUEBJ4g0+9sj
Jx35//+wYObptrjmmzTTXNjbQXMwB57c+MyrnIvaQfu8gCzaoS/7t6U8rFLlV+ol
+jXCn+VzVLAfbx7gqW6xuNVJVAKufgNHp2PDu+RMXWA+ohCqmbDYebA+B6iOObgc
ZTmO5sW6TmNg3pSVmnZ2Ewq+UoC8djdywXJMTeZGSIT5T/GtryglqzfdIdTkRpsw
U7vDEkJblT/e+LIwepQB
=k8CN
-----END PGP SIGNATURE-----

--7IgncvKP0CVPV/ZZ--
