Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaAMDVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 22:21:15 -0500
Received: from ozlabs.org ([203.10.76.45]:52930 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaAMDVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 22:21:13 -0500
Date: Mon, 13 Jan 2014 14:20:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree with the net-next tree
Message-Id: <20140113142059.f9f1c58c391b2c8bbd05699f@canb.auug.org.au>
In-Reply-To: <20140113141824.4301cb76e8e5540d42d74015@canb.auug.org.au>
References: <20140113141824.4301cb76e8e5540d42d74015@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Jan_2014_14_20_59_+1100_h/SpCkbPTL_TGL45"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Jan_2014_14_20_59_+1100_h/SpCkbPTL_TGL45
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 13 Jan 2014 14:18:24 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the tip tree got conflicts in
> arch/arc/include/asm/Kbuild, arch/cris/include/asm/Kbuild,
> arch/hexagon/include/asm/Kbuild, arch/microblaze/include/asm/Kbuild,
> arch/parisc/include/asm/Kbuild and arch/score/include/asm/Kbuild between
> commit e3fec2f74f7f ("lib: Add missing arch generic-y entries for
> asm-generic/hash.h") from the net-next tree and commit 93ea02bb8435
> ("arch: Clean up asm/barrier.h implementations using
> asm-generic/barrier.h") from the tip tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>=20
> BTW: thanks for not keeping the Kbuild files sorted :-(

I missed arch/mn10300/include/asm/Kbuild the first time round.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mn10300/include/asm/Kbuild
index bc42f14c9c2e,367ef399ddf7..000000000000
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@@ -1,6 -1,6 +1,7 @@@
 =20
++generic-y +=3D barrier.h
  generic-y +=3D clkdev.h
  generic-y +=3D exec.h
++generic-y +=3D hash.h
  generic-y +=3D trace_clock.h
  generic-y +=3D preempt.h
- generic-y +=3D hash.h
 -generic-y +=3D barrier.h

--Signature=_Mon__13_Jan_2014_14_20_59_+1100_h/SpCkbPTL_TGL45
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS01ufAAoJEMDTa8Ir7ZwV1cQP/2X1LVcKgmjfXyFT4F+xLFti
b9s/COuWq871BphIx02tvSByY4EN+a+Wv46Z0bJlMxeFf4RcOgDkcS40QPxkkzYW
agnW7vzx5EZniIZ5p1FHoBKCl9rx46fH9GampBw9Gftfv2SUZ5gw83f8Ru4H7Iih
PV5zRL8kIJvAIT/nya0Pw1Xxx8GCBo5Hl1NRuB8GIXuzJ1nxBRe+tMV0T1+n2vTM
AIToOkG93QzoT+9Nlzg5oNVitwIFaNfoNcgjswMQW7jNqLaL17VCFCx6XkDlvIQG
CYrOQA7rtM4/zJKS34x88BnMHX2KEAAn5THGmF3aIGGhplX9hT2Bze2hlPIyjDa9
qyuk0zPJHuBkr+pp+pX3BXiYfg/AH+9a21LXHEIMY1qD+o8Iv/+h4BUwiQ4Wx3WL
i5af066ZLOltn81GPtHDPaojgsIS4G0ML0zPYx9lNqVoouX8gXixvpcPb5rV3jKN
sh6gLH1Ot9/Fsgo6SO0mEwVA/u15nIhkbJ+VnJVkqRELBf5UkfMZ4/EH7inw5+bt
bVqd7Ndk9BWpOExoMHARD+AWYw8YuPAKMswzLe2EWYhQQifXkY61tU6u0XHXztpK
ngz/CPwkoQUckrIzYXCR79Il/TYZL1QfyjbsqCbtSID9cj2p1VH4GkoNE8vDm3ml
GE05OUw435ykwjcp2eV9
=KVJs
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Jan_2014_14_20_59_+1100_h/SpCkbPTL_TGL45--
