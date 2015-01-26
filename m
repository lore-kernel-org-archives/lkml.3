Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbbAZMhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:37:35 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57749 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbAZMhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:37:33 -0500
Message-ID: <54C63506.3020106@ti.com>
Date: Mon, 26 Jan 2015 14:37:26 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: fbdev: sis: remove unused variables
References: <1421940699-20670-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1421940699-20670-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="e2Mvn7ckpOhQ4MSFDodcmeA6BE37N8kGQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e2Mvn7ckpOhQ4MSFDodcmeA6BE37N8kGQ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 22/01/15 17:31, Sudip Mukherjee wrote:
> removed some variables which were not used. Few calls to SiS_GetReg()
> were left behind as they are reading from the hardare, removing them
> might affect the overall functionality.
>=20
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
> This patch will generate checkpatch error, to fix that error we need
> to change the style of init.c and init301.c
>=20
>  drivers/video/fbdev/sis/init.c     | 33 +++++-------------------------=
---
>  drivers/video/fbdev/sis/init301.c  | 10 ++--------
>  drivers/video/fbdev/sis/sis_main.c |  9 ++++-----
>  3 files changed, 11 insertions(+), 41 deletions(-)

Are you able to test this?

The patch doesn't look too complex, but it's still slightly too complex
for me to comfortably merge it without any testing.

 Tomi



--e2Mvn7ckpOhQ4MSFDodcmeA6BE37N8kGQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxjUGAAoJEPo9qoy8lh71cnIP/3HA7IZ09M3THHjJCe5C2Dgo
iZ0dM66ulp7mbdICDJhpZTpaVtU6l9sONyF0BRMxRcdeE2UhNLIzUN9MPa6THOMM
qzEJ0Yqw9xpFpsz7Ap+jxdcqGh/SIX2EcdO6yZqz8cKox8BQDoTgQHVZTLrcKt+C
Q7ZsBUXV8M+w6WKqYRYvhvnXR1x7FTXm2UUb/HOg4Dd6UZbrJX3oHBmwPhuzFZxq
eUONR85FUR9xXV0qk3N12TKxRjwbmujsuINMsdDV8hilJBpg4PtEQ+Wz8KhJM5X2
R6oQRxadTJLgFCSkmZWlr+VmkDtSKON86lwWZm3UvcPewiTOeGxN0rxjXujFZw0V
zjEJJk9057SOXQKRTIIIMY+PennV+i8frfQrTjZjY74zYFzhbIuzkSs4L3yDY20Y
cvc0icEfHEC4bFk8Js1oNLYfSslNInAvhbZEGTHiFdlgPQ01+6tUaO82/fn0MB1S
HesimVYkhHF4z34aVUlYHYTUpsOXVuW4+t3Kj26NU8MfOf32vmFtrETzIDMNr2Pq
FPSRPhI38W3hPXOvQ9KZsb+YrkZr05WxbE7P80MzboqzAPhNx2kcgG+gd69FKGNw
DVxHv3hAB/+3da3QWTfb7hNpgT6ejDDTMjxHtuQSawCvzSkfGMFvic3Wv/IIcUK1
1aEx6IAHdklZg83Tx/Ll
=y+B3
-----END PGP SIGNATURE-----

--e2Mvn7ckpOhQ4MSFDodcmeA6BE37N8kGQ--
