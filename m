Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaKWEm6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 23:42:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45666 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbaKWEm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 23:42:56 -0500
Date: Sat, 22 Nov 2014 22:43:06 -0600
From: Felipe Balbi <balbi@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Alexander Kochetkov <al.kochet@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 2/4] i2c: omap: implement workaround for handling invalid
 BB-bit values
Message-ID: <20141123044306.GA19898@saruman>
Reply-To: <balbi@ti.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416518925-20679-3-git-send-email-al.kochet@gmail.com>
 <20141121160808.GM7508@saruman>
 <20141122132309.GC2679@katana>
 <B6D9B4D7-25CB-456F-88B4-EB6A53E33A9D@gmail.com>
 <20141122180222.GA9698@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <20141122180222.GA9698@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 22, 2014 at 07:02:22PM +0100, Wolfram Sang wrote:
> On Sat, Nov 22, 2014 at 05:06:10PM +0300, Alexander Kochetkov wrote:
> >=20
> > 22 =D0=BD=D0=BE=D1=8F=D0=B1. 2014 =D0=B3., =D0=B2 16:23, Wolfram Sang <=
wsa@the-dreams.de> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
> >=20
> > > Huh, I can't apply this one? Which kernel version is this based on?
> >=20
> > v.3.13-rc8
>=20
> Wow, that's old. Can you please rebase the series on top of 3.18-rc4? Or
> my i2c/for-next? Or at the very least 3.17?
>=20
> @Felipe: With which kernel did you test the series? Also, 3.13?

maybe there was a typo? I tested on v3.18-rc3 :-)


--=20
balbi

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUcWXZAAoJEIaOsuA1yqRE1C0P/iGX6Y9cgqX6v7Z7ypYoL/ck
VWHwwtcmm6qSZjOvin/Xd9LQiiBLlq1AJ61u2bYwQK3PqvYbjUXJobZPs0fBYr1z
tI6TslWLs4C2Yr40TX5mKnhmWZfKaQtItrbrKA18OUhKxH17NIwZHkHh7URJZ+2K
2thnp8aEYYHLMzBoANmIcTN9wsG/xObHSi5qYj5U0l5ltuiIPo4MeCJyQ0QNsSde
wKXpX/YkdF8c6YECTp74VH7d+hSgCwwuTY0vIPOjk2tZHNnj44cFl42ulX+WG0ib
cRbE+HruahgK2kGzYULwaoKLUcEVRV5/jV3mMqhyPQwTokjdRKxZP67vmVsfbBTU
K76XVGK73lSgVNO7/OLKQDLkwGO2Jlg3Fq4x5MmzGkImP0D2nyoM3Zh0h3rHDK24
RCmqkcyuslHUNQO78WZvYzPFZHavUibm1yTQfgezcJt3LW+gnv2cxVkALwdLToae
YLsezKdAULXQkNHodLSg2Xw/K5H0zGMm9Vc0Z/19eTda4G5JpH63dy1V/nfvfC8E
C6z3Q2UkMIZa6kt/u6Rwgwn2kYVW6lZ3L+WcMIZ0Ah1omF9Ty5D9WvKhjgWyZU7k
gDKyrmAcrrR8ly7+idlD+gU7+VgwUiHjLcMdr7L8umAB6KxkkNEOTbVppCPnhW5Y
CvI4RAFX+Hzyorx5GFEX
=nLGk
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
