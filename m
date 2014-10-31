Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbaJaIPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:15:11 -0400
Received: from down.free-electrons.com ([37.187.137.238]:40556 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752297AbaJaIPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:15:03 -0400
Date: Fri, 31 Oct 2014 09:13:23 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, davem@davemloft.net, grant.likely@linaro.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com,
        mchehab@osg.samsung.com, crope@iki.fi, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security System crypto
 accelerator
Message-ID: <20141031081323.GS21251@lukather>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
 <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com>
 <20141021191149.GQ21108@lukather>
 <544A9FEA.6020304@gmail.com>
 <20141030171933.GR21251@lukather>
 <20141031072030.GA7563@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="owPIoVL9FiqC4k42"
Content-Disposition: inline
In-Reply-To: <20141031072030.GA7563@gondor.apana.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--owPIoVL9FiqC4k42
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2014 at 03:20:30PM +0800, Herbert Xu wrote:
> On Thu, Oct 30, 2014 at 06:19:33PM +0100, Maxime Ripard wrote:
> >
> > > With AF_ALG and cryptodev, the SG is in highmem. Verified with some
> > > PageHighMem().
> >=20
> > Then fix AF_ALG and cryptodev, because all of the other drivers might
> > be affected.
>=20
> No it's the driver that needs to be fixed.  Of course if there
> are enough drivers it may be worthwhile adding either copying or
> a software fallback for highmem requests.

I don't understand here. Why would other drivers *not* being affected?

If the scatter list passed by AF_ALG can be in highmem, I guess it's
the case for every driver out there. Almost every kernel code I've
seen so far makes the assumption that the memory it has is mapped and
accessible.

Somehow, it's the driver's fault now, and not the part of kernel that
actually does the allocation?

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--owPIoVL9FiqC4k42
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUU0SjAAoJEBx+YmzsjxAgc0oP/Akx+HiU2vyi+QPmjZdlLPb0
o/iaSamNfISpdhFlFa6yYebY/r6g2IOhMkXuAB9h8SBHCLkgR8PnUw9P1F/Xj3rW
RlLAH9T8uC9ldl2paP2YOGzhQCDAkkxHJdmkakcyKu8CnQ2bfFOqtuayDl3otC3h
mq+kYiSB/i5bQsGG8gwMlys0TO61xFhvoElOVWr0IhuhQ3oAL8taCGvs5XHCxew+
Okfm/E1mJ1/3rfIZ5NyTQU8SrwRfppoS9FtK0D08dCpxez+d5313USyw26HwySRR
LYSSpMbFWfuz95ZbXE1hpZbbCW8fjYezzG6EzIfXScvWRC9NRTfHlBWqfgyfC5fg
zvW9XwshH0sx59uQ6q8c5nZNugPmqymbwhX6ARqk9EEbEUGUg0CbdAHegxaC+dt3
sq3xymGRl7lek/BD3R5Xoumc4JP9fSuyEzlaNlEMJ7BmpXe46+hv8/BCYx7dpbUT
oCdsLTw7Ob/8np28d1V6MTZ987gjnIhtzctWJqsnRBK0TnnF+Awe9JwnRqhO3VW8
H0CnLUVPbZO9dsLp6QiXSnXhKLS91B8cJj2deO1pChoajU89zU5KdO/9JYb4+7GU
qae9b587nHwaPJumAv/rtM185y3inqJphf9BmYFK/tHdhiWk61z89NC+zTfv1M6+
JNPb0/Mqbiy4KzzTyNR4
=NRk6
-----END PGP SIGNATURE-----

--owPIoVL9FiqC4k42--
