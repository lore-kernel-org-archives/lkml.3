Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbaCRTpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 15:45:05 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:54310 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaCRTpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 15:45:03 -0400
Date: Tue, 18 Mar 2014 20:44:58 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-pwm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv10 0/4] Add Freescale FTM PWM support
Message-ID: <20140318194457.GA5917@mithrandir>
References: <1393493992-26073-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <1393493992-26073-1-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 27, 2014 at 05:39:48PM +0800, Xiubo Li wrote:
> Changed in V10:
>   Fix some bugs and adjust the code from Thierry's comments.
>=20
>=20
> Xiubo Li (4):
>   pwm: Add Freescale FTM PWM driver support
>   ARM: dts: vf610: Add Freescale FTM PWM node.
>   ARM: dts: vf610-twr: Enables FTM PWM device.
>   Documentation: Add device tree bindings for Freescale FTM PWM.
>=20
>  .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        |  35 ++
>  arch/arm/boot/dts/vf610-twr.dts                    |   6 +
>  arch/arm/boot/dts/vf610.dtsi                       |  13 +
>  drivers/pwm/Kconfig                                |  10 +
>  drivers/pwm/Makefile                               |   1 +
>  drivers/pwm/pwm-fsl-ftm.c                          | 496 +++++++++++++++=
++++++
>  6 files changed, 561 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
>  create mode 100644 drivers/pwm/pwm-fsl-ftm.c

I've applied patches 1 and 4 to the PWM tree, with some minor cosmetic
fixups that I thought didn't warrant these patches to go through yet
another revision. =3D)

Thanks,
Thierry

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKKI5AAoJEN0jrNd/PrOhDbEP+gOKW9XIHugIvrXFSwCaJOB6
USpCF2+AMx1TwEPLcj2caUDcdHnUuse8WVRc0f+jFbZFEBil52UJ5amzHo8I/xOU
jQKiYmAzUZIyNmaRy25KAoOItXvRQ+/2rMt0rGoUghuKz32nGlMSO1xXpuY7j+2Q
qe1cGLuSWgFvaRbwcxbWRZ7MeEcQMpRdVgIwmsuDkK9IN1MVGOm+CRrkrF+oEAUi
xPcyVujR2qQ4JnqeiVZpPxgLZhQs+7gDG2gM1u2rg+CG/Llm9m9YqyMejmjwmuBG
6KwxwnYHspXqABizCMk2QvStsFy/UT23zGZlW+Jo7/RE96H3xlNtuJ6z+Jq5pGjD
St/GHGZJ0wsjpK8mKS7PdG5D+bdH+QwuGJXOHmFqXGPdCXzm2mUlnaY88A7trCkb
WSaRqfBQRCmhWwVnUWjL/yCkDlV8q4mYoFuNA5HdTqYpZUjRXJzm3qdwrHatkEBr
rz7smtsLl+VdkxoARS1hjW59lsg1EN2gUkGz5aOp3JZF6D/W+ll4ajTc2p6BLVsw
V+i84YoRc8OHGZDtKhqA4cxhKobA6vjHkMUPO3M8KsddTD/LpFebTFSkLnMVcUX4
jiIF2CSABU9NnHP5MpePm0Aej/nZcMgrs7GIQGrqwWUFK+8koouP64CoKuUk1DoE
k4PHW13PCttsCEtJFSat
=0O3h
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
