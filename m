Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3HZEQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 00:16:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34648 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab3HZEQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 00:16:01 -0400
Date: Mon, 26 Aug 2013 14:15:45 +1000
From: NeilBrown <neilb@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>, Guenter Roeck <linux@roeck-us.net>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH 3/3] raid6/test: replace echo -e with printf
Message-ID: <20130826141545.5de533c4@notabene.brown>
In-Reply-To: <d44b178f-0c43-483d-80f5-9791573bc526@email.android.com>
References: <1377183186-8407-1-git-send-email-jcmvbkbc@gmail.com>
	<1377183186-8407-4-git-send-email-jcmvbkbc@gmail.com>
	<d44b178f-0c43-483d-80f5-9791573bc526@email.android.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MKVxnMERgkS49Mr//pYz+mg"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/MKVxnMERgkS49Mr//pYz+mg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Aug 2013 17:09:11 +0200 "H. Peter Anvin" <hpa@zytor.com> wrote:

> Acked-by: H. Peter Anvin <hpa@zytor.com>

Applied with the Ack - thanks.

NeilBrown

>=20
> Max Filippov <jcmvbkbc@gmail.com> wrote:
> >-e is a non-standard echo option, echo output is
> >implementation-dependent when it is used. Replace echo -e with printf
> >as
> >suggested by POSIX echo manual.
> >
> >Cc: NeilBrown <neilb@suse.de>
> >Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>
> >Cc: "H. Peter Anvin" <hpa@zytor.com>
> >Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> >Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> >---
> > lib/raid6/test/Makefile |    2 +-
> > 1 files changed, 1 insertions(+), 1 deletions(-)
> >
> >diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
> >index 087332d..73b0151 100644
> >--- a/lib/raid6/test/Makefile
> >+++ b/lib/raid6/test/Makefile
> >@@ -28,7 +28,7 @@ ifeq ($(IS_X86),yes)
> >                     gcc -c -x assembler - >&/dev/null &&	\
> >                     rm ./-.o && echo -DCONFIG_AS_AVX2=3D1)
> > else
> >-        HAS_ALTIVEC :=3D $(shell echo -e '\#include <altivec.h>\nvector
> >int a;' |\
> >+        HAS_ALTIVEC :=3D $(shell printf '\#include <altivec.h>\nvector
> >int a;\n' |\
> >                          gcc -c -x c - >&/dev/null && \
> >                          rm ./-.o && echo yes)
> >         ifeq ($(HAS_ALTIVEC),yes)
>=20


--Sig_/MKVxnMERgkS49Mr//pYz+mg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhrWcTnsnt1WYoG5AQJfKw//SqgGXkNioPnzah8ben2JU80O/xpmnpd1
Sb+4HsJ9ZktVg3onYDzO+SMjb394RTgvc6M+lbbywHDrck8dx8AwBcapYVKTJcLG
dTDfd8Ya/IRtbX2BVOG3Q4TewofqdBV11DJIeHeXhJdyH37ChKuZnC9PB1qxhpHi
eofLUTH2E/L6Xzzyk7DJsIOWGwpphUOOTtGAtO+cMf+WtdOnja1YWILEibi+eTOb
rVSOCt+LPdabXU8h1JEQnnKgpbUY5DzNDKti3g0mTKM80TbYq5tcqPVclLhV6gSg
f4zP6XU+Vx6Bd+EEbC+us6sH6kqlYDoAyuyqWxW4MsKdgAhhboD4e4j1nVDzlBHa
wDsL44PobvHGQp4FNuphZCGUjYcIBJotQ8q8gGMwqmaepVLW25IRwGZAX5tew1Xr
bm3AIllCEsxB9wSY2InGgyB2Z6nIy6uGJNRkeLJWJyNxYVy6db6pe9dIcuQaYvpQ
7NnZuk2A1MnmxWEos/GvZ6dgxgZSuLNaj+UdMGwCrWdDkrDfkW1Fww6PaSr9MPLF
8P3zFbFAe2po7XuL+PdAMFMh21egfI1JL0/ETqIbgD4vVDraHk7A/223Ei5Bhw2J
fEFJWOr66+Z8e2f1Qbb7dCM5Gmq7S4ZPKP4y3koXtVdFUb5+o4Xl8zcY9+bvV/3i
2PiAUXEBdZo=
=RCB7
-----END PGP SIGNATURE-----

--Sig_/MKVxnMERgkS49Mr//pYz+mg--
