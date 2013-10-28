Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab3J1SBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 14:01:49 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:52964 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab3J1SBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 14:01:48 -0400
Message-ID: <526EA686.70008@gmail.com>
Date: Mon, 28 Oct 2013 19:01:42 +0100
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: seth.goldberg@oracle.com, The development of GNU GRUB <grub-devel@gnu.org>,
        Daniel Kiper <daniel.kiper@oracle.com>, boris.ostrovsky@oracle.com,
        david.woodhouse@intel.com, ian.campbell@citrix.com, jbeulich@suse.com,
        keir@xen.org, pjones@redhat.com, richard.l.maliszewski@intel.com,
        ross.philipson@citrix.com, stefano.stabellini@eu.citrix.com,
        xen-devel@lists.xen.org, linux-kernel@vger.kernel.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl> <526599A8.9090501@gmail.com> <52663D54.2020800@gmail.com> <20131028162603.GA4716@phenom.dumpdata.com>
In-Reply-To: <20131028162603.GA4716@phenom.dumpdata.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2HVBTXSOEWTRKENLTXOEP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2HVBTXSOEWTRKENLTXOEP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


>>> Will a multiboot2 tag with whole EFI memory map solve your problem?
>> I added such a tag in documentation and wrote a patch for it (attached=
).
>> Awaiting for someone to test it to commit
>=20
> Great! I think from Xen perspective we first need to have Xen be able
> to understand multiboot2 - that is something Daniel had been working on=
=2E
> I will let Daniel talk more about it.
>=20
> Seth, would you have any time to test the patch against Solaris to
> make sure it works?
>=20
I've committed that patch. BTW do you want protected mode or long mode
entry point for x86_64 variant? Currently it's protected mode but I
planned to add long mode possibility but it wasn't a priority.



------enig2HVBTXSOEWTRKENLTXOEP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iF4EAREKAAYFAlJupoYACgkQNak7dOguQglLHgD+PmVC+4w0W8GUizjCz5g3TWCi
zQsuyllMSg34CgflbR8A/AgEcTX3GYx5YVgk2DoNCwC6CvJcu6sQZAOAjhB8UnR1
=ri09
-----END PGP SIGNATURE-----

------enig2HVBTXSOEWTRKENLTXOEP--
