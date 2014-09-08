Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaIHKWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:22:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56857 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbaIHKWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:22:44 -0400
Date: Mon, 8 Sep 2014 11:22:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@infradead.org>, Peter Foley <pefoley2@pefoley.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Message-ID: <20140908102229.GG4015@sirena.org.uk>
References: <540651B3.8030400@infradead.org>
 <20140902232906.GG29327@sirena.org.uk>
 <CAOFdcFPmHH9z+6Kuc5Agu6PDC9+t+420Cb5R6VuHp+MebG+2LQ@mail.gmail.com>
 <20140903232149.GG29327@sirena.org.uk>
 <5407A68F.5090805@infradead.org>
 <20140904104201.GI29327@sirena.org.uk>
 <540A503D.20807@infradead.org>
 <540C9D19.5080201@infradead.org>
 <20140907184837.GD4015@sirena.org.uk>
 <20140908180327.6ef7f2b8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AjmyJqqohANyBN/e"
Content-Disposition: inline
In-Reply-To: <20140908180327.6ef7f2b8@canb.auug.org.au>
X-Cookie: See label for sequence.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AjmyJqqohANyBN/e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 08, 2014 at 06:03:27PM +1000, Stephen Rothwell wrote:
> On Sun, 7 Sep 2014 19:48:37 +0100 Mark Brown <broonie@kernel.org> wrote:

> > Yes, I'm using his scripts.  I guess it's possible there's something in
> > his global git configuration that changes the behaviour?

> You seem to have been using an older version of my scripts.  The above
> was changed on May 5th in commit
> 9f1441da46c87531635fe742016124db2069db24 in my "tools" directory.

Huh, weird.  I rsynced a fresh copy over when I started (and I needed to
reconfigure where the builds would run and so on so that does seem to
have worked) so I'm not sure what was going on there...

--AjmyJqqohANyBN/e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUDYNkAAoJECTWi3JdVIfQ4PIH/jZKo+XK8Ijfd1L5jrx41cLC
OHPa6G6id/hBTdIHjWDtsSF5JoIW8sz99OLlBkEWGbazWL1b3UwyZlEJKjGQlPCt
R9GW0r+35flP71ipSk/OjOSh1++/4C6IhyfG0b7aYITP/9HfgHWbxOxteufYjw50
S5lSRfDZXTp9xiVwIhSxm05+KvEeA3Eh2/fspKhnTKb5D3d0jR5Odh1jDdO5eQjZ
A9xypG8yP0Xm+PVLZLEibtmHJO3bACGa9wUUiryn90MzmlM/BdIL21T4Zu3gzoqJ
VSRaC3+EqUdVnjncUfX7Rt2XeHaXeGz3ZaamNsMfhzjjbWNi2IDsfue9VThvcQI=
=Zp4I
-----END PGP SIGNATURE-----

--AjmyJqqohANyBN/e--
