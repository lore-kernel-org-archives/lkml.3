Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbaIXHFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:05:49 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34437 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaIXHFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:05:47 -0400
Date: Wed, 24 Sep 2014 09:06:12 +0200
From: Christoffer Dall <cdall@cs.columbia.edu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Auger <eric.auger@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: linux-next: build failure after merge of the kvm-arm tree
Message-ID: <20140924070612.GA15794@cbox>
References: <20140922140645.7c2ad9c8@canb.auug.org.au>
 <20140924165030.41c90baf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20140924165030.41c90baf@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 04:50:30PM +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> On Mon, 22 Sep 2014 14:06:45 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > Hi all,
> >=20
> > After merging the kvm-arm tree, today's linux-next build (x86_64 allmod=
config)
> > failed like this:
> >=20
> > arch/x86/kvm/../../../virt/kvm/eventfd.c: In function 'kvm_register_irq=
_ack_notifier':
> > arch/x86/kvm/../../../virt/kvm/eventfd.c:493:2: error: implicit declara=
tion of function 'kvm_vcpu_request_scan_ioapic' [-Werror=3Dimplicit-functio=
n-declaration]
> >   kvm_vcpu_request_scan_ioapic(kvm);
> >   ^
> >=20
> > Probably caused by commit 0ba09511ddc3 ("KVM: EVENTFD: remove inclusion
> > of irq.h").
> >=20
> > I have used the kvm-arm tree from next-20140919 for today.
>=20
> Still getting this failure.
>=20
Commit e9142e3b69c2ae8a699463e219e5b029ff0d652b in kvm/queue fixes this,
but it hasn't gone to next yet.

Paolo, I know there's a scary commit in queue but there's a bunch of
scary stuff in the kvmarm/next too that I'd like to see in next, any
chance you can put a subset of queue into next?

Thanks,
-Christoffer

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUIm1kAAoJEEtpOizt6ddy1v8H/2cav2en0ZsQaE00/oJKlP/3
FvzNP47nyqBHDHrtB59wClgGb7JH7JRHQXETMbB35J2CJKM7N4yG2RpdC30E+JWC
A4tneXTYywtXJE2t7ItWLOW8s7g6stNEMKAz3BfWBK7Z7qLwTvj9G0MkB349INOm
jWhVyNBBVKEfAgyYZ5PAKzCyBRrKIqfEs+7gaQLT4tZt1IyJWf/M6ifGN18XQAk/
q/S0ncjwrnlEYFMJreayMZyxiVYn8T3Dx1qNtSc1PzVE+8U93J22oaN8F+slCm3d
YBULJglWxg/pVCWL1WmOq/udqhugrhU+IQkU3YFExAtBEPKMheGVpuUshgm2Le8=
=yqr2
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
