Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3JaKcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:32:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39612 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab3JaKcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:32:16 -0400
Message-ID: <527231A1.5010402@ti.com>
Date: Thu, 31 Oct 2013 12:32:01 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>
CC: <plagnioj@jcrosoft.com>, <hns@goldelico.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v3] omapdss: Add new panel driver for Topolly td028ttec1
 LCD.
References: <1383085540-8063-1-git-send-email-marek@goldelico.com>
In-Reply-To: <1383085540-8063-1-git-send-email-marek@goldelico.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="5LK1iAkfBTwtKSd7FXgBWg1p7qIi6U2Xx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5LK1iAkfBTwtKSd7FXgBWg1p7qIi6U2Xx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-10-30 00:25, Marek Belisko wrote:
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> ---
> changes from v2:
> - move tx_buf from driver data to functions where it's used
> - update write functions names (to reflect how many bytes are transferr=
ed)
> - update delays from 1s to 1ms (probably typo)
> - remove unnecessary 90ms sleep (tested and works fine)
> - disable dpi output after disable panel
>=20
> changes from v1:
> - reworked to be spi driver instead platform with custom spi bitbang
>   this configuration was tested with spi_gpio bitbang driver on gta04 b=
oard
>   and works fine (thanks Tomi and Lars-Peter for comments)
> - address previous comments
>=20
>  drivers/video/omap2/displays-new/Kconfig           |   6 +
>  drivers/video/omap2/displays-new/Makefile          |   1 +
>  .../omap2/displays-new/panel-tpo-td028ttec1.c      | 480 +++++++++++++=
++++++++
>  include/video/omap-panel-data.h                    |  13 +
>  4 files changed, 500 insertions(+)
>  create mode 100644 drivers/video/omap2/displays-new/panel-tpo-td028tte=
c1.c

Sparse gave these warnings:

drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c:67:5: warning:
symbol 'jbt_ret_write_0' was not declared. Should it be static?
drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c:81:5: warning:
symbol 'jbt_reg_write_1' was not declared. Should it be static?
drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c:97:5: warning:
symbol 'jbt_reg_write_2' was not declared. Should it be static?

I fixed them and queued the patch for 3.13.

 Tomi



--5LK1iAkfBTwtKSd7FXgBWg1p7qIi6U2Xx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJScjGmAAoJEPo9qoy8lh710WUQAIQ5cxjfLdeR8QjGnG+uTyAs
3Z3sVmafIWSVMvelQPaNzH5yceqijJLpul6FcNCjgiZ3yGKo14nE4BrT/IdR8qyO
xskam6h0+Dq0sbqs/02aiNlJ3VLiwlXVQqmmfK/LKxJDPr+lxl/SNYrXj1wHKTGX
EEnNSr/1h33G0EbK+0VZwaLe/Az9L8Cw8JjUwSiC8KS3cARp5nOM3aJQ1zgpTsJW
v7BPVkHHHUKTLSFoUaa6ieWZYWuArzRMO3UfiSAysSrZDWNLDykF1waFp0ra5y9A
xcLKT+bCwSWbmcr6jMRpzHr/vOdx6fPArK81aZ57jheIhy6zxClT9wrfAbgd9DJP
HnGJXTwO1eXbPoc8joq47zZavPHPj9T5iMfdXgy5PQ4eGptrklswiX2YfySwNUFF
HBG3Ff1ubLcdPcwk92IsAKAxzfkVlHlZ0JguIAAjkwMwDjBAd9uAsnG4SAz1Q6Fd
eCNOTZwwLBSQmLTfQV8fbkTP8ieJkveGVbNDqeu8WpF6fIPhhBDxn/frjd5kme6x
hiGVGoW2KqkJoD/LjkKOddUDJFuw7LIJnDCCNswL3DJq2c5DYvpHWzJNwPN3qe3Y
18QQbDKtcZlIQK8nhGh5AVQv7v0pZc9tz7bYsfSY+IhoftL2cbiUsr2KfFoQ8MDS
RP11ACwzcVLwtWUKoKvK
=LY3Z
-----END PGP SIGNATURE-----

--5LK1iAkfBTwtKSd7FXgBWg1p7qIi6U2Xx--
