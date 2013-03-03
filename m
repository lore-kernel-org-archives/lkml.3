Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3CCOXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 09:23:05 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:41593 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3CCOXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 09:23:03 -0500
Message-ID: <51335CBD.6040206@kernel.org>
Date: Sun, 03 Mar 2013 09:22:53 -0500
From: Konstantin Ryabitsev <mricon@kernel.org>
Organization: Linux Foundation/Kernel.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: webmaster@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git.k.o] gitweb->cgit: Re-add Git snapshot tarball feature
References: <CA+icZUUWqeHdgjP-Hi630DDwO65evWUUCX2tBYfj=Cn1w3dEAg@mail.gmail.com> <513355C5.2010505@kernel.org> <CA+icZUXxJ=4fuKCOckLfvc=V9XV5u8qy07nhVB_9jt5LPvHJ+A@mail.gmail.com> <CA+icZUUQypdXaqYApQ-uP=q02RBKvEvpqW3sjSh4PTOowzECoQ@mail.gmail.com>
In-Reply-To: <CA+icZUUQypdXaqYApQ-uP=q02RBKvEvpqW3sjSh4PTOowzECoQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2NSOXTOSHHFIKHKFLCQPV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2NSOXTOSHHFIKHKFLCQPV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03/03/13 09:17 AM, Sedat Dilek wrote:
> $ wget http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/s=
napshot/linux-6ec40b423032ca769c96fbf9a080db822821893d.tar.gz
>=20
> It's downloadable, but not visible in the CGIT website if you select
> the commit-id (missing download section and link).
>=20
> See <http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/com=
mit/?id=3D6ec40b423032ca769c96fbf9a080db822821893d>.

It'll show up in a little bit. Older commit pages are cached and are
unaffected by the config change until cache expires.

E.g. this page was generated after the change:
http://git.kernel.org/cgit/docs/kernel/website.git/commit/?id=3D12d4c6167=
0617f0e3ea306b27fedcb470dac6ba6

Regards,
--=20
Konstantin Ryabitsev
Systems Administrator
Linux Foundation, kernel.org
Montr=C3=A9al, Qu=C3=A9bec


------enig2NSOXTOSHHFIKHKFLCQPV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQGcBAEBAgAGBQJRM1y9AAoJEI6WedmufElepNwL/RKOWJs1Q4UON2jQZMChABEJ
9s82u/6I45NJh7gYPV5DsbHIeR0wXoxjiLbXxRid6CppEhlOKuGyVMOPxBpoSySb
A4D+Xb33cufjYnFasTpEmQnSZzx2EL2jXWKJnUAGjosPWeZF/WZFIrRC2SACM27v
xQgGLUHMHC06pALwjd64Fw9NZ1KcmlciOP/zrGsD1uE7fUXyR84WJA+LgnWofebw
PQzBRZBWMRY/aYc4JVcRzG/7YpsMzbGWZxxfeqytK6Nb5pHvefUdwOJUaIq09+de
H3utyLVmN51Nd1boL2wvT4aZglZTkxniCblgNub9h8fk7bIU6cHz5OMZOcNjmTp1
7ejD6lCB4axy2r2AHlF8SvnYMxNljrkU78qiMRvLOmpu0KFq3LwtXNWjpoG9cI+2
+3qMIhl6znNdjjZN6R6YBS5X5jgLmqxz/uraofkpPeTo7nDDv6DTr+fu0QGWtG5B
CVAjnvjpDNdrtosaAnfwe/CyVKDkeiUTjGNKs0UA1Q==
=gl5H
-----END PGP SIGNATURE-----

------enig2NSOXTOSHHFIKHKFLCQPV--
