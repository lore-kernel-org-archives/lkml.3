Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab3IIU4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 16:56:39 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:62373 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3IIU4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 16:56:37 -0400
Message-ID: <522E3606.9060504@kernel.org>
Date: Mon, 09 Sep 2013 16:56:38 -0400
From: Konstantin Ryabitsev <mricon@kernel.org>
Organization: Linux Foundation/Kernel.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [16/85] b43: ensue that BCMA is "y" when B43 is "y"
References: <lsq.1374674564.753305150@decadent.org.uk> <lsq.1374674565.595401652@decadent.org.uk> <20130909180115.GC6276@home.goodmis.org> <20130909183904.GJ7729@decadent.org.uk> <20130909144642.7d61907a@gandalf.local.home>
In-Reply-To: <20130909144642.7d61907a@gandalf.local.home>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gnb01Q0929w9wl8Ruax8unlVQQTockf0A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gnb01Q0929w9wl8Ruax8unlVQQTockf0A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/09/13 02:46 PM, Steven Rostedt wrote:
> Initially, LKML would be archived on kernel.org, but that never
> happened and doesn't seem it will after the whole security breach
> incident.

I believe we're hoping vger will eventually start doing it on its own. :)=


We do archive some of it as part of patchwork, but only actual patches.

> But if mid.gname.org is a better link to forward to, then perhaps
> Konstantin could update it.

If it's the general community opinion, I can easily change that. The
trouble is, "sucks less (most of the time)" is a subjective opinion that
may not necessarily be shared by others. :) I have to be very careful
changing such tools, as someone's workflow may be disrupted by the change=
=2E

Therefore, for now I leave /r/ as-is, but you can use /g/ to direct to
gmane instead of marc.info:

http://lkml.kernel.org/g/5187EB95.2060605@infradead.org

Even further, if the message contained a patch, you can use '/p/' to
refer to it:

http://lkml.kernel.org/p/20130909183608.GR13318@ZenIV.linux.org.uk

You can just use that instead of /g/, since if a matching patchwork
patch is not found, it'll fallback mid.gmane.org. E.g., this message
does not have a patch, so no patchwork entry:

http://lkml.kernel.org/p/5187EB95.2060605@infradead.org

> In any case, as I would think kernel.org will be around as long as
> Linux is still in use, having the link go to kernel.org, and then
> kernel.org could point the result to where ever it liked, is still the
> best option.

Yes, do use lkml.kernel.org for this. If either marc.info or
mid.gmane.org go away, we'll find some other places to redirect without
losing historical context.

Best,
--=20
Konstantin Ryabitsev
Senior Systems Administrator
Linux Foundation Collab Projects
Montr=C3=A9al, Qu=C3=A9bec


--gnb01Q0929w9wl8Ruax8unlVQQTockf0A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQGcBAEBAgAGBQJSLjYGAAoJEI6WedmufEleGDUMAIfavC3kLGmI2C8xT8uvGjXG
2zK/SDKdlVQvyDnbO0HBQyNrHhWs70eRcFYdinp8tRwvHV6wXqOD0IWXvNNjXAhr
JqnvhPB2hGwEYHhTkK4gjEFnOir0fY5/eeTAeKafVcpS2A/dkHUYDjjmhe9sZIyG
gudrRYUVpyucY76YUpvA4o/O85qiy+pzm/iwTaDqsjMIoo23a89qYmyJXPhE5gJn
HvPb1IClkpPstrPs8uPpu0KOFhQovVyom0zkeffwgJ6SUm/JYzyDcRYH2gVMC2+/
I8htow1HfsSUkhslJ1Q6e+JJLhSNL2ovZRzmdJ8fKcg7mODlxtpd88M6fuygserM
1nlJrNdxe1W/ks0zEMfP23j3fzHxDRlMgI44OzxZBGhK3aMib0R8Ky/GEPqiQOxt
hKMh31FidsmzzUo+9aQKrcDBiAdgYhrzTuEcLdNBRryLxCKwsjjeUDKh7zNiWmrv
NxqqiXPR/v12+hpIWySw7PNUJgOFyBDtDYfjA1BVLQ==
=OYkO
-----END PGP SIGNATURE-----

--gnb01Q0929w9wl8Ruax8unlVQQTockf0A--
