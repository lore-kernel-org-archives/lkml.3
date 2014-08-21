Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaHUOxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:53:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53178 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaHUOxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:53:02 -0400
Date: Thu, 21 Aug 2014 09:52:42 -0500
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140821145242.GJ24407@sirena.org.uk>
References: <20140820061703.6128f99c@canb.auug.org.au>
 <20140820155222.GA24407@sirena.org.uk>
 <5248cecd-03f6-407b-a4a7-1d2989ee0469@email.android.com>
 <20140822003440.3ffc15c4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uLcrxnkzOGy8pA6s"
Content-Disposition: inline
In-Reply-To: <20140822003440.3ffc15c4@canb.auug.org.au>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: Tree for Aug 20
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uLcrxnkzOGy8pA6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2014 at 12:34:40AM +1000, Stephen Rothwell wrote:
> On Wed, 20 Aug 2014 13:53:56 -0500 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:

> > >Are you sure about this?  There's a bunch of updates to the tree
> > >including one that's supposed to have fixed the build failure on
> >PowerPC
> > >which haven't made it into the tree, was there a problem with the fetch
> > >perhaps?  I just checked and cgit says I pushed 23 hours ago so it
> > >doesn't look like a problem with the push.
> >=20
> > I thought I checked, but I may have missed it, sorry.  I will check aga=
in before the next linux-next.

> The fix appears to be there today, but I dont; think it was for the
> previous linux-next.  Does it matter that I am currently in Chicago
> (despite what the date on this email says :-))?  I guess I must have
> fetched your tree earlier than you may have expected.

Right, that's why I checked that the push really had been the day before
as I had expected before I mailed - I'm in Chicago too.  Very odd.

--uLcrxnkzOGy8pA6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9ge3AAoJELSic+t+oim9AOYP/0FfywmN4PXhiVOFp7eFhPsc
Pi95quB2iNO1koWnTOuzW8VLVrv1stmJ2f22DxXUJgXGcCntmi4zxlGDT7B9QurA
85Ix1LB0oBOqFR0xElW2qeTPVMtkrWphqOvKCgvpe5eZh8MWZR2Ro5Su3/J2ZCKM
1hcDYaZOxwMVVvHiDzREJwcISRJsIS2MLzfJSz9WsEwU2eRBAKjzf6xnIZ9XMZBg
EE647wTkLFySPEe6O7p7oGAhSbBZ0NqED+lgIM0PGGMQoxO1prf6zqb65J6Th8au
5HD1sMr1pBVLnef5hnYmu//BmnLdZ3rbJ6uVmU98Ah2rghPnYRd8jVMhqnjLBcKk
MKV22qMAfwFgHYaelGxJhpRphDtg+CJGxQqX2dV6R0BbJBGOrtdZgAaybkLFajbX
KW2i8/ZAPGwnZ6fgUk1WpV5vrVK7VsXYYbg4S7VpqNuf2Q/fmnyyHTTO+TW4hE9p
X0joaalAa6UEaUpd0XwyILiJNCn8kioF/VpkNsqATmOwBxk3GonN34Zt0nZFTAWo
xWLJDNhdqYehRnyWL2GlL/xPCtDW2F0dnSTsgjN+SBcGQRj8EGAbk9YgBN9Z97ef
FEd0IytkM4gIIbw6jvQvyZRG84plnQKFaKl2GWL/radl7bZkb+GOg1Z71zW13+78
1aDCs/YiKb3z9bOm0/nt
=EBHL
-----END PGP SIGNATURE-----

--uLcrxnkzOGy8pA6s--
