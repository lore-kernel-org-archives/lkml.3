Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab3CFUqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 15:46:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33090 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab3CFUqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 15:46:22 -0500
Date: Thu, 7 Mar 2013 07:46:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (staging tree related)
Message-Id: <20130307074612.0ea87b15b03f63c3252d5b6b@canb.auug.org.au>
In-Reply-To: <20130306200444.GA13744@phenom.dumpdata.com>
References: <20130306113508.9c868be103b6b140295c548f@canb.auug.org.au>
	<20130306004341.GA28426@kroah.com>
	<20130306135654.GA10760@phenom.dumpdata.com>
	<20130306200444.GA13744@phenom.dumpdata.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Mar_2013_07_46_12_+1100_Yry/4fagRuC7avTA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Mar_2013_07_46_12_+1100_Yry/4fagRuC7avTA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Wed, 6 Mar 2013 15:04:44 -0500 Konrad Rzeszutek Wilk <konrad.wilk@oracle=
.com> wrote:
>
> > diff --git a/drivers/staging/zcache/debug.h b/drivers/staging/zcache/de=
bug.h
> > index eef67db..494cea02 100644
> > --- a/drivers/staging/zcache/debug.h
> > +++ b/drivers/staging/zcache/debug.h
> > @@ -1,5 +1,7 @@
> >  #ifdef CONFIG_ZCACHE_DEBUG
> > =20
> > +#include <asm/bug.h>

Why not include <linux/bug.h> ?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__7_Mar_2013_07_46_12_+1100_Yry/4fagRuC7avTA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRN6sUAAoJEECxmPOUX5FEh5YQAKZ/7Y0Ad/7msbh1keRvw+4k
PJFPKF8KPcepeMA2XN554OTxwVfdGQlyfSxKjvriumM3Afs3yD2+M7JTcSE6nHMi
dd0Ab/v5rDNDOIBRdrS6dDwJ4UKgNTv14XKBYNdzxIIk3FiIwPIoV6gfQRlEmHmf
Z1nzQOcuRfG2KGiVV4njdbWXNhsSbS0w/KYDaPbtVFZuI2RslwLMxY6ZiD9fiAeZ
P2VTaQa8NwhjAG02ZFz8tSbpMioaMw0tqnRbrL1xcoYdoBl2d1dDJQ2/cXBUCdrT
taIRFLRTUNF/JzJLi5WJLZ+VqfuDDW51X8egjj+565VikExYTx4lbvd9HBC1tnT6
q2it93P1DuKeKZtJmymxQnh1/MbnDCRRaRJFPKCNDipRSdHT/NUpqkk3CUp4yQRb
sdqpkw5KfmHd0dPYNaAjN0/sjfNZdXThYQHDjemcPbnG5qnmvuqxD3gY6LXqzHa6
z2dF/kDh4ENeBYCNudrYKW3DasjBjhFajkPekpv+P/j82XDD8ZLW/PvyfiXgUzM+
DclVGXtmkmsitkwkfXm6guWibVYlRV/NibGF3bt13CC4T8DIvKjcYNp19/x6lU29
+MMiluNX5/1bpYh2iCZrMIP5Q0DnJD9/DOH/y+Py4cROwj4Xio2KyKP5I3HqPo5Q
DEs9m0FPwCt7WFK9lOS/
=IUsk
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Mar_2013_07_46_12_+1100_Yry/4fagRuC7avTA--
