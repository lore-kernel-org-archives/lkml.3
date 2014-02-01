Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbaBAQuZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 11:50:25 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:43079 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320AbaBAQuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 11:50:22 -0500
Date: Sat, 1 Feb 2014 17:50:17 +0100
From: Henrik Austad <henrik@austad.us>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>, LKML doc <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Gleb Natapov <gleb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        James Bottomley <JBottomley@parallels.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] Documentation cleanup, update 00-INDEX files in
 Documentation/
Message-ID: <20140201165017.GA7901@medea.cisco.com>
References: <1391041675-31683-1-git-send-email-henrik@austad.us>
 <52E9D3EB.1060209@landley.net>
 <20140131142442.8030cf06d1d729c8e3a4541c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <20140131142442.8030cf06d1d729c8e3a4541c@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2014 at 02:24:42PM -0800, Andrew Morton wrote:
> On Wed, 29 Jan 2014 22:24:11 -0600 Rob Landley <rob@landley.net> wrote:
>=20
> > On 01/29/14 18:27, Henrik Austad wrote:
> > > Some of the 00-INDEX files are somewhat outdated and some folders doe=
s not
> > > contain 00-INDEX at all. Only outdated (with the notably exception of
> > > spi) indexes are touched here, the 169 folders without 00-INDEX has n=
ot
> > > been touched.
> > >
> > > This applies to Linus' tip (0e47c969).
> >=20
> > Looks like an improvement.
> >=20
> > Acked-by: Rob Landley <rob@landley.net>
>=20
> Are these 00-INDEX files actually useful?  I've never opened one of
> them in my life.

That depends. They serve as a very nice starting point when you start to=20
dig into a particular part of the kernel. Once you're up and running=20
however, you probably won't need the index-files all that much.

So, I'd say they serve a purpose, but not a major one. For that reason, I=
=20
didn't start adding index-files to those directories that don't have them.=
=20
So, should we start an epic bikeshedding-context and ask "should we scrap=
=20
all 00-INDEX files in Documentation?" ;)

Either way, outdated index-files are pretty stupid, which was my motivation=
=20
for at least keeping them current.

--=20
Henrik Austad


--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlLtJckACgkQ6k5VT6v45ln9xgCg6GS9mw9gDI8N8tr32vsrLcCL
m2MAoLbOOAb6pSBekaLyoXZ9v4a7JkRz
=zIIu
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
