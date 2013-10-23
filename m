Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab3JWRNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 13:13:45 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:57483 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3JWRNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 13:13:44 -0400
Date: Wed, 23 Oct 2013 21:13:40 +0400
From: Andrey Borzenkov <arvidjaar@gmail.com>
To: The development of GNU GRUB <grub-devel@gnu.org>
Cc: phcoder@gmail.com, Matthew Garrett <mjg59@srcf.ucam.org>, keir@xen.org,
        david.woodhouse@intel.com, stefano.stabellini@eu.citrix.com,
        Daniel Kiper <daniel.kiper@oracle.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Jan Beulich <JBeulich@suse.com>,
        ross.philipson@citrix.com, richard.l.maliszewski@intel.com,
        boris.ostrovsky@oracle.com, Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [Xen-devel] EFI and multiboot2 devlopment work for Xen
Message-ID: <20131023211340.656092cf@opensuse.site>
In-Reply-To: <5267D82A.3010307@gmail.com>
References: <5266620602000078000FCA48@nat28.tlf.novell.com>
	<1382435127.1657.70.camel@hastur.hellion.org.uk>
	<526668A502000078000FCA7B@nat28.tlf.novell.com>
	<20131022134252.GA27302@phenom.dumpdata.com>
	<1382449985.18283.12.camel@hastur.hellion.org.uk>
	<20131022140947.GA17829@phenom.dumpdata.com>
	<1382451868.18283.21.camel@hastur.hellion.org.uk>
	<1382455358.18283.31.camel@hastur.hellion.org.uk>
	<20131022162632.GB19189@phenom.dumpdata.com>
	<1382517150.22417.21.camel@hastur.hellion.org.uk>
	<20131023131348.GA23898@phenom.dumpdata.com>
	<5267D82A.3010307@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WqGsET1q_M4i6=nZ_WWUT/_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WqGsET1q_M4i6=nZ_WWUT/_
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Wed, 23 Oct 2013 16:07:38 +0200
Vladimir '=CF=86-coder/phcoder' Serbinenko <phcoder@gmail.com> =D0=BF=D0=B8=
=D1=88=D0=B5=D1=82:

> >  - Do the signature verification (hand-waving which one - probably both=
).
> Can someone throw me the link on the EFI signature specification? Can't
> really find it now.

It is in UEFI specs, specifically chapter 27 of UEFI 2.4, Secure Boot
and Driver Signature. Link to download: http://uefi.org/specs/access.
You need to accept agreement so I cannot post direct download link
(actually I do not have it handy).


--Sig_/WqGsET1q_M4i6=nZ_WWUT/_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlJoA8QACgkQR6LMutpd94z4HQCgrKpW721u1bhc0y+D7/ScGaKu
WOwAoJVoM7GKiIEWEqAsOmSSJNC1G7Eu
=1kiu
-----END PGP SIGNATURE-----

--Sig_/WqGsET1q_M4i6=nZ_WWUT/_--
