Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3FZMAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:00:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40111 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab3FZMAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:00:42 -0400
Message-ID: <51CAD7E4.2000403@ti.com>
Date: Wed, 26 Jun 2013 15:00:36 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: "Etheridge, Darren" <detheridge@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] video:da8xx-fb: Convert to devm_* api
References: <1368688257-18705-1-git-send-email-prabhakar.csengg@gmail.com> <1368688257-18705-3-git-send-email-prabhakar.csengg@gmail.com> <51CAD305.30407@ti.com> <CA+V-a8uhK5-QJKifkiSUN6Nz0aBc2moraWQUJPCmZg9zaFX0eg@mail.gmail.com>
In-Reply-To: <CA+V-a8uhK5-QJKifkiSUN6Nz0aBc2moraWQUJPCmZg9zaFX0eg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2IEJDLSRPTTVQWJLOXTCJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2IEJDLSRPTTVQWJLOXTCJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 26/06/13 14:56, Prabhakar Lad wrote:
> Hi Tomi,
>=20
> On Wed, Jun 26, 2013 at 5:09 PM, Tomi Valkeinen <tomi.valkeinen@ti.com>=
 wrote:
>> On 16/05/13 10:10, Lad Prabhakar wrote:
>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>
>>> Use devm_ioremap_resource instead of reques_mem_region()/ioremap() an=
d
>>> devm_request_irq() instead of request_irq().
>>>
>>> This ensures more consistent error values and simplifies error paths.=

>>>
>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>> ---
>>>  drivers/video/da8xx-fb.c |   39 +++++++-----------------------------=
---
>>>  1 files changed, 7 insertions(+), 32 deletions(-)
>>
>> There's something similar in Darren's da8xx-fb series. Can you check i=
f
>> there are differences?
>>
> I don't see similar changes in his patch series.

[PATCH 14/23] video: da8xx-fb: use devres

 Tomi



------enig2IEJDLSRPTTVQWJLOXTCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRytfkAAoJEPo9qoy8lh71AsEP/1sQaYeYGmwiI+kmVmjKJS0W
YNDzHBtcZw+oB6on32pd+16+XPw+r2eLSRjz4L41VAbeQ5Dnq3sKSikCTomdRVKt
+OtcsSgrrORQf6Le2PhXECaUa663HG2m24di6ijDrnGAeHfsIVZUwtU/LaldD/Ea
TXWtv/GTm4QcZee6dgriTQACEHCjTgaXND+NHz3SxE4uFvqcardMe/2Gjutub602
L7Rj7l3M9hWMShR9npkJXeT6CUl1jzHly4T6u3LAZHYwZ1umEkNDe4XfZwOIKsNj
KHdsWvOu2Kh8rjAqzstogrLVyUjjDMG12E/Bfhs814s9ctAlLey9VnoAraHbNkM1
uLum/DX4MiG6ylmWHuynUP68rMjkfW4hWUjI/t2xIrucP+SHhH0VXqv0PnYC+pqf
VCuT2bCJr3YtP06wzmUcSjgJemTGDvftDoJflvpY1wqTpA+lzQ712S7u2lVjh3K+
BQzXWa3Y6pxEIMn0V7bWoVK5AiFPNpTZhCUcpVlfPaBsc9myJ7yE4ZYKfZx1mVqV
+9Bh16YFedXVqRvwD9UdVvqPFYKo1EiTiWbXu6BDpXDjcrP+68XL/Dtq9jarUDQ1
x8FJYv6RJC65pHUllX0yMr1oOTJzSMsgfn5sVBJbD00XY4Zq+5MwQ+9vmjPSnYzu
oh3y0EgfA+x90WaUbWRY
=oA6T
-----END PGP SIGNATURE-----

------enig2IEJDLSRPTTVQWJLOXTCJ--
