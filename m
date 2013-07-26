Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab3GZHi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:38:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47407 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3GZHip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:38:45 -0400
Message-ID: <51F22781.1080906@ti.com>
Date: Fri, 26 Jul 2013 10:38:41 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 29/36] video: output: convert class code to use dev_groups
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org> <1374703539-9705-30-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1374703539-9705-30-git-send-email-gregkh@linuxfoundation.org>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="clS6sc07IItX65tHUGRGVpNOovXeJl8qT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--clS6sc07IItX65tHUGRGVpNOovXeJl8qT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 25/07/13 01:05, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the video output class code to
> use the correct field.
>=20
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>=20
> Jean-Christophe and Tomi, feel free to take this through your tree, or
> ACK it and I can take it through mine.
>=20
>  drivers/video/output.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

I can take this.

 Tomi



--clS6sc07IItX65tHUGRGVpNOovXeJl8qT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR8ieBAAoJEPo9qoy8lh71ucQP/AmiLb5SHHc+oI/0ByQIQPSf
Z5r+xnnQ8NAgRMi1VO/Bfuu3CsnCPa+ljUlv5mX9JDKtjip5n0s9aYEa/wU/gmbl
w6XyHObS7t5WBv75OeIwLH546Q6V8ja2DArr3Qi5+4Jn2EQxORIJTdc1T2j/Go7Q
rgbkg+tsBCXsiekT+NhYar7gMxDZpwxbpnYwj+bgoTHUjYDFwkbGC4NCMaFwPTxN
bNqh9UPwrxNCAxawfR2+A1xQJXBU2Zc96qFAOF46QB2G3d/k5UgnOP3fsI4ggOZR
P5gmTRDfLSdPOM+HsJ2QGqezmpczR6d7mR12tBdsukxbTzI9FSrsP18ARKrqVhDS
xF6JRlC1C8pEveeqZosQlnlzG5mYJ7rAVnTURn5WJGkxVuSIjwMjd/8GrsKXU9Dq
pAq0oZD6k24zrJgucfqX32jdl9+nf5Oit2tvvv95HlRdek9mGkXTNQn4EKvtlT7C
Prv9Cwoo5ypf513I9un5uH4hORu/8gNGTvWL9VxgqfFsBTCg8v5gOh2Mcq+0EO+C
E2eScpjik/vKALa45K1Y+xaYBKPDlVQ3oDwk7tytgPW8D6JUYqkpMcfhM4Dz4qDV
A1DrtO/WnFcwwHD30fQMKqCmLFHdAxMQt/87zquw7MqAvRsLZbbsB89zxJv9P+Q/
ksYRwfHWvcTH+SUlDk0Q
=QHf3
-----END PGP SIGNATURE-----

--clS6sc07IItX65tHUGRGVpNOovXeJl8qT--
