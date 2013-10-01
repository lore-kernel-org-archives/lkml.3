Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab3JAN6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:58:55 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46120 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab3JAN6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:58:53 -0400
Date: Tue, 1 Oct 2013 08:58:38 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: Robert Baldyga <r.baldyga@samsung.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>
Subject: Re: [PATCH v2] USB: gadget: f_fs: fix error handling
Message-ID: <20131001135838.GP1476@radagast>
Reply-To: <balbi@ti.com>
References: <1380534101-23956-1-git-send-email-r.baldyga@samsung.com>
 <xa1teh868r5q.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kLVKJMuKEUFaIs8+"
Content-Disposition: inline
In-Reply-To: <xa1teh868r5q.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kLVKJMuKEUFaIs8+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 30, 2013 at 01:50:25PM +0200, Michal Nazarewicz wrote:
> On Mon, Sep 30 2013, Robert Baldyga wrote:
> > Hello,
> >
> > This is update for my patch fixing error handling in functionfs module.
> > I have fixed typos from previous version, and changed description for g=
reater
> > clearity as Sergei Shtylyov suggested.
> >
> > This patch add missing error check in ffs_func_bind() function, after
> > ffs_do_descs() function call for high speed descriptors. Without this c=
heck
> > it's possible that the module will try to dereference incorrect pointer.
> >
> > Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>=20
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
>=20
> > Changelog:
> >
> > v2:
> > - fix typos
> > - expand patch desctiprion
> >
> > v1: https://lkml.org/lkml/2013/9/27/128
> > ---
>=20
> Note that it's helpful for maintainers to include everything that is not
> meant to go in the commit message after those three minus signs.  This
> way, =E2=80=9Cgit am=E2=80=9D will ignore the text.

right, please resend so I don't have to manually edit. Also, while doing
that, add Michal's Acked-by to the patch.

thanks

--=20
balbi

--kLVKJMuKEUFaIs8+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSStUOAAoJEIaOsuA1yqRE0eoP/RPChriUC0+yv/OYbQZOfawV
2CUnPlsmFfAmfWwZ13/9kL+JHSzQM5zctnhdlZiSqfVvvu5hk0HwE8DOc6R20FBg
N5aJb8BzaxaEBQ+HI7zCdIjSuZWLr6wyet3T7tqsgKrGfa9Bmt8mjwbgo4QHPl2p
0vZc+dDwNFFg8Z5+7OK2tx60gre9WQB/v5gtHfv6jp5uS2i1jHUW72PdjAKFs9C7
XDBmXCqX4fcwPAnXHjl9o96RA5XWtdcjuB5nuhix1jPdzot4Wqv1P5ilLbPNuICT
1nMwVxNYOlBIDgKMY480yjHyQfRwR3DsmEI/1hAO4Y93oQHZStXsrR5tBMQwQIhI
vJo7xH6UqxqsW7+rKsU0izZa1gcV/p+A9mQnbwmiqXUcOeomCSLt3v1YGHWZiC9G
zSnfqEJhL4uZMEbg693KNAFNK2BoALQtfn7NFAiEhmikqXOCp74eqiiqSUc+24Qy
Y8g+MQNkklZpShD+6cL+Wex/Ef/HYNR8SQ2mOlKzAvIhvSR7iOtLMVWkGqaBtovE
38LZRs6FFLU9nJkk1Qu+tid0Lds07bY/wNC6Xh/rBz/bV6JLjWg1blvWXteh8Zgc
vWQZ5UB6lPMty1uTUfO77C9COyRZaXGIw8s4olkCCGEU2mFxqdtyxVdIfB8QErPO
m+cNWUh4HthwryS5ftgs
=ieho
-----END PGP SIGNATURE-----

--kLVKJMuKEUFaIs8+--
