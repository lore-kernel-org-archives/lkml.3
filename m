Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaGKPCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:02:49 -0400
Received: from mail-wg0-f67.google.com ([74.125.82.67]:33167 "EHLO
	mail-wg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbaGKPCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:02:47 -0400
Date: Fri, 11 Jul 2014 17:02:41 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-pwm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/3] pwm: rockchip: document device tree bindings
Message-ID: <20140711150241.GD6523@ulmo>
References: <1403360528-12757-1-git-send-email-b.galvani@gmail.com>
 <1403360528-12757-3-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
Content-Disposition: inline
In-Reply-To: <1403360528-12757-3-git-send-email-b.galvani@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 21, 2014 at 04:22:07PM +0200, Beniamino Galvani wrote:
> This adds binding documentation for Rockchip SoC PWM driver.
>=20
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> ---
>  .../devicetree/bindings/pwm/pwm-rockchip.txt          |   17 +++++++++++=
++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-rockchip.txt

Applied, thanks.

Thierry

--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTv/yRAAoJEN0jrNd/PrOhIykP/jaLrEw3Ed+9ADJRMV/RIvn+
YxkdaeAe2XRWjKc5PxK4z8g93z08isLk6DQG4vOqXKuqTUza65GId2pemP22vShP
Dxu7F8MWCfNVHwc6FLuIHZgiNP6rEGX5+DQcLQdYTSgkFwK8X1OAXVXvCLvwreth
BjqP/9bDRKXl8j5jDrCJdjbsPP28ZkYKPz8CG6gpjsCxnMpzWWyff5IeLh3REkuR
siAt36JvF8jGzwapUmvRWfTWrsDpotp+hF3f4+roVNrA2gCRhQ8ia28P1xR/9c7Y
xMF4wHtfq64ck5oEZ4uJ25XaRFlkBRYEIIqCgncTT0G1kXmc7PkI7+JlqEXDPy2z
fnKhRnCLPYDULuhBTaEqcKC1mFq93thU6vVGH3TXEhrVUJOn/ToFDSF29A97esym
zRyOfOvKu0w6AGrjziZHtezbAN646rUh8JZ++6NroEEp40kD7hBPhwEoiu79BoeC
1A/rtO7vGqtPj+d/WJYDTT+M6w3YT0vOzTiefG40Fslxi35Bep3gyc/VoB3+rWlf
mKSj+ljcVXjuJn1A3LmDhc/5LUwBm8nul0rD4P6Fq+DX7a4A6LzrgNGU19aNoNrO
3u8pdbJjEAXJB4GEYrTDagtDL6dgSGCLkr6WYy0ZPSjMMT62cz1Ck6Fko+l1WYi5
VHh+UO65ObMgZRhpFZqK
=HLyp
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--
