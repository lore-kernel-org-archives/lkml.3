Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaFTEYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:24:44 -0400
Received: from ozlabs.org ([103.22.144.67]:39470 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbaFTEYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:24:43 -0400
Date: Fri, 20 Jun 2014 14:24:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-ID: <20140620142436.385e1c10@canb.auug.org.au>
In-Reply-To: <20140616115709.3fce3a2a@canb.auug.org.au>
References: <20140616115709.3fce3a2a@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//RE+TsD4aozgjdJBsm=V3n8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//RE+TsD4aozgjdJBsm=V3n8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 16 Jun 2014 11:57:09 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the tip tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
>=20
> In file included from arch/x86/crypto/camellia_aesni_avx_glue.c:23:0:
> arch/x86/include/asm/xsave.h:73:12: warning: 'xsave_state_booting' define=
d but not used [-Wunused-function]
>  static int xsave_state_booting(struct xsave_struct *fx, u64 mask)
>             ^
>=20
> Lots of these ...
>=20
> Introduced by commit adb9d526e982 ("x86/xsaves: Add xsaves and xrstors
> support for booting time").  Forgotten "inline" :-(

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_//RE+TsD4aozgjdJBsm=V3n8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTo7eJAAoJEMDTa8Ir7ZwVncsQAJAX+I7sHsxmKAzxElMCWtsz
lwDxAbhuBPK0hv5rHbHHxCSWeA4JPKg3EYU+nxmAorJvDoKbrSG4tsJSbdclGaDQ
GoETLWXZVz94wbbE0e4dTCJIJyOFoQVp3iqZsEL/nRKCFCH9SCstQV4480b9rfgT
mSXyeuXh9CIUrvoZRrn+w1w+2hYs9Ps0cmfV2vooWeqnidLGdqzmgXyzcmJgvuMa
KZ6I5Mrn+GXHolayZBQqSMzMff+cDCnTb8FjgrzK1wdFoURsOzuhT2tVNJTKwWF6
ZCBp+NP16836XaKCgFSDaIvp3jnTPqQ7s57kKrSxWXfwSL6mhX4ihPttUfCV1g2x
pXK6C5RoMsi/XrpnWnoRrj31jFU2isd+MeYuQs+eL4dOUXYVePe0th02y/J7a6Hi
sxVvz2WKFqN1kUcQFdIDobaTiTx+GgY31b3po2NEVOlZtF0IMZjYEz/NG82HCPO7
8Smw/DWuZeV4S/ZbCeT8C8sPAL9/EpSFM1EPYrgWqEn+sap/nHQAzCvgoyu6qPIQ
DPKZQFxS+28e6DBQEolE78THQrg3qq7opcLEYCLERV7jzfBkMbDm+L8EFXCp4Jjr
SxDs/SCWKH0yHsaVf5SbCN7LJaS5pIhhSwO1lKAiIBHvVZb6PWDwO7Chk4DrPJ1M
uvloqRP4+kZtz/6xx8Ms
=m0Do
-----END PGP SIGNATURE-----

--Sig_//RE+TsD4aozgjdJBsm=V3n8--
