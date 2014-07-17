Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaGQByS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:54:18 -0400
Received: from ozlabs.org ([103.22.144.67]:50241 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbaGQByP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:54:15 -0400
Date: Thu, 17 Jul 2014 11:54:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-ID: <20140717115409.03b7fb40@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/HPMNHKueOWJ+JeJghvp_QrN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HPMNHKueOWJ+JeJghvp_QrN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/Kconfig between commit 2fd48f94426d ("ARM: mach-s5p: get rid
of all <mach/gpio.h> headers") from the arm-soc tree and commit
72dc5e8f84b0 ("ARM: S5PV210: Enable multi-platform build support") from
the samsung tree.

I fixed it up (the latter is a superset of the former) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/HPMNHKueOWJ+JeJghvp_QrN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxyzFAAoJEMDTa8Ir7ZwV5UIP/RLfWMMh6TYTxee1t4jknKkf
9d5uEjBsnQUnRn6FpJu0dTidFXxjPKzp+spSJ7oKpaQuQg0aeFl8CGyG+vl92PIc
4XbGd2ibM7Mc++uo/GaHwZ5btk9TMOGST++vv0dVV0SxIHS8AvFvNCm+r86i0QVI
+HW8985OrI5bBKFhdCOjTnOgiYFL2OQitsnBH6+GuxJH3C+Ow5IcmTbniQHN0xLl
ovIi28I/81bFAslgt6AWnoJFWZS0wweHvYE3zqAu4AFdkI2LELjPgqe1BqHBkuTp
LWpfI4BlXTGe+2NqIzfJ+KviK+u3mVPHRuwrQ/SqWJNuMg93dIWzqV3JEvrRiiYD
eqkMJMJu+w7NlrTJItV6Bz/KfB549kZfbMeLFsIxTAOVknfY1Y9NW/P7OyhIQtDF
6pGUgWOwElVhnJf3p9XQrGufBFkh/3gCQ6FKkWbO690WM3SbG2eJQi8CfgT0nRkL
X6mx+/KUhnyJY9dACiwEk32CG8VumIhquz6st0FG2ByXTEvALRzb/EAjjTSzUmtk
iJsquvlHWREmmLjRjO5TdKs3TKRBIexwT5fDykSG9jvuiCH2ySKm6PQo9XbCSLhT
5d8mwjQMRy8y7o+kclbEI+xae/zjdHdQPH7K3qsi4rayZDptyYta+p8+OtWQCxm9
RDWqwZixgpvKq6GRfryL
=+OtF
-----END PGP SIGNATURE-----

--Sig_/HPMNHKueOWJ+JeJghvp_QrN--
