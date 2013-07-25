Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab3GYRaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:30:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33495 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678Ab3GYRaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:30:30 -0400
Date: Thu, 25 Jul 2013 20:30:17 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] usb: gadget: mv_u3d_core: fix violation of locking
 discipline in mv_u3d_ep_disable()
Message-ID: <20130725173017.GK25415@radagast>
Reply-To: <balbi@ti.com>
References: <1374610817-14894-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2O+9B+xSKalj/wdD"
Content-Disposition: inline
In-Reply-To: <1374610817-14894-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2O+9B+xSKalj/wdD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 24, 2013 at 12:20:17AM +0400, Alexey Khoroshilov wrote:
> mv_u3d_nuke() expects to be calles with ep->u3d->lock held,
> because mv_u3d_done() does. But mv_u3d_ep_disable() calls it
> without lock that can lead to unpleasant consequences.
>=20
> Found by Linux Driver Verification project (linuxtesting.org).
>=20
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

which commit introduced the bug ? Which kernels are affected by this bug ?

--=20
balbi

--2O+9B+xSKalj/wdD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8WCoAAoJEIaOsuA1yqREGQQP/jTo8gzqGRzWsfoXMbPFziKy
TV1BqQR7kJPnHDmbsdnY9UjFHEE8XysbYU9zFfqLMlpyaWZ5KlZxutRc5Nrbo2Bw
NovMCEe1lj1IzRMLWrDtGXWlNKJvhxE8GGJTSjnWF4h+v323PaDQn5T2Ec+JiHuv
fIHLPb2iWuRt4N1MZK3HS1eeqAYa6BTWm1f8VoCpTN0F76bI4mE0Id5LnOt9q0Es
JYovSj/IwH4GiY5/iRpWsP3QiwBUjfuWT1DnnIbiywA2ksR5oWqBpB/h13Ep192k
W2TqF0kEK3pxJsObJNmOXieaNeNRa/tRCGt655+qwFC8tbf8Ka+5TF3ONz2cwOth
ivZx3X9GO1ORiANkUWL9//2Hb5jAM2OKVPgmzldx2pV4FV/Qi1ASS310MDQeGBI3
dENHlT2MHLgKXxtMOmuSbNgmc0Z6qsDWvlENKNkUS0hv2JYBKLl0KCNWrt6BUEps
0RlIxYm/T8pojKKACAtxfpiBmLBpuLucm22A7jYGh3wVz0Z3LWVDBH1OUHtrR+2W
0K0Xx/6ldzrySUNr7sMhp7NgzG4pKbM9B1SqbNNSEcHWN6uKasqlshCVDs/Le69l
OLLq/A2q8TLJFaSLgs5F8xPgiWTc7h5lRepRlqMu68/xNrJsi2mzj2UwnURO34fK
VTruK9mgOPWiMhEwLYka
=es9l
-----END PGP SIGNATURE-----

--2O+9B+xSKalj/wdD--
