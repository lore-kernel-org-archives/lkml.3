Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaBNMbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 07:31:46 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50229 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbaBNMbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 07:31:44 -0500
Message-ID: <52FE0C9C.6090905@ti.com>
Date: Fri, 14 Feb 2014 14:31:24 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        David Airlie <airlied@linux.ie>
Subject: Re: [PATCH RFC 2/3] fbdev: move fbdev core files to separate directory
References: <1392376711-11290-1-git-send-email-tomi.valkeinen@ti.com>	<1392376711-11290-2-git-send-email-tomi.valkeinen@ti.com> <CAMuHMdWWOUVe-16VBZ098-OfB21X9Wz1wO8gmSUy4PsFvQoX1A@mail.gmail.com>
In-Reply-To: <CAMuHMdWWOUVe-16VBZ098-OfB21X9Wz1wO8gmSUy4PsFvQoX1A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="H0fDMKj3Um9qoHsuRgn0hO7GjHmd1oDLF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--H0fDMKj3Um9qoHsuRgn0hO7GjHmd1oDLF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 14/02/14 14:27, Geert Uytterhoeven wrote:
> Hi Tomi,
>=20
> Thanks for doing this!
>=20
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
>=20
> On Fri, Feb 14, 2014 at 12:18 PM, Tomi Valkeinen <tomi.valkeinen@ti.com=
> wrote:
>> --- a/drivers/video/fbdev/fbmon.c
>> +++ b/drivers/video/fbdev/core/fbmon.c
>> @@ -37,7 +37,7 @@
>>  #include <asm/prom.h>
>>  #include <asm/>
>>  /*
>>   * EDID parserpci-bridge.h>
>>  #endif
>> -#include "edid.h"
>> +#include "../edid.h"
>=20
> This looks a bit asymmetrical ...
>=20
>> --- a/drivers/video/fbdev/wmt_ge_rops.c
>> +++ b/drivers/video/fbdev/wmt_ge_rops.c
>> @@ -18,7 +18,7 @@
>>  #include <linux/module.h>
>>  #include <linux/fb.h>
>>  #include <linux/platform_device.h>
>> -#include "fb_draw.h"
>> +#include "core/fb_draw.h"
>=20
> ... to this.
>=20
> Perhaps (the content of) edid.h belongs in include/video/edid.h?

Yes, I thought the same, but I didn't want to start messing around too
much in this series. I also noticed some odd Kconfig options (for
example, HAVE_FB_ATMEL, SH_MIPI_DSI, SH_LCD_MIPI_DSI at the beginning of
drivers/video/Kconfig), which I almost started cleaning up, but decided
to just concentrate on the main reorganization.

 Tomi



--H0fDMKj3Um9qoHsuRgn0hO7GjHmd1oDLF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS/gyjAAoJEPo9qoy8lh715ugQAIUwVqQC15qPyjBynI7AsFEi
JerkdL7p+vQvPquO/p0T/aBqjalZszWBxDw+VdC5ilo4ekqA8TIiGrmSYmKpSQuB
IG0dnOo3wg3bZpZrTUPp8gKqN60olta3HmT89nUGuCdHJxtlC8BOcN+7NV0/Lix8
9Pw/OCug4pufvGxeCnJoGGL4fle+pKyxa5YsEdHdz0qic86SKs/tGy5+s/0xzsyA
jr0U74LmNQMEuJzEd4/krCacRDFmoUj+29uWOaYhxIAshlqkIo0Ou2JY7U7V8ozP
A06HE6nBLHAd3hLsjZYEG68mOuYmkBKEvJipaSzm9Q8+YU6dgjxyAaZtjl8KLdPc
I4dBtsYKsURe8D7AJ0irK9M2VU2rCgc1UzMF0StwuNQDou79jTsPn7gg3m/BCQN3
Ig7xUXcoCYxe3rSBJEYWyzzVqe8rXuhMEJ8Bx7xCJabWSaYPPhgRP4jAgVe8TcvS
rFI9Fz1LQO5cJA8A/eR4PG5wXZz9T6jEiukqkSglBe3EL8OkU7DqJvgCw+sh7dm5
ta8aMWQ9EohM0sgIXCSQxCwVdM1vri5mAyiDZ/sE0qVP31Zphrq8pgWAa5kkpxP9
Pc4zsq5BjrsdKn7as2c3JPK75u0lL8ZFrBhsuF3PQtvhiv13268EdHEI/aLOw2FN
j1UUt44XjK5jvvB0CcEP
=ja7q
-----END PGP SIGNATURE-----

--H0fDMKj3Um9qoHsuRgn0hO7GjHmd1oDLF--
