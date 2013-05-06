Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3EFOkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:40:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35775 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120Ab3EFOkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:40:15 -0400
Date: Mon, 6 May 2013 15:40:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, balbi@ti.com,
        ldewangan@nvidia.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, rob@landley.net,
        gg@slimlogic.co.uk, ruchika@ti.com, tony@atomide.com,
        sameo@linux.intel.com
Subject: Re: [PATCH v4] extcon: Palmas Extcon Driver
Message-ID: <20130506144010.GF13472@opensource.wolfsonmicro.com>
References: <1362662506-14823-4-git-send-email-kishon@ti.com>
 <1367846225-15685-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EgVrEAR5UttbsTXg"
Content-Disposition: inline
In-Reply-To: <1367846225-15685-1-git-send-email-kishon@ti.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EgVrEAR5UttbsTXg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 06, 2013 at 06:47:04PM +0530, Kishon Vijay Abraham I wrote:

> +		if (palmas_usb->linkstat != PALMAS_USB_STATE_VBUS) {
> +			if (palmas_usb->vbus_reg) {
> +				ret = regulator_enable(palmas_usb->vbus_reg);
> +				if (ret) {
> +					dev_dbg(palmas_usb->dev,
> +						"regulator enable failed\n");
> +					goto ret0;

This is very bad karma, why is the regulator optional?

--EgVrEAR5UttbsTXg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRh8DDAAoJELSic+t+oim9YbIP+QEW3AJx/61YFE4SuyeCbGOM
Gcq5lxBXzoBFWjclWeBUIZu3jLyGGausejqUmF8PfJ/DF/f47hcc423vwyHw4618
QoZTo+SZg+y5sr/L9Hgh4g9tI607kaFd1dZCTH8gzuTKZ474uxzQ+IlIebO9INca
SIvzcEjO770RsF9MNM1Cr5rLLlji70GvjLtcMn+GQPo674E3+jNc4R2W4fobAGSJ
9XB8cCMxaf4KgMgKDcUtLBTKefcRFsdvv143JW1yEzOnkw6qZLfBmabtlmzmBXZx
C0+XkvS2uY1w1LPgv/VGK8EXubEQ+0UoKTnswJhjgvwTsRjkaXNQiH09s8/CQR/X
G1YagjZMet4BUPH8eBKNQfpCjBKy20UxRbAHAiqv0HVu/eCkBaFpVIHRyoJFDGWl
S1nI7EmPeC/+Y/CLwwtezVPUo2buubRZpzx5V5RK+ULMjVc6CStu9+U9NpbPmSZy
QNi5B3tJRQOZ8YSz61QuSni11BQjkoL8d5xgdAIwMNSJA/4HQKDS6giLX0fjejI4
JXaG2GLu9jPf/STcw4YMooqIQJwy7ew9pilg4loMVxvxAm+DghlhdqB5U7S5QkXm
HLR96OX4Dja5zCAsaTyNvB1W58BurPOU2eY70rezEFVsFRr+A+WBlmyenR6hAxpv
KnT6qrDgg1NJWMThe0uN
=BZqL
-----END PGP SIGNATURE-----

--EgVrEAR5UttbsTXg--
