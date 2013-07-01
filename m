Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3GAEnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 00:43:06 -0400
Received: from rrcs-24-173-105-85.sw.biz.rr.com ([24.173.105.85]:54068 "EHLO
	mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab3GAEnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 00:43:04 -0400
Message-ID: <51D108EB.7020608@gentoo.org>
Date: Sun, 30 Jun 2013 23:43:23 -0500
From: Matthew Thode <prometheanfire@gentoo.org>
Reply-To: prometheanfire@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130628 Thunderbird/17.0.7
MIME-Version: 1.0
To: Luca Barbato <lu_zero@gentoo.org>
CC: linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org,
        torvalds@linux-foundation.org, kernel@gentoo.org,
        hardened-kernel@gentoo.org, corsac@debian.org
Subject: Re: 3.9.7, 3.10-rc7 - UEFI stalls at boot (nothing displayed), when
 booting with mem=300M
References: <51CC6CAE.6070401@gentoo.org> <51CC81A2.8040305@gentoo.org> <51D10603.1080403@gentoo.org> <51D1087E.3010304@gentoo.org>
In-Reply-To: <51D1087E.3010304@gentoo.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2VSWQOJVNSLAKUIDALINV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2VSWQOJVNSLAKUIDALINV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/30/2013 11:41 PM, Luca Barbato wrote:
> On 07/01/2013 06:30 AM, Matthew Thode wrote:
>=20
>> You had the problem where it was blank on boot (right after grub, no
>> kernel messages at all)?  Sounds like this might not be limited to jus=
t
>> Lenovo then.
>=20
> no grub, efi-stub directly from the efi shell.
>=20
>> mjg59, is there anything I can do to help move this bug forward?  I've=

>> done all I can think of (even tried a serial expresscard slot for logg=
ing).
>=20
> If you feel like bisecting seems the only option =3D_=3D
>=20
> lu
>=20
I was hoping to avoid that, was thinking of bisecting 3.8->3.9 for only
the uefi stuff though, should help keep the traffic down.

--=20
-- Matthew Thode (prometheanfire)


------enig2VSWQOJVNSLAKUIDALINV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0QjwAAoJECRx6z5ArFrDBmIP/jrjIM6/EncWF3VbihoNrGC0
Ei/M5QQKD2IaR6IwMXbJTQzUAqQpGpgPsPNMwKyT/IoovTZifOrawBdKnA0LXkgi
AmJG5qzH5YaSPxTA9i70HM5AwJAjudnyjDRMdAuFSkKDPMevDjulHeI+SYioPSP5
lyjeyHdj8nNC4PXoKg4VPsEdrl8XgjOuhB+x2MaNSmzvitymlm5Q4zWHw6Uhij0r
SguzJgQqjYzPyigPz70Zt5BSc7NUKkJ+dXl1OZihzTNtZ2wBnrWH/4j7NBgw1CdX
6eBO0YkFGSKoYMl5dR9e8Aq7j9kyN7KLAmee4OiyrGVUXbKqN/wiBRxKzOiqu5f+
bmRFx9lOqSjF5FCT3shDXQzmec3oF+VZeq6Ser4e32gLPGVZi0cSXQ1EvS2j0fCM
QmeucFv5YMs4QUqOlT8+TXQ+CZg/AHEwffyQoBIyCUPRpawK3cpilWJu+fGn7fso
qM4iODC80+WXw52iUTaBAaymGc0zRLfMqZGfy8v1iuc2W8Scum9BcEh2m4nouIMh
9v035rdo7zLooiyFv29J8XE2N5iqFfCcVomIjijqF3Jh2bCWKXxc7/wTLgV2cnWx
FMHUqMvIBx1ABOcd4QBRehBQPKIlcpWY3xwZYunEQABX3I4Cc0IWWiwJz+hpwE9r
HSM8Sbyc8fRZSWY9DTLt
=qu/0
-----END PGP SIGNATURE-----

------enig2VSWQOJVNSLAKUIDALINV--
