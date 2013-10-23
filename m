Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab3JWIpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:45:04 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:54555 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3JWIpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:45:00 -0400
Message-ID: <52678C88.3020504@gmail.com>
Date: Wed, 23 Oct 2013 10:44:56 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: The development of GNU GRUB <grub-devel@gnu.org>,
        boris.ostrovsky@oracle.com, david.woodhouse@intel.com,
        ian.campbell@citrix.com, jbeulich@suse.com, keir@xen.org,
        konrad.wilk@oracle.com, pjones@redhat.com,
        richard.l.maliszewski@intel.com, ross.philipson@citrix.com,
        stefano.stabellini@eu.citrix.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl> <526599A8.9090501@gmail.com> <20131023074334.GS3626@debian70-amd64.local.net-space.pl>
In-Reply-To: <20131023074334.GS3626@debian70-amd64.local.net-space.pl>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2UOALIXUABTLUDUWARLFD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2UOALIXUABTLUDUWARLFD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 23.10.2013 09:43, Daniel Kiper wrote:
> On Mon, Oct 21, 2013 at 11:16:24PM +0200, Vladimir '=CF=86-coder/phcode=
r' Serbinenko wrote:
>> Mail is big, I think I got your essential points but I didn't read it =
whole.
>> On 21.10.2013 14:57, Daniel Kiper wrote:
>>> Hi,
>>>
>>> During work on multiboot2 protocol support for Xen it was discovered
>>> that memory map passed via relevant tag could not represent wide rang=
e
>>> of memory types available on EFI platforms. Additionally, GRUB2
>>> implementation calls ExitBootServices() on them just before jumping
>>> into loaded image. In this situation loaded system could not clearly
>>> identify reserved memory regions, EFI runtime services regions and ot=
hers.
>>>
>> Will a multiboot2 tag with whole EFI memory map solve your problem?
>>> Additionally, it should be mentioned that there is no possibility or =
it could
>>> be very difficult to implement secure boot on EFI platforms using GRU=
B2 as boot
>>> loader because, as it was mentioned earlier, it calls ExitBootService=
s().
>>>
>> GRUB has generic support for signing kernels/modules/whatsoever using
>> GnuPG signatures. You'd just have to ship xen.sig and kernel.sig. This=

>> method doesn't have any controversy associated with EFI stuff but at
>> this particular case does exactly the same thing: verify signature.
>> multiboot2 is mainly memory structure specification so probably how th=
e
>> files are checked is outside of its scope. But it's possible to add
>> specification on how to embed signatures in kernel.
>=20
> I think that EFI signatures should be supported because they are quite
> common right now. However, I think that it is also worth to support
> GnuPG signatures. This way anybody will be able to choose good solution=

> for a given case.
>=20
Agreed.

> Daniel
>=20



------enig2UOALIXUABTLUDUWARLFD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iF4EAREKAAYFAlJnjIgACgkQNak7dOguQgkqjAD+KXCOHoE/gTculbdG4pqsK3cf
kf2FiGB2O3m9FR/7M9wA/0VOKSoi7JEVY8qoG1RPVsG5ZyhCzqmxorlL6iy5SEeC
=PvIW
-----END PGP SIGNATURE-----

------enig2UOALIXUABTLUDUWARLFD--
