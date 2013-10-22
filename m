Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab3JVRUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:20:51 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:56991 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab3JVRUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:20:49 -0400
Message-ID: <5266B3EE.4010901@gmail.com>
Date: Tue, 22 Oct 2013 19:20:46 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@gmail.com>
CC: The development of GNU GRUB <grub-devel@gnu.org>, keir@xen.org,
        ian.campbell@citrix.com, Daniel Kiper <daniel.kiper@oracle.com>,
        stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        ross.philipson@citrix.com, jbeulich@suse.com,
        boris.ostrovsky@oracle.com, xen-devel@lists.xen.org,
        richard.l.maliszewski@intel.com, david.woodhouse@intel.com
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl> <526599A8.9090501@gmail.com> <20131022211227.367d3997@opensuse.site>
In-Reply-To: <20131022211227.367d3997@opensuse.site>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2ICFGSGIHWVNTAFEKMKIX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2ICFGSGIHWVNTAFEKMKIX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 22.10.2013 19:12, Andrey Borzenkov wrote:
> =D0=92 Mon, 21 Oct 2013 23:16:24 +0200
> Vladimir '=CF=86-coder/phcoder' Serbinenko <phcoder@gmail.com> =D0=BF=D0=
=B8=D1=88=D0=B5=D1=82:
>=20
>> GRUB has generic support for signing kernels/modules/whatsoever using
>> GnuPG signatures. You'd just have to ship xen.sig and kernel.sig. This=

>> method doesn't have any controversy associated with EFI stuff but at
>> this particular case does exactly the same thing: verify signature.
>> multiboot2 is mainly memory structure specification so probably how th=
e
>> files are checked is outside of its scope. But it's possible to add
>> specification on how to embed signatures in kernel.
>>
>=20
> I'm a bit skeptical here. Given that
>=20
> - EFI secure boot will still be needed to handle Windows
> - kernel can be launched directly as EFI application
> - there are other bootloaders with secure boot support
>=20
> distributions will likely need to carry on EFI secure boot support. At
> which point it is not clear what advantages second, parallel,
> infrastructure for the sake of single application will bring.
>=20
Using PE signatures is possible as I already said which invalidates your
points.
> The most compelling reason would be allowing module loading (which is
> currently disabled by secure boot patches).
>=20



------enig2ICFGSGIHWVNTAFEKMKIX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iF4EAREKAAYFAlJms+4ACgkQNak7dOguQglysQD+K5RyaK8KFIfMrPNjv/NC45Os
DYTudeKSJFEAD0AT5BIA/07rsKtiCzQgvfdoMC4uw/pBURSTKp6KmZJTm295mNjI
=HQdX
-----END PGP SIGNATURE-----

------enig2ICFGSGIHWVNTAFEKMKIX--
