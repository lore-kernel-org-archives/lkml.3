Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab3CDBpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 20:45:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51469 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3CDBpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 20:45:24 -0500
Date: Mon, 4 Mar 2013 12:45:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: build failure after merge of the gpio tree
Message-Id: <20130304124513.cf97f6249b0759a1ea1cb34d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Mar_2013_12_45_13_+1100_MYpeKRkhG8fykMTc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Mar_2013_12_45_13_+1100_MYpeKRkhG8fykMTc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

After merging the gpio tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/gpio/gpio-stmpe.c: In function 'stmpe_gpio_irq_init':
drivers/gpio/gpio-stmpe.c:313:23: error: 'struct gpio_chip' has no member n=
amed 'of_node'
drivers/gpio/gpio-stmpe.c:316:61: error: 'struct gpio_chip' has no member n=
amed 'of_node'
drivers/gpio/gpio-stmpe.c: In function 'stmpe_gpio_probe':
drivers/gpio/gpio-stmpe.c:351:18: error: 'struct gpio_chip' has no member n=
amed 'of_node'

Caused by commit f7719903b7c7 ("").

I have used the gpio tree from next-20130301 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Mar_2013_12_45_13_+1100_MYpeKRkhG8fykMTc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRM/ypAAoJEECxmPOUX5FECI4P/j9QaDuVP2EkOfJD/MOVHsNL
eZA9S5DwU6D93vO61U+IiMcqctkXZog7UHSwMxUKLmoou5mC0rfXz5wAD8ObKf/K
nV5KnoQSCZFf9ErjxP5kFGWUs4pvBE24CduEV9AEAc+EJ+fRzQsnSJZMcnEGUdBG
clld1eMfFwib9i0cMA21HKiGpFD4ZCynWNUMNe8xmh+VjjAkZSe60ntDYKjxz32S
SgxFPU6oSkwJ3rziT4DpaSpA8f3ewTdiXGVcF3B2punVRN96z5+OA+FlarXLVfe1
qnZVwvc91LGz3JfQCyFlXQK9sX9ndVXXZbkiOaGzvdEyZkECmSbyPORHZLtVWb7V
3zcrGT8VOOKryB3Ae6VkMtZtjUynRfhVDwDsM6P4iRChJU/uy2Jql7tkb7x2WH7o
JtmALtaRwJ/usHcwwgk7GlBjwURqQWQcv/Adkilju6RgP+S8EPT+ADezso2yLnJE
fLoq9s17tMKBTtbxXlRKa6shiMNUmWL6z//PuENrS9qoaiMBXtE6O+JWR79vWeo8
XjtYplLOp9hgge+tByDV4cKeMNiX4UzW25NnXL+m2FhBapQ9dzbhFG4DFnd0lrQ2
6gGoCGQ0JgTIsXk5Yeht0bYCaMO4NCRGqDWeWCM1dK8+FVcUk3l2Z6aZoGLfniCZ
FqFiAq7ptjW7SRnEpzFi
=lMgE
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Mar_2013_12_45_13_+1100_MYpeKRkhG8fykMTc--
