Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3ANPPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 10:15:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:51976 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461Ab3ANPPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 10:15:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,468,1355126400"; 
   d="asc'?scan'208";a="276659674"
Date: Mon, 14 Jan 2013 17:16:41 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-mips@linux-mips.org, Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: 3.8-rc1 build failure with MIPS/SPARSEMEM
Message-ID: <20130114151641.GA17996@otc-wbsnb-06>
References: <20121222122757.GB6847@blackmetal.musicnaut.iki.fi>
 <20121226003434.GA27760@otc-wbsnb-06>
 <20121227121607.GA7097@blackmetal.musicnaut.iki.fi>
 <20121230103850.GA5424@otc-wbsnb-06>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20121230103850.GA5424@otc-wbsnb-06>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 30, 2012 at 12:38:50PM +0200, Kirill A. Shutemov wrote:
> On Thu, Dec 27, 2012 at 02:16:07PM +0200, Aaro Koskinen wrote:
> > Hi,
> >=20
> > On Wed, Dec 26, 2012 at 02:34:35AM +0200, Kirill A. Shutemov wrote:
> > > On MIPS if SPARSEMEM is enabled we've got this:
> > >=20
> > > In file included from /home/kas/git/public/linux/arch/mips/include/as=
m/pgtable.h:552,
> > >                  from include/linux/mm.h:44,
> > >                  from arch/mips/kernel/asm-offsets.c:14:
> > > include/asm-generic/pgtable.h: In function =E2=80=98my_zero_pfn=E2=80=
=99:
> > > include/asm-generic/pgtable.h:466: error: implicit declaration of fun=
ction =E2=80=98page_to_section=E2=80=99
> > > In file included from arch/mips/kernel/asm-offsets.c:14:
> > > include/linux/mm.h: At top level:
> > > include/linux/mm.h:738: error: conflicting types for =E2=80=98page_to=
_section=E2=80=99
> > > include/asm-generic/pgtable.h:466: note: previous implicit declaratio=
n of =E2=80=98page_to_section=E2=80=99 was here
> > >=20
> > > Due header files inter-dependencies, the only way I see to fix it is
> > > convert my_zero_pfn() for __HAVE_COLOR_ZERO_PAGE to macros.
> > >=20
> > > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> >=20
> > Thanks, this works.
> >=20
> > Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
>=20
> Andrew, could you take the patch?

ping?

--=20
 Kirill A. Shutemov

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9CFZAAoJEAd+omnVudOMbdUP/24tVWl2QDuay6OFsj6muPt+
fyeM0Rjl+vwOi3UaIz5Xhckf7mVJEE1P/xMkxL2GLf8anJL4fRxrYDE30phPOuOz
YRQ4xGEDzjmfHNLQJgzgUdbcM03RwNazwteFYOHh67/Ag8CkPDUEqWgd/cmDjeKy
Q/DFpxuqrVmgRQ0Mekei5vMGDd/k05piDgGzglsORTcAKxmFTH8R7XA8TtX7VzyN
xI1+TA1hnGbS2lYJVNsoB1Q7FQUSHri06RtBzC8lbk5NDqrrNdilKqwZomuCPwuz
9Qbaiht0+LoVbipPylAspJpJ+wNMCLE7UpGsfwB326Y/io/1lW9D4UAWgYzIVcNw
o48a9v7C8GA0K5VWQg6Ps2t8FsRPsDDIE0asTp6w3yLhrwlvgl46kD5wVlXQDww9
C0CKqV4UYLkyhmK6vHsoH9E9+pgsg420Xd9B7bPmoMOQVshtor9PyMnqNT500v3W
feefsvorH+gDacvIzpHVd685dgi2EcGrNFv3St+qOlMUUJ7STBP8+WF7J8SpTY7/
4OqTyavnLuAwYoQ7fri5S7pBITAPLCrcBe4oIKWFY9d5l6hsCokeMka8en1LBimA
fGaI9i9dOim+aCKbMrCj4Lg18HIxJ45pAfoGnuvoRasslyFW8NhkIClQVI/gbmUq
LFUita7qoobzjt4YCPG7
=M1Vh
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
