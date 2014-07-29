Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaG2I0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:26:53 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10815 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaG2I0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:26:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 29 Jul 2014 01:18:36 -0700
Date: Tue, 29 Jul 2014 10:26:46 +0200
From: Thierry Reding <treding@nvidia.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus Walleij <linus.walleij@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the gpio tree with the arm-soc tree
Message-ID: <20140729082645.GC31360@ulmo.nvidia.com>
References: <20140729181949.427a7fb5@canb.auug.org.au>
MIME-Version: 1.0
In-Reply-To: <20140729181949.427a7fb5@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 10:19:49AM +0200, Stephen Rothwell wrote:
> * PGP Signed by an unknown key
>=20
> Hi Linus,
>=20
> Today's linux-next merge of the gpio tree got a conflict in
> arch/arm/mach-tegra/board-paz00.c between commit a0524acc94c9 ("ARM:
> tegra: Sort includes alphabetically") from the arm-soc tree and commit
> 0a6d315827ee ("gpio: split gpiod board registration into machine
> header") from the gpio tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc arch/arm/mach-tegra/board-paz00.c
> index bb4782a32713,91fd858ced0d..000000000000
> --- a/arch/arm/mach-tegra/board-paz00.c
> +++ b/arch/arm/mach-tegra/board-paz00.c
> @@@ -17,10 -17,9 +17,10 @@@
>    *
>    */
>  =20
> - #include <linux/gpio/driver.h>
>  -#include <linux/platform_device.h>
> + #include <linux/gpio/machine.h>
>  +#include <linux/platform_device.h>
>   #include <linux/rfkill-gpio.h>
>  +
>   #include "board.h"
>  =20
>   static struct rfkill_gpio_platform_data wifi_rfkill_platform_data =3D {

Looks good to me.

Thanks,
Thierry

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT11rFAAoJEN0jrNd/PrOhTLsP/Rkd6Y8QxgP9lOnnoUOjiSG4
bdSDR4OV99v2901RRf2lPqf1DjXOiFubFssqlUp31rt5gyHq+hG5URkwahFbS3Fp
DNJAvBD1CWg9PJfdRyxkLFAlLvat02BJCcNA3EZtyh85j4rezy1bWLUOWgCPBo7D
IlnVdP3p4a/XpGbNVNmJz+zPtVmgnumpyeODuGjbf67qKH1upsGqX4Xmr5miRajt
TEKHuZF158Q5k2J8UklUnf9Kk0AsjdLAoWJGv4bQ1GFADoDL751Mmwn/WP3F5bKq
sexogIA+LmBcoOtBhLb0VkZriOxZkZ5/3zZv42Kjti76vzrluZZUEQrrvDMUldh2
v9hVE1Uqmsqr4Yyo2OF7leFUxiSXnXuVoSjBfIgC1mSZDjfCHwSdz8tLwpMWq8+K
D9HNQ6fXkyA+dsWmRNpLm3aUH25/A7gUsuRJvLNM/Png4dSQ2HbL/e8m05WFGGxn
jZd3OXURY5Pge7aO9fPGHChkpCwZ/ewI4B+4Pt+yGZwyWMYIjKJ/tRRS0JkxPj2o
pMygh2hES1xAlIN7jabdnFFzxoDJtRMlhsUQ/ERukOWemFvwrKanxg85J8+xsd7K
cbLh6ERq6SHOxqBsAqaAcXY5IRbYBHdwS+e5KB6+2xhZigi8QA2gT/bRQeV5yNNf
fj0hbdKJcnTV1q6Xj6I7
=KCGD
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
