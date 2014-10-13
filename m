Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaJMOit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:38:49 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbaJMOis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:38:48 -0400
Message-ID: <543BE3EC.9010601@nod.at>
Date: Mon, 13 Oct 2014 16:38:36 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: status of the signal-cleanup tree
References: <20141013173301.0664c8ac@canb.auug.org.au>
In-Reply-To: <20141013173301.0664c8ac@canb.auug.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="n7lMnmHlkOMmSOrvO9JUF5WXVAo3mJ78E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--n7lMnmHlkOMmSOrvO9JUF5WXVAo3mJ78E
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Am 13.10.2014 um 08:33 schrieb Stephen Rothwell:
> Hi Richard,
>=20
> The signal-cleanup tree
> (git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git#signal_v4)
> has not bee touched since July and when merged into Linus' tree,
> produces no changes (same patches different commits :-().  So all it is=

> doing at the moment is producing unnecessary conflicts :-(
>=20
> Can you clean it up, please?  Or should I just remove it
> from linux-next completely.

Just remove it. The "feature" was merged.

Thanks,
//richard


--n7lMnmHlkOMmSOrvO9JUF5WXVAo3mJ78E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUO+PzAAoJEPmeIjfg4UaadN4QAIgk8ejiOYQqZh7LjJy7A1d7
1xanFzrieQJXNQUofE1lF2rp41zd5N7DNWdoFYXhGpfDCS9fASgpntVV5ZzFDBWx
pQmzCcHWMuEUnSI/go26GVVlMGyVnekEboQdHqADo6EaptZ0AOBB4Rat4qo+HoJJ
D4h3KT+VR8lrytChm/O+B2tqrkFiJZWAUClsFCGJvQOsA+nx2OxEfym0X1LaFCSl
3YTLox+WiE20cW0qvAkDxkSxdcFFcuXgjGxdUkEe+HYCs+dg7l0K4TJYNDQ/zKMc
JtuOOaHpF5Y+ITCMyBF8UPBSBYvBjxBcvpIF7igTKzrJKO6EOGHX12VR94Xw2AFC
+qOclvFPpZc+YsC5x3LdjARujF9gDuZjNPvKbmjCTQ3UHKO1YaQmypcmwiEoPUP8
rPOy65sfHHJ0R8Ac/jN9HpdDhT5IkbJ+XWd6yrr3CWV+GuZP7iEygwetM64dG2+H
BpCa1fkNhGfNA3zbt6wIvQSSPH3VVyFVNzJIsDwJE97nBi45EULVN7rCSuB5jBTs
/+nWKWBEk6LW+I3w0q2+7kzC5QtXcMg5lz2lz9aHenPNxo/qSA4ZFnaxsHiIWrI3
8sawbs+rXCdvrd2B0FEFQpkeneB9FASQWJL3jjLLyHagip1zkVAWD4X7BrqdLWoG
LkYGinm2MDATANvyl5L+
=eSor
-----END PGP SIGNATURE-----

--n7lMnmHlkOMmSOrvO9JUF5WXVAo3mJ78E--
