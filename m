Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaHGHgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 03:36:05 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbaHGHgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 03:36:01 -0400
Message-ID: <53E32C5C.5010103@nod.at>
Date: Thu, 07 Aug 2014 09:35:56 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [GIT PULL] Global signal cleanup
References: <53E20F1E.2080606@nod.at>	<20140806212720.66dbd58b@canb.auug.org.au>	<53E21186.3000702@nod.at> <20140807102823.7a743bdf@canb.auug.org.au>
In-Reply-To: <20140807102823.7a743bdf@canb.auug.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="pjSBldROt1suUeH1jhKBiWnxfO8hGaAaB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pjSBldROt1suUeH1jhKBiWnxfO8hGaAaB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 07.08.2014 02:28, schrieb Stephen Rothwell:
> Hi Richard,
>=20
> On Wed, 06 Aug 2014 13:29:10 +0200 Richard Weinberger <richard@nod.at> =
wrote:
>>
>> Am 06.08.2014 13:27, schrieb Stephen Rothwell:
>>>
>>> On Wed, 06 Aug 2014 13:18:54 +0200 Richard Weinberger <richard@nod.at=
> wrote:
>>>>
>>>> the following changes since commit 19583ca584d6f574384e17fe7613dfaea=
dcdc4a6:
>>>>
>>>>   Linux 3.16 (2014-08-03 15:25:02 -0700)
>>>>
>>>> are available in the git repository at:
>>>>
>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git signal-c=
leanup
>>>
>>> This has all been rebased onto v3.16 but none of the patches changed.=

>>
>> This was my indention. Also I've added some acks.
>> Did I screw something up?
>=20
> We discourage people from rebasing their trees just before asking Linus=

> to pull them unless they have a good reason.  Adding Acks is not
> necessarily a good reason.  It may be a different thing if you rewrite
> your tree (without changing it base) and, given that none of your
> actual patches changed, that would have worked for you.
>=20
> In your case, since you haven't updated the branch (signal_v4) that I
> fetch for linux-next, its doubly bad as, after Linus' pulls your tree,
> I will have two copies of all those patches in my tree - which could
> easily lead to conflicts that I really don't need to have.
>=20
> Also, note that the fact that the actual patches did not change at all
> means that either you missed some change that coudl have justified the
> rebase, or the rebase was unnecessary (since the things you are
> patching did not change).
>=20

Thanks for the kind explanation.
It would be nice to see these rules written down somewhere.

Thanks,
//richard


--pjSBldROt1suUeH1jhKBiWnxfO8hGaAaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJT4yxcAAoJEPmeIjfg4Uaae3UQAJEeWfauWDyHSEUmC1tPfbQY
SoWsSwOBytySwVnvdJgOad7lkqQPOBCpMC1Qkx7wUpZ2kM0iIe/TsO652hPRfalt
mm0meQSFzs8rqW/vQvRD0bWf4GmEa4VwO4k6xr3fHqvuOUHCCHzuhnUoO3TFieJU
7bTibYl+rGzCPOv+6fT3SZYwMP5/Ai8Xq2ydv83gw1JHjCaVzwT0/s4aCzQCG6sO
/mxPWc6gQu54ChyP74bSlvpGvlzwXe9MG1kXoXpzsUIe2f9tl621rddFgfIC5PTI
+z7Ru/hBcoH6iiVSskULUdhaYww+OHmLSwZ2fX5srAFIKfaeKBJdND5SY3enT7+L
e4VTyAj3cD2WRn8erpGr7pymA9LqlGJttUKu4eFzSABpeIZM30AMg+BHEUj6puKk
p2Jk1ciS+IZ58TxmI6u4TvrDR9f7Qy4aIA45kq6RUvATqTRF5W6DEkv5jaMzwl/4
2KC6L+bvmCd3GSdMCGlsJzM8hlzMGbDWLDEw3/0lZLTl6+fNtiXPK4onhXFXv8VH
koGwKDOwOy48aHGig2+BPZxWwbA3kYqzju66eEWR56nqT8is83Z6ru2YEEEttyft
2KAcxZKiwLoWn52ns/yZxNkh7bhs9wCI0nlTQX2QZsCxgR9/GIv9ZzkGiz2B938q
nGeWuduJJDuoRI5JyBSI
=yAvt
-----END PGP SIGNATURE-----

--pjSBldROt1suUeH1jhKBiWnxfO8hGaAaB--
