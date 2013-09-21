Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab3IUNmo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 09:42:44 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56936 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3IUNml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 09:42:41 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>
Subject: Re: [PATCH 0/4] Add support for charging battery in Nokia RX-51
Date: Sat, 21 Sep 2013 15:42:37 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>, Felipe Balbi <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3163465.hdrj91rlDQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309211542.38033@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3163465.hdrj91rlDQ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 08 September 2013 10:50:35 Pali Roh=C3=A1r wrote:
> This patch series finally bringing support for charging
> battery on Nokia N900 (RX-51) without any proprietary Nokia
> bits in userspace.
>=20
> Pali Roh=C3=A1r (4):
>   usb: musb: Call atomic_notifier_call_chain when status is
> changed power: isp1704_charger: Fix driver to work with
> changes introduced in v3.5
>   power: isp1704_charger: Add callback function set_current
>   RX-51: Add platform function and data for bq24150a charger
>=20
>  arch/arm/mach-omap2/board-rx51-peripherals.c |   56
> +++++++++++++- drivers/power/isp1704_charger.c              |
>  107 ++++++++++++++------------ drivers/usb/musb/omap2430.c =20
>                |    3 + drivers/usb/phy/phy-twl4030-usb.c   =20
>        |    2 + include/linux/power/isp1704_charger.h      =20
> |    1 + 5 files changed, 117 insertions(+), 52 deletions(-)

Anton, can you review this patch series, specially power supply=20
code (changes to isp1704_charger.c driver)?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3163465.hdrj91rlDQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlI9ok4ACgkQi/DJPQPkQ1LYwgCgyxBw+K3ehNBuZZUNrD7J5o86
cp8An3C8aro3cAqGTENDJ3Kh2w2FrocV
=ai5M
-----END PGP SIGNATURE-----

--nextPart3163465.hdrj91rlDQ--
