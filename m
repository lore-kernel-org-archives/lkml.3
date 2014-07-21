Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaGUI5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:57:23 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58313 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbaGUI5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:57:21 -0400
Date: Mon, 21 Jul 2014 10:57:17 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, b.galvani@gmail.com, cf@rock-chips.com,
        huangtao@rock-chips.com, addy.ke@rock-chips.com, xjq@rock-chips.com,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] pwm: add this patch to introduce for rk-pwm and
 vop-pwm
Message-ID: <20140721085716.GH8843@ulmo>
References: <1405774529-26027-1-git-send-email-caesar.wang@rock-chips.com>
 <1405774529-26027-2-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xQmOcGOVkeO43v2v"
Content-Disposition: inline
In-Reply-To: <1405774529-26027-2-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xQmOcGOVkeO43v2v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 19, 2014 at 08:55:28PM +0800, Caesar Wang wrote:
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
>  Documentation/devicetree/bindings/pwm/pwm-rockchip.txt | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt b/Doc=
umentation/devicetree/bindings/pwm/pwm-rockchip.txt
> index 3182126..bb6e7f1 100644
> --- a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
> +++ b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
> @@ -1,11 +1,14 @@
>  Rockchip PWM controller
> =20
>  Required properties:
> - - compatible: should be "rockchip,rk2928-pwm"
> - - reg: physical base address and length of the controller's registers
> - - clocks: phandle and clock specifier of the PWM reference clock
> - - #pwm-cells: should be 2. See pwm.txt in this directory for a
> -   description of the cell format.

Can you please stick to the original format rather than removing the
space in the first column? It makes it difficult to see what's being
changed by this patch.

> +- compatible: should be "rockchip,<name>-pwm"should be one of following:

I think it should be either 'should be "rockchip,<name>-pwm"' or 'should
be one of the following', not both.

> +    "rockchip,rk2928-pwm" - support the old version PWM for RK29xx,RK306=
6,RK3188 SoCs.
> +    "rockchip,rk3288-pwm" - support the new version PWM for RK3036,RK328=
8 SoCs.
> +    "rockchip,vop-pwm" - support rockchip integrated VOP-PWM for RK32 So=
Cs.

"old version PWM" and "new version PWM" can be dropped. Maybe:

	"rockchip,rk2928-pwm": found on RK29xx, RK3066 and RK3188 SoCs
	"rockchip,rk3288-pwm": found on RK3036 and RK3288 SoCs
	"rockchip,vop-pwm": found integrated in VOP on RK32xx SoCs

? Could you explain a little what this VOP is? Also since the above says
that "rockchip,rk3288-pwm" is supported on RK3036, the compatible value
should really be "rockchip,rk3036-pwm" since we usually list the chip
that an IP block was first used in (I'm assuming here that RK3036 is
older than RK3288).

> +- reg: physical base address and length of the controller's registers.
> +- clocks: phandle and clock specifier of the PWM reference clock.
> +- #pwm-cells: should be 2. See pwm.txt in this directory for a
> +  description of the cell format.

These are all unchanged (except for the first column's space being
removed and the full-stops for reg and clocks properties). Please keep
with the original formatting so that it becomes obvious what the patch
changes.

Thierry

--xQmOcGOVkeO43v2v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzNXsAAoJEN0jrNd/PrOhBf8QAK0fSsvV2zvWSlg4g43Vve2p
G9i4BKXJQiNftszGVUeena0CdeLESSrDepp04mvqj8CVBYJ+k6kF4hvbU0vRG3d4
5RQiUwCvWcOSSwsAvex3WWD5cn6unOOZafZ8c/njHZZjLycwPA6XtjAnrEM9QKb+
xWOXFgqyEV7gLhV+g6IS91wuSL0pgQtmDKj0fsfsC7CK3VU7ciLz2jFE6/44ssQG
Qt4RX0s2WwEfl3ijsYWLRbCiFoOuJpROhpI4jKVrr1YpKXFIycoBvEEpDiLOp/T+
Csnx0LC5nQbeynSlG2dO17HIw5J4CwLQkI/UM1lcM2VFJygfWYqFy8TEHAk3kZo0
MsRj5ENeQQ8ezxu4rETJuaedVefnaYciRsHnQbr5374xxflC+zzhTWSn0yNwUFFf
QwxvO2pj9Ltn6X+6BKfZD96OoncmfSp5PmQ4Hx9rwVpByJ76/g+Njk6iZy7DIqcD
2N+tu986Qsy2OkYd789tfkoDyOWm02+3c0PsLsX9BfeNztmVcK0hy9HsIPksxx44
sk5iFluiQgKkUzV+tqj2mtRnbCiSYN6STf1Ni+hQrdyIP+iuJmnKKTf6/uEhJWxw
Cg7+892CURmbmVwHHdoAa9mHQZTZwR/D+6ZllklJgDnjsC+yZh7EaeBIxRoG8Ruc
SQG0mwORl+iLimXVVYGE
=1VGz
-----END PGP SIGNATURE-----

--xQmOcGOVkeO43v2v--
