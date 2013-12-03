Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab3LCKZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 05:25:58 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:49177 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3LCKZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 05:25:54 -0500
Date: Tue, 3 Dec 2013 11:24:56 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Milo Kim <milo.kim@ti.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pwm@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 3/4] pwm: add LP3943 PWM driver
Message-ID: <20131203102455.GH21178@ulmo.nvidia.com>
References: <1378949630-6275-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5lq+205vWdkqwtk"
Content-Disposition: inline
In-Reply-To: <1378949630-6275-1-git-send-email-milo.kim@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5lq+205vWdkqwtk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2013 at 10:33:50AM +0900, Milo Kim wrote:
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

Hi Milo,

Is this patchset still the latest version? I've tried to remember the
status of this series, but I could only draw a blank.

Thierry

--r5lq+205vWdkqwtk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnbF3AAoJEN0jrNd/PrOhqAkP/AqIOrF+xw6W734frmBfQXik
BYS6Aic0/Tih/fTnxvjXFBegamf6/cBYLewQ8+qltUrVjODQPQB18PmEfRcS8206
X71pwsNfWG4aKVHtNZYRxIInoKSU80jm6AGSJMjo9SS/ZAoSN6mJiNVJKeCAp3oa
Fl5LyD6X744SrB8/pE3ak7ZSWWkKeHK6UbY0Ytf03+UgBzD6LYGbyHWJPsa2WZHS
S6Z/tg56PWmP/coGo4g34jhe9Sl/Nn9rWUen9svEUrWcGfQ8FoMkYrnUOFVxs/xL
uPusy30TJ6UARjo4KORxIV+tNvM5f0C6G/eGHs2NxgWUsbw3eY9bGqrMuXSVq845
+oi4J747PTGqlTyCIJ+iUZuKoPaYftuGs24Mw026QYxbsJJmyfYEzNI5jg4WR4Jp
maG+ankJsERYYpIJaEZBWgj5VTDYtAOWGQbOJ+S4YrnABUKGX7sR4GGzL/StQ7MJ
WJyogOkTD7HDkNRpwpxD6hfQuxxzGwD9WB7HCUkPpoejCOxwrmwWfTRa72U6fhX4
x4uusdr7fBTPt/fx1VEJOG9hjeKUe39jgVoq5Oj/rXxgnMFQ3aRGFDA8rU8aa8CB
Ur0MgZMBUsqxEqvtn57PoN5SatIz7B45yhtcC0OmEOhcv3xEcDkOKD/2IXnnYTmJ
gFnDyFKaTknnVFG5IB2B
=/gb2
-----END PGP SIGNATURE-----

--r5lq+205vWdkqwtk--
