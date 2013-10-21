Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab3JUV1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:27:21 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64691 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3JUV1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:27:20 -0400
Message-ID: <52659C34.6010508@gmail.com>
Date: Mon, 21 Oct 2013 23:27:16 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: The development of GNU GRUB <grub-devel@gnu.org>
CC: Seth Goldberg <seth.goldberg@oracle.com>, keir@xen.org,
        david.woodhouse@intel.com, stefano.stabellini@eu.citrix.com,
        linux-kernel@vger.kernel.org, ross.philipson@citrix.com,
        jbeulich@suse.com, boris.ostrovsky@oracle.com, xen-devel@lists.xen.org,
        richard.l.maliszewski@intel.com, ian.campbell@citrix.com
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl> <alpine.GSO.2.00.1310211348530.2162@oretfbsg>
In-Reply-To: <alpine.GSO.2.00.1310211348530.2162@oretfbsg>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2PDWWOOPFOAROEORGODRU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2PDWWOOPFOAROEORGODRU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 21.10.2013 22:53, Seth Goldberg wrote:
>=20
>=20
> Quoting Daniel Kiper, who wrote the following on Mon, 21 Oct 2013:
>=20
>> Hi,
>>
>> During work on multiboot2 protocol support for Xen it was discovered
>> that memory map passed via relevant tag could not represent wide range=

>> of memory types available on EFI platforms. Additionally, GRUB2
>> implementation calls ExitBootServices() on them just before jumping
>> into loaded image. In this situation loaded system could not clearly
>> identify reserved memory regions, EFI runtime services regions and
>> others.
>=20
>   Yes, that is exactly why we added full support to pass the entire UEF=
I
> memory map via a new tag.
>=20
Can you send this patch? Or provide a link to publically available
source? I think we can accept it with probably just minor changes.


------enig2PDWWOOPFOAROEORGODRU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iF4EAREKAAYFAlJlnDQACgkQNak7dOguQgkeTQEAm3P4kiG965hqIu0AmvKuBgxe
viWMF+Irlm/ntfuug3EBAKax39HHiu9vnHRT0anXBomCrexYPDyOr0HW/F26EXuy
=MyhS
-----END PGP SIGNATURE-----

------enig2PDWWOOPFOAROEORGODRU--
