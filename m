Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaLZE4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 23:56:24 -0500
Received: from ozlabs.org ([103.22.144.67]:39087 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaLZE4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 23:56:21 -0500
Date: Fri, 26 Dec 2014 15:56:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: livepatching tree for linux-next
Message-ID: <20141226155613.36dd95b9@canb.auug.org.au>
In-Reply-To: <20141223151056.GA4789@treble.redhat.com>
References: <alpine.LNX.2.00.1412221412360.1680@pobox.suse.cz>
	<20141223094607.GA16445@infradead.org>
	<20141223151056.GA4789@treble.redhat.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/sSi3tLVOg.pLycl_hainmFk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sSi3tLVOg.pLycl_hainmFk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Tue, 23 Dec 2014 09:10:56 -0600 Josh Poimboeuf <jpoimboe@redhat.com> wro=
te:
>
> On Tue, Dec 23, 2014 at 01:46:07AM -0800, Christoph Hellwig wrote:
> > On Mon, Dec 22, 2014 at 08:52:02PM +0100, Jiri Kosina wrote:
> > >=20
> > > a substantial amount of work has been invested into abstracing "Live=
=20
> > > Patching" core functionality out of the already existing implementati=
ons,=20
> > > so that further improvements can be built on top of it in incremental=
=20
> > > steps.
> > >=20
> > > The core functionality (which is self-contained) now works and has be=
en=20
> > > Reviewed/Acked by both interested parties (i.e. people working on kPa=
tch=20
> > > and kGraft) and agreed to be a common ground on which further develop=
ment=20
> > > will happen.
> > >=20
> > > We plan to send a pull request for 3.20, therefore I'd like to ask yo=
u to=20
> > > include 'for-next' branch of
> >=20
> > This is still missing the actual patch generators, which should be
> > merged together with the code, otherwise we'll get a mess with forever
> > out of tree tools like systemtap again.
>=20
> Well, a patch generator isn't required.  You can build a patch module
> from source with kbuild, just like you would for any other kernel
> module.  This is what kGraft already does today.  For example:
>=20
>    https://git.kernel.org/cgit/linux/kernel/git/jikos/livepatching.git/co=
mmit/?h=3Dfor-next&id=3D13d1cf7e702596e0cd8ec62afa6bd49c431f2d0c
>=20
> We do want to add a generator, but there are two of them out there that
> need to be converged.  It doesn't make sense to do that work until we
> have first converged the rest of the stack (namely, consistency models).
> That's our next step.
>=20
> The current code is by no means a final product, but it's still quite
> useful already.

OK, I have added this from today but if it becomes an issue, I will
drop it again.  Lets see how it goes.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

--Sig_/sSi3tLVOg.pLycl_hainmFk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUnOpyAAoJEMDTa8Ir7ZwVIhoP/ijzP8x+UQ3pmr6MANGMPZtk
3ETTXmXuJzngDfA1+umlxiykOJbx7Sf8FGiJYCCiD+bZ+DB8aRmi9qsMECpOi1x8
8RKe3UgXZ5ARk4bX5Sdb0dgljpbkXbSLUxYt6xWIx3EgHaTzZBnPv2xvx+0Jo7lr
JoS1ATiyiv0Js25YN+H+qGCWPZzfwBfYL60qhtWC15lmAuAruy023BtMNmiszWHr
0s6eytCsDfr1cHxcu/d1JmKHqYHv/dIf5ML177nr2E/YUfO8Z2j3xo2x47RO1hYE
wgSy2aYIbgXxtDSBOqWzGTGTd7AMmBaamTQ2QtKlbu6FDS8jDIVJ24k4OBVZKKoa
oWXhf0qyy+LGuwSbZWaLP3vlX3I73sl/uZL/ZLPkr7t9oGX4Hf+ROuZpIcpG5uGe
UZ5OCgY1bygUIL3xQTPOkjL0lZ/xDNMA2uNmoDMbRZq2/Z0OLT+GxwrJlCGBSr2v
3Yuy2cjoPUZorFxFY50TnbyH92wS/4WJdx2NHXaUPOLpLRHtOSXY82FfB45RzvJH
N+/dFuUD5X3Wvi3HglMUQ1qTMztyqN0tFb0/Ly9E7f5tubaHfZHEH572ZDXvC1Ys
vyXTIc1ldZ01y+4Os6vBaJ6whZbSpZ3V8voKwVudqsd6E5pP9gcWKDXy9eXU9vHr
zAdDoAMUfCO2ymv7V7vq
=LN77
-----END PGP SIGNATURE-----

--Sig_/sSi3tLVOg.pLycl_hainmFk--
