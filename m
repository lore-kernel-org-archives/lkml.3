Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbaGOLJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:09:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:56885 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403AbaGOLJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:09:03 -0400
Date: Tue, 15 Jul 2014 13:08:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf: Fix missing vdso name in mmap events for x86
Message-ID: <20140715110852.GI6758@twins.programming.kicks-ass.net>
References: <1405419844-3915-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wXrNoiI3xS2qTXng"
Content-Disposition: inline
In-Reply-To: <1405419844-3915-1-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wXrNoiI3xS2qTXng
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 01:24:04PM +0300, Adrian Hunter wrote:
> Commit 78d683e838a60ec4ba4591cca4364cba84a9e626
> added vm_ops->name as an alternative to arch_vma_name
> but did not update perf events use of arch_vma_name().
>=20
> Commit a62c34bd2a8a3f159945becd57401e478818d51c
> removed "[vdso]" as a name returned by the x86 version of
> arch_vma_name(), so the perf event for the vdso mapping
> no longer had the correct name.
>=20
> Fix by making perf events also use vm_ops->name.
>=20
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

I've already got:
http://lkml.kernel.org/r/1405353439-14211-1-git-send-email-jolsa@kernel.org

--wXrNoiI3xS2qTXng
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxQvEAAoJEHZH4aRLwOS609EP/ROF+HAhUEPrpej3c4rKT2wM
nYYzPYDQTySJohkHtb8a3lhHKRfWbWfcE0EzOxfHH659DI/4EEERwv5OoJNoAgXY
VuDKubuS+yTuwTr80UiGB4lBpqaVirsNGVuuYPZjPtYl6OrergOgRNRcuAXcUQyS
D3Dnt2NLCdUiISzGKaU95GcedCsrftLYUOLaXL1XN0fev8BShsdMo3ENInFmrWf3
5W3jjNk1AJvYTKdGtEbqb8sUjCngyoJFTcJC9oyImH95qLkoy7uZEZ1IyxLazOtw
xeRVdb0aUN5+PMXL9uQOl8F73iOF2IEqD5JHxeKJ1pcDCC2Dd5D8mIxtY81Ct1GT
laMf2SA4Am8fqwyumKlVe4Qh9hp1nct7sKdM7DH8oTHr4vbg+eN6sl2aaZ84kWJr
0FiOexN8mpDgrTEIG37H73i+Z4/vZCcnIe2hXPsoICTpSjNYWTf2hCtDWpeVVf/K
lr1pUx6K4r9/7ELqyFxBa/BU9uiIHj9+kxMOdeoLx+8qT8e77FNrTng4mTGbEkmH
ByiCH0Zi4Cl7bLWAZmwhugwbph2IWwnCNU0nQZGkYvJ5vY8YEsYAMkwq/hZNHIRd
WbMPcNFU3VGvGBwbtWJEdElrfMoz2OCuxDq1WBl8Ib3mWDlSBdwk3ZkKE8pLg9tu
I8rDUj3GpMBqNAm7Rlfz
=We93
-----END PGP SIGNATURE-----

--wXrNoiI3xS2qTXng--
