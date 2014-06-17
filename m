Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965586AbaFQVpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:45:38 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:35849 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965487AbaFQVpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:35 -0400
Date: Tue, 17 Jun 2014 23:45:32 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>, linux-pwm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3] pwm: rockchip: document device tree bindings
Message-ID: <20140617214529.GB24743@mithrandir>
References: <1399504115-16257-1-git-send-email-b.galvani@gmail.com>
 <1399504115-16257-3-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <1399504115-16257-3-git-send-email-b.galvani@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 08, 2014 at 01:08:34AM +0200, Beniamino Galvani wrote:
[...]
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
> new file mode 100644
> index 0000000..35deba4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-rockchip.txt
> @@ -0,0 +1,17 @@
> +Rockchip PWM controller
> +
> +Required properties:
> + - compatible: should be "rockchip,rk2928-pwm"
> + - reg: physical base address and length of the controller's registers
> + - clocks: phandle and clock specifier of the PWM reference clock
> + - #pwm-cells: should be 2. See pwm.txt in this directory for a
> +   description of the cell format

Nit: this sentence should have a full stop at the end.

Thierry

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJToLb5AAoJEN0jrNd/PrOhWZQQAIqrRizkqAgQMAEwTZHQR15Z
qPByCxXAnJWqrGt6bbA9d7C3x2u/ztoZhy7D3gClrImL+wsB3ygbBKonHTEHG7Bq
Wp5Eu+Uu6LPleSOMkVfV7tyXVm87q1eoh/A29XwOiElsNaX50uHcZk8vnGRTS/Wg
mHGNJCj1z1oFMnvhIij2EPgXxp9QhePo3dujIm7n7zzaIckiVGGvo180MAiL3xyq
nnIQPpQFWZq8t3FxkzR6thcd+MuozUqaMysDn36tzjDCna2637FcfyQCQEKmEmbv
bdrKtXVDutaLDJLVIQWlvIOT3FCCgqZ/moQH/j6x2U25Fme8RT1iLEesZNbKSl1s
+vaKOC5crtIn2xNn9xES77pwWHaW6xNzXumVDOhaOjoXFdt3M5QaCv0caGBZfvKa
8+TPH6z61GtlVvvZd9Gv/mIeNeo5mMALpkOpMIKR0PPuNsLeT2/8jj3lVQhDM+8B
B7CwlPScV5E22xiRtAMqAxYKMiz9grrdCt/WCtKlkwRBm2UNeKnHiOGmoGlcIekn
zSdd2UW9JxO50z9CrrPWhe24P8VmtJPaZ4IIQjuLrFglHytvKf5nA/pTYWW94mtq
HIfHpbx/TOPhbji8c4CgHlUXCGmfpXTaZxCJAoTspHiJDZoFtdS4jEdk1Xh32T/3
OFS5xdLhvE1q4uDGC5Lg
=Tgdh
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
