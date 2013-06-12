Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab3FLKw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:52:27 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:55292 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3FLKw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:52:26 -0400
Date: Wed, 12 Jun 2013 12:52:23 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [RFC PATCH 30/50] pwm: atmel-tcb: prepare clk before calling
 enable
Message-ID: <20130612105222.GB1940@manwe>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
 <1370622402-19693-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <1370622402-19693-1-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 07, 2013 at 06:26:42PM +0200, Boris BREZILLON wrote:
> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
> avoid common clk framework warnings.
>=20
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  drivers/pwm/pwm-atmel-tcb.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.

Thierry

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRuFLmAAoJEN0jrNd/PrOhSHAQAI8t1+ITjYNuWmbCXe4OhdaG
n5kgz2AbfU+1t2vpFT3KAP/p/0FrG55JeajP5qIvysbNdui/O5akfccB/POVobsb
sLsLenIcTnd6LYF0+FcBYDvRW1Enjax2yRR/4ibsmLLPPiqKKv8e4j1Lx5gfYTez
8zAHsb+RgKQycJkgu1HLwwjiEmlkYVK4PvWqFU+y1Hb2pD9jjmANLQEISL7E/flc
EQHZ1vzPtr65F+/pc9wuUOjmGr+g3JPpC93sbWZBK+ArTzVaZHUpIxwNcxTvvC5i
bXyhUtY7/FnDgylKzV438TCJ7Lf1cdh7C5INDi0eRuZdR5ZPYRJQsdHbNAfh3BZ0
NR6eXA59ppCFl7Ya1h5st5Cm5etG1NXgnpmdWYItSLuL/FW+Dty9mQ2DwCIJ2rCN
teEwfX841L70TjW27XhxI5+YuKKc7WhWonq/BlRzGZgniOuvvGxFPoc+Zqen9Rpy
SQRqQnf7AM2UpRMxUP+Y/Ywuo/gdIId4lSLRcv0MrWpFyEBAfw3c4GfLUTe5gLDu
2SyigJWuhHra6sDDH5guraAPyHKrbvfViu1oPIxxTfS8nJhEGaaimnDP4QwlLd+e
uNeK7zeyVWHWKadJ/JAgNeHu4H9HcL1/15tcIbLgRQkgjYcuwnp/dkkdM2j4Pdk5
BCbKDq2aiN543SObFkDM
=kTp/
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
