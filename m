Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaFCIr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:47:26 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbaFCIrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:47:24 -0400
Message-ID: <538D8B96.7080503@nod.at>
Date: Tue, 03 Jun 2014 10:47:18 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: sched: Disallow sched_attr::sched_policy < 0
References: <20140602021319.9A5F9660C19@gitolite.kernel.org> <20140602202204.GA26649@redhat.com> <20140603080826.GK11096@twins.programming.kicks-ass.net> <CAFLxGvz4yKJfWyRqh5wnG-05m9P3oxcrvVZLH-Yap8dFz-0ctg@mail.gmail.com> <20140603083228.GN11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140603083228.GN11096@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="5CFgTI6VJm7RgIjxhbp9nSTeKMgIkqpuV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5CFgTI6VJm7RgIjxhbp9nSTeKMgIkqpuV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 03.06.2014 10:32, schrieb Peter Zijlstra:
> On Tue, Jun 03, 2014 at 10:15:44AM +0200, Richard Weinberger wrote:
>>> Once upon a time GCC also did warns like that, but my compiler is sil=
ent
>>> :-(

-Wtype-limits is what you're looking for.

/me currently builds some kernel configs to find out how much noise it tr=
iggers...

>>> Yes, that needs fixing..
>>
>> I sent already a patch for that...
>=20
> I found it.. thanks again :-)
>=20

:-)

Thanks,
//richard


--5CFgTI6VJm7RgIjxhbp9nSTeKMgIkqpuV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTjYuXAAoJEPmeIjfg4UaalTQP/0OMTV8IyRWMTQda3WUoGpnO
CqvCQk3WbuDl/sN3OG6N9Pv14kTJKpVbrGaZnmZO3cRhirxTJb7tjm8kXSGl+JTh
p2nqqfemUGfaldbgU+OyC+qHgkQmJTudsJocevU+DATr6zEB2nAq7pGskalLhNxH
ALvHMS0P1r8+rNp1F5jXj/p3z2sAs3yq9a8RsI3hYSF47BZkrFfbWlZt1Xg/FPkE
20YyE6qzaW6STUaM7xvgrC7T3nxYuMOAKSgp1hpgYZFQlIzz8ugn/eeTIo7koMwg
yKOGQ5yEZwQ8EIkv9Kl+FYJh3FfZmoqdwbsMOK9j0ETG/urCukso8WvNNXJx451c
cuCjOz2G/xUQ4uRofY5Q3s6Lsi8cuUdj0vTYsUu3YVLUzRDq5OP9M7k19pt8Osy8
DUJ+cI20OdQaR+xXOuHCrCQ2dx5d4NgIfv9eCxB3QUNbLLzr1TkhW8phDuwCgPRJ
PDUxOCq3zErXBWIVPm5hWp3K4NoBj9snEG9f/jSohD5qMKlq9ttacaa/PxT1AUPI
1rtSQ7Iih7TwjTEzNn4eavgd0qvp1/Y0irrzA58gH5eq58TmiJteEH7e9zTqu2Bq
iIPJiv3v9uyTogAVK9KDb2jNXUSO+MCMjSElcMr20oMglzW5ifT6C90sq0HE9Tic
ciEzxfFUDe/z+LsRhoU+
=Cleb
-----END PGP SIGNATURE-----

--5CFgTI6VJm7RgIjxhbp9nSTeKMgIkqpuV--
