Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab3DXMYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:24:09 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55655 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758253Ab3DXMYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:24:03 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] RX-51: Fix probe order of SPI devices
Date: Wed, 24 Apr 2013 14:23:58 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.0-rc4+uvd+synaptics-generic; KDE/4.10.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@debian.org>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joni Lapilainen <joni.lapilainen@gmail.com>
References: <1364724561-18045-1-git-send-email-pali.rohar@gmail.com> <201304101615.19400@pali> <20130410170001.GY10155@atomide.com>
In-Reply-To: <20130410170001.GY10155@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2642373.QS0rev7zdg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201304241423.58635@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2642373.QS0rev7zdg
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 10 April 2013 19:00:05 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130410 07:20]:
> > On Tuesday 02 April 2013 18:31:38 Tony Lindgren wrote:
> > > * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130331 04:23]:
> > > > On Sunday 31 March 2013 12:52:23 Sebastian Reichel wrote:
> > > > > On Sun, Mar 31, 2013 at 12:09:21PM +0200, Pali Roh=C3=A1r=20
wrote:
> > > > > > From: Joni Lapilainen <joni.lapilainen@gmail.com>
> > > > > >=20
> > > > > > Without this patch LCD panel on Nokia RX-51 is still
> > > > > > black
> > > > > >=20
> > > > > > Signed-off-by: Joni Lapilainen
> > > > > > <joni.lapilainen@gmail.com> Signed-off-by: Pali
> > > > > > Roh=C3=A1r <pali.rohar@gmail.com>
> > > > >=20
> > > > > Tested-by: Sebastian Reichel <sre@debian.org>
> > > > >=20
> > > > > Please note, that this patch has actually been
> > > > > proposed by Aaro Koskinen <aaro.koskinen@iki.fi>
> > > > > quite some time ago [0].
> > > > >=20
> > > > > [0]
> > > > > http://permalink.gmane.org/gmane.linux.ports.arm.omap/
> > > > > 8172 9
> > > > >=20
> > > > > -- Sebastian
> > > >=20
> > > > CCing Aaro.
> > >=20
> > > Any ideas why this is happening?
> > >=20
> > > Is the touch screen controller somehow pulling one of the
> > > SPI lines before it's reset? I don't think there's any
> > > other connection between the LCD and touch controller
> > > besides the SPI lines?
> > >=20
> > > In any case there should be something in the description
> > > why this is needed..
> > >=20
> > > Regards,
> > >=20
> > > Tony
> >=20
> > Hi Tony, look at this Aaro's email:
> > http://permalink.gmane.org/gmane.linux.ports.arm.omap/81729
>=20
> OK can we have that summarized in the patch description
> please?
>=20
> Regards,
>=20
> Tony

Aaro, this patch is yours, can you resend it with description?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2642373.QS0rev7zdg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlF3zt4ACgkQi/DJPQPkQ1KbQACgmcBaUvMsGHe0hn+mlWlJP/PK
w68AnRMiCCRO784KIirkiqOrwq0qpiJI
=COqc
-----END PGP SIGNATURE-----

--nextPart2642373.QS0rev7zdg--
