Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935472Ab3FTBGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 21:06:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57612 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934734Ab3FTBGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 21:06:23 -0400
Date: Thu, 20 Jun 2013 11:06:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 driver-core.current tree
Message-Id: <20130620110610.7d245d88b70620fa271a29f7@canb.auug.org.au>
In-Reply-To: <CACVXFVNsbBunNzYecUG34sFjPqRuzMHRTBD2Siy9d4RhqPnr3A@mail.gmail.com>
References: <20130619153225.9ff68f0984bfa54333c4df10@canb.auug.org.au>
	<CACVXFVMhVs7Wy1A=TfczYzHLFwyRPhEGW9Yo9hTERekaxSnpdQ@mail.gmail.com>
	<20130619143918.GC8413@kroah.com>
	<CACVXFVObBDwaounzZ7RyF=+QrQCBoEd0s-uLYFokksOzKgZSjA@mail.gmail.com>
	<20130619163628.GA28672@kroah.com>
	<CACVXFVNsbBunNzYecUG34sFjPqRuzMHRTBD2Siy9d4RhqPnr3A@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Jun_2013_11_06_10_+1000_K78g1cXe1IosawX0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Jun_2013_11_06_10_+1000_K78g1cXe1IosawX0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ming,

On Thu, 20 Jun 2013 08:23:30 +0800 Ming Lei <ming.lei@canonical.com> wrote:
>
> Yes, I already merged the two branches together in my local repository,
> and there is one merge commit, but I don't know how to generate/format
> patch for this merge commit only:
>=20
> commit e4b00d75ee3ed3af9fac83970d21e27d1ad4aa8d
> Merge: bb07b00 8759793
> Author: Ming Lei <tom.leiming@gmail.com>
> Date:   Wed Jun 19 23:56:05 2013 +0800
>=20
>     firmware loader: fix conflict driver-core-linus and driver-core-next
>=20
>     Conflicts:
>         drivers/base/firmware_class.c
>=20
> Anyone who knows, please let me know, thanks.

Try "git diff-tree --cc e4b00d75ee3ed3af9fac83970d21e27d1ad4aa8d"

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__20_Jun_2013_11_06_10_+1000_K78g1cXe1IosawX0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwlWGAAoJEECxmPOUX5FExRcP/ipZr1sef+CGOiF7/q1a9yHQ
1wUkm65G7uru/KxYYH0+DY9kXp1ocEPTR4chxI78ZhoznNwwGd/InQw422WjbUQP
GaKMPH5fWdarOraxmq+gOO0O3mPMVMefF3lNzKshXDN7CR1qgvXxy86QwXLqZM0E
jY4Z9a8Bjq2X9OLixMNstzR6fRUMzUIe12Lcky9awjRp28ITSxFxZIB6lfJt/kz5
UUKMVolKr0FFYgxzJ2+Xw3sDspuA8EGtL2PI9SPyI1u2bePxfb2AIsTGlIyFHwYY
bCyZVGNC2A3Ot1jDIH+zte9J/iqITefIWBGePW3bhec1es2Eg2IqPjrVEDp2glgs
rLqroiZ3rbaQHDhekTaF+O0yntt3R1uE40ERRY4atTq5PCYqVPi5Zjws+A0ej5Lg
CmkD5qlgwzBggd2GsXUJZqWghqri4acILPF5jI2xyGnLf26TIlF9VkpoKVa+nPda
F4+NcrIaBKsX7xXyUZChJ5+V/ZpUSXV3XMD4jvQbeaaukPwYJ1LmsDu4G3r70Rsn
9j7Gp7IdFaDGSpLKiOfzSmt/uXnU8ICItxTxuZhcpPbavVl+NoganaiTWzvOtoy1
MNphVlLT0P6sSKLTM8+sUJ7L4t9G5g2nFtZE7GIJsfH9dddKvo8EuHsImfv4JcFp
nLnAfbqgrQE3c+EDYqIW
=ctmJ
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Jun_2013_11_06_10_+1000_K78g1cXe1IosawX0--
