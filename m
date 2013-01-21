Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3AUBbv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 20:31:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49053 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752581Ab3AUBbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 20:31:49 -0500
Message-ID: <1358731892.24121.238.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] linux-firmware: add MISSING file
From: Ben Hutchings <ben@decadent.org.uk>
To: Pavel Roskin <proski@gnu.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Daniel Drake <dsd@laptop.org>, Ulrich Kunitz <kune@deine-taler.de>,
        David Woodhouse <dwmw2@infradead.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 21 Jan 2013 01:31:32 +0000
In-Reply-To: <20130114175533.4f184cd3@mj>
References: <1358030383-15609-1-git-send-email-xose.vazquez@gmail.com>
	 <CAFLxGvxTenzaaypsUz6pYmjiyEeUtkNGDKwBNeAVFUb5ZZgonQ@mail.gmail.com>
	 <20130114175533.4f184cd3@mj>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VCZvQISQsRs1FNey2Auk"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VCZvQISQsRs1FNey2Auk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-01-14 at 17:55 -0500, Pavel Roskin wrote:
> On Sun, 13 Jan 2013 00:09:46 +0100
> richard -rw- weinberger <richard.weinberger@gmail.com> wrote:
>=20
> > > +This file attempts to document the reason why a firmware is not
> > > present +in this bundle.
> >=20
> > From the user's point of view this not really helpful.
> > Wouldn't a in-kernel table of known but missing firmware files make
> > more sense? The kernel could write a log like "Yeah, I know this
> > firmware but sadly I don't have it because of ..."
>=20
> The firmware file may be absent on the system even if it's in the
> linux-firmware tree.  Conversely, the firmware may be present on the
> system but not in the linux-firmware tree.
>=20
> The kernel doesn't know whether the firmware is missing due to
> licensing issues or due to misconfiguration.  The kernel cannot know
> that.  And I don't think the kernel should include as much information
> as the MISSING file would include.

I can see some value in an index explaining where to get firmware,
whether it's available from the copyright holder or some licensee or
must be extracted from Windows drivers with a particular tool.

I'm not sure whether linux-firmware.git is the right place for that,
though.  Would distributions include this in their packages and would
users be able to find it there?  Would a wiki page be more useful?

Putting my Debian hat, I can say that we don't distribute any of the
older files that are 'GPL but no source visible', while we do distribute
some files not included in linux-firmware.git that require click-wrap
licences.  I also prune files that aren't referenced by the kernel
version in any current release.  So a file that says what's missing from
linux-firmware.git would not be that useful to Debian users, for
example.

Ben.

--=20
Ben Hutchings
Q.  Which is the greater problem in the world today, ignorance or apathy?
A.  I don't know and I couldn't care less.

--=-VCZvQISQsRs1FNey2Auk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPyadOe/yOyVhhEJAQqvOw//RLcyEOZnEzSAZpTZ1LDGj8vlG4Uhgb3v
3rDNk56BSo0JN4D/eH3mWBT5cbMXtGPcoOmnURvlxAs23/OTJFhQ4K9ZBcKQGJxs
voOHUeXEBJIpwlw6nxtyJuV7Z4NhIcHtm0wJmEb6RnTFYaGYzb2Zc7MxKlMPN6uQ
Fke+y8CPAP0sAMO+yfxBqwCkL60GaxvjltOlQVIBGQcgumihPvKvjYl/eiJRuiRy
6JazOvC1mvb5uKUJm60AlX2D3SBVdRm31JjpPwfIhvjv4H1ilgJTSDKdGJqwJkdM
AZGx88eLoHWVij2MFm9x39c7RpdKTiZdd3neDu84pFkMaKHhQA62m9MoFW+XfbuG
Leoc1Nss+JiXRLhJ//KvD4j6MTgoWU/ANi13iGY/lNj+gHLA/+u6tNH7BTKKEpHE
jIN5pQbg31XMJixL9nArJXdj8ouvzUfaou99ssvcWP+LEDBjHftrDlq9XijbEYOe
ZDueHofcdFDnqYqISsJcCzyZ04rvdGcY1OvML18XF2y90uNe67UkL+LLF0lCpZnz
QFcFwcTJqGPXREvjuVfWuuIl+unu5snpPaqcQELy9l4hOoP3gp+am/GlQwQwRkzv
oyiWoZvofU5DXWXztB6gEp4ZklOwMBmUPgI8jPYBNLK8UD7Twrs0W+1m/EqS32fA
AA7sTqgL748=
=82jV
-----END PGP SIGNATURE-----

--=-VCZvQISQsRs1FNey2Auk--
