Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567Ab3DBJiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:38:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58368 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760928Ab3DBJis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:38:48 -0400
Date: Tue, 2 Apr 2013 11:38:43 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: pxa: Remove PWM_ID_BASE macro
Message-ID: <20130402093839.GA856@avionic-0098.mockup.avionic-design.de>
References: <1364802082.6252.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <1364802082.6252.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:TxsoCMYCOvR1eyE14Nk4buHUrEiJLEK66uxzRWfcwSB
 HBgNHORFAJjnvxUb+vVIkLaNNeRImHo8Bh0DFGVliPdEB73e2e
 E0i7sASdHYzJiHFwMk0ouoFlmpmjc3P42GmUCkEnhKMe+t6c4l
 TB/Bcx4VmhacDI64uu+3HpwPv+5mUN6qc7y10/+puI2aLaR6IR
 pVna89gI6I1hNdnSW59tidgU4iJ+aY93DA5nnEmbqIACzTvUdQ
 QGzn0Jv+Me/CBgxjulGZ8MG8OXeI3N4sDBjE1DUr1wqKO5J3Z4
 wt1sQYkQm2YE6PtPediBSkmaokVYMLKiHQlF0oG2/KS2HRMdzF
 AZ5hYpgfXF9+JITDdz2AH8eGngZynQFzk8WrVV7qLLMp/FQF0t
 gJld1VXpOpl3VYdkEuC2vmPRNiaEmhYNso=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 01, 2013 at 03:41:22PM +0800, Axel Lin wrote:
> PWM_ID_BASE() is not used after convert to PWM framework, remove it.
> Also update driver_data field of struct platform_device_id accordingly.
>=20
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> This is v2 of [PATCH] pwm: pxa: Use driver_data field to store pwm_nr.
> I change the subject line to meet the change in v2.

Applied, thanks.

Thierry

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRWqcfAAoJEN0jrNd/PrOhKgYQALAydxDit1ICyLvIH0ywA5F4
2PKaA6YDFHNVa9UzLMdpMsXHJOYjN9i7C0O+t5ucgluvtnzv65g3g4HCq+fzDzZg
cAVDohRDZcrzl+frI4PL86AJW+AtJuB6afcesp/DI/p7YJy+wfGjRapYdRpSuZQs
kWXVACcoPc4gQvFGhxE0uAsPJQ61Wus7+lA+7TsV2ji2e3UU/IT8i0hewMRoOIqJ
Y2Gpn5WL2/jifPFkGhsGpchPkxyIVZJlRsmu083MAt4K4t7EJoKG1b5qn2+z1M41
Fu0+qKpJjjGS5IMJ5WOJ6EKEOjMW+H9DnbrC8DFzu5W2x+GGfxxu+8YIZ/82Raek
bZ6rm+cgZ/h9m0MUHBN+ffywkmxjnzAeD2Npt3uY1sDtQ/MJ7LnrC9Forg0owpJL
hbbmFIH3miWxJy+5GnApQucDDWmJQbU9sCRCs1w+ToquRnOW4PbLZeTk+jpeVmR7
0Xq4Sae5iI+hQW+7yVfKnsNccsxgmuIIE0EuuNhXH0LedY1SU+kI9zQJgiSE1kGl
0H6Z4FhSzaGJSTiAyAuhll/Mlo8miRsiWQjZOTh/RLXl2xnjqTu8TbTV+TL5193O
6SyB6GxZ42bWsP6sz+6Bz7Q/LEUvQUzwVZ26AI5TU7ecK83HKQD1M8QlPrDbMZCm
Hxdcjq6C9gbyPWLs82s7
=/ufa
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
