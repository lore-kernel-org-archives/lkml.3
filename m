Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135AbaKQHuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 02:50:05 -0500
Received: from ozlabs.org ([103.22.144.67]:52440 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaKQHuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 02:50:03 -0500
Date: Mon, 17 Nov 2014 18:49:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Schmidt <yath@yath.de>
Subject: linux-next: build warning after merge of the ia64 tree
Message-ID: <20141117184959.15d4dbb8@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/KTXkqVVl/Gy+T+ao4NBfh1f"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/KTXkqVVl/Gy+T+ao4NBfh1f
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the ia64 tree, today's linux-next build (powerpc64
allnoconfig) produced this warning:

In file included from kernel/printk/printk.c:41:0:
include/linux/syslog.h:55:12: warning: 'check_syslog_permissions' defined b=
ut not used [-Wunused-function]
 static int check_syslog_permissions(int type, bool from_file)
            ^

Introduced by commit c36487706565 ("syslog: Provide stub
check_syslog_permissions").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/KTXkqVVl/Gy+T+ao4NBfh1f
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUaainAAoJEMDTa8Ir7ZwVT68P/2JRk+7uz4y8uI2ERXYjELYH
zqTM1bif4et+Iby5awtWksdBG/0AZZaCcdesdOYBmH4wbOjcza4Ux+eC1rsZWTvE
EO/yvEtxaqQy8tr1k56+nC419AOocQJs9KgCBG8Ri663kpGYiyQfdMRHAWzO2Hrz
rZ/n7eWBMLPcXSSq/4eFj46VHPwPhfxnX7fWJrwrz9ZxQ+q9XZnbpypDo/IfqkmY
/zq0RJ1AKR3n8wcjmlZugDMcI3bxk/pn70VE6qI/BQRTol2jjuI4AgEoJCajITaF
jxf9rvW3dI5J0syhHHnTm2Ue9yQ/Ld7e+rv29jVIfeyDv7CcHCBpj+hHX4nCyXLV
CD0FzMmYvbv/LsVhB6eQKWCkpwKiZQplw929lOuButHtrNSg2gczGEfOONKgdwHW
NwNXs2ZA2Y6axViua3/S/7vOggaW87fCwoJDrZxSR889W03Wz5AdK+71eU3BKSbR
eiBE8SVlevfn3T8YU2PBbDhjBkPcE5ocj3VoOmBqOZapgfCEVcAzTpsdjTaGVnHx
jZD/EGHKfyYeGR2br2SctDQboinjinjSnS5HI+VpBk+z3UCJtfjlsELVj/ds5caC
UO3uKkiAFMhXmU5F/lowojD1/3uEj6jSJ90hyuIo2xVs5TkxtqbLVeGGzwIJZCs5
X5XnLysVyFJSdOi+J14f
=yZ+k
-----END PGP SIGNATURE-----

--Sig_/KTXkqVVl/Gy+T+ao4NBfh1f--
