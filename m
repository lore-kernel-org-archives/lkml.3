Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbaKSX34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:29:56 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37339 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbaKSX3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:29:52 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 0/7] Fixes for ALPS trackstick
Date: Thu, 20 Nov 2014 00:29:49 +0100
User-Agent: KMail/1.13.7 (Linux/3.17.0-031700rc6-generic; KDE/4.14.1; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Vadim Klishko <vadim@cirque.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com> <1541270.g199T8YFIC@dtor-glaptop> <201411170839.17504@pali>
In-Reply-To: <201411170839.17504@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1468653.bjLaFNRBS1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411200029.49547@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1468653.bjLaFNRBS1
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 17 November 2014 08:39:14 Pali Roh=C3=A1r wrote:
> On Friday 14 November 2014 21:59:31 Dmitry Torokhov wrote:
> > Hi Pali,
> >=20
> > On Friday, November 14, 2014 08:38:19 PM Pali Roh=C3=A1r wrote:
> > > This patch series fix detection and identifying trackstick
> > > on machines with ALPS devices. Last patch split trackstick
> > > and bare PS/2 mouse packets between dev2 and dev3 input
> > > devices which make sure that driver will send only
> > > trackstick data to trackstick input device.
> >=20
> > Thank you for splitting the change, unfortunately it is now
> > quite big to apply to 3.18. Any chance you could try
> > implementing what I suggested in
> > http://www.spinics.net/lists/linux-input/msg34029.html and
> > then we can do the more comprehensive solution in 3.19.
> >=20
> > Thanks.
>=20
> Hello, I think that patches 1/7 and 5/7 could do that job. I
> did not tested them alone (without other patches), but if you
> think that two patches are ok for 3.18 & stable I can test
> them...

Dmitry, ping.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1468653.bjLaFNRBS1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlRtJ+0ACgkQi/DJPQPkQ1IB8QCfaIZtGjyfWSYGCYe1NR6UMTvd
LR0An3kFbFR+MffcNTFxWgVuzOtUVr8M
=BwJL
-----END PGP SIGNATURE-----

--nextPart1468653.bjLaFNRBS1--
