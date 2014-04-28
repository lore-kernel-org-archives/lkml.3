Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbaD1LJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:09:09 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62423 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbaD1LJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:09:05 -0400
Date: Mon, 28 Apr 2014 13:07:32 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Matt Porter <mporter@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 RESEND 0/5] Add Broadcom Kona PWM Support
Message-ID: <20140428110731.GH19455@ulmo>
References: <1398450675-19609-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q6STzHxy03qt/hK9"
Content-Disposition: inline
In-Reply-To: <1398450675-19609-1-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q6STzHxy03qt/hK9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 11:31:10AM -0700, Tim Kryger wrote:
> This series introduces the driver for the Kona PWM controller found in
> Broadcom mobile SoCs like bcm281xx and updates the device tree and the
> defconfig to enable use of this hardware on the bcm28155 AP board.
>=20
> Changes since v5:
>   - Rebased on v3.15-rc1
>=20
> Changes since v4:
>   - Added in real polarity support
>   - Labeled trigger bits as such rather than use the name from hw docs
>   - Listed unsual hardware characteristics at the top of the file
>   - Removed default from Kconfig and update defconfig accordingly
>   - Always use unsigned int for temporary register values
>=20
> Changes since v3:
>   - Removed polarity support for now
>   - Cleaned up whitespace issues, shortened some variable names
>   - Use container_of instead of dev_get_drvdata to get private data
>   - Removed workaround for PWM framework bug
>   - Reworded some binding documentation
>=20
> Changes since v2:
>   - SoC DTS file updated to use real clock's phandle + specifier
>   - Toggle smooth mode off during apply so new settings take immediately
>=20
> Changes since v1:
>   - Fixed up macros to be clearer and more complete
>   - Corrected spelling and punctuation mistakes
>   - Added support for polarity
>   - Made peripheral clock use more efficient
>   - Made prescale and duty computation clearer
>   - Moved Makefile addition to keep alphabetical
>   - Split complex lines into multiple steps
>=20
>=20
> Tim Kryger (5):
>   Documentation: dt: Add Kona PWM binding
>   pwm: kona: Introduce Kona PWM controller support
>   ARM: dts: Declare the PWM for bcm11351 (bcm281xx)
>   ARM: dts: Enable the PWM for bcm28155 AP board
>   ARM: bcm_defconfig: Enable PWM and Backlight
>=20
>  .../devicetree/bindings/pwm/bcm-kona-pwm.txt       |   21 ++
>  arch/arm/boot/dts/bcm11351.dtsi                    |    8 +
>  arch/arm/boot/dts/bcm28155-ap.dts                  |    4 +
>  arch/arm/configs/bcm_defconfig                     |    3 +
>  drivers/pwm/Kconfig                                |    9 +
>  drivers/pwm/Makefile                               |    1 +
>  drivers/pwm/pwm-bcm-kona.c                         |  319 ++++++++++++++=
++++++
>  7 files changed, 365 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/bcm-kona-pwm.txt
>  create mode 100644 drivers/pwm/pwm-bcm-kona.c

I've applied patches 1 and 2 (with two tiny whitespace cleanups) to my
for-next branch.

Thanks,
Thierry

--Q6STzHxy03qt/hK9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXjZzAAoJEN0jrNd/PrOhkLsP/29qxlKh/dhTfb4gSR+V5t9a
WwdhhsZNLlNSgQ03c40DwV8DtEHD2Z4BbxeF+ElCYq0xeDU79erEDVIjonu9939v
jL1FyE0UHU9sLvwU03R7Sjcco3ljbuAG8H1TEsPyw7OKGBmcjrSEBJcgLlcHqXrg
/z2cOdgOkrBWplxqMUNVr6sh5ErT1584DceUWfJsrD6M3g6Bd39FnKhZrcPPRQAM
CN8dRcBIXsrelEpJHkLenxgb93ADFZSR1N1tU1UexQn0ufZnDJmAwRFHeTnmPtd3
kreSGOphiZwvUOy7cNC3Sxj5irCzn8vGcWiixy50SkvRwnCe5C6G+4OBwHKaj+36
FmdpP/un3AYaZ53pMoCXSYnxiMS/LboMNmXLh70VM/N1tx2j+hAL10u5LzOqFJNU
WyujvbYAs9e6FwTyLTi24j3BbPRCFJmj/cEWzuqqaMOnVnwq20Z9xFkmfBgkZlV1
WjPNRq9B1WkV/arbk5SBM7BHrylSEneo4pOl+bgEVVnes2LnL4lhWCMP4G2KAhMa
KR6vtDpVbzILz2jQbCRC4W93emOv/w+ZnkG9UmOOECf3gLDSzhiE5QPnW5AvIH/s
4LjuLg9PBCzz5ZykOZVmRPG461nRuUR+oCwuKelFs0gqvmYofa8jZ6e8Rp7Ikgoy
pHvmyR4lXBY5+KdSgkqU
=nxgn
-----END PGP SIGNATURE-----

--Q6STzHxy03qt/hK9--
