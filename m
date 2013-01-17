Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab3AQP7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:59:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63158 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab3AQP7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:59:08 -0500
Date: Thu, 17 Jan 2013 16:59:04 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Philip Avinash <avinashphilip@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, nsekhar@ti.com,
        gururaja.hebbar@ti.com
Subject: Re: [PATCH v2 1/2] pwm: pwm-tiehrpwm: Low power sleep support
Message-ID: <20130117155904.GA2186@avionic-0098.adnet.avionic-design.de>
References: <1358414403-13431-1-git-send-email-avinashphilip@ti.com>
 <1358414403-13431-2-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <1358414403-13431-2-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:GJD1IEdMbGsEIY8YD3L7+qF7sBLmlASLozTqunfI/CU
 NFexZhNfYMRiwqlcjqx63cvFKjUgkdHIuCmf5TZTzBYoFUkYg5
 +nJxJd42SfraevtIf1PLKoAklk/V3bjUvHNQO4ibuY0+PivdxO
 ApMf6Nr3/MvybV1doA6RvcoMsVQx5mqAxhKPyp5VnMe3oJWZ9O
 j60h5taQwivc8gAy8wTugvLcP65ysO++TQiMl6FvTb1qk2b+DP
 2Q65dYKDkpYkQUezIc1fVbYePKSddRpoxKsrtRqbq3PvtMDzmA
 UpWSSp/1poBXT98RKijHmtcOYTi0OztvAJsK55g9nqj2OrPJ8k
 JQexcrMzxHs/CJ48B3EH0OQXBeIV8X7K3U/MSYQkhwHW81pTNI
 L018rVbv6qHQtB9nZk0wSNSFBRFG+M4jN4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 02:50:02PM +0530, Philip Avinash wrote:
> In low power modes of AM33XX platforms, peripherals power is cut off.
> This patch supports low power sleep transition support for EHRPWM
> driver.
>=20
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> ---
> Changes since v1:
> 	- check the enabled status of pwm device for handling module
> 	  enable/disable on resume/suspend
>=20
>  drivers/pwm/pwm-tiehrpwm.c |   83 ++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 83 insertions(+)

Applied, thanks.

Thierry

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ+B/IAAoJEN0jrNd/PrOhGQMQALFB9VBRyCMOzXi9pkVH7rAL
0V/T1tEM4XQXx3reohTXMRsxmuV9C3a9LFKsLUbMbucguZJAz+IW67lz8wqF9ZZ+
hRIOlpQHJU08ZH9ihB6V3VpYIoQax/2R2BEZZM5o2Oud8UtCzAV98pFnrDQjYP2f
J3qgLNsN/1f+YH7JMslzCPhLX7t5AOf6TYdhXXh82+i2IBGO88cmHNx2pqp5H5PP
mYQb1o0oyivmbc4K5Vck47qxUF4PIK4eq6MLlxoZovqvwBF2tlgaVjFpCzIB/24y
xYO0Iq9cQJZz/Gws8KBkQLchqSwSookqls5ks+j0cixGFG2bzcbIDxl+NcxvS9GH
jZAX9aURVLPHmf6xyAncpXbLy/G73Mj91p4WbyeqqpZaDTAu29kcWNr+vFIE3fuo
ffYBhfzc+LNUX+gqMYjKvU+9gvMw3Gisx6O4TXi/5Hrg7NCaRHiqkDpsHeE8N6dJ
Zj/BRLb8mWzN/DgzwbB41C08UP+dRdIXcdDLLCptFk90KBags1oWbGkORpjJRzxi
mC/+j9NDE1VmHsoe7zysyHEbWmcgmtNP2SPjGrlkHMIQy1xDKX/Y8fDCNREdDj87
P7q8uyoGkiB9x38VVeMpAPzqwy/wxUdnwdD/q1/kIixrHobFZOlmtcaMiZG/oj2K
nS/0RZe05+320KpM8NFA
=ncjK
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
