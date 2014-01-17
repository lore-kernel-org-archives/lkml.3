Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaAQEEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 23:04:01 -0500
Received: from ozlabs.org ([203.10.76.45]:45626 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaAQED6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 23:03:58 -0500
Date: Fri, 17 Jan 2014 15:03:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: linux-next: build failure after merge of the kvm tree
Message-Id: <20140117150343.0720327c08c8134662e936b2@canb.auug.org.au>
In-Reply-To: <20140110140043.1e090e614df48b230202ab3d@canb.auug.org.au>
References: <20140110140043.1e090e614df48b230202ab3d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Jan_2014_15_03_43_+1100_jEFcC6Ct2g8h=9tW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jan_2014_15_03_43_+1100_jEFcC6Ct2g8h=9tW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 10 Jan 2014 14:00:43 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the kvm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function 'kvm_vcpu_on_s=
pin':
> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:1807:4: error: implicit dec=
laration of function 'kvm_vcpu_eligible_for_directed_yield' [-Werror=3Dimpl=
icit-function-declaration]
>     if (!kvm_vcpu_eligible_for_directed_yield(vcpu))
>     ^
>=20
> Caused by commit 7940876e1330 ("kvm: make local functions static").
>=20
> I have used the kvm tree from next-20140109 for today.

I am still getting this build failure.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Jan_2014_15_03_43_+1100_jEFcC6Ct2g8h=9tW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS2KujAAoJEMDTa8Ir7ZwVQq8P/iPRaYjO6tA3t6BoHf8nEbG4
scgP1hRvS8FzSNWLix6p/O7ZEZcD2+4FqlEfJIxdXybx6ogY3472NsvCNcHva8fa
0qk9cUd0Mv3vPh7itirLT08TxlD51uSCG2wN/qWEtfnYxE80SyAt9Blmz3mzlq9Q
Qnjv5thLSyxvfGYo9c3OQ7tz/oGtQyY7M+mk2USC2ls9OhlBElayrFN9mED31OyQ
8RGjYg3fr+EhSbLkN9alx8KRlnQPBkNtYuRQPqMt3mQ9ikPGfYTS+UwnnP0X9QL3
s/NvGcUoHWaATf9mdl9o6u6aPWgvGW3NaCRINngqari6wxTJDz5bVEatgIo0pYs2
fX5kTVUQeUb4ljH45/pu52vJpQ2yhlbpnNtKrJeq0EitE0dBzN288q6iQPvEZPDe
8h2BjkjHLJ5rxUBQwV61tQxeH++MP/GlBylYPXdqkgM2uTEa7/55iNNxzwgAibJV
Ktp4uVQT3SIw5h8eEzSL3nbj/7JZtmvMH3ECXcEqRQQRRWF3LjB8Bv999QPEJ9yb
vKQTYedqCZez9IkEvDfCJ4kOQrxCpElGXDU1RsLwNg/Van3cUrmBbnOvsbiZoOm9
V5VncU9iEow285GxCGbQzibdmI3CH2UWiTn0Ikn7/q3rNHP56H7v5qUWtvb2EHc4
6m+8O/8Pyl1Ic3tLd+qs
=Df5A
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jan_2014_15_03_43_+1100_jEFcC6Ct2g8h=9tW--
