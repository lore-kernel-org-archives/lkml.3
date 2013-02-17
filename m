Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3BQXny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:43:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51157 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab3BQXnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 18:43:52 -0500
Date: Mon, 18 Feb 2013 10:43:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>, John Crispin <blogic@openwrt.org>
Subject: linux-next: build failure after merge of the mips tree
Message-Id: <20130218104340.eb5e20da05dffe89ac4da693@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Feb_2013_10_43_40_+1100_F5xhtAWh7SMSnpfZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Feb_2013_10_43_40_+1100_F5xhtAWh7SMSnpfZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

After merging the mips tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/ssb/driver_gpio.c: In function 'ssb_gpio_chipco_to_irq':
drivers/ssb/driver_gpio.c:82:3: error: implicit declaration of function 'ss=
b_mips_irq' [-Werror=3Dimplicit-function-declaration]

Caused by commit d630dd4ef20f ("ssb: add gpio_to_irq again").

I have used the mips tree from next-20130215 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__18_Feb_2013_10_43_40_+1100_F5xhtAWh7SMSnpfZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRIWssAAoJEECxmPOUX5FERqAP/i4Fao5EqncczW3yO81oDB/l
srwOXcOoAQHHHz/iwu2K45Y79NnlBDDhipIW61jnYZmQNMtFb4aJJZcGhb2QFAEB
n1frsYuDvjq1RF5ZOTmbWbaUxAGGRqdDiABm4cw9Dc4HclxMvzcRZspeNVkyB55R
MXUQdiy8e0BYR31xRTK518wbsPx06IVVcsR/lyXffrcxG8H4OBYDJh+TpxVhvQdO
uS5nSlZ0PnJ7BKiWhwsA8n/oPKoWsZtpV9uQU+W1Hf373vnrP5lHLUn30urz4FDz
G8NHBJVCBGIZu0GneU2SGyWwJo/s1dgSvqexVct3aCJdZg2zcXdZXc4mfMltXcnY
TTcqlUMeL11oYR+Vxtv6ZJ+5bd63qqo8EQ0f5+F0xIsEjt0OA/6Ctu7LVu4KvbjK
lZht8JfJpvQNNvjVcMoT5Z5NKGfiRjq2AX9A15YwwnfawtEh5o8Olv2lr/fBhPpa
p317gDIJuMgddthTodb3JvcrnsAGERut0+epPvAExrNxCvbcy3RBCfWrAQTiDe/O
Gx2s6j0lH0RxD+HiIAMQlMg0vO2Rk9uPDMUDTSVDnSvZAzERPXs5oKrWKt5QNukL
0pE8b2LDFfbqh9FVWdAmty79Qatjm9zXZeQqk9k6ztdYk2u+IhHSe2BSDnwy24jB
ily+yn7QZj6YasYJe/HU
=rqMP
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Feb_2013_10_43_40_+1100_F5xhtAWh7SMSnpfZ--
