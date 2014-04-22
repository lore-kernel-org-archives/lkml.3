Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaDVAnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 20:43:33 -0400
Received: from pide.tip.net.au ([101.0.96.218]:46858 "EHLO pide.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbaDVAna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 20:43:30 -0400
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Apr 2014 20:43:30 EDT
Date: Tue, 22 Apr 2014 10:32:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Capella <sebastian.capella@linaro.org>
Subject: linux-next: build warning after merge of the arm tree
Message-Id: <20140422103223.f16654774d15a81410eaad22@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Apr_2014_10_32_23_+1000_Gcy54+PqtJPVwwDA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2014_10_32_23_+1000_Gcy54+PqtJPVwwDA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

After merging the arm tree, today's linux-next build (arm
multi_v7_defconfig) produced this warning:

In file included from /scratch/sfr/next/arch/arm/include/asm/page.h:163:0,
                 from /scratch/sfr/next/include/linux/mmzone.h:20,
                 from /scratch/sfr/next/include/linux/gfp.h:5,
                 from /scratch/sfr/next/include/linux/kmod.h:22,
                 from /scratch/sfr/next/include/linux/module.h:13,
                 from /scratch/sfr/next/init/version.c:10:
/scratch/sfr/next/arch/arm/include/asm/memory.h:297:0: warning: "virt_to_pf=
n" redefined [enabled by default]
/scratch/sfr/next/arch/arm/include/asm/memory.h:194:0: note: this is the lo=
cation of the previous definition

Lots of these ...

Introduced by commit e2b5c192c4a6 ("ARM: 8011/1: ARM hibernation /
suspend-to-disk").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_Apr_2014_10_32_23_+1000_Gcy54+PqtJPVwwDA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVbidAAoJEMDTa8Ir7ZwVWosP/0/IXKfFK/YquHHXX1ylvMIY
EBAkPsCz6/1Fsq6mSHIvZ+6SY9fQmQpnEyzV2f9Ndl0wVdnjvOVVOkp7//Mq/Qsh
CWhPYvZagqJKkKnosxRuykTVUlLvzGsE34cfy1SffQ14JC2wl4ppBGeXwe8vSDfm
yBtSUD/EJJsoO3TUXJvHpKrMpgB9bNsZIMz4pluy7iaxtakKcFGjqVTTcYJEobxX
xR9a2Nn7eY4QeOM+hpKFTJ/6SqZ9SHGP2FfbP8i7FGaZ3UmElUJ1rBfUHxhEa58t
jTMRVC3Yqsmw6zBVsgSmHrZK+YdJPtiaMYnpJgigdIoc3BFc65UkLKWjbG5uZROi
MuMt+SMOQX39f1/U9A5lKwPcVevbs5pJTglbPmFaD2c67XW3VtUFRssLuMvcQRaa
GqEKv0VVE4h8gmqLRQ7ZSdvU9H9m2zAmmQNLrnr1NnjNWai0CoDN9xm7CqPM1/hk
FHOLzUFGTPoWRHIqoDgsx6nkZ8TLIm3DwHWFY60SIQT9Jo1QrBywTdAGnq5YpJnA
m81pUt7cj+hX1VdnnUyUPYkJXDi/GoMBuTLJWqV7N+ris8GGytQujYJxCjULl2gt
aIT8rXmM+T89CoCIpMW14o38WKPJh11gaitvZKyx80T22+1kLweSrwzCyyJRUttY
bgPOv0UYhwu/YEWn+Cc2
=pQDx
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2014_10_32_23_+1000_Gcy54+PqtJPVwwDA--
