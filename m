Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaEBM7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 08:59:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32890 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaEBM7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 08:59:47 -0400
Message-ID: <536396B9.60801@ti.com>
Date: Fri, 2 May 2014 15:59:37 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Brian W Hart <hartb@linux.vnet.ibm.com>, <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <trivial@kernel.org>
Subject: Re: [PATCH] fbdev/fb.h: silence warning with -Wsign-compare
References: <20140501193235.GB6495@oc3347516403.ibm.com>
In-Reply-To: <20140501193235.GB6495@oc3347516403.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="iCkP6iR3XqbDPQjF373mAa8WJdGvfXSsu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iCkP6iR3XqbDPQjF373mAa8WJdGvfXSsu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/05/14 22:32, Brian W Hart wrote:
> Silence the warning when building with -Wsign-compare when fb.h is
> included:
>=20
> include/linux/fb.h: In function =E2=80=98__fb_pad_aligned_buffer=E2=80=99=
:
> include/linux/fb.h:650:17: warning: comparison between signed and unsig=
ned integer expressions [-Wsign-compare]
>    for (j =3D 0; j < s_pitch; j++)
>                  ^
>=20
> Signed-off-by: Brian W Hart <hartb@linux.vnet.ibm.com>
> ---
> Compile tested only.
>=20
>  include/linux/fb.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index fe6ac95..0da7634 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -641,7 +641,7 @@ static inline void unlock_fb_info(struct fb_info *i=
nfo)
>  static inline void __fb_pad_aligned_buffer(u8 *dst, u32 d_pitch,
>  					   u8 *src, u32 s_pitch, u32 height)
>  {
> -	int i, j;
> +	u32 i, j;
> =20
>  	d_pitch -=3D s_pitch;
> =20
>=20

Thanks, queued for 3.16.

 Tomi



--iCkP6iR3XqbDPQjF373mAa8WJdGvfXSsu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTY5a5AAoJEPo9qoy8lh71ul4P/1fx2UNNV9voof7oVfG1CBeY
ZZn2XRKpUN9ZrIuPb8vRF+g6irqs+T0KA5oAX+31AUaU4BdXhFu0N0HGqXbj4KLE
XEGqsLe88yqEHwKgSgItHbX8V9FabesXrdMJQN5lvnlTfYPx9uUzSUIhYIm9D5fs
EvCFQLk/xQ8KT9ww65xweUiWll7PHLT/C04w9E+UQPsBcq8cyhzKGx4To4dGuVpa
6oWrfmx74CnktnehBckKB9tNgJLO+DO9yjtWlyPWSChxfbnQOg6YFPldxuOy4E+d
58T950R5LrZJ/PbmjqY3kwRVMpuqd7NJMoSbRfDlpEiRWa3AyQiI70e91Wv5yeJD
srfNVlym62Sg1n3DtZkGIh4D0jtqqBO9j9tNy1SWZTeefZ+O3Cmi3fJpkrxuWLCr
LKhgURZ8lnNlVrNUw6ms7cck5/3qX22x/8V88MH14qO76lYELTRPPs/teEC4KKxk
bPByqBo8mJEHkQ/cPRY+DFUbezCgd4j19u8Fmr9yqp4iOiq/ZccDinUeS34cvMxp
lFt6HlaMHEHNE1tPyebGjtQvGE2711kJ3WioffwDL/uXftNQBnyCm8vDbMGEdKdc
ZCqg9kdIeDAnONfy9VdNTFWJDoc7Krm6+BaB5YB4/iIg+lu7CzVrBMXwPvcHVY0n
YR8v2VOpU4/zznbif3rM
=/x/S
-----END PGP SIGNATURE-----

--iCkP6iR3XqbDPQjF373mAa8WJdGvfXSsu--
