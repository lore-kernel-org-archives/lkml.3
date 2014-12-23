Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaLWGco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 01:32:44 -0500
Received: from ozlabs.org ([103.22.144.67]:56071 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaLWGcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 01:32:42 -0500
Date: Tue, 23 Dec 2014 17:32:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: linux-next: missing merge fix patch for the merge of the
 xen-tip tree with the arm-soc tree
Message-ID: <20141223173234.7c4c45f5@canb.auug.org.au>
In-Reply-To: <CA+55aFwQKe0PvSuYqOeQMM8kouB3mkyQQ=gFMX=bkPx3GxanvA@mail.gmail.com>
References: <20141208184908.27bfd605@canb.auug.org.au>
	<20141208103328.GE27367@arm.com>
	<20141223132605.02d81e01@canb.auug.org.au>
	<CA+55aFwQKe0PvSuYqOeQMM8kouB3mkyQQ=gFMX=bkPx3GxanvA@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/74vVFQ3VyjweQBk_D1gmmF/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/74vVFQ3VyjweQBk_D1gmmF/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 22 Dec 2014 20:09:50 -0800 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Mon, Dec 22, 2014 at 6:26 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> > Hi Linus,
> >
> > I have been carrying this merge fix patch for some time that is now
> > needed in your tree:
>=20
> No, it's not. Look more closely.
>=20
> My merge put the
>=20
>         dev->archdata.dma_coherent =3D coherent;
>=20
> line at the top of the function, like the way it was in the original comm=
it.

Oops, sorry about that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/74vVFQ3VyjweQBk_D1gmmF/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUmQyHAAoJEMDTa8Ir7ZwVJK4QAI6Sto8zHENd4L6S86wn7F9B
Jj3CSvO2A503KTA/Muneq4//PRplt0RZZUP/nDaPSc8ZKjCd+SNxp2vBPZRSUoWh
OtevOroAGAlDvWz2AgF49TVw1ud73AiVgInFSFGmdhPzk47akTe+V4S8q2Yflo+I
b1CC/PvVC1sW36dA3kKZ11EldNzF5AXAu7gHdFNSKB3FAIkar4jaq8tj9x6OBcDZ
9Eo+fWduvEBI4QKBsb9dB1O5Wweon+/29rsEj3J989loYS4aD3Y5hpr+/EVtEPs7
P6mvYmoI4KEhtHWzlFLF7t5/AeCzA/pKmTBiOrlAR5Mnru485jCJb1v+jN8LmwmK
afwcBcEunVQihmETSMX5lBlq4IefrsYYVEoTO0wz04zP3Hd4kyGZVsoiGl48O6Rc
Bnnw7Ke4xyy+4h6PYhTUS0EDloxBlVUfCvm5e87/yJ14sjLnt4CUUXm9gcpwFLp6
o+nS/nfgScKiKXnVk5etNQ9z4Wd96XUJdlAvhX3FcV1/ZaAMzk1HiE0P9XUl76mo
/eB01BmTjH+6hgl3ZnTOH33+s5cZVA0JixX3lvjyeaBvTNHjPhaUwMybkPFeWXzH
HTWyO58H6RKTCVNFsD+vuDHOlgGgU3z28Nlxgmh7/wO15/tOX2f4HbPn6jX1dIN2
7gm/dC6cGmJkf09fzWPo
=phOW
-----END PGP SIGNATURE-----

--Sig_/74vVFQ3VyjweQBk_D1gmmF/--
