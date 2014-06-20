Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaFTEfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:35:25 -0400
Received: from ozlabs.org ([103.22.144.67]:54673 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbaFTEfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:35:23 -0400
Date: Fri, 20 Jun 2014 14:35:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-ID: <20140620143516.4f5eedf1@canb.auug.org.au>
In-Reply-To: <53A3B8F9.1080005@zytor.com>
References: <20140616115709.3fce3a2a@canb.auug.org.au>
	<20140620142436.385e1c10@canb.auug.org.au>
	<53A3B8F9.1080005@zytor.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/4X4JDfxaTARHuDpTAI4LvIj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4X4JDfxaTARHuDpTAI4LvIj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Thu, 19 Jun 2014 21:30:49 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 06/19/2014 09:24 PM, Stephen Rothwell wrote:
> >=20
> > On Mon, 16 Jun 2014 11:57:09 +1000 Stephen Rothwell=20
> > <sfr@canb.auug.org.au> wrote:
> >>=20
> >> After merging the tip tree, today's linux-next build (x86_64=20
> >> allmodconfig) produced this warning:
> >>=20
> >> In file included from=20
> >> arch/x86/crypto/camellia_aesni_avx_glue.c:23:0:=20
> >> arch/x86/include/asm/xsave.h:73:12: warning:=20
> >> 'xsave_state_booting' defined but not used [-Wunused-function]=20
> >> static int xsave_state_booting(struct xsave_struct *fx, u64 mask)
> >> ^
> >>=20
> >> Lots of these ...
> >>=20
> >> Introduced by commit adb9d526e982 ("x86/xsaves: Add xsaves and=20
> >> xrstors support for booting time").  Forgotten "inline" :-(
> >=20
> > Ping?
>=20
> I already applied an equivalent patch from Borislav.

Thanks.  I look forward to it filtering out :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/4X4JDfxaTARHuDpTAI4LvIj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBCAAGBQJTo7oJAAoJEMDTa8Ir7ZwVXpsP+KbAxHNMEFxxVLkoSwPcjRIZ
+Max4pNfG50XXTpesnEgh9ba6R/vou/3UxEh2QKYLsHQ1R5Xj+YRlf1nbFr1DJp4
ArshNHhV9al06ABKzEc9rxFul8buU0ckOesdJpAl/t1EsXbVJA4etiAkpap6DRBi
lcPJlmFbUNUmlcDgAlRp7Gr3GLbk2yX9JNIPJgI4wNLlpYCgUsTnwaHaDBHpivkh
tcvcwJjjdLDRirSiHyWbuqS7MG+5E/d4AY+VdJivhtv6AI3dLL2wYe8eQEHTViGB
HcTi6oMBbB0Gbzg2/vLRu7V8ntL5no1U1zpz083NhGg4YVBblylQXKGc/6K9hGCg
RzuHbL5YhVm9xzERKV6q14lTSlRKsUE1g3Lb38QzhJ+ehwMgB8PnYJu0a8W0cM9e
9HA6GJ8sfVmlYs9acF3iRVAGqB4P3jA+WQQmdjVzqG1eFRKscKWJkffjns6GN4FR
leGvgjw3l16ix25xCyY4iHW6Xp/yK2dKGylibwgeHTPwt13iy2G+W8tCWdsfh9o6
R4+bzhsQ6qVCQy3kSlmQ1dJjhmtQRvxuJ4BJP/QqKDQa6RSHHz1vuO6rmIW0LXOO
su5l0TJIgoELsDEuLEOFLkdGDfWaK/6ZAPIkhjj561TPsDhvvMhVg42297LNXeZ+
3snFEvMNJjYigdKbhTY=
=q/Zt
-----END PGP SIGNATURE-----

--Sig_/4X4JDfxaTARHuDpTAI4LvIj--
