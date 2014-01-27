Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaA0XFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:05:31 -0500
Received: from ozlabs.org ([203.10.76.45]:45027 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbaA0XFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:05:30 -0500
Date: Tue, 28 Jan 2014 10:05:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 1
Message-Id: <20140128100522.04e310871abd77de53b5359a@canb.auug.org.au>
In-Reply-To: <20140127142520.GD10323@ZenIV.linux.org.uk>
References: <20140127142520.GD10323@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__28_Jan_2014_10_05_22_+1100_CsZUrBDJSDeJttTq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Jan_2014_10_05_22_+1100_CsZUrBDJSDeJttTq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Mon, 27 Jan 2014 14:25:20 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> 	Assorted stuff; the biggest pile here is Christoph's ACL series.
> Plus assorted cleanups and fixes all over the place...  There will be
> another pile later this week.
>=20
> There's a couple of conflicts - rcupdate.h and posix_acl.h; proposed reso=
lution
> in vfs.git#conflict-resolution.  Please, pull from the usual place -
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Yet again, none of this has been anywhere near linux-next, in fact there
has been nothing in the vfs tree since v3.13-rc1 :-(

Some of these patches are dated last December, yet none of them were
committed to that tree before last Friday.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__28_Jan_2014_10_05_22_+1100_CsZUrBDJSDeJttTq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS5uY3AAoJEMDTa8Ir7ZwVJUkP/j1CUIGZWZekElzakDYyKKHB
YLGBamE4Vt0DAy7AK2jTCEG5MdBBKX0rVwnTj/OA7sjaxWd1VigZaB6BKnLNQNcm
1OZsCiGlJobzZkc+/8gecrWD0DXAMna2+9hISUvZ65ufnmdaW1wDalyOcxooz4IL
Ad9k3lAiB4VUyXlahG7HS3WXmGVvDe5PeuBY7OgQQ0r1IEbTBs084pBiwt3wU4O0
/ZoxjPRh2u+oEP2gEp50wwdNEVq7L80Wk/UYcLdjb3H3jIoIBl0+wQhmgv/jFqcD
NrwO7aqdeBWu91DUSCm+NagdbQvgkzZ0V2H6ld5/YXdSLUGbwZkZTT8x5Uys7BL5
DctmTaQIb851S0LO4ieFXPJjcQoweiq+YyRPw5CUv59ba9ay1rgxmgdb9xaOpMZn
P/CYGojqSuv6MeLFSXAbfUIa64NEwkymtZRckSkY3kyVEYfmokKHOkbs4LhrOveW
4NdLLYvZYenNQjV/T43ZsDK3unHeErmYAsMQF7UA5/qjbjv3i435PN3tXRuLEsIa
Kz8QU+zm4++UysW1+kvWi6o+wKbup/AyiM28K/u7uA1uVNpmOjRK9aDv0RYE8LKD
usgR+DxrPLIaMn25swUSDIBB79VZxpturFoGw4UTu/pYf6VSzlmJBwZvt9doImw1
GfTmCnoaAnt6vAC3eejE
=stfq
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Jan_2014_10_05_22_+1100_CsZUrBDJSDeJttTq--
