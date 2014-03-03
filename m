Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaCCGHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 01:07:15 -0500
Received: from ozlabs.org ([203.10.76.45]:59906 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbaCCGHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 01:07:14 -0500
Date: Mon, 3 Mar 2014 17:07:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the tip tree with the pci tree
Message-Id: <20140303170707.8cf779051fd070ec0dda5bcf@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_17_07_07_+1100_UuIKSkJkIfWmzaXf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_17_07_07_+1100_UuIKSkJkIfWmzaXf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got conflicts in
arch/x86/pci/numaq_32.c and arch/x86/pci/visws.c between commit
8d7d818676d3 ("x86/PCI: Use pcibios_scan_root() instead of
pci_scan_bus_with_sysdata()") from the pci tree and commits c5f9ee3d665a
("x86, platforms: Remove SGI Visual Workstation") and b5660ba76b41 ("x86,
platforms: Remove NUMAQ") from the tip tree.

I just removed the files and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__3_Mar_2014_17_07_07_+1100_UuIKSkJkIfWmzaXf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFBwPAAoJEMDTa8Ir7ZwV0TwP/R70LDvgR9VqphoOZ+43+VYu
6w6vtu8UFdibU731tG2ta6pBigMx571j0bhRuxEYvM/IB8pYRZJeaxpAPzvUpSK8
1OIfwgT8aOPsv+DzG/ov98BhKKneGyv1+zH2OJBlVHqTqA8B8jC0lGr4Yjp2PmWN
mp3pPVi9D9lqjwrGsTv1W3JxvEdIUdaJ4wBl/Y/21315598GdUna3czeUL6yilPt
c+extRVvscpcrZP5yD3kj3tWm3Wac0traRFmV4irrF6ZyUjAYn1cgWGMQ3MM3UAU
57+HE1ikjOq0AuA/Fd3d71RhN/ytuieS7gK7z6unX81rmCC/plG+tdc2ohwr+rBJ
AF1u3Az7uNoOss1a5GtEeJkIx+TW/aon7xx2mf1cmW5oEbMF38gyyLx/FZO4+Xwr
tU437+tzdjFyLk/+sTsDkAc6zt9/YtApzfDVpdatxRoTAE8mU51bPFVm8O7wdymo
w+8Dv+WY8JPStEHR7vUECtEH6CVaPpjShUaLIuL/l1zO960fvT3LN9/6QJGpGmry
oZ1DTMejnS5mpcvXxBW8F3mal7AhVhdRbgpp+QRbmuyjv2gk2xl9WLrvcEIIhAEx
RDlsDQd8Yn8dUxw+8jry76+wopM48iIBJcXlrpOMalq7goAbYgOFqN5dW0BDuH/6
zzTggyiB95t3j6FzM2Iy
=lbTx
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_17_07_07_+1100_UuIKSkJkIfWmzaXf--
