Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab3J1Hex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 03:34:53 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:49677 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab3J1Hev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 03:34:51 -0400
Date: Mon, 28 Oct 2013 08:34:46 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>, Mark Salter <msalter@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the c6x tree
Message-ID: <20131028073446.GB6629@ulmo.nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <1382706224-8859-1-git-send-email-treding@nvidia.com>
 <20131026131938.GT16735@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <20131026131938.GT16735@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 26, 2013 at 02:19:38PM +0100, Russell King - ARM Linux wrote:
> On Fri, Oct 25, 2013 at 03:03:39PM +0200, Thierry Reding wrote:
> > diff --cc arch/arm/Kconfig
> > index c06647d,7db8abe0..b6a708e
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@@ -5,7 -5,7 +5,8 @@@ config AR
> >   	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
> >   	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
> >   	select ARCH_HAVE_CUSTOM_GPIO_H
> >  +	select ARCH_USE_CMPXCHG_LOCKREF
> > + 	select ARCH_MIGHT_HAVE_PC_PARPORT
> >   	select ARCH_WANT_IPC_PARSE_VERSION
>=20
> Thanks.  Generally we want these things to be arranged alphabetically to
> reduce the longer term chances of hitting merge conflicts, but in this
> case it wouldn't make any difference.

I was aiming for alphabetical order... guess I need to revisit my ABCs.

Thierry

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSbhOWAAoJEN0jrNd/PrOh+7kQALb+ksrdhjNtYs56DmDp50qO
4ZL7e4SN0WrLJMxu8HE1mLY8+kBByz7IccJkRsnZ9WyfjysdT/3zPw1F7zUJta4f
YQv7tqLwl+O72Le56pWEymN1eQmtBin7srJmx6TsdjTHyFs42ZN0RxLf9H+yfcOc
wCa1XKYC2D4/6Skcm1WKThM05Jbe5lda8dvAzvRploS6jBziJtb7frcZUmSnt2qf
qBHlNRgXOHKvKZi89wD1NWT+Rqbbi6czDLnQb/ThowGZa6iMKi/Ms7Rd0b0lGew3
4F+hKhrI0iRCwdwbaJ2UeAVKie/TcK0vOtQt+NQbkABlHHQwgdvrC/U5N3Uol08J
FMFiAQ2oCYFbrlZ/UtLjnxLfN+yYaspoefxDnKfj2+tMhV3lmPgoBrG6IP/Zu7eM
qqVhRLtGgtITPumlWH1guxEQ5rBKjRAGipaHY1P3Gxn275hatsMxYVPZ/LqyWy/h
5ferH+nllpDRun24cSf+xhAuEF0Zjet8iHmnND0HsrHKEWP2zDStdLDeqGPiDZ7z
Tv9o2chiA6DlOATOoGztOGrtuSszUbCWt6qIOu8dc0hmoVgf3fnW861fUbatWUmT
O3qFzhhUnAbDH4m3mDiy9ExMEez114MMusPicEKD0T9J6+nDj7Dn8/7ATZ+tPWet
rB2Dt3FXR3GBSLmfHmz8
=Mtng
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
