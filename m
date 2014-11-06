Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaKFFCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:02:16 -0500
Received: from ozlabs.org ([103.22.144.67]:48853 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaKFFCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:02:13 -0500
Date: Thu, 6 Nov 2014 16:02:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: linux-next: manual merge of the usb tree with the usb.current
 tree
Message-ID: <20141106160203.244759be@canb.auug.org.au>
In-Reply-To: <20141106021934.GB17253@kroah.com>
References: <20141105151825.26c53948@canb.auug.org.au>
	<20141105043030.GB10613@kroah.com>
	<1415176413.20372.206.camel@x220>
	<20141106021934.GB17253@kroah.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/JCUwSS/MkDJoraWT4eyKVzn"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/JCUwSS/MkDJoraWT4eyKVzn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 5 Nov 2014 18:19:34 -0800 Greg KH <greg@kroah.com> wrote:
>
> On Wed, Nov 05, 2014 at 09:33:33AM +0100, Paul Bolle wrote:
> > On Tue, 2014-11-04 at 20:30 -0800, Greg KH wrote:
> > > On Wed, Nov 05, 2014 at 03:18:25PM +1100, Stephen Rothwell wrote:=20
> > > > Today's linux-next merge of the usb tree got a conflict in
> > > > drivers/usb/host/Kconfig between commit cd6e245a2d06 ("usb: Remove
> > > > references to non-existent PLAT_S5P symbol") from the usb.current t=
ree
> > > > and commit dd3cf17488b1 ("usb: host: Remove optional dependencies on
> > > > PLAT_S5P") from the usb tree.
> > > >=20
> > > > I fixed it up (I used the usb tree version) and can carry the fix as
> > > > necessary (no action is required).
> > >=20
> > > That's the correct fix, thanks for doing that.
> >=20
> > Shouldn't that be the other way round?
>=20
> Sorry, you are right, I read the merge backwards.

OK, I did that in today'y tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/JCUwSS/MkDJoraWT4eyKVzn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWwDQAAoJEMDTa8Ir7ZwV2noQAILkwtWqadLDRQw7QzOX7AMH
O2I6fdJNsFMkgyDlFpHbQJDuOuLT0o/jAMj2Ci2gPPpE+2AYsJ1dU+HBgbPAZPaq
b6qZoAneSBy2eekiG1yd9LAKWUXA9GoC6uULR4IDYztidWmKvLqx0KRMCTTy9Btx
mKAaGdyzXtxeryCGEOtUc0rheeiSX2dJL5xHorQdHD2ASjjSLWK8MZ8AU09ncvwO
5kPKZelgam2cKiH7DHIqY3L50P88rRTPbVdIt7s/wX7A6zltHu7RBeCRSmnpsVZm
nx8xnkjeSKGFrsNRYHxos5u3qeuO/hlSkdf17tCPe4OYfwUPaA1MY2fEjNNcL99R
vDsweprV3ZGjBZp/xfm2tV6cBWKEVyTQMRODNSbS3pWnsmzlXwPR/ZjMLd2rgblg
rAgluBIcSMwDKUoSIVyy6NIccnO3GrVroyn4Jq1mQ7vd0iZeK7sA2gUPvmNRABuV
x3xzramXrhyVSOQoXY+/BDnd7pJpQ/IJ2gop37fvRjwafr83NDUwBqAkpTg2Dg6v
l1dKrCqAWGqtRJG1PiBaaqMSYuku5NJkxQeIfzRT+iAwZHtMsg5lc/5RSHwJQbpF
JTAvVyYDFOHGYG4FTORICXRSuM8ZO1o4FwjWmcQt9MeCl0BGVkeIHAn9E6t8qew5
H5I7LeH6jHJRPiIvPaT7
=TQ+c
-----END PGP SIGNATURE-----

--Sig_/JCUwSS/MkDJoraWT4eyKVzn--
