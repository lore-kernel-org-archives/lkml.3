Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446Ab3CMQYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:24:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab3CMQYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:24:38 -0400
Message-ID: <5140A83A.4030702@redhat.com>
Date: Wed, 13 Mar 2013 10:24:26 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Thomas Backlund <tmb@mageia.org>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        libvirt-list@redhat.com, stephen@networkplumber.org,
        Zhenhua Luo <zhenhua.luo@freescale.com>
Subject: Re: [libvirt] if_bridge.h: include in6.h for struct in6_addr use
References: <50F2FF1B.3020708@mageia.org> <50F313A5.3020707@mageia.org> <50F49B7E.50906@redhat.com> <81B30F90-5A18-4386-9C30-E336AE212D85@kernel.crashing.org>
In-Reply-To: <81B30F90-5A18-4386-9C30-E336AE212D85@kernel.crashing.org>
X-Enigmail-Version: 1.5.1
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="----enig2HOMMVEENLIVPILXACAAV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2HOMMVEENLIVPILXACAAV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03/13/2013 09:17 AM, Kumar Gala wrote:

>>>>
>>>> if_bridge.h uses struct in6_addr ip6; but does not include the in6.h=

>>>> header.
>>>>
>>>> Found by trying to build libvirt and connman against 3.8-rc3 headers=
=2E
>>>>
>>>

> Did this ever get resolved ?

Libvirt has managed to work around the kernel issue in the meantime.
But just today, I hit the same issue with the latest
kernel-headers-3.8.2-206.fc18.x86_64 on Fedora 18 when backporting to an
older libvirt branch that did not have the workaround.  A kernel person
would have to speak up for certain, but I think it is still a problem.

--=20
Eric Blake   eblake redhat com    +1-919-301-3266
Libvirt virtualization library http://libvirt.org


------enig2HOMMVEENLIVPILXACAAV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCAAGBQJRQKg6AAoJEKeha0olJ0NqgnAH/jgctWdJVg/2ZMFoDo0Eq3Wl
OwgKzaeHnGK79QEfoAmw5OrVd9QTSfZscK3yL7Ab5CKqMqRr6gMRzPA67zxm3Dsi
uRzGt9tyxhBsJMoFbfgxBCZCZbBPW/fPn0xcO4zIjSgsBuUl+YX1qC3TUYi4R1if
Mfzn7lgXfu7Rp5Bu5KJorzGEUFoBfeu/JLM7S8/ykzODkpLf5K5UxTIeyAptKAaZ
JB9761Mer2MQ/oKGwsOLAmjuVMrJKv/xAcqZIppwVRscEaPsou2sKcwMpoP3semX
nOGob8I2L2DlxpnPU9ZbKWrWWfr2yc5Xk9PDEPqR9jzqmcZuXmF+UBXWIxuPLgI=
=jYZ/
-----END PGP SIGNATURE-----

------enig2HOMMVEENLIVPILXACAAV--
