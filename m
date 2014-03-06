Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaCFGM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:12:29 -0500
Received: from ozlabs.org ([203.10.76.45]:32807 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaCFGM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:12:27 -0500
Date: Thu, 6 Mar 2014 17:12:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20140306171220.9262f702efb6fba592b60b11@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Mar_2014_17_12_20_+1100_cPoxtuayb5QSEWdy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Mar_2014_17_12_20_+1100_cPoxtuayb5QSEWdy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (i386 defconfig)
produced this warning:

arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function 'snb_uncore_imc_=
init_box':
arch/x86/kernel/cpu/perf_event_intel_uncore.c:1725:15: warning: unused vari=
able 'addr_hi' [-Wunused-variable]

Introduced by commit b9e1ab6d4c05 ("perf/x86/uncore: add SNB/IVB/HSW
client uncore memory controller support") from the tip tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Mar_2014_17_12_20_+1100_cPoxtuayb5QSEWdy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTGBHIAAoJEMDTa8Ir7ZwVYPYP/0j8L5Rr24hZi+weDT/tqj+O
SJveqaFE5KH3R/FDIM/TNf+g051ThT45klRNwx4gTPvHF1yeyM+ZEBGtIPp78DjD
5FWn2/OfQ9iB3sztbv9XXap5Hir0ICfdnOat2RDsfwYBtI6DXImBX6cEp0AX9zhY
aaKWMyfyHqbQKtvymiOW9YJJBPF/a2Se0bOGr6e/u8CrDcuVtevRq00dC8pKsp2/
Y5QmutJJg0XGnnwAaVXmf465M04TBYYVzDxEif+GrIoM9nvewewPCQABjRgm7PU2
TfzyLQ8efef97WxtSgWTN3PdaoX5C+biTau28zs/3W4IXm3xInWYe3xDkf1ZiAd0
AXr6veMLJBLYC7/yZu3WPN+hH5Lh4cX9yeEbdSin8VnvdMt8yzGqbzTrBhAil+i1
I0QaV4ixOQYYwSLsmbGYLNPtPzdgQYdfn2gba/lo6c/qEe5BmB7hQP9UK8fS4koB
WlEtjlEMquoNONpEsRrHCrs16xAWI1zULuCi+Mhn5KDv0ZVT69ST43Wp8SHZ2cb+
vmVrItWsjJV5dQ28WYzR5yn3i0i/MPhG0C6LrR8L44Nhyhl88Ojc/uUiLo/ylh3w
Qf6U5rTcnNwP02c5fldy4aA/yoSOLiGxj3HUujYaBz4ueDGzZQrMtyxCK4TbJMzR
oi0hFiW966dEMx94tel6
=V4pi
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Mar_2014_17_12_20_+1100_cPoxtuayb5QSEWdy--
