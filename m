Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaAAQW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 11:22:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59072 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbaAAQW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 11:22:26 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: fdmanana@gmail.com
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "linux-btrfs\@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] btrfs: remove dead code
In-Reply-To: <CAL3q7H6ftrPyGK56i2EQ8fZaHa+RvaiFPR9SdJ4C9QrpFGPe=A@mail.gmail.com>
Organization: http://mina86.com/
References: <1388553589-26778-1-git-send-email-mina86@mina86.com> <CAL3q7H6ftrPyGK56i2EQ8fZaHa+RvaiFPR9SdJ4C9QrpFGPe=A@mail.gmail.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140101:fdmanana@gmail.com::54Ef3jY1pHOoQ8VY:000000000000000000000000000000000000000000004wt
X-Hashcash: 1:20:140101:clm@fb.com::M3537ai/ZsKcrv/x:00000001U9M
X-Hashcash: 1:20:140101:jbacik@fb.com::lE03KovhtbQsJeS4:00000vha
X-Hashcash: 1:20:140101:linux-kernel@vger.kernel.org::plK3IqJOz6dTRDOc:0000000000000000000000000000000002R4L
X-Hashcash: 1:20:140101:linux-btrfs@vger.kernel.org::YtSG13VLoPGs08+E:0000000000000000000000000000000000Cgid
Date: Wed, 01 Jan 2014 17:22:18 +0100
Message-ID: <xa1tiou3d64l.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On Wed, Jan 1, 2014 at 5:19 AM, Michal Nazarewicz <mina86@mina86.com> wro=
te:
>> [commit 8185554d: fix incorrect inode acl reset] introduced a dead
>> code by adding a condition which can never be true to an else
>> branch.  The condition can never be true because it is already
>> checked by a previous if statement which causes function to return.

On Wed, Jan 01 2014, Filipe David Manana wrote:
> Josef already added this patch to btrfs-next weeks ago:
>
> http://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/?=
id=3Dc4a886e433dce2b902324a54ef2d13691a760312

Ah, sorry for the spam then.

The original thread did not mention it and this commit was not included
in linux-next's master branch.

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

iQIcBAEBAgAGBQJSxEC6AAoJECBgQBJQdR/0KC8P/0FV6QTYO3Gv0u6xZ/d+n0Re
JY2PMOLYvPkn8P4rB2B4Voh+5+rZz19A9dLPu0YEHC2HzoI+CELHjc0W42jHX3bY
oCWUOt6+JgXQJtlamFtdSj5K5oGswu0Md1j59H6sLAzndK7TJoJS88/+1e2nV5I1
Z1CxpzUVKYkQa7UPhvqDUmptFzfhmcH8ZwDKFvoixSc5geBibulKQAl3XLw0a7xb
oSlTY4fNy5/DX/Laa7pAYhac9x8SUZtfm8oxPZyTMqtg4hGfA3kq8aLYgl4NHmsb
wVOqPJBsbaF0XCDmdw/imQfrnK8XUnuw3wjjJUhe0MnLzzuHzJP0nW15/AbZ5VY7
Bql0T08U22ZwKbbSMAfs3yT3J2xP/gFQt4dMcnG2BGktmg5kHoM3k+V1DYSfkOEN
41Aw/zlsPh1m/WYU1HuHRLbP7sygRTyZVcAaeYPR4T9PoEM8nb2qOfGQEBuRtwd3
ER8tMNAVH5IfeN3H6s1qOCKNiBUxXzraPRBJWcw6UMVl5AsVcK5EY2EFjgeq6wCL
bBPsie2CAsu2quOLaMqfHMhT3DApnqoGyRDUtIgvyP6lCbCK3LSCx2t0U+jyCSrP
Rf0/RKQ/dMSfiT+AZr8vFjpifmQ3r5Tn85ZfvN4RRx4SB0mBAW+chOOHX74kclcJ
QMwQZB3IboIKmd5rC/ip
=ttg3
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
