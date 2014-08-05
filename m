Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbaHENGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:06:38 -0400
Received: from domine.madduck.net ([77.109.139.90]:49182 "EHLO
	domine.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaHENGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:06:37 -0400
Date: Tue, 5 Aug 2014 15:06:32 +0200
From: "martin f. krafft" <madduck@madduck.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Disabling physical RAM regions for testing
Message-ID: <20140805130632.GA18164@fishbowl.rw.madduck.net>
Mail-Followup-To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
	linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20140805114010.GA14521@fishbowl.rw.madduck.net>
 <53E0CD59.10003@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <53E0CD59.10003@gmail.com>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux jessie/sid kernel 3.14-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Austin S Hemmelgarn <ahferroin7@gmail.com> [2014-08-05 14:26 +0=
200]:
> The e820 is probably not what you want to be looking at.  I would
> suggest looking into memory hot-plug/hot-remove support, IIRC the
> hot-remove support allows you to bring a bank offline.

Oh, good pointer, yeah, that would do and allow for online testing
to some degree.

I found http://feishare.com/linux/memory-hotplug-in-linux and
memory0 through memory69 in /sys/devices/system/memory, and only
3 of those are "removable=3D=3D1".

My goal is to bring one of the two 4Gb DIMMs offline, verify that
the error I am seeing still exists, bring it back online and take
the other offline.

How do I find out which memory to hot-remove?

Am I right in assuming that I won't be able to remove
one-then-the-other as some memory regions may not be movable?

--=20
@martinkrafft | http://madduck.net/ | http://two.sentenc.es/
=20
"the scientific paper in its orthodox form does embody a totally
 mistaken conception, even a travesty, of the nature of scientific
 thought."
                                                -- sir peter medawar
=20
spamtraps: madduck.bogus@madduck.net

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQLvBAEBCgDZBQJT4NbPwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xO/f
D/9GKyPOy8UNvaP560DgZy4oXFi7DqpEtj/Areq+LlsVo6G3oz8ZBVybgSM2MlMu
zcsisxcc1ZY5QKvh5K7nAxas6W9o6BvF+EOKRSSyj5xRxx1hYoY9P7KLT1vxOz2K
nKZC/l7amAOLJIWyKvGGgCJCPVSGGbdyqlXttrwGDAGMIJqOirNTORTekzPi4Jca
QiYqbKxCcRL2Q63aCNpVeFs2SG8KC9/AR6xRbokb9oY0DM0Fe05NeqlwXcTOSez4
JUuSn7Hph/IPmymaQp5dt9fYfNCKNnl+589YcAy8iRPxUpNfd9uMFyv+1VL1IICj
F3r9BzII9DhC/XUAJ4BcxgD8784zZgfjMPhJxWdoufLcdMnj70OCnmO7BezsX5IK
TldrFJnbZkLKZ3MHWPsxmq3lBqt6PpQzJZd/QYfj9zxDWFf+3rgtXLkStMqqB8jE
pnJbgbDpTpt/1Uc4VDkUgrgw0mans8kKgLpq6TMUpzboJMUhjLMbXdWE7CWrdWM+
KxQsIPF5x+K4GyvUraO+1oSQeH/MWOYKFpLFpIZ8l0vKyzdJs2ePQEy+xLvvzB51
QduyRdc8BNImIAzCeNLRjRK5YXo7cNV4DWfLgoegFMkexyU3p6FoSVNy6KZMc8cX
vigczf7y/bzD+gJjqIMnsvN9HnSxoP5eiztYW91nIGr7XA==
=SoA1
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--

