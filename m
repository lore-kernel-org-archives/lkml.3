Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaIHHHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 03:07:09 -0400
Received: from ozlabs.org ([103.22.144.67]:44765 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbaIHHHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 03:07:07 -0400
Date: Mon, 8 Sep 2014 17:06:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Yegor Yefremov <yegorslists@googlemail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philippe Reynes <tremyfr@gmail.com>
Subject: linux-next: manual merge of the usb-gadget tree with Linus' tree
Message-ID: <20140908170659.1ec79726@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8_ECue.VeiFsHT.TH9Ht3ja"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8_ECue.VeiFsHT.TH9Ht3ja
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got conflicts in
drivers/usb/gadget/Makefile, drivers/usb/gadget/legacy/Makefile and
drivers/usb/gadget/function/Makefile between commit 5d19703822da ("usb:
gadget: remove $(PWD) in ccflags-y") from Linus' tree and commit
fa31409a82ee ("usb: gadget: use $(srctree) instead of $(PWD) for
includes") from the usb-gadget tree.

I fixed it up (I used the version from the usb-gadget tree) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/8_ECue.VeiFsHT.TH9Ht3ja
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDVWXAAoJEMDTa8Ir7ZwVhlwP/1ydk5G1YHyOh/Aa1twGYBSE
Q6ahr5sdngs1BLiBQZ8vZXOA7E7CsPDfmp6/pAW7FvXCQ6gjBX+5M/zaBFHYc24M
TzLlwJO/oHUaVtvSjUlmnMjgCCHu2t7S6BmTjV0X1bCgaeyfkDhPc6+F+bvDOm7n
Y62QfsJxKd6dGsnvkWxYuz4hc2b85JjqMaOaFnRS4E+6txoH9ETXs2hlRRRbOifp
xUOZswRkKnbCmnGr8FaDPCkNMv6cJcQVGDwUA2u1E91EfM/PCRq6a6OfLpKeGEPW
Z9kcUnuE5SUCknWWIiFnX5CeDbRsmJzGypM+ZMncuLSLOZH8siEbq/+a0WrW53Kz
sIiCEEfHnX/8Yac7OHgN58s7pcEvyonZYZRR+GLU392I3nL1VPu13Pqh+P/tlDeR
HSLXHmfaPHVTekPrRIX6bCVU7jDE3MNv5WMQXCL49Kp7O9tr3hHWf2s4PK2ORvUn
Bk5APRwX8Nhh2SNoJBCUD/rlrkT73LPGgbCRFEcyWWwIbSzLFbYu8uxCniGreZJK
hQTx8dGks0EdUp/a5+qQ/XL783/doT9L4twqVxlbt6E0P1pKVlDby16ukkkKdGko
tnoWaMFIeXyNqBfirvp5fJQH9+TjmAJM/nVqQYG/DsbGKFiqhJ4tGnTJ1LIO71lF
8+NuftWRLyH5FH4p7RnD
=agzU
-----END PGP SIGNATURE-----

--Sig_/8_ECue.VeiFsHT.TH9Ht3ja--
