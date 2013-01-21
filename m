Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab3AUHDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:03:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59521 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3AUHDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:03:11 -0500
Date: Mon, 21 Jan 2013 08:03:01 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2 1/2] ARM: shmobile: sh73a0: Use generic irqchip_init()
Message-ID: <20130121070301.GB15508@avionic-0098.adnet.avionic-design.de>
References: <1358493373-28722-1-git-send-email-thierry.reding@avionic-design.de>
 <20130121005439.GF19062@verge.net.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <20130121005439.GF19062@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:2Gs5YRcw1BLUXXc/TdqJ6DFJdbRpAMsrnYFxRgMJAeH
 twQmEq6c6aoZwDfZHokiaq56BRGwqR1Bfi/Z3NvgQNLnoYpJFj
 89ZC0KqlqRobqUdPZH2YHHpUXL6+vgF/gupNi7c7ORrthlzt+B
 j9vwsmHPTmOX7E1IR4UVEjir0h7NUTrzE+hMBRPsnRS28hbWQW
 T1S+uqZFba0azdg/lTtKZWmPhUlAS0S5OXkf20GJRb+dT5cUsL
 fmnEKiB+by1j8rGEcOBQhNhx87WvWxyy0IigwpxnfRSGSnVmti
 ssfra7uTKT2IGWE+A+vedGls0V3MOB/UHv6uUk/1jhs2VnQy9R
 OwakkPt1DXJYRnJx8A5njs7WLWimgfCNfCrvaHlZ6tceqbI3nj
 OmLCNr5CrMqK5YL0hyvHgPaq7lQJgXeAu5EeiqYv/7NNzKBTBT
 YuYPF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 09:54:39AM +0900, Simon Horman wrote:
> On Fri, Jan 18, 2013 at 08:16:12AM +0100, Thierry Reding wrote:
> > The asm/hardware/gic.h header does no longer exist and the corresponding
> > functionality was moved to linux/irqchip.h and linux/irqchip/arm-gic.h
> > respectively. gic_handle_irq() and of_irq_init() are no longer available
> > either and have been replaced by irqchip_init().
>=20
> asm/hardware/gic.h Seems to still exist in Linus's tree.
> Could you let me know which tree of which branch I should depend on
> in order to apply this change?

I found this when doing an automated build over all ARM defconfigs on
linux-next.

Commit 520f7bd73354f003a9a59937b28e4903d985c420 "irqchip: Move ARM gic.h
to include/linux/irqchip/arm-gic.h" moved the file and was merged
through Olof Johansson's next/cleanup and for-next branches.

Adding Olof on Cc since I'm not quite sure myself about how this is
handled.

Thierry

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/OglAAoJEN0jrNd/PrOh4cYP+wQwC94qxtul2hK6Zpcn3Ib5
Ko/yqqvcRc9tXDEJmuKGfsZ7liT0pTHlBgIyJqYPh1vZ9jjkAAalrj+F/3DliVrU
hfITcHR8IGfBDh7SQMuHZ4IZBUdbOQgQaDpJqb7X6jQ00yA1/8BrvokUb7kVC2+5
y/3w7NMgiIX24W70kdpb7qPjMu4qz0yw79XlkuMsFBQCAhc6iZUYnllWlOAHDJzG
3hdZWMFn/pTncrCHpEY4uqghKESm6QmkjdK5y4zQspdbSnc3/3xNhBmbjIiXi3b1
cRDkwPcHSD1e1AkyGh4c18mbDBQZmegx6scs4xm9ogx0aHLwa2350FD8qR49N0Ew
OkpoVKuUzcHqvb1Z9qhIqsN2E+pdu4AEuWVIjyatB4QbF1ENTaWrCliEiX6Vphd4
aZH52BAW2SW60dl/1/Nij9yKYoxE+3BdfdpF7ek8BgML9HoF1zGHWn+n8rBdcu4L
Chb8aOx210hRcvLLSdmrQsrHfmsM5BDyBZXwseQ52fcrfE6bEDeQv5qOFE9Jo/8l
SIXUYDqzar+NQ3roepFHpRi2TH5GGoXOE9VGR1l9MCutljHF6I8Rc4XNp9oezukz
PVMFxuHlegDkFmKYDNkAE4B5jWXOnv91r+cftj87SwbshofcKxJSzlMN5/c0IcpK
gAQQAsi3eVMyF80uJIiI
=xr2d
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
