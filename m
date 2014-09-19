Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbaISPiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:38:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:12194 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756392AbaISPiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:38:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,555,1406617200"; 
   d="asc'?scan'208";a="575758073"
Message-ID: <1411141042.2513.3.camel@jtkirshe-mobl>
Subject: Re: [PATCH 5/7] signal: Silence nested-externs warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Richard Weinberger <richard@nod.at>
Cc: sparse@chrisli.org, Mark Rustad <mark.d.rustad@intel.com>,
        linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Brian Norris <computersforpeace@gmail.com>
Date: Fri, 19 Sep 2014 08:37:22 -0700
In-Reply-To: <541C4D57.9050507@nod.at>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <1411140580-20909-6-git-send-email-jeffrey.t.kirsher@intel.com>
	 <541C4D57.9050507@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UpjXBBNZGFIz/2ACVmse"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UpjXBBNZGFIz/2ACVmse
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-09-19 at 17:35 +0200, Richard Weinberger wrote:
> Am 19.09.2014 17:29, schrieb Jeff Kirsher:
> > From: Mark Rustad <mark.d.rustad@intel.com>
> >=20
> > Silence nested-externs warnings for these, as these nested
> > externs are truly wanted.
> >=20
> > CC: Oleg Nesterov <oleg@redhat.com>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: Geert Uytterhoeven <geert@linux-m68k.org>
> > CC: Richard Weinberger <richard@nod.at>
> > CC: Brian Norris <computersforpeace@gmail.com>
> > Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > ---
> >  include/linux/signal.h | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >=20
> > diff --git a/include/linux/signal.h b/include/linux/signal.h
> > index 750196f..e68ae6b 100644
> > --- a/include/linux/signal.h
> > +++ b/include/linux/signal.h
> > @@ -67,7 +67,9 @@ static inline int sigismember(sigset_t *set, int _sig=
)
> > =20
> >  static inline int sigisemptyset(sigset_t *set)
> >  {
> > +	DIAG_PUSH DIAG_IGNORE(nested-externs)
>=20
> Do we really want to clutter the source with such tags?
> Does this even build? i.e. how does gcc know to ignore that?
>=20
> rw@azrael:~/linux (ubi-wlcrash $)> git grep DIAG_PUSH | wc -l
> 0
>=20
> Thanks,
> //richard

See patch 1 of the series.

--=-UpjXBBNZGFIz/2ACVmse
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUHE2yAAoJEOVv75VaS+3O134P/R4Dj5kmTy/h9SzTbOb4ioct
suvJZrWiSLBs7U/sa55iwgW/HuRjdFwuzo4Ufv9xPIL/PtSi1igmj3sEPjmf2eMc
Kvv8ipXJ+T1408MOJyHZ5tqW3kF+dRJ3hBhA/VgEJzykP9SF4jkwCR5rVgBfx4sf
xRkFCJA2gPVNRomCA76rgGN6tzKWGTRzt+ztZRGKdjeDvdf3LnqexNtbxIOGJFNp
RycMGNplTqd23dx1KbnI5To+FaVd/UbgAd6f0L+Mj9Y9VnmhBBMDeXawn2qeqRRZ
mN86djJ3r/kctB56+xnS7ElDoJgBQTMUEX1ESLrGBIp7smqOvA7QgNObu4rosQNE
XTfi5G73XOtRss9UJ/j0ojP6OOAqsqqmlAl/pvnlDA7Tcrg6hIC9OInstNAejk8N
St2j2GUu0pNl7Jakv0afcEji1IZgfTHTC2sTGfJVypDgpB1rk89wZmYTEAejFWjc
tcSKcMEXqkwZhyHBOqCyRYzT+LflrpV4arBe8WGGPh802ASgqclYc3ut+dIkUYB6
ZhysyQBzINqW1U4/H5kq1iBknNODzwoJXkoGU0Z/YnAgUdJlk7CHDlWcGU7E5yar
pr99YxsbCnbCaCEoNMntZlpkb2WUVX2x5sjQ+f6NNKpGrkXA4d674gVhNXXXRTze
hMbcU7aV5ls1mppgOmnO
=kaEw
-----END PGP SIGNATURE-----

--=-UpjXBBNZGFIz/2ACVmse--

