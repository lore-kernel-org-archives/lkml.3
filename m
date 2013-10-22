Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab3JVRJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:09:27 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:43915 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3JVRJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:09:26 -0400
Message-ID: <5266B143.9080708@gmail.com>
Date: Tue, 22 Oct 2013 19:09:23 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>,
        The development of GNU GRUB <grub-devel@gnu.org>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, "keir@xen.org" <keir@xen.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Jan Beulich <JBeulich@suse.com>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <5266A6AD.90004@gmail.com> <CE8BF72A.243C%richard.l.maliszewski@intel.com> <20131022165140.GL3626@debian70-amd64.local.net-space.pl>
In-Reply-To: <20131022165140.GL3626@debian70-amd64.local.net-space.pl>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2JEDDDMNQFGVOQCWCINWC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2JEDDDMNQFGVOQCWCINWC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 22.10.2013 18:51, Daniel Kiper wrote:
> On Tue, Oct 22, 2013 at 04:36:04PM +0000, Maliszewski, Richard L wrote:=

>> I may be off-base, but when I was wading through the grub2 code earlie=
r
>> this year, it looked to me like it was going to refuse to launch anyth=
ing
>> via MB1 or MB2 if the current state was a secure boot launch.
>=20
> Are you talking about upstream GRUB2 or GRUB2 with tons of distros
> patches including linuxefi one. If later one it could be the case.
>=20
> Daniel
>=20
secureboot patch in its current state has only one goal: make microsoft
sign existing image and load linux. If we integrate it with GRUB
signatures check (as far as GNU policy permits but rest would be tiny)
then it will be a matter of choosing which way xen is going to be
signed. I'd recommend GnuPG detached signature (xen and xen.sig) but
don't insist on it.


------enig2JEDDDMNQFGVOQCWCINWC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iF4EAREKAAYFAlJmsUMACgkQNak7dOguQgk3ZQEAscA3BzU6BXsVciRL3IsopGJc
bTG4ZtezVT8u6cbw8eMBAMJ+zRIqa9Wa1dBBpfdgUgVExl8y3iaEcZ1Kz//ZwOVJ
=ywBL
-----END PGP SIGNATURE-----

------enig2JEDDDMNQFGVOQCWCINWC--
