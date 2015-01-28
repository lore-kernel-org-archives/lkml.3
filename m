Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbbA1FCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:02:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761478AbbA1FCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 00:02:41 -0500
Date: Wed, 28 Jan 2015 16:02:31 +1100
From: NeilBrown <neilb@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, hpa@zytor.com,
        james.t.kukunas@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/raid6: correctly check for assembler capabilities
Message-ID: <20150128160231.58be1f9b@notabene.brown>
In-Reply-To: <alpine.DEB.2.11.1501231716090.5526@nanos>
References: <54C2148E02000078000588FB@mail.emea.novell.com>
	<alpine.DEB.2.11.1501231716090.5526@nanos>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/k_Ja2rlFitG//3Y5qmlZZQc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/k_Ja2rlFitG//3Y5qmlZZQc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Jan 2015 17:16:59 +0100 (CET) Thomas Gleixner <tglx@linutronix.d=
e>
wrote:

> On Fri, 23 Jan 2015, Jan Beulich wrote:
>=20
> > Just like for AVX2 (which simply needs an #if -> #ifdef conversion),
> > SSSE3 assembler support should be checked for before using it.
> >=20
> > Signed-off-by: Jan Beulich <jbeulich@suse.com>
> > Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>
> > Cc: Neil Brown <neilb@suse.de>
> > ---
> >  arch/x86/Makefile       |    1 +
>=20
> For the x86 part:
>=20
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
>=20
> This should go through the raid tree.

Thanks.  Applied to the raid tree.

NeilBrown


--Sig_/k_Ja2rlFitG//3Y5qmlZZQc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVMhtZznsnt1WYoG5AQLwohAAvnzdzyd60sWrFcn9Bxdop5xKvibfmCVw
XQgTHyIVMnH1L3/r8/dtT17UrTZraB6drC/+SGfjs2pHm2NkyXConEplxBHB0UBx
JG+P/Qsn6Fa2T99ib3xJVr1Sx4zL9EtCt1re6mv7EBr6NYcxeWZ3f6DRcKJnnxtQ
+Zcl+bv/b1Mt56AjH7D+Bz0N1+zh7skrypHUzcmqJmoYeh7KyN/kV3QkxxqHYfTL
RZYcEDPLMhxuX5agbMManMfvAM3L2/iQ01jfNgjAbcT2wOybQoO9GmNVtpYQ1HgV
zqN8ABr7aVkET5UcikH6MIJpjHq9UsS3yfEWo1lcKg6XuSrMCning6Hg1LkSIxeQ
8Ex9JyM93kyh3PZeDPUgQMInHs0lCFAsgYkY5asYss9YOIvvIZIyYeh2loTSjMTi
rhShz6JY936I8BES6DnRAgBxdX1xK8rhu8Pl6kTTFFrX9AsmLH3kF/wd7asQtDqA
xndBXPmv3x2PNuBbHUmfFzjwgjc9LDQV37GzJl7nkxm5+i4e6A2ktxFTQvi1IWsy
ozXspOsKTY7oLbqZyO8lqpzYiq5UQLW+x4cmcFa/JMqB/MCsuaqy14BN0QHVDOBv
Zike8DX8Nw/XKfQe60CTCtjPl6udqDgyARRoePKvfGG6Z2QVOk0g9yHsf2Pz4ek0
M/b9jECyBso=
=vg0C
-----END PGP SIGNATURE-----

--Sig_/k_Ja2rlFitG//3Y5qmlZZQc--
