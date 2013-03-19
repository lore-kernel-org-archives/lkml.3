Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118Ab3CSHj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 03:39:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46557 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371Ab3CSHj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 03:39:57 -0400
Date: Tue, 19 Mar 2013 18:39:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <balbi@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xi Wang <xi.wang@gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with the usb-gadget
 tree
Message-Id: <20130319183946.cbec2469b421909f8a5d7695@canb.auug.org.au>
In-Reply-To: <20130319063334.GA16715@arwen.pp.htv.fi>
References: <20130319143922.f60895f782e5c8e9824c447b@canb.auug.org.au>
	<20130319063334.GA16715@arwen.pp.htv.fi>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Mar_2013_18_39_46_+1100_V73cICh7hV34ms9="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Mar_2013_18_39_46_+1100_V73cICh7hV34ms9=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

On Tue, 19 Mar 2013 08:33:34 +0200 Felipe Balbi <balbi@ti.com> wrote:
>
> On Tue, Mar 19, 2013 at 02:39:22PM +1100, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the akpm tree got a conflict in
> > drivers/usb/gadget/amd5536udc.c between commit 6c39d90393a2 ("usb:
> > gadget: amd5536udc: remove unnecessary initializations") from the  tree
>=20
> Looks like there's a small bug in your scripts: "from the  tree" misses
> "usb-gadget".

Yeah, that's one of the bits I have to fill in manually and sometimes I
forget - at least this time I got the Subject right.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__19_Mar_2013_18_39_46_+1100_V73cICh7hV34ms9=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSBZCAAoJEECxmPOUX5FEecMP/iaUJGccw2TMXg75JHNon8pa
F5Aa+yYm0NYZ5fu7DxZu2Tm61QI6OkCBfTA0iVcBasW+c8ErRFi1zgNm8f8j7PTG
BJ9zMtZSqpullAy3Zm0B13GVgEW05jn9VLNrGFx2A9KJciQxkb8hp6gstjjKOTLS
ngUwBP4RJi4bfvPyvGXOfRUKcObru7MAdQiRQ8pQw5nBD/lFT+d/CU6UcbPIUh0i
RyCyqzuOkpy8jNMXMEaUa2Nq+AL9wHKwZXClwsc1nSM/i9RwHgrsNHilehEndUeK
obORceijVZZcagERQEtBdYwjPkGICdIDz0piZdMVUyDa8cXhvQ/nMP8qIG+jUkYs
AZMPj+fUyjsHIyVePuJwslVQAyz1VYWvDSaqUVAOsGt6urovgR163ld2dNbhsBF/
NJEi6eIbP9zQXghX7rcTSKS6fFDbfpNwZzk4DMITkKAMldTVWwL2e86yzDTnZXmP
boLU50p/9D+/LddL70STUxhaEfOVkKiTH3I2Lh/H3VJ5WiG+XRKcgv9tnWD7A2iq
sOX0ULEr4DMZwgmllN/B7YUp0/Dq1pWd/EpOMAdUCSSlbCJOdb2+Zug3u4dds/4d
Bya8DNLdnV4TIBk5CXaVz5L8yIznYABAJ39A2xEe6lLr3xCEP0KTta7yuM6D+vpo
kBwjMzSVk6TccpHQoVkw
=GsGb
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Mar_2013_18_39_46_+1100_V73cICh7hV34ms9=--
