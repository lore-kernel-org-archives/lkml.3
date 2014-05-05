Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaEEFlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 01:41:12 -0400
Received: from ozlabs.org ([103.22.144.67]:46587 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbaEEFlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 01:41:09 -0400
Date: Mon, 5 May 2014 15:41:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robh@kernel.org>
Subject: linux-next: manual merge of the tty tree with Linus' tree
Message-Id: <20140505154103.941b62e29706efa62b826354@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_May_2014_15_41_03_+1000_80h7XuoxpnDxrQ6y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_May_2014_15_41_03_+1000_80h7XuoxpnDxrQ6y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
arch/arm64/kernel/early_printk.c between commit f774b7d10e21 ("arm64:
fixmap: fix missing sub-page offset for earlyprintk") from the  tree and
commit 8ef0ed95ee04 ("arm64: remove arch specific earlyprintk") from the
tty tree.

I fixed it up (I removed the file) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__5_May_2014_15_41_03_+1000_80h7XuoxpnDxrQ6y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTZyRzAAoJEMDTa8Ir7ZwV36IQAIybcKs6I4juMAfJMS+ym9Hh
BT1gERUUiR9Yp0m+/NmjAnR0za1urqvaY3++SovcdrKUFMMQmnzsxeeHWxvo/ctk
Tmn4mDTKWj4DbytYvlEWkRHk7mtFe2AR9E4s/kcD+QgWyvlNhl9iByGgMUn3gxef
0a6RmeH8fe51/BosyKH7nrvAK1JLktOHQE3cty6ucGvUQzea8DgHBwdppuwqvlMA
SoXLVUuu+j6mouDwTcjCkwOscHHS+Xgpol8aV13Hu377iWntEmvBzMJ2xnuoU0SI
bgSZFml+87Dw07A7VRybVmVnKX5VMgQPUcoBSGElL2tQmT5WptYTT48lmV5Pf67P
xTr45NqQv7B+cf/dTHCERlqUp5PC0bALD7leu5ry8MOKVOJjuFbc8ZQqL5LtdUsO
68b89wSBVRzcTpqFzq2zvSDvdGEuLJdBTZ3qFFUsp+7RN/jMTjaIvYKb1QsyB3iC
nhJflmoMOiB82pmbV6J4MIB3Xu8dLNr3DxgWlG8uguYJ6tj4Z88PDFiuH9vsxdrc
vFIrJXpn1bFLrSwrF0o3aT3z3VPKWhDhmommlHfXgHdQQk9/rX9lO46Y8ZaQcLzk
hgAaDikqrPbnrywaG+50d22yywotCJw2uOPvQAqIxBCemS+lMMb9FJLljq1d458q
5TZwp+nxKbPAbO2rGePB
=zG5S
-----END PGP SIGNATURE-----

--Signature=_Mon__5_May_2014_15_41_03_+1000_80h7XuoxpnDxrQ6y--
