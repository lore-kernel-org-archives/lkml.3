Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3CaLZa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 07:25:30 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:54903 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab3CaLZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 07:25:29 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Subject: Re: [PATCH] RX-51: Fix probe order of SPI devices
Date: Sun, 31 Mar 2013 13:18:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
References: <1364724561-18045-1-git-send-email-pali.rohar@gmail.com> <20130331105222.GA22426@earth.universe>
In-Reply-To: <20130331105222.GA22426@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2903223.bUCHxYMm0J";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303311318.41846@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2903223.bUCHxYMm0J
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 31 March 2013 12:52:23 Sebastian Reichel wrote:
> On Sun, Mar 31, 2013 at 12:09:21PM +0200, Pali Roh=C3=A1r wrote:
> > From: Joni Lapilainen <joni.lapilainen@gmail.com>
> >=20
> > Without this patch LCD panel on Nokia RX-51 is still black
> >=20
> > Signed-off-by: Joni Lapilainen <joni.lapilainen@gmail.com>
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> Tested-by: Sebastian Reichel <sre@debian.org>
>=20
> Please note, that this patch has actually been proposed by
> Aaro Koskinen <aaro.koskinen@iki.fi> quite some time ago [0].
>=20
> [0]
> http://permalink.gmane.org/gmane.linux.ports.arm.omap/81729
>=20
> -- Sebastian

CCing Aaro.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2903223.bUCHxYMm0J
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFYG5EACgkQi/DJPQPkQ1KxfACgoKHBpejLKOC8PdgvOaQe6rwC
UcMAnR+I8O57CohHzkvkmR2XFJ99aj+n
=nHEL
-----END PGP SIGNATURE-----

--nextPart2903223.bUCHxYMm0J--
