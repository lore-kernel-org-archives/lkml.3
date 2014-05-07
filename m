Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaEGJSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:18:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38096 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbaEGJSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:18:23 -0400
Message-ID: <5369FA56.1070802@ti.com>
Date: Wed, 7 May 2014 12:18:14 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>, <linux-kernel@vger.kernel.org>
CC: <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH 00/13] video: Arnds randconfig fixes for video
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="XJ9X1xP7s9gC39uwr7aATQlBFkqCtAVve"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XJ9X1xP7s9gC39uwr7aATQlBFkqCtAVve
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 24/04/14 15:28, Peter Griffin wrote:
> This patchset series addresses various bugs found and fixed by Arnd Ber=
gmann=20
> whilst doing randconfig builds.
>=20
> My involvement has been to review, add/check the maintainers are correc=
t
> and submit upstream to try and reduce the backlog.

I've applied patches 1, 2, 3, 4, 5, 6, 7, 11 to fbdev tree. I'll apply
13 later if someone is able to test it.

 Tomi



--XJ9X1xP7s9gC39uwr7aATQlBFkqCtAVve
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTafpWAAoJEPo9qoy8lh71jmwQAKifJN3yMDOYqJduXT11aLCF
oCUKQN+YAlu5JD8vRiYzlcYXjwRViLYSYVSrrF+3EvOOFzV7Rz6nAltUXTUJHkRN
9cfcp/tg6J8KejJIoLtGc/uv/aUp3vzohvp+KLyHr4Vuv0P6R2Jp/RF3ZAwIZw2C
Rb5t8NwTf9PEz28stwkOpqqJaYPxvuEi4OorbZ53hqjjlTUYyTS+gtbdh70ctBiB
T5MTkSSQVJionex3AhK+k3RGaTQ/WVKfa7UQMwnzWwo3Eot0CDUHIOQBHI4GujKE
oD1in7tpsQjMLApHlrZATQGUD/Np7pGngJzRXl4aNncNWVll5ObQUWQm2LAQPhrP
Dl4Vv+L9Hl+UAUd87pYo4LwUmAVFg+UZkHtMdGgNSQ840zZaxrJ0TsBXr7yDSDRs
M8HjCyuFpTpTTguurp4WSb9sduhNzto6cgQFYyq8AHoLew2WhwVPHzFDxgtdtist
s1PcV4/qR9u41iR0xbdmvCoZeJoWszyvBbYwIZzty1uCFYcxyoYfy3/vsps6uju/
U4ugdRGXekNqrb643MbUzFgsveT5BMnatAc2bNcIErwUFK4NgQlrStjLJq9ni3Nz
faCc0D/GbbfZvPyVsp9LL9VKQ0LYXStCP2vnJA/uvIuFBJLxx5NM3EXK23kYTImQ
IsgRwNwtB044LF53B3Mp
=fi+e
-----END PGP SIGNATURE-----

--XJ9X1xP7s9gC39uwr7aATQlBFkqCtAVve--
