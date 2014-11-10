Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaKJXuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:50:52 -0500
Received: from sauhun.de ([89.238.76.85]:57878 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbaKJXuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:50:51 -0500
Date: Tue, 11 Nov 2014 00:52:05 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fabio Estevam <festevam@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver needs an owner
Message-ID: <20141110235204.GA2914@katana>
References: <CAOMZO5CZ0rzhBquTLp+oo0ddvwy22iz0yE3pyap+wVDT0+oMKQ@mail.gmail.com>
 <20141110234555.GB21278@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20141110234555.GB21278@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Oops, we forgot that for drivers built into the kernel, THIS_MODULE is
> NULL :(
>=20
> Wolfram, want me to revert this patch?

Yes, I sent out the revert a second ago, too. Still wondering why this
did not trigger here... I'll have a look.


--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUYU+kAAoJEBQN5MwUoCm2cHMQAJolYbcuM/guXDGIRvFI4Eec
xaAUNXnC/2uzpvZBV3zOtZJ5ezpGUEDU0uUfOiFa4Gp32uj+sRdpmgxr7VKbuS8f
we85zFtead/sWlOr0nG/2iFHeYwhXFa3kHvm29n6q29F5/RV92TAFrB2J+Zf8xLQ
q6BsWltZVquPCorfdOu7DGRAc/8OCfhtwFo0F99ctWdahO/zodj5Y7NvzTi7r9IA
WKQBs/xbE8v6HlIgtEBTcdiSltr8SSyKaWDr00ABjpP1cay4blP5wjpvzoy1SOLM
1Y+k77OL8O0hMnmHY0qKIvH7PS9vHi2dWap73OteVaQHKc+BNG/y9zIFTlFL5iS3
vLCh5NkL//5WGuUnOkVSMWcnSQ47w7wKnVe1j+j9BetJ4iu2P9Q2RZo4waCIE1IN
qtJIxVvI3D3AANtG8tNVFXRoiDtpB5gis6xnmQ6z5/sRtzaHcUflr3cqqsbxAAJA
dbf+LwIbhBktJM4hZQVmsy6Z3A3k8uLJ0ZHoU4G/daxyXAFvpu/uMaWNvYH5OziY
GV9wefOsegJmnOWFfdne2Qzw41ksej5WjoUFOmWXuirhM6domsCCUkKe4hpBd6XO
7pfhNAcr29r5iMD/Cxs8bQd9ToPD38VIt7MRFaiZ/gOQAjWBVK9fgQ5ZeWWVqFr3
2KQS87HiV4Qm02Ch5ok5
=eEu+
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
