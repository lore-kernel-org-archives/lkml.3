Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaFMJZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:25:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39295 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaFMJZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:25:16 -0400
Date: Fri, 13 Jun 2014 10:24:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brian W Hart <hartb@linux.vnet.ibm.com>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Christian Engelmayer <cengelma@gmx.at>,
        Christopher Brannon <chris@the-brannons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Jiri Kosina <jkosina@suse.cz>, Lindar Liu <lindar_liu@usish.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Simon Wood <simon@mungewell.org>
Message-ID: <20140613092442.GB5099@sirena.org.uk>
References: <877g4oau2s.fsf@rustcorp.com.au>
 <20140611105503.GG5099@sirena.org.uk>
 <87y4x2q5qr.fsf@rustcorp.com.au>
 <20140612112715.GX5099@sirena.org.uk>
 <87a99hpqnb.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GtM+3wSyc54Btfn2"
Content-Disposition: inline
In-Reply-To: <87a99hpqnb.fsf@rustcorp.com.au>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PULL] modules-next
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GtM+3wSyc54Btfn2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 13, 2014 at 10:33:20AM +0930, Rusty Russell wrote:

> So, did you queue a patch to fix your email address in
> drivers/regulator/virtual.c?

No, that's more about giving credit to Wolfson for funding the code I
guess - it's very rare for anyone to update the author information (and
becoming more common for people to not put them in the file at all).
Everyone uses get_maintainers.pl these days, it'll do a reasonable first
pass at figuring out who's been working on the code and who the
subsystem maintainers are.

--GtM+3wSyc54Btfn2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTmsNXAAoJELSic+t+oim9/JoP+gLUckUWjRjqff1J/3lXamNr
eIRDS0pUow+rUBSinqYOGsMbLZAKvk1ADG3u57iBvn18u7Z9csJz8tBQMznwUK5f
2iYlI/yXBOM/QDKBWTvhLb6gDpvnPLCzCqX+TbkgyByXPrkwxr14OBxntzBshCWA
5vGA2LGHpnLapRDJm/S/LNXkVMf/BHWvGzYaaiPB8ZvhpxhrFCZOYD7bAyHBByz6
zhUR0w5tsO4sNlHmdzNnlsP8lcjcELZ+jXv1p9lWlgzHc1Z8/ZW4htU9B3nqjVYY
rVdBgxaSwu3u/mFyCTe/4VorIECZorcU+8wXUr8Tw6vG7NZYXik5coABPUyyJeu6
BzrUHdsYVw01BJspFlleXJVgXuDRgLepa+zF14XQ9mwtfhT23UEgkEzmhq3Qz3Fs
sY8R1s0joFZaDt1ZvUzKDEz0n42ZPTbs30diFjg35YEcPfD+/gutuuZrCdwEgcL0
6wiI8OCMk6zeJmGdDbI8PzY+oL1ent9CmYkhUEyxz+MFdn9gy61mIn6ElwfG61Iv
B+N++uQcCtxv1I1WfkLTQrxqqGmN8cPg1xZlH5GHV5Nm+45p+sDjZDcXCP5FZpBL
kAQ6whQsQ4SfYPQwarpFh4xAkhCv5JklxxDQdIV/NFSN6mW3k9z1BzOmth/2UMA7
6J/4M9TA1bi1Oj+d04V9
=Nc8q
-----END PGP SIGNATURE-----

--GtM+3wSyc54Btfn2--
