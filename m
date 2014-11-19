Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbaKSVfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:35:05 -0500
Received: from domine.madduck.net ([77.109.139.90]:52563 "EHLO
	domine.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404AbaKSVfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:35:03 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2014 16:35:03 EST
Date: Wed, 19 Nov 2014 23:28:08 +0200
From: martin f krafft <madduck@madduck.net>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: EXT4-fs error, kernel BUG
Message-ID: <20141119212808.GA31961@fishbowl.rw.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
References: <20140805103436.GA7531@fishbowl.rw.madduck.net>
 <20140805125114.GG5263@thunk.org>
 <20140805131555.GB18164@fishbowl.rw.madduck.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20140805131555.GB18164@fishbowl.rw.madduck.net>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux jessie/sid kernel 3.16-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach martin f krafft <madduck@madduck.net> [2014-08-05 16:15 +0300]:
> > It's possible that this was caused by a memory corruption, but it
> > wouldn't have been high on my suspect list.  Still, if this is
> > a new machine, it might not be a bad idea to run memtest86+ for
> > 24-48 hours.
>=20
> =E2=80=A6 and will do that. I did it before, but I also just upgraded the
> RAM and didn't do it again.

For posterity, the problems went away after I memtest86+-identified
a bad RAM module and swapped it, then recreated the filesystems for
safety,

Thanks Ted!

--=20
@martinkrafft | http://madduck.net/ | http://two.sentenc.es/
=20
will kill for oil!
=20
spamtraps: madduck.bogus@madduck.net

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQLvBAEBCgDZBQJUbQtowBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xJDC
EACBKmTScySiqwyZaoK9Kpv4RmvBt28vjwDX9V1CnAqQBVHZwfVcsb6cXcruUyO6
7qSUtcXVLbyyn4Shh+AhjkU+MNjDDV0t3oz5OOGdvLEHj5/BcY2McECJUbUWO4MP
Y3C8bXtVDEWfcZemv3zPrVLG1P4pxNB9yNS2M1UV6GHAl6ST47gAa2GEeKukUUez
XocZy8jAH/tV1YxeTnn0QxipGE6LOExpzx7n7bmtWZgfoDmYM2dF0cnZfNPOk6lc
ugB2Ri9ItxEIa+c9X3Uo0muhZTeWV72dqkae0qKvOki/Mdt9fFSttUb7ofIFY0Xx
bnttTKb1Din32cyQ//cPTBSy52vNO1w7hkU4IL8ablyYL8gMjpQOOtfZUvOlEJuy
ZjdiuWsCP71vFcVCvxLEYwvN8Ff9ppawak6yJAkevbKVZT8ja0HWGEZ/ZvInXl3j
hkxeQbp52NTchwxet4+iIyemYwhOson0dsL6cVlZ0AaoMK2slcpYECfEabFmooye
qLBE0eXhl18cfRZahCXdRY335qKBVPAfGpamW4ECPCBhIVq07On870W1lex35ABf
GPXSBin/QYv/k92rV+hLdKTN8SlgJU7S0UiB3zudAlbQ4jgqJcfgBlU1LZBCt3dD
0wttByUq89w004gZ6qs9SiPNUyz4VmlqSVlxfo83Wzbaww==
=SyG2
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--

