Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaE1KYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:24:22 -0400
Received: from ozlabs.org ([103.22.144.67]:54246 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbaE1KYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:24:20 -0400
Date: Wed, 28 May 2014 20:24:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20140528202411.0660759a@canb.auug.org.au>
In-Reply-To: <1401271041.28714.22.camel@x220>
References: <20140528194629.0757af1b@canb.auug.org.au>
	<1401271041.28714.22.camel@x220>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/i1PiIVa99UlydVGCDDkV9VQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/i1PiIVa99UlydVGCDDkV9VQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Wed, 28 May 2014 11:57:21 +0200 Paul Bolle <pebolle@tiscali.nl> wrote:
>=20
> That may be related to my "staging: rtl8192u: rename
> CONFIG_IEEE80211_CRYPT_TKIP" (see https://lkml.org/lkml/2014/5/26/531 .)
> My message states it was compile tested, but that would be on x86_64.
> Did it only break on powerpc or did powerpc hit this first?

The powerpc allyesconfig build was just where I found it - I don't do
that many different builds during the day.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/i1PiIVa99UlydVGCDDkV9VQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThblQAAoJEMDTa8Ir7ZwVMToP/3sPqESpU1XtOKKba0ByDRDM
j85idBBR6ANW5+oBvvb34TwMvDwiH9kns8R+tzeaydqWTW5yM68NA7N5OfHXQj+8
K6crYv9/x/b/OaCuenSdMmtThDs1wGzLQ0S1C40jbiaqUWdJtAE0OadeJThIFpK6
RPmyaLGfVrw3/sXfccwrnunuh7ClMgmdLqGyttNffqdJkO88fzLaBrSi7v8JRkI7
iLATn70Hybya7Fohd2W+0JIuWMriqZb5rrthEpL/2yHi8iZlnovXRsTBY8IK84RK
B4p5b2RmNnqQXWIfe8mMdaWbm3+BFc33N0Q+MTVsQvv2MgkRIEN/pdh+XllsL1iK
eGeKmsOFzSTFLzrxxy0WJb2QugyDx+xXVWbkPg/lh2KKcBgXN4TWYmmg6XTgNTIM
67uSfOXQCIKJla8JHegDdNV/VOkhPIZyiNO7Jic7TOwedLzAuLyiOTkbd3+/IdTx
CjPMqri1lgQ76upjfejXdBQWNJVotlEfC/ui/uCFgxWU+EyIKbPsl+H5C+Daxpfl
frp/uyCNT1ALeX44V/VH4CHTcEvrm+P7GFLa+3LzBut35zFH0kbI9lYYdIFUJzOp
mhWJ2jAIIteKw1ikECoULr1plnIzpZfkW8xhAvxtffdQOpmW3UOWzmexn1UK2gci
xFCpCme0pqcYfT5NMLPY
=K1o0
-----END PGP SIGNATURE-----

--Sig_/i1PiIVa99UlydVGCDDkV9VQ--
