Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaFPNaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:30:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55476 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751188AbaFPNaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:30:04 -0400
Date: Mon, 16 Jun 2014 15:29:15 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexander Bersenev <bay@hackerdom.ru>
Cc: linux-sunxi@googlegroups.com, david@hardeman.nu,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
        james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
        pawel.moll@arm.com, rdunlap@infradead.org, robh+dt@kernel.org,
        sean@mess.org, srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v9 5/5] ARM: sunxi: Enable IR controller on cubieboard 2
 and cubietruck in dts
Message-ID: <20140616132915.GC9757@lukather>
References: <1402250893-5412-1-git-send-email-bay@hackerdom.ru>
 <1402250893-5412-6-git-send-email-bay@hackerdom.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qtZFehHsKgwS5rPz"
Content-Disposition: inline
In-Reply-To: <1402250893-5412-6-git-send-email-bay@hackerdom.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qtZFehHsKgwS5rPz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 09, 2014 at 12:08:13AM +0600, Alexander Bersenev wrote:
> This patch enables two IR devices in dts:
> - One IR device physically found on Cubieboard 2
> - One IR device physically found on Cubietruck
>=20
> Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
> Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>

Applied, thanks.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--qtZFehHsKgwS5rPz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTnvErAAoJEBx+YmzsjxAgdKIP/3TxwASLhpIjRFCQdu11poGq
WaulJgo9H6mmGXNI9twlmkkgWcQM4bcYp6UGOlcYkGry+uFVdhCS3uTJB5zDvs7R
LqaU7E7/AeV4nPKADCy+yJLkEl/LMu6GVeN/gnZCSSNEh4ArXhKLcE5BHfqR5BEw
lpxplUadFeHjSkzRTNGxfjVSGA0VbHT05dNqzh2DUIbZaKfZyX+ZbCTcON07KzfF
mn+pJ5fXFHcj+puxH1HYSYJVpOkTnpmGDX/al/AL9J9lJ8NtjfLcsRs7ipC5ovY5
8Rt2Hu4YwaLJUeM2ytlrFtxnUD+2l2/bfZ4DZyuuYn44QPYP20/zPcwbKaj1zYPE
EVGlG7CQ/1IGuYYM/BNaXt4VciAjjBD5Ce85HrY4CpddQ4ocwH4l/YAdPMVI0GIT
2ZDSH8uRWf7cKNRw5D6Kr9yXhbFMhTNSu7rOaAyFlKYH0EjD5IVgbAsbi7FJHD5Z
Cfgy74NIOsQjFWexPkytN35JrAHulEoUvySVbqJmufro7rqTQRw+DmAzXNq37BLK
uB8FeKc/gleoJmaJmvnIrUWsLphSBHe7TNI9BE4EyKv+fZGnmeKokwZp5a1diYaL
+Lcg8iSOgfxQN1z4PDWPh51AvvrqAoG/c6m03kYwNHvcPW3aaXbcG6OlvpVOEGe9
DCBU3uwNkSJMPedHHHd6
=K9RW
-----END PGP SIGNATURE-----

--qtZFehHsKgwS5rPz--
