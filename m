Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab3KZOfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:35:46 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40144 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499Ab3KZOfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:35:43 -0500
Message-ID: <5294B1B6.1070606@ti.com>
Date: Tue, 26 Nov 2013 16:35:34 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>, Olof Johansson <olof@lixom.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] video: exynos_mipi_dsim: Remove unused variable
References: <1384463364-28864-1-git-send-email-olof@lixom.net> <CAK9yfHw7poMXWgRYBojzWsdoTxCMRf24YjdbxBhw=gohPrtwmA@mail.gmail.com>
In-Reply-To: <CAK9yfHw7poMXWgRYBojzWsdoTxCMRf24YjdbxBhw=gohPrtwmA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="pjjoPl5ov60xplEBGnw9KW8P4HutX4Acw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pjjoPl5ov60xplEBGnw9KW8P4HutX4Acw
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-11-15 04:52, Sachin Kamat wrote:
> + Tomi
>=20
> Hi Olof,
>=20
> On 15 November 2013 02:39, Olof Johansson <olof@lixom.net> wrote:
>> commit 7e0be9f9f7cba3356f75b86737dbe3a005da067e ('video: exynos_mipi_d=
sim:
>> Use the generic PHY driver') resulted in a warning about an unused
>> variable:
>>
>> drivers/video/exynos/exynos_mipi_dsi.c:144:26: warning: unused variabl=
e
>>     'pdev' [-Wunused-variable]
>>
>> It is indeed unused; remove it.
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>=20
> I had already sent a similar patch to fix this issue [1] which is
> reviewed by Kishon.
> But the patch that caused the warning was in Greg's tree at that time
> and he wanted
> the follow up patch to go through the video tree. I have pinged Tomi ye=
sterday
> regarding this (now that his tree as well as the original patches are m=
erged).
>=20
> [1] http://www.spinics.net/lists/linux-fbdev/msg12755.html
>=20

The one from Olof seems to have been merged, so I'll drop the one from
Sachin in my tree.

 Tomi



--pjjoPl5ov60xplEBGnw9KW8P4HutX4Acw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSlLG2AAoJEPo9qoy8lh71rM4P/ibWprz5prdzVoU6ehI4+9/B
/lMMcBN2eDbzBg8E0kmezhhjj7M8+YmlxVIpLqTC68edRgFtdJRsY9yPf0XE3YmS
XCKkWuPAEDAJOSWXrvnENQnS1/2QAs0tcc5xzNp/7/NH40VGwFPRRBaBIocByXH+
3CbCtfsIcGgVeQBIZoKrrbXRLPlC2QdjYzAg0sgNLrpS0x8eYA3vAp0fZOSqxHYe
ADTXtsIasFNfhipVhlV9col+R62X5AVqFpotmQJO3Su/KvoqQlSk+M/WdF/8NQg4
fH2hdn9PhlAf8FSFx60iRHxBZns79gbRFEJcZkYtq1F1QM1Ggx5yydrnovU3kVDf
FBd32ERaVQbKX7DwROLmqc4CuHdqdOeElWvg4d/sCgPakxWJ9A6smaGlJaxq4hja
zt4sB+WjYncPBhWfM2FFqxuHq4XktstVnyKlYlXt9bmzatBhdfhg0U42WgQ9vclC
Chv/cbbROTPGLbL/khZxtl0GExcu5O+FWJxJHzMu5dEQ3zZf4bGvtIHy1mLEM7i9
pe/Ev+PuHg19g6fyDfIYlgLcSOx4GvOAqgEa+V/sSOMhbPJoUu4HKh4v8gB1dmcX
3D0z3wg1TPfNATcBZ2msYVU3scH0e/ZFECt/QIGTvNZ60U0i45V1UFFRZ07jXCo5
HoRPDVfCWTtJ44iB7N5x
=ae0/
-----END PGP SIGNATURE-----

--pjjoPl5ov60xplEBGnw9KW8P4HutX4Acw--
