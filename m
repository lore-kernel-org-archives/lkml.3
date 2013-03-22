Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab3CVKit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:38:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50759 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab3CVKis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:38:48 -0400
Date: Fri, 22 Mar 2013 11:38:43 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] pwm: pwm-tiecap: add CONFIG_PM_SLEEP to
 suspend/resume functions
Message-ID: <20130322103843.GB4567@avionic-0098.mockup.avionic-design.de>
References: <005301ce1dfd$f306bec0$d9143c40$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <005301ce1dfd$f306bec0$d9143c40$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:kn+9sRAUJUmeYg/QsNomn+D57AXCZjHWfAGaZGLunTa
 0P41wlHWysAtUFAXsvn7TMR7DTY1ATAnS2w+BGRRHpX5Y3gxjs
 VdWOPYEoZQJZY2j/xCg/12Qx+NSZPyQoDzC6PFgwEAsv4LKMyl
 z+CtD2odmBt48XNuOzKsnLrAMddy0CC6L4hMsTPm4jtt2/V3Zt
 kiBE95R4j97/nPehBSoCXLDdkH0WnQhAZ1mn659msMYQ9ENhwx
 zx8/A3z64eHWnDtkoOzMGJVmznxjEHGXx27P4jWlZbohSmKZND
 8o1di5Kn+ilZ65MOve4DMEeXfdNHDtAjIV9KlMOSdK7uk80clJ
 hKVKIqiHBUsubfMAuMD9Mb+/sLVTTZx1Iauw5nm2O8k5viJwOd
 lKlAI6EmdO4xsaNd6M/GVu/Udj9/AGVdxA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 11, 2013 at 11:12:58AM +0900, Jingoo Han wrote:
> This patch adds CONFIG_PM_SLEEP to suspend/resume functions to fix
> the following build warning when CONFIG_PM_SLEEP is not selected.
>=20
> drivers/pwm/pwm-tiecap.c:314:12: warning: 'ecap_pwm_suspend' defined but =
not used [-Wunused-function]
> drivers/pwm/pwm-tiecap.c:328:12: warning: 'ecap_pwm_resume' defined but n=
ot used [-Wunused-function]
>=20
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/pwm/pwm-tiecap.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

All 3 patches applied, thanks.

Thierry

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRTDSzAAoJEN0jrNd/PrOhNccP/jDqB5FInM/Y0nFXFJJqMwpB
kuIeOhP0BwiDlIbZjYoLWxiqzSXmIf/XusoCi9ltNlzKHOf4oOOmC58HA9C8Jrvx
kHwy9Rh+wiqnuiVB5QIDkUxYzgl2aemnxQ+O9fqoQLam3xIUXLNTIEGPna7ZOFgV
xDbCRBYcOtl08dPB8IRxaP1TniHrRccpLsvVN7zqQIOMBjG28d1CAO9AvajRRRcL
OAe0lJfnVJNbzOjn3MlIZCdp9dTKjNee2Fyc+u40kcL3W6oEXm85vD0E9sHc6plX
D0ije6aGN6O2T1LWl6aHJxrgeheVtnHaXUYIs/6fdGq7yUKfVNEDJ+tE9HfUcruo
4lEvmiNZp9n67x5UpmA90znjKLLlwjQx89FdLjfWxSwJyQAAuos+/xH7RZZrPP3S
DDo4QOfj2BkY7fQPfFNvyWqKu+dmDZeQ9JO72t062gdagC7H64ANlVJ12aiOlsr8
ziJ2K917LbknvMeInmcqeF1towPif8ihKSWbNXo4APnNG2ygaFlVwIh3A39GiMqF
Gc1xJpG7e6uIwqrXRuA6PsN6806vQ8fG+QLTFVRLhODbbvYqOfOR4zbC2OjbnTl/
RgBFD5ZDCzZ7CxfQ5OcAf0d5dNT13Kg1bqvPyk6de7DAwuKYgz36KRyO/iWUdwXa
bBPIdXKNQFpS91nabyOD
=/f8P
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
