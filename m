Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab3GaX5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 19:57:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41457 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3GaX5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 19:57:21 -0400
Date: Thu, 1 Aug 2013 09:57:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Stupid linux-next git question...
Message-Id: <20130801095708.b43c432b2bf914827fd45d79@canb.auug.org.au>
In-Reply-To: <24590.1375311493@turing-police.cc.vt.edu>
References: <24590.1375311493@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Aug_2013_09_57_08_+1000_Les5tUHxOEwOBMHW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Aug_2013_09_57_08_+1000_Les5tUHxOEwOBMHW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Valdis,

On Wed, 31 Jul 2013 18:58:13 -0400 Valdis Kletnieks <Valdis.Kletnieks@vt.ed=
u> wrote:
>
> OK... So I have (as usual) found some issues in linux-next, so I'm lookin=
g at 3
> bisects.  I already know that bisecting between (say) next-20130715 and
> next-20130730 won't work, but bisecting between the 3.11-rc1 base of
> next-20130715 and next-20130730 *will* work.
>=20
> Question 1:
>=20
> Does bisecting between "the HEAD of Linus's tree when a given next- is bu=
ilt"
> and "some later next-" work? (basically, I know that anything in Linus's =
tree
> as of -0715 is 'Good', so I'd rather start from there than from 3.11-rc1 =
to
> save several bisects).

Yes, because that point only moves forward (obviously).

> Question 2:
>=20
> If that works, how do I determine the commit ID to feed to 'git bisect go=
od'?
> I *hope* this in Next/merge.log is the magic I'm looking for:
>=20
> $ git reset --hard stable
> HEAD is now at 6c504ec Merge branch 'drm-fixes' of git://people.freedeskt=
op.org/~airlied/linux
> Merging origin/master (5ae90d8 Linux 3.11-rc3)

Yes, that, or if you look in Next/SHA1s, my start point in Linus' tree is
labelled "origin".  Also, it is the "stable" branch in the current
linux-next tree (which is moved forward each day).

These are not stupid questions, by the way :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__1_Aug_2013_09_57_08_+1000_Les5tUHxOEwOBMHW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR+aRdAAoJEECxmPOUX5FE6QwQAKKGJ+vFxjHsiscq4JRBkOPE
NOfqj7oSmyYQ0UyLIMrlQykEg7JAXzwqVOmR+qkX9zc34toZ6seBRAR/JU5VbNqT
GFO37wXO4Op1JRZuE8SpcGC3VcM9aXCcvx6rWTNuPmJ6MXIor/LIJHkgL0pOUSj2
d3uHpBfo1RKeB5lHkrldwMCDxXiqSpYn1l8ItAA9WxyyaQEfTbe9uVnDxaOZgyie
3XhuGtQ5dcIL5x2H2/I77zRceCDQObuwkzXMh5QrjzzVkz2A1V98S1WvDfU63JV1
/8GHU1kIYSEaTlWRslGAiHWKy1oKZm+b6EfiHaUJ2gMp1hWu8XjF34jeEzdm+M5J
i0xyAxK+T5yJ5IXT4fuOssV7VuFSyUBc82uQ6FcT9n+Y/cmRqGqw5k8mqloD6po9
6rvrvPxGadAp5Yth8ijqJcxWl4dXU7L5bJ0RLmzlp4FTxp+/sSezS5Wf6JhueEKU
mHaB9fl77x9CjPJrCjJq/xvpkd7YA22dsZ+0lNbZsV3gw0zHEj1mD+6CtKtZnyoo
VgioZTLF+qIfhcxsYZ2SvPiHmKkh06XZVvaEhZKkUrSWaN1WrfpM4zYHGc9qkhHQ
sf6P+D+YHxLqpf6hInpMeWDwn5urq3LALq4Ijjkutfg1r1JCwl7A/yaBB1b6Fgzg
Btw++55PwEfPKodRS7+3
=obI1
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Aug_2013_09_57_08_+1000_Les5tUHxOEwOBMHW--
