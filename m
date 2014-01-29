Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaA2NHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 08:07:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49564 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaA2NHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 08:07:52 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the btrfs tree with Linus' tree
In-Reply-To: <20140129115403.4d2772c096a4fc7a4c9cb156@canb.auug.org.au>
Organization: http://mina86.com/
References: <20140129115403.4d2772c096a4fc7a4c9cb156@canb.auug.org.au>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140129:torvalds@linux-foundation.org::6WmDTgmqAuc6tNs6:000000000000000000000000000000000+N9
X-Hashcash: 1:20:140129:viro@zeniv.linux.org.uk::bFgtkD+T19hNwBrW:000000000000000000000000000000000000001TTG
X-Hashcash: 1:20:140129:clm@fb.com::4hX4x1T4L37ppbWn:00000003ZiB
X-Hashcash: 1:20:140129:linux-next@vger.kernel.org::/5S3cezZsa4fwo7z:000000000000000000000000000000000006t31
X-Hashcash: 1:20:140129:sfr@canb.auug.org.au::7D43hfDVNnrlIWtv:000000000000000000000000000000000000000008UZV
X-Hashcash: 1:20:140129:jbacik@fb.com::5b5AqioRiS9jjuax:00007lO9
X-Hashcash: 1:20:140129:hch@infradead.org::3ZP0c4ZohOR1QlZI:00000000000000000000000000000000000000000000863+
X-Hashcash: 1:20:140129:linux-kernel@vger.kernel.org::yQ4vNZYZs8is6F3y:000000000000000000000000000000000GeFj
Date: Wed, 29 Jan 2014 14:07:35 +0100
Message-ID: <xa1t7g9jym08.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29 2014, Stephen Rothwell wrote:
> Today's linux-next merge of the btrfs tree got a conflict in
> fs/btrfs/acl.c between commit 996a710d4641 ("btrfs: use generic posix ACL
> infrastructure") from the  tree and commit cfad95253440 ("btrfs: remove
> dead code") from the btrfs tree.
>
> I fixed it up (I used the version from Linus' tree) and can carry the fix
> as necessary (no action is required).

That sounds correct.  My commit [cfad95253440: btrfs: remove dead code]
can be dropped, since Christoph's commit completely rewrites
btrfs_init_acl function.

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJS6P0YAAoJECBgQBJQdR/0rdQP/1nGJKzJxKlQcHjHWC+LjBTu
5pjMOuu6ydBULYF+VXFKILwKhS5R2qY0AHVp0ApsU/MFDimbj20i8+tbAzPaTIaD
XNKMV/xp4VZvAQAwkr295VdlO2hBUOypHcwik7zs7Z70FE4quRbaUNK5FmdWjJ1d
tMpcZ7L9jZCTNFa//DCLsO7OBg8hfPcB7verRMtpyWbQnGsBvgzJhRXbt5bQchwn
fdKg6WHaHr9zObvjHEn/oiaPm3aZEVajCkfaTRHsH43sl9g4dGfTbZdDP8PzL+bf
0R4NnHUDdlu+lhMjSrztG7hKWQhwVGAokZivm8ytltuBzpjW9IHTwFEeyQtsFdky
Y1cskKeaduL0seO2YOeZ3Q6Csz8g72HryEO6szeRRoPf2KDV+8fHp6CaEqqr5zVj
ONMAzVd2jXj0FV0Jpmb4c4ge1x5Khu1fBXP3fZMfAT2HXImZxy16nGlGH3WEbl8q
7TzZzi+7O9ilv+MKB+se+x5yGGjaDqCPNI8O4cEm7BdVhlE0OzvcKqdPg7VXWDtF
L9aOZbp0acPnU9dO1syyyrfj5nJZCFnbMM34VZT2ci8UQyJw5rMINXZnpzpNCF/b
uA0nDbZz+zR7fbObRNDkZSZv3LuVx/ySdz1ZjcyjoHoST4UTtxVODlID+vj3R/hl
wYdVCXm41fCCRc0lR/Mw
=E5JR
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
