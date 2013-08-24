Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab3HXVyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 17:54:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46736 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab3HXVyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 17:54:38 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Omnikey Cardman 4000: pull in ioctl.h in user header
Date: Sat, 24 Aug 2013 17:54:12 -0400
User-Agent: KMail/1.13.7 (Linux/3.10.6; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, laforge@gnumonks.org
References: <1376676429-3953-1-git-send-email-vapier@gentoo.org> <20130822155545.e263454227265e049f58f6a3@linux-foundation.org>
In-Reply-To: <20130822155545.e263454227265e049f58f6a3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9780763.JC2Z4JIgkZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201308241754.41626.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9780763.JC2Z4JIgkZ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday 22 August 2013 18:55:45 Andrew Morton wrote:
> On Fri, 16 Aug 2013 14:07:09 -0400 Mike Frysinger wrote:
> > This file uses the ioctl helpers (_IOR/_IOW/etc...), so include ioctl.h
> > for the definitions.
> >=20
> > ...
> >=20
> > --- a/include/uapi/linux/cm4000_cs.h
> > +++ b/include/uapi/linux/cm4000_cs.h
> > @@ -2,6 +2,7 @@
> >  #define _UAPI_CM4000_H_
> > =20
> >  #include <linux/types.h>
> > +#include <linux/ioctl.h>
> >=20
> >  #define	MAX_ATR			33
>=20
> I'm assuming this fixes a build error under unknown circumstances, or
> not, or something else?

yes, it's to fix a build error.  i don't have any specific source packages =
that=20
are known to fail though.  just doing analysis of the headers by grep/eye.
=2Dmike

--nextPart9780763.JC2Z4JIgkZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJSGSuhAAoJEEFjO5/oN/WBobgQAMtrLICwV0eZ+cMuSh9LYhWQ
jASwKlbeTR22gAS4pGRP3oFmJAiwA/c/V8f3xOUOpHwS415mis9EIOG2NLxtphfw
NzlIE5m6V/p5SNNszktTiz7huikdbfTuYhqV6sFTE75Q96hNMDF7JhrAn9xeKUWt
fPKMtwKZ3746TwoRLB9xcrCia91CfF/mIe43KMS1hbKSBgpqLJmjus34Wj83iBME
8Y2gwDWFIZ6NkpN9apRiLN2ZhJz161y+WA1H06kZpM6l/7Jf8kWVnxZ+Z6jAtGMq
EBSP9USF3AeXryBVxMCFPp9Hl4vzQNU5/q8o3QpEgFHZ7/AqvNrZewW5wtD1Mnld
GU5CpQ5HbzXlwS0Fq+yjxEr4Sj9si1f4e62sQbzK6YNV+bEZjJ8pg/lOH09sxbIP
utLZPY1yBsZdFuNO5R04F9zMVj1emBgp08Cf6Pk/5WYxGiQlYfA/xbImRtjyp+y2
BgbsGQnlKm819j1v3S/L4ivyUCWYqWOtDOlG78HvJSULctiEd3dTaDrpX8Tkc+3V
G4SdtxivGuVqNScIcmZ0TeGpy/xsLgfX6MULDXJMcDLWK0l1/ha5AaKttuUW2Xs7
4AeEJ6cuEXhiutCZnPClsirDO9uEAf7ndCcUAXCqJhHUfjsa0E2cM5a8ew8jGQdc
GYHZiyhprV2MOLlFMctZ
=X9mZ
-----END PGP SIGNATURE-----

--nextPart9780763.JC2Z4JIgkZ--
