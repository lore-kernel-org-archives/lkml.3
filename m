Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3JVRMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:12:32 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:46176 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab3JVRMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:12:30 -0400
Date: Tue, 22 Oct 2013 21:12:27 +0400
From: Andrey Borzenkov <arvidjaar@gmail.com>
To: The development of GNU GRUB <grub-devel@gnu.org>
Cc: phcoder@gmail.com, keir@xen.org, ian.campbell@citrix.com,
        Daniel Kiper <daniel.kiper@oracle.com>,
        stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        ross.philipson@citrix.com, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, xen-devel@lists.xen.org,
        richard.l.maliszewski@intel.com, david.woodhouse@intel.com
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131022211227.367d3997@opensuse.site>
In-Reply-To: <526599A8.9090501@gmail.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
	<526599A8.9090501@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bA_TVaiY6NygKBBuw1sdoQ2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bA_TVaiY6NygKBBuw1sdoQ2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Mon, 21 Oct 2013 23:16:24 +0200
Vladimir '=CF=86-coder/phcoder' Serbinenko <phcoder@gmail.com> =D0=BF=D0=B8=
=D1=88=D0=B5=D1=82:

> GRUB has generic support for signing kernels/modules/whatsoever using
> GnuPG signatures. You'd just have to ship xen.sig and kernel.sig. This
> method doesn't have any controversy associated with EFI stuff but at
> this particular case does exactly the same thing: verify signature.
> multiboot2 is mainly memory structure specification so probably how the
> files are checked is outside of its scope. But it's possible to add
> specification on how to embed signatures in kernel.
>=20

I'm a bit skeptical here. Given that

- EFI secure boot will still be needed to handle Windows
- kernel can be launched directly as EFI application
- there are other bootloaders with secure boot support

distributions will likely need to carry on EFI secure boot support. At
which point it is not clear what advantages second, parallel,
infrastructure for the sake of single application will bring.

The most compelling reason would be allowing module loading (which is
currently disabled by secure boot patches).

--Sig_/bA_TVaiY6NygKBBuw1sdoQ2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlJmsfsACgkQR6LMutpd94xY7ACfenRofnQwW+3fSdx6k3OWsUPM
G5IAnjj9Llm0MxKJg+82+cdoMHGZpamj
=+ahS
-----END PGP SIGNATURE-----

--Sig_/bA_TVaiY6NygKBBuw1sdoQ2--
