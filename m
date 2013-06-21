Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab3FUJcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:32:18 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:61160 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469Ab3FUJcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:32:14 -0400
Date: Fri, 21 Jun 2013 11:32:08 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-pwm@vger.kernel.org,
        linux-doc@vger.kernel.org, poeschel@lemonage.de,
        Ryan Mallon <rmallon@gmail.com>, rob@landley.net
Subject: Re: [PATCH v5] pwm: add sysfs interface
Message-ID: <20130621093207.GC31464@manwe>
References: <201306111039.00344.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <201306111039.00344.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2013 at 10:38:59AM -0700, H Hartley Sweeten wrote:
> Add a simple sysfs interface to the generic PWM framework.
>=20
>   /sys/class/pwm/
>   `-- pwmchipN/           for each PWM chip
>       |-- export          (w/o) ask the kernel to export a PWM channel
>       |-- npwm            (r/o) number of PWM channels in this PWM chip
>       |-- pwmX/           for each exported PWM channel
>       |   |-- duty_cycle  (r/w) duty cycle (in nanoseconds)
>       |   |-- enable      (r/w) enable/disable PWM
>       |   |-- period      (r/w) period (in nanoseconds)
>       |   `-- polarity    (r/w) polarity of PWM (normal/inversed)
>       `-- unexport        (w/o) return a PWM channel to the kernel
>=20
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Lars Poeschel <poeschel@lemonage.de>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Rob Landley <rob@landley.net>
> ---
> v5: * rename the 'duty' attribute to 'duty_cycle'
>     * make the Kconfig option hidden and enabled when CONFIG_SYSFS
>       is enabled
>     * use sysfs_streq() in pwm_polarity_store()
> v4: * address a number of issues pointed out by Thierry Reding
>       - fix some typos and wording issues in the Documentation
>       - rename the new source file to sysfs.c
>       - rename some of the variables in sysfs.c to clarify them
>       - fix the period store so it does not change the duty cycle
>       - change the polarity attribute to use a string representation
>       - add a warning message is the pwmchip_sysfs_export() fails
> v3: * fix an issue with the export/unexport of the PWM chip
> v2: * add API documentation and update Documentation/pwm.txt
>     * fix some issues pointed out by Ryan Mallon
>     * add the pwm attributes to dev.groups so they are created
>       when the device is registered for the exported PWM
> v1: * Based on previous work by Lars Poecshel

Applied, thanks.

Thierry

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxB2XAAoJEN0jrNd/PrOhQZcP/itozeTE/X74IiDW12mWTJcL
bLCWdaa2/2P8iZvKjl92gZYzW+hHgapL86m+fKyzg95UNp00e/zsfKnYv2bscj/W
5p6lDNlY/JE1Q0+HBTouFdcccJ++xJF0zzp5XBA/dyKUJeKL1a1C2wlW2Z53YXBz
XQJ539bHDqBhk71QjZNfpaGT+rKekiUlXpfRzDuOqhNRJrNAzQoSRhpuTv1BgRGX
Gnk6Sp3E2FKV+ligE/X/FM6NE8DrhecIUsLfJ9S2yJbNPEJ2h4f5vyoGUI38Dqn6
Ruz0TqzxmNLohi535D9Du8//+qJoIh4Nx60SG5liYK32IdhPlJy33Pe3kG4ezLNf
im6Gv7w5vB8/yt1uD8slsXc5fKaqAHNHEBsCB+YVlECoVWJl29/ZebMqbN4e+8w8
bjr2L1Yimncir8XE74h9geiO3USE8aLaw0zA/K0tsnHE8mUkFF6qdDJ9vt4ZBuR0
/hcfZgUlcJVXIXtx2fEJr0MsCx9iagrvmbMcR/rOG+wSnLXzX0LneGkhvbgNS+3g
SccesVrk5a1rBfxCCez4gBWXrhQxrVSWHp9nYSy5z3vtgoO+Rb/KElJQj7Hgxx5y
xnD41mXhtJZrQ9vP2i0z1eTpYkmlB4GsMDT5pWPm3Mo04BsEHns6/tCvQSk+PWrr
4cvmYMyZhRdSDwSHsXJ/
=30+e
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
