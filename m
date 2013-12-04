Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3LDKc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:32:29 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:65020 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab3LDKc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:32:27 -0500
Date: Wed, 4 Dec 2013 11:31:27 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Milo Kim <milo.kim@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pwm@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4 3/4] pwm: add LP3943 PWM driver
Message-ID: <20131204103125.GA26589@ulmo.nvidia.com>
References: <1380083078-6212-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <1380083078-6212-1-git-send-email-milo.kim@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2013 at 01:24:38PM +0900, Milo Kim wrote:
> This is the other of the LP3943 MFD driver.
> LP3943 can be used as a PWM generator, up to 2 channels.
>=20
> * Two PWM generators supported
>=20
> * Supported PWM operations
>   request, free, config, enable and disable
>=20
> * Pin assignment
>   A driver data, 'pin_used' is checked when a PWM is requested.
>   If the output pin is already assigned, then returns as failure.
>   If the pin is available, 'pin_used' is set.
>   When the PWM is not used anymore, then it is cleared.
>   It is defined as unsigned long type for atomic bit operation APIs,
>   but only LSB 16bits are used because LP3943 has 16 outputs.
>=20
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
> * Patch v4
>   No update, same as v3.
>=20
> * Patch v3
>   Manual polarity not supported any more.
>   Add encapsulation functions for accessing internal data structure.
>   Use pwm_set_chip_data() and pwm_get_chip_data().
>   And other code fixes based on Thierry's feedback.
>=20
>  drivers/pwm/Kconfig      |   10 ++
>  drivers/pwm/Makefile     |    1 +
>  drivers/pwm/pwm-lp3943.c |  314 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 325 insertions(+)
>  create mode 100644 drivers/pwm/pwm-lp3943.c

Acked-by: Thierry Reding <thierry.reding@gmail.com>

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnwR9AAoJEN0jrNd/PrOhFuQQAJMR6YUUxg6LrOAgRxmc9CbX
xJlEi4FWtpKnET0LWO2oy5/vFM0kMVAs9mZorAOBY5ksPLpF7ALY24zen1lAjA0i
dKmkpfwylyPSjZKFfO2DBKPmxGsxBBK8aabfty9kAzNRvR/CTUVXbGcESmzu5N44
7Kihowb2IXp+AtPkmuliWiFPSiPNVRWlBKwtiLifrQVEZCCTg4OQZ97UBIe9JzEt
ZC24W9w/kYCKBFosadvN9p2r3CotKQnKfCfIGISa/KeTpdzJ7FGxnTJefHxtn5L/
Fv1Ik1xcYUerzWX0KKxKaYCbT5HkkMMEvpr39VnKLLcv5cg0XfcxcTRzPnIKXNcw
02zPC1WPbrkq7gdEkP68O8S4GQXQfYRUanMiJ4DnS0GKwZT7GVEuL4uz21AwFZlt
snaY7tEjiUmJecw7hr/p+9fbdJ05J+50rZCxxT85awH7b9LnD9JVYhVr94z5Z6YW
EPDIH8bWfzHowTAaS1uGqhjOkFZS8n3+h4XFJVAOnF+vsgJqL4HhOF2DosnKXvD8
S5ODejxfUMOvqQoSQtHcTb+8mwEnBxaU45UpyFPTRwko3Es2Ags9/C5Ty28hqTVG
iJpzzdNuEecZkUp6pCgoJVgw+qBWSx4ISmgThDE3KODKm7uAGOsXWHtq4rmu3TKo
hAwiF2a9RfAyIf3tFLj4
=Sx4D
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
