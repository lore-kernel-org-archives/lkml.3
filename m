Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbaAJBzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 20:55:55 -0500
Received: from ozlabs.org ([203.10.76.45]:40968 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaAJBzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 20:55:52 -0500
Date: Fri, 10 Jan 2014 12:55:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>
Cc: linux-sh@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Paul Mundt <lethal@linux-sh.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bastian Hecht <hechtb@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: Re: linux-next: manual merge of the sh tree with the tree
Message-Id: <20140110125529.9843f450bf79223164031b02@canb.auug.org.au>
In-Reply-To: <20140110004724.GA22965@verge.net.au>
References: <20140106121317.bada4233ec3fec40f79735cc@canb.auug.org.au>
	<CAOesGMgJe9KR2muA4F9EaXYpDFDLxVZsKOj-8qZFbDZTiRBuww@mail.gmail.com>
	<20140110004724.GA22965@verge.net.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__10_Jan_2014_12_55_29_+1100_SvavUGTAcUyLk69d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Jan_2014_12_55_29_+1100_SvavUGTAcUyLk69d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 10 Jan 2014 09:47:24 +0900 Simon Horman <horms@verge.net.au> wrote:
>
> On Wed, Jan 08, 2014 at 11:11:03PM -0800, Olof Johansson wrote:
> >
> > The request to merge the sh code came through Simon with claimed
> > agreement from SH maintainers to do so -- I didn't verify this since
> > they have in the past been well-coordinated. Simon?
>=20
> I spoke with Paul recently and my understanding is that
> he hasn't been actively working in this area for over a year now.
>=20
> I guess there are some stale patches in his tree.

That is certainly what it looks like.  So, do I remove the sh{,.-current)
trees (git://github.com/pmundt/linux-sh.git#sh-{latest,fixes-for-linus})
from linux-next permanently?  Will it be cleaned up any time soon?

Is anyone maintaining/supporting sh now?  Is it a candidate for pruning?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__10_Jan_2014_12_55_29_+1100_SvavUGTAcUyLk69d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSz1MWAAoJEMDTa8Ir7ZwVnpIP/A+iKbAeswNZaczDSBECksLB
52GnN8weDyFm6xgh3TnlQVK5ud5PJZWN/bG3d8IQaPTNWNXnqF8GGEVNzeNQ5mFT
XPZ1voH143P3cFa8k9SYgRBuva8qWVlgaxAcM7dvoC2tUCOQ7FL9/pO0iMpDRjUk
xoKGJpzxsHcbxyb30c07q75KHO4Z135jep0kOzc+GMSi5z6xhrtsOhX3AqIsGRC7
8zu3OBsQmRHlEwRJhBR+mcXNdHn5dSOYj/HBC5LoqSj+3WWyvG2aoXslirzBe2P1
bZPXBnX8F4WtKGb2zliQ37rhBE/pzaPRkxlVwC7t1UE275P2PCXuea58SqTi3VD3
KluF2EfQNF3EDaukJ4s3nRjsLdJmCVwoiEAP2N6acI8WrmVxQUd8D5TJe+NVg9T9
TbXtGpIrP6O2ocAXWZ1v8QKotXmg9Rh09nSeMihbaDGY7vl37StD0OKlJ9u/FAZh
bPiZb9k3GG+E0WIBume0BKxFPnOEcnnMp/F6R0B/ZuM8w42NIg5tKtb6pYet/d6u
j5iyRlbqvKsYSnHo459IETP+zUXTHhcW45PdSC2hTKT90Iu38SORe4bFnXOLjO2R
9FUt9cNzZmGz0PMTYo/nV2jIl2V73EqZd1fI08q7bTr4CmtWvc34PfMcD7GpeUpC
MLjs4xlUrT8pFfkQ3jcJ
=KM7E
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Jan_2014_12_55_29_+1100_SvavUGTAcUyLk69d--
