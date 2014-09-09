Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbaIIPEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:04:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58433 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012AbaIIPEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:04:43 -0400
Date: Tue, 9 Sep 2014 10:04:26 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 1/3] usb: gadget: f_fs: fix the redundant ep files
 problem
Message-ID: <20140909150425.GK6151@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410243797-9719-1-git-send-email-r.baldyga@samsung.com>
 <1410243797-9719-2-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z9t8O/5YJLB6LEUl"
Content-Disposition: inline
In-Reply-To: <1410243797-9719-2-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Z9t8O/5YJLB6LEUl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 08:23:15AM +0200, Robert Baldyga wrote:
> Up to now, when endpoint addresses in descriptors were non-consecutive,
> there were created redundant files, which could cause problems in kernel,
> when user tried to read/write to them. It was result of fact that maximum
> endpoint address was taken as total number of endpoints in funciton.
>=20
> This patch adds endpoint descriptors counting and storing their addresses
> in eps_addrmap to verify their cohesion in each speed.
>=20
> Endpoint address map would be also useful for further features, just like
> vitual endpoint address mapping.
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

This is a fix, which sits in my 'fixes' branch. You can't include it
here. This series should be rebased on top of my 'next' but it should
not include any fixes, only new code.

This is why we generally ask people to split the series up into fixes
and new code and not make them depend on each other. You need to
remember that, rather frequently, my 'next' branch is based off of -rc1.

I only merge an -rc back into my 'next' when the conflicts start to
become non-trivial because of all the dependencies people add :-)

I'll see if I can fix this up myself, but if I can't, then we either
postpone this series to v3.19 or you get it done properly and without
any cross-dependencies :-)

cheers

--=20
balbi

--Z9t8O/5YJLB6LEUl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDxb5AAoJEIaOsuA1yqREi9kQALM93hYjPchlg5GDFUnQrj2j
UrdXIIerThpAVfwW2iILVVttnZdr31+POeiDodt+7Z50AbNlWx155jVHp+71+h6W
bM5fwkMAJ9JJ8tYsZUu3TVTolQYEPFANEIrkToZtNlEe46DKptQq21ett04Fj+++
amfgQm4nG5K5iOwb0pMDlBvsvq3aPA1R/7bnNDihgYDq9kZvxZbskDfDIXa93ee7
QTpwQkjdjrT5aBP66DjczAYcTLxQ7ctinungdY7XHtHlUQP2+rD6jLjT5gQsukbe
9CoERH/W1fuavVhsvCcUxhxFktpgpVzl1Jpn8JUx9i6bF/cbpu5QTchMs2l68um+
4hva/ZQDvDNgSDIMCk4ZEcJFJVNxqnLFeEOycxZDpZWsgE9cJHPFH4gn4l4yJY0P
1RUZXiweyVumwm2ZKwNrWQ2UdBrwJx6dBps9Td9vau6TblN0umHqKSOrzbEUlRHl
eVfY1S+r7LO+OOnXunbvaqm9CjbqmDMB8FUXTbHsK4rv/w6oGUy8IfvB7948rEqu
Wg+jTb7KzUVejta0zxeBafIbL+ACeuUL2YO9L710jllNZ0Hdb5VWQcNsGwC8GX1v
frrWZUQI4FAVlUnVnSq6LvPwRHyBRU5LoQoNC6GIHnT+dvF51T89pVOyV7aGk9am
RFVvXrX2O1631BPx/8w5
=LhKV
-----END PGP SIGNATURE-----

--Z9t8O/5YJLB6LEUl--
