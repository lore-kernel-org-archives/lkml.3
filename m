Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446Ab3CNAUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 20:20:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60006 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab3CNAUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 20:20:51 -0400
Date: Thu, 14 Mar 2013 11:20:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: Tree for Mar 7
Message-Id: <20130314112040.c5a2a3f1d1bc801a7f527ed1@canb.auug.org.au>
In-Reply-To: <20130312233311.GA23925@logfs.org>
References: <20130307150645.e4e23e69340c25b5d21b70e0@canb.auug.org.au>
	<20130307162504.GA6727@logfs.org>
	<20130312184422.GA19035@logfs.org>
	<20130313111144.7d5c75022f0fd00e445ead1f@canb.auug.org.au>
	<20130312233311.GA23925@logfs.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__14_Mar_2013_11_20_40_+1100_rgOx_KGWs17Epnze"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Mar_2013_11_20_40_+1100_rgOx_KGWs17Epnze
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi "J=C3=B6rn",

On Tue, 12 Mar 2013 19:33:11 -0400 J=C3=B6rn Engel <joern@logfs.org> wrote:
>
> On Wed, 13 March 2013 11:11:44 +1100, Stephen Rothwell wrote:
> > On Tue, 12 Mar 2013 14:44:22 -0400 J=C3=B6rn Engel <joern@logfs.org> wr=
ote:
> > >
> > > Any chance to get the bcon tree included?
> > >=20
> > > git://git.kernel.org/pub/scm/linux/kernel/git/joern/bcon2.git
> >=20
> > Well, maybe you could tell me something about that tree i.e. what is in
> > it, why I should merge it, how it will be sent to Linus ... also what
> > branch to fetch and who should be contacted about conflicts, build
> > problems etc.
>=20
> What is in it:
> - Mainly blockconsole, a console driver that will write printk
>   messages to block devices.  Very useful when netconsole, for
>   whatever reasons, is not available.  Code is originally from April
>   last year and by now we have upwards of 100 machines running it.
>   A number of bugs were identified because of it.
> - Also a patchset to disable the loglevel filtering for
>   non-interactive consoles like blockconsole and netconsole.  Again,
>   we run it across the board and real bugs were fixed because of it.
>=20
> Why should you merge it:
> I plan to send this to Linus in the next merge window.
>=20
> How will it be sent to Linus:
> Merge request, unless someone finds a good reason against it.
>=20
> What branch:
> master.  I personally don't use branches at all, at least not
> consciously.
>=20
> Who should be contacted about conflicts, etc:
> Me.
>=20
> > Also consider: is this stuff ready for inclusion in Linus' tree (maybe
> > apart from integration conflicts), is it well reviewed/tested?
>=20
> Two people from SuSE seem to find the code useful and have provided
> testing and patches.  To the best of my knowledge this code is ready
> to go and useful for more people that just me or $EMPLOYER.
>=20
> I will be giving a talk at the collaboration summit that is
> essentially going to cover this tree.  Conferences have a lower bar
> for acceptance than Linus does, but at least it must have caught
> someone's interest.

Added from today.

One thing, the last few commits from Takashi do not have your
Signed-off-by even though you committed them.

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

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Thu__14_Mar_2013_11_20_40_+1100_rgOx_KGWs17Epnze
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQRfYAAoJEECxmPOUX5FEayYQAIM9+2ZYFWPOa5zivLcTWGjh
Rwrc6+vybX5Az91vqy39+ueB9dnJ65PLZ3EY+hdtlEX6wNazpVzYNXmIERScZKmz
IvDVqAMPOAD/XvQo+n9fdCEKGAmtsGL8OCNzYd+sHsVulgpn08nwa8kbdEiYUSLc
SCuIMllGBDFvtF4S7jzcaxNXywzii1WRPzm2FMEnkq2FOO986epIafRWL2y531ii
TYgFVUBBhp5fMUpVIM4zPgsU/xYOL/z/YQtJA72V0oALRnl/3bwas7DHwZJUMRua
bElOEUiYqhBOZ4NohJJ7Lmst9J1xbLbklEcjZ22hFZIBH/M95pa2ujXR+ctoqRGQ
e2Tj6OYwaIwsX9b5saiE6sdvhT/X3m6RzObeZbCOlIKvCvzMdh1nYNUAZYhKbtXc
An1ArPxX+6yIGuqN6AiSF8vNI6QIkzlWLjOckL5Seu8xd7SYdvUEg7aa0ic0dwFj
z1Zx9i2l54MWejy3HRYYCQIjE2MvoEpRT2r/1QwwEnx1x193GYOIteMowuQD0gzc
FeorpsFtXaBYPvEpf42ALlh1rtGLEeo35sz2flz5L1RpLbJ5utZIsAu+2HxGMkCe
06J7BcsLR7c/2gqWWOYPHYGIDBH9yjFGOkpcq75ipBUe7hs0/jHvLKnBGWMvtQhk
BgytXQ2SFLMUt2WlplQR
=s00i
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Mar_2013_11_20_40_+1100_rgOx_KGWs17Epnze--
