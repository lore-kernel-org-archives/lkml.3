Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbaKEF4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 00:56:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaKEF4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 00:56:49 -0500
Message-ID: <5459BC1C.3000807@suse.de>
Date: Wed, 05 Nov 2014 06:56:44 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-sh@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Olof Johansson <olof@lixom.net>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>
Subject: Re: [PATCH 0/7] Pinctrl support for Zynq
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="7IchI7Vel7pe60H9xXHiup0qR20NGLJha"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7IchI7Vel7pe60H9xXHiup0qR20NGLJha
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi S=F6ren,

Am 03.11.2014 um 20:05 schrieb Soren Brinkmann:
> Soren Brinkmann (7):
>   pinctrl: pinconf-generic: Declare dt_params/conf_items const
>   pinctrl: pinconf-generic: Infer map type from DT property
>   pinctrl: pinconf-generic: Allow driver to specify DT params
>   pinctrl: zynq: Document DT binding
>   pinctrl: Add driver for Zynq
>   ARM: zynq: Enable pinctrl
>   ARM: zynq: DT: Add pinctrl information

Thanks for your work on this,

Tested-by: Andreas F=E4rber <afaerber@suse.de>

I've tracked down all 54 MIO pins of the Parallella and cooked up the
equivalent DT patch. QSPI and USB still seem to be missing drivers
upstream; I reused the SPI driver for the QSPI with pinctrl and
Punnaiah's chipidea driver (not fully working) without pinctrl for lack
of group/function definitions. For testing purposes I've configured a
heartbeat trigger for the USER_LED (CR10).

To my disappointment these pinctrl additions did not fix one issue:
Whenever a write access to be handled by the bitstream (0x808f0f04) is
performed, the board hangs and the heartbeat stops. Would a bug in the
bitstream allow this to happen, or are more drivers missing to actually
make use of the PL in general? With a downstream ADI/Xilinx 3.12 kernel
that problem does not surface.

Regards,
Andreas

https://github.com/afaerber/linux/commits/parallella-next

--=20
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6rffer; HRB 21284 AG N=FCrnbe=
rg


--7IchI7Vel7pe60H9xXHiup0qR20NGLJha
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUWbwcAAoJEPou0S0+fgE/RjgP/Rv9mvYJOZxmXGnlfhtE+poG
bqoHZz9y4vszCvtNSCz6gIsyg+Cw0/hEX2Kwmbqe0b87OTv+16hTAhd3xqY4A0gL
hwSju7S4zy/aV3WAebDBETmryv6uH297uKsX7uZ+UacfvnBiOzwt9o2p6PdpDEwJ
O0z122Fy/cNldS7amrgJJXOEYH2XLyIIuZ53viyvbPbneF5PhZvxj5e1t3dyDZtm
4mPdcy3PqIseZl2Egbtad6B96tcUvr3BwbGs9gWkyKHNQMqhqqaeG+7uTlFncV2Y
BCV6Hn1SOEfLLXDCpXTYb5lAAVr1915PRzXcSOzzi2AmeyaE71Z0zZKWJpP2yna3
JQuNuo4BATzVmv8pzzU6LisVv9n/ccUXJP3zATGKxI5pakei9ylJWIj8CKuoqGbB
10eE5JwbH1qMkVa4nz079khP6bRV4jzeyHaxNobZuMmTny50wavQmnAS3gWH6+Ez
DQN64BYDD8ghLQz03Mt/GcwOdxhh3rEesPyVCQ445rL7PkP+FHhwSVn95P5YWVlB
rgUIqFfWJJG1Y7PVD50BJ5wBP9I75AiQu58/QdtO600fRio57M5X/jZoycBm69rC
20hSZ7PC94p8GimARS5tK4FxxMWhYvOiuZnzURU1DStUsE9C2dbJeGcT4E16azBL
yqoCFMqKh3mfbDyseq2Q
=JI8m
-----END PGP SIGNATURE-----

--7IchI7Vel7pe60H9xXHiup0qR20NGLJha--
