Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaIXGuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 02:50:44 -0400
Received: from ozlabs.org ([103.22.144.67]:47568 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbaIXGum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 02:50:42 -0400
Date: Wed, 24 Sep 2014 16:50:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoffer Dall <cdall@cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Auger <eric.auger@linaro.org>
Subject: Re: linux-next: build failure after merge of the kvm-arm tree
Message-ID: <20140924165030.41c90baf@canb.auug.org.au>
In-Reply-To: <20140922140645.7c2ad9c8@canb.auug.org.au>
References: <20140922140645.7c2ad9c8@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/192MeR9bTmk4VsjCJO8.nus"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/192MeR9bTmk4VsjCJO8.nus
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 22 Sep 2014 14:06:45 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi all,
>=20
> After merging the kvm-arm tree, today's linux-next build (x86_64 allmodco=
nfig)
> failed like this:
>=20
> arch/x86/kvm/../../../virt/kvm/eventfd.c: In function 'kvm_register_irq_a=
ck_notifier':
> arch/x86/kvm/../../../virt/kvm/eventfd.c:493:2: error: implicit declarati=
on of function 'kvm_vcpu_request_scan_ioapic' [-Werror=3Dimplicit-function-=
declaration]
>   kvm_vcpu_request_scan_ioapic(kvm);
>   ^
>=20
> Probably caused by commit 0ba09511ddc3 ("KVM: EVENTFD: remove inclusion
> of irq.h").
>=20
> I have used the kvm-arm tree from next-20140919 for today.

Still getting this failure.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/192MeR9bTmk4VsjCJO8.nus
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUImm+AAoJEMDTa8Ir7ZwVILgP/0QSK6aPjzRXBcG7zuHLchu8
DtNNNftbm2eYJ1q3zbqHWaSKKMi8ud/YeqewVbPURGWKCUlYPKQoS3Zr+lVk+V0X
/d3nXMLcQvgWPlD1xmNfsA5qcRjhCmBULg1B3UWrZ0RUU/jBDkEct2ETyoiljflT
6S39qhwO75igX2XwbUlDNhkgpKBOFM7SDkOwKkgjQzzumBSRRhUcBEakldtX5LwD
ay1+DGSiJAoCCMLRZCGtV4jemCflSJDvxJbW9vEnVY1OD0ngRCwkYF6Vi25uj5EE
Z4JIKih+GK/p/ayoFYoY96GWtAKM1V5gMrmiO/MyjxGW2GmFHBhw/4MOJcZKFO9T
SVkNfJwQc6hQT2QgNMGwTeA3JUk2KouQMpFC44qz+cUL155kuOefJ7xZRucFGGQX
zN1xVJKNiZCtNZBU9iSy9lNfMg5juLWg4eH4BAQCetF1ud1qaXvcCBxZsES5i1oo
P5W5gwWh8whGck80mdm2yGoivmTVRUTS2fJEvFyUy/ZWk/kI262HwWDFF/MDZ0Pq
JABm2QIYRYCeQJms0IGL34yCRP4PX83H7l2kLz5xo/njaqGaG1pUopcBkxwZjQ8e
UuEOgczNtf6lEvD7sOIxIej18Y2ykOYYd+pCAeBIvr2UNCcgrqjXWX3ax0x+Zbfr
Z2hZy2LgSgSU9w1u6tkY
=UbSn
-----END PGP SIGNATURE-----

--Sig_/192MeR9bTmk4VsjCJO8.nus--
