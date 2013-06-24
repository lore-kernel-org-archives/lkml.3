Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3FXF3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 01:29:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40438 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3FXF3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 01:29:46 -0400
Date: Mon, 24 Jun 2013 15:29:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Suman Anna <s-anna@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the mailbox
 tree
Message-Id: <20130624152930.4c6cef3c5a272d8ca82d94c6@canb.auug.org.au>
In-Reply-To: <51C4703C.10206@ti.com>
References: <20130621162656.bb94e0fa8b6813781b804a73@canb.auug.org.au>
	<CAOesGMjszju75jo6Ej6C=0-rfdPLuEj0mwmU1zYvFvYw1dyQCA@mail.gmail.com>
	<20130621071239.GM5523@atomide.com>
	<201306210936.09593.arnd@arndb.de>
	<51C4703C.10206@ti.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Jun_2013_15_29_30_+1000_7wTGWFdFiz4cQkT."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Jun_2013_15_29_30_+1000_7wTGWFdFiz4cQkT.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 21 Jun 2013 10:24:44 -0500 Suman Anna <s-anna@ti.com> wrote:
>
> On 06/21/2013 02:36 AM, Arnd Bergmann wrote:
> > On Friday 21 June 2013, Tony Lindgren wrote:
> >>> I wonder if this mess is caused by the fact that I did the revert
> >>> instead of rebuilding our for-next and dropping the merge in the first
> >>> place.
> >>>
> >>> I'll rebuild our for-next (or maybe Arnd will beat me to it) before
> >>> next linux-next build, i.e. Sunday night my time.
> >>
> >> Could be, especially if some of the commits are the same in the revert=
ed
> >> branch and newly merged branch as git might think that some merges have
> >> been already resolved the right way earlier.
>=20
> Yes, please drop the particular mailbox branch that you were picking
> into linux-next. It was the previous framework which was dropped at the
> last minute during the 3.10 merge window in favor of new one still under
> its final development steps, so we will not be using any commits from
> that branch.  Sorry for the trouble on this one. The branch that Arnd
> took has some of the OMAP patches reworked in preparation for the
> newer one.

OK, I have removed the mailbox tree for now.  Let me know if you want it
to be back in again.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Jun_2013_15_29_30_+1000_7wTGWFdFiz4cQkT.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRx9k/AAoJEECxmPOUX5FECJMP/23ao125iilRUiraNJfn/lmB
yjFrwZVVp1oCr0vtVnjFsPT+VYWFU0Xuq3h1cRfE/BtOi2tvWFziqAP3DgN1qtQR
+v5Xo8qclGJuUcqXUm8LRwUxyZtr8SpNYq7caxoPGo6hs8RyRqcFXiXAcDKYE0Om
pIyjV1hzAWSNkeRZSUh3yVHsgfjAZF7cNEhSMECCzqERyn0H3J+Wsb/o2wwLrAX4
0RAGBLEv1LMxl2rXEiF/LR9F2TW/lXlarRJ9WWI85viJiYFL7+naN897r89CSDF7
uShcjPCasKYBWk8RvLwjNYOL/Ynih97KrJaTBBesdT5gLuhBAgB3OkwuQ1j4utVO
YW6pzsGr93FVs4GC1RTN9bRFF2ONE3HE16yAntZwTs/xXRsCtjM8ZgL+cvBeSOA6
HJeYGZaBLKW7/H1U4Lq2nd3Ju/giwh5t4PtX0Gu5pVsfsuLzjyxb4gf49tPXVkGs
jo+eDR8F0Exoc4dZKqsWd5GOKfycOfwp6bRCqf2KVJw6zmj9bDtk1+BM8+VRmKnh
7TGooWWOQx9b050OPAnDP7wHKkWbod/CrvgqM6wPUE6zRo7rn5rtbtfHQt4O7jAP
/eKurem28fXSTPIp9N5qDwn6zZMl/j3XlV9byS5AGgtZPlYIWn3GHX1nlJObd/Jg
zInem8vdRxay4QZ4APcd
=5kag
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Jun_2013_15_29_30_+1000_7wTGWFdFiz4cQkT.--
