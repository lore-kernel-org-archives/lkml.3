Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab3IRAiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:38:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41657 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab3IRAiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:38:04 -0400
Date: Wed, 18 Sep 2013 10:37:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next stats (Was: Linux 3.12-rc1)
Message-Id: <20130918103750.21e32e537dec100fe30a4839@canb.auug.org.au>
In-Reply-To: <1379463821.32763.601.camel@haakon3.risingtidesystems.com>
References: <CA+55aFxg-WropC74v5ir5r9kBJKEd93fgye4oTBhw5T8e8sb+g@mail.gmail.com>
	<20130917155057.2125aa5f69fb9cf9bbe01166@canb.auug.org.au>
	<1379463821.32763.601.camel@haakon3.risingtidesystems.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Sep_2013_10_37_50_+1000_OVBi/WgPnGzQwKTU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Sep_2013_10_37_50_+1000_OVBi/WgPnGzQwKTU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

On Tue, 17 Sep 2013 17:23:41 -0700 "Nicholas A. Bellinger" <nab@linux-iscsi=
.org> wrote:
>
> On Tue, 2013-09-17 at 15:50 +1000, Stephen Rothwell wrote:
> > On Mon, 16 Sep 2013 18:08:11 -0400 Linus Torvalds <torvalds@linux-found=
ation.org> wrote:
> > >
> > > So it's been two weeks, and the merge window for 3.12 is now closed.
> >=20
> > As usual, the executive friendly graph is at
> > http://neuling.org/linux-next-size.html :-)
> >=20
> > (No merge commits counted, next-20130903 was the linux-next based on v3=
.11)
> >=20
> > Commits in v3.12-rc1 (relative to v3.11): 9474		(v3.11-rc11:	9494)
> > Commits in next-20130903:		  8891		(next-20130701:	8929)
> > Commits with the same SHA1:		  7991		(		7670)
> > Commits with the same patch_id:		   472	(1)	(		 759)
> > Commits with the same subject line:	    70	(1)	(		  55)
> >=20
> > (1) not counting those in the lines above.
> >=20
> > So commits in -rc1 that were "in" next-20130903:	8533	90.1%	(8484	89.4%)
> > Commits in -rc1 that were not in next-20120722:		 941	 9.9%	(1010	10.6%
> >=20
> > So better than last time, but it would be still nice to figure out where
> > the last lot came from.  I have the "git log --oneline --no-walk" list =
if
> > someone wants them.
> >=20
> > Some breakdown of that list:
> >=20
> > Top ten first word of commit summary:
> >=20
> >      57 net
> >      53 mips
> >      49 drm
> >      47 [scsi]
> >      23 perf
> >      23 nfs
> >      20 cifs
> >      19 nvme
> >      18 vfs
> >      17 arm
> >=20
> > Top ten authors:
> >=20
> >      33 Al Viro <viro@zeniv.linux.org.uk>
> >      21 Sachin Kamat <sachin.kamat@linaro.org>
> >      20 Linus Torvalds <torvalds@linux-foundation.org>
> >      18 James Smart <james.smart@emulex.com>
> >      17 Jon Mason <jon.mason@intel.com>
> >      17 Chuck Lever <chuck.lever@oracle.com>
> >      16 Tomasz Figa <t.figa@samsung.com>
> >      16 Jingoo Han <jg1.han@samsung.com>
> >      15 Daniel Borkmann <dborkman@redhat.com>
> >      14 Trond Myklebust <Trond.Myklebust@netapp.com>
>=20
> I'm totally confused by these stats..
>=20
> The target-pending/for-next pull had ~30 commits with the term 'target'
> in the first word of the commit summary, and yours truly had 40 commits
> merged.
>=20
> Is there a reason why these would not be showing up in the above..?

These are the lists if things that went into Linus' tree but were *not*
in linux-next prior to the merge window opening.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__18_Sep_2013_10_37_50_+1000_OVBi/WgPnGzQwKTU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSOPXkAAoJEECxmPOUX5FE5AMP/iU9jYYKk4rftLscPWZPq0YH
DLjBVM99w8++44TFAiguic4CT0501iPoyjWzT2rgwuKNp7aAzaz1ODboqK6FYEhR
m7mbN3ZINgmR87ucobq4fDuKxRSv6dtei3ffWy5+EkH6U+9fwzHBkdjdTpWQGF43
52WzOSiDzLdhhJ3KbgUwnLn2Vk0KKFpSXTvFFG600Rac6Gq2IgxH8SolB/mkH86E
ayXw8ojrE9Qa/fJYgbCAVMotZaxPsVMmgNqhxjnLmJEPb8RdQxGNujRZn45Y6UtM
LBDwnfxsWN2PekV+Zr5I7fmuAnMotr7vQMjVeiTIzNRtS4QELpTWXCH4cmT9vfac
Bpde0v6lGLKeFFhEAN4bTayKIbs5sBZ+IdDXAS+/O4qwJEyWe+vq9vt+ENM5RzJ6
C8ZMHOQgNJ6FViP/KMIMdKeLapjH+/khMelr0P7XwqENDSEWqRVhltL+w/u8TwZ3
nY5pOrg98pI0ZM6uVlsf+SRels8+MaCrjP8cMQCLzmEgF0Cz+/AnQLa2IkqGXE1d
ldIUAbzr+AwL51Hbpb/V2FJnmQak6K9N0bOf0SmvEcxvB6TFnNLT1WjEj16u5ftK
IV+tJEFCtiJMZRK6wzcOtmOPJ5cmlI9bccehAR6e2q7f5Oe0zGie/+D3qT+fLRAF
oWO7kz6sa6xGveuuMlyw
=Ei/A
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Sep_2013_10_37_50_+1000_OVBi/WgPnGzQwKTU--
