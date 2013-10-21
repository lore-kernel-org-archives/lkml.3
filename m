Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab3JUVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:16:28 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:48670 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3JUVQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:16:27 -0400
Message-ID: <526599A8.9090501@gmail.com>
Date: Mon, 21 Oct 2013 23:16:24 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: The development of GNU GRUB <grub-devel@gnu.org>
CC: Daniel Kiper <daniel.kiper@oracle.com>, boris.ostrovsky@oracle.com,
        david.woodhouse@intel.com, ian.campbell@citrix.com, jbeulich@suse.com,
        keir@xen.org, konrad.wilk@oracle.com, pjones@redhat.com,
        richard.l.maliszewski@intel.com, ross.philipson@citrix.com,
        stefano.stabellini@eu.citrix.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
In-Reply-To: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2TUVERMCVQOSRRMSJPDAL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2TUVERMCVQOSRRMSJPDAL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Mail is big, I think I got your essential points but I didn't read it who=
le.
On 21.10.2013 14:57, Daniel Kiper wrote:
> Hi,
>=20
> During work on multiboot2 protocol support for Xen it was discovered
> that memory map passed via relevant tag could not represent wide range
> of memory types available on EFI platforms. Additionally, GRUB2
> implementation calls ExitBootServices() on them just before jumping
> into loaded image. In this situation loaded system could not clearly
> identify reserved memory regions, EFI runtime services regions and othe=
rs.
>=20
Will a multiboot2 tag with whole EFI memory map solve your problem?
> Additionally, it should be mentioned that there is no possibility or it=
 could
> be very difficult to implement secure boot on EFI platforms using GRUB2=
 as boot
> loader because, as it was mentioned earlier, it calls ExitBootServices(=
).
>=20
GRUB has generic support for signing kernels/modules/whatsoever using
GnuPG signatures. You'd just have to ship xen.sig and kernel.sig. This
method doesn't have any controversy associated with EFI stuff but at
this particular case does exactly the same thing: verify signature.
multiboot2 is mainly memory structure specification so probably how the
files are checked is outside of its scope. But it's possible to add
specification on how to embed signatures in kernel.


------enig2TUVERMCVQOSRRMSJPDAL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iF4EAREKAAYFAlJlmagACgkQNak7dOguQgnuFQEAgHdQsQF5mxk2SeZ1oAxhoIfH
iR3GubT/Yr3itSw3zEcBAJTNALqQcgRb4Y6oEFex8N+nex7sfa4bkBuMJeVdhtwO
=GXi1
-----END PGP SIGNATURE-----

------enig2TUVERMCVQOSRRMSJPDAL--
