Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3IROMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:12:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58565 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab3IROMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:12:07 -0400
Date: Wed, 18 Sep 2013 09:11:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Felipe Balbi <balbi@ti.com>, kernel list <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: Fix style in s3c-hsotg.c
Message-ID: <20130918141106.GH21559@radagast>
Reply-To: <balbi@ti.com>
References: <20130902135832.GA22300@amd.pavel.ucw.cz>
 <20130917154229.GI15645@radagast>
 <20130917220427.GC23937@amd.pavel.ucw.cz>
 <20130918014539.GB19817@radagast>
 <20130918092027.GA8325@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U3BNvdZEnlJXqmh+"
Content-Disposition: inline
In-Reply-To: <20130918092027.GA8325@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--U3BNvdZEnlJXqmh+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 18, 2013 at 11:20:27AM +0200, Pavel Machek wrote:
> On Tue 2013-09-17 20:45:39, Felipe Balbi wrote:
> > On Wed, Sep 18, 2013 at 12:04:27AM +0200, Pavel Machek wrote:
> > > On Tue 2013-09-17 10:42:30, Felipe Balbi wrote:
> > > > Hi,
> > > >=20
> > > > On Mon, Sep 02, 2013 at 03:58:32PM +0200, Pavel Machek wrote:
> > > > > Hi!
> > > > >=20
> > > > > checkpatch.pl has some valid complaints about style in s3c-hsotg.=
c :
> > > > > macro with if should be really enclosed in do {} while, and puts =
is
> > > > > going to be slightly faster.
> > > > >=20
> > > > > Here's suggested patch. I don't have the hardware, so it is compl=
etely
> > > > > untested.
> > > > >=20
> > > > > Signed-off-by: Pavel Machek, <pavel@denx.de>
> > > >=20
> > > > this is not how you send a patch, please read
> > > > Documentation/SubmittingPatches
> > >=20
> > > Have you considered possibility that this is how you nudge maintainer
> > > into fix their coding style?
> >=20
> > cute...
> >=20
> > Seriously though, read that file, you're commit log has garbage in it
> > which shouldn't go to git history.
>=20
> Run git log on SubmittingPatches.
>=20
> Then, instead of telling me what to read, run checkpatch on your
> files. You can either fix them yourself, or use my patch as a
> basis. Note there's missing } or something, so it probably will not
> compile, see the other mail. So you actually will have to modify that
> patch. Stripping "Hi!" from it should not be that hard, neither should
> be stripping note that patch is untested when you actually test
> it. And as you are the maintainer, it is your job.

you misunderstand the work of maintainers. Our work is not to fix you
crappy patches. If we start allowing crappy patches, we'd be fixing your
nonsense forever and linux wouldn't move.

> No, I'll not polish patch for hardware I don't have and have little
> interest in.  wanted to help you, but according to your first reply,
> you do not really want help.

that's your call. Now how about you stop being such a baby and go fix
your mistakes to start with ? Just because I'm the maintainer of the
gadget framework, doesn't mean I'm the maintainer of s3c-hsotc.c file.
Maintainer !=3D author too, btw.

Anyway, I got much better stuff to do than babysitting grown ups.

cheers

--=20
balbi

--U3BNvdZEnlJXqmh+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSObR5AAoJEIaOsuA1yqREytcP/1SbXUsWAqQNc7u70By58AzX
YWQA7A/fv4wCcXDRXnXyN11jZR12dZJQlrQMNdRzuK5sO2EqpJO0gIl0KDa6VbhV
T0tydLPy8x0DNfMt5JiAPBdfch6EzofUwNuVn+i1fEoZ4AZC2Za6mt6VI6IFhFpu
XOgVhCJAoF97MBkveEqVauJUGmHQfqDPz+gEAyXB0ZM8XWLJKI6QaissHFdWWYU7
PtR0fW05H80uaE4ygywcO64ufIK4p1eClv3RKabZKoFQ1nFFcZpziqdgC65ljynY
MBZms127CrN6JvY8+gBwy2fU3aBbe/iil2Rxpo9eiwpGSfFDGP39ztseiK0PcbH3
0+xvUoXkcAwC1K1eRvztaZyRbPqwshKFsJ5kLhBQyTfhtCLM5zexXJVtdfauCmCA
B6hvsrgHw5hek2lqr2UrK7632jq6FypyUkM9azqJ/sHJazdhhhT5uqjjB3DmqB38
Gt62BzRUmqntNUn/mnBrHp63GBpVRJPCYxKkMCcda/rYIwIgnwY9MeRDsqNPTAbb
JY9bHbqo+jAewlJIXSPchhpLx/9yBwwOeMhF8+qAFBAK7AMS2GYKPKNY8Ppn4oKc
E2R910NnTzQx87t3mlisK1Baa3x65ELhRYsWIHvlBx2ZhM4QdtxEDvi0xsAbgYvE
EhV8sh3wuoaeEzLVrJ6C
=2ZW7
-----END PGP SIGNATURE-----

--U3BNvdZEnlJXqmh+--
