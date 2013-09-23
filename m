Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab3IWNel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:34:41 -0400
Received: from hydra.openmoko.org ([144.76.72.4]:54293 "EHLO
	hydra.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3IWNek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:34:40 -0400
X-Greylist: delayed 1670 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Sep 2013 09:34:39 EDT
From: joerg Reisenweber <joerg@openmoko.org>
To: Pali =?iso-8859-1?q?Roh=E1r?= <pali.rohar@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2] RX-51: Add missing max_current to rx51_lp5523_led_config
Date: Mon, 23 Sep 2013 15:06:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.28-2.20-desktop; KDE/4.8.5; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1379541145-25934-1-git-send-email-pali.rohar@gmail.com> <201309200020.58671@pali> <201309231450.12171@pali>
In-Reply-To: <201309231450.12171@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3680985.MF4FSAcEKD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309231506.37942.joerg@openmoko.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3680985.MF4FSAcEKD
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mon 23 September 2013 14:50:12 Pali Roh=E1r wrote:
> Hi Tony,
>=20
> here is new version (v2) of patch which adding max_current values to rx51
> board data. According to joerg safe value for max_current is 100 (10 mA).
>=20
>=20
> RX-51: Add missing max_current to rx51_lp5523_led_config
>=20
> File drivers/leds/leds-lp55xx-common.c refuse to change led_current sysfs
> attribute if value is higher than max_current specified in board file. By
> default global C variables are zero, so changing always failed. This patch
> adding missing max_current and setting it to max safe value 100 (10 mA).
>=20
> Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c
> b/arch/arm/mach-omap2/board-rx51-peripherals.c index c3270c0..f6fe388
> 100644
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -167,38 +167,47 @@ static struct lp55xx_led_config
> rx51_lp5523_led_config[] =3D { .name		=3D "lp5523:kb1",
>  		.chan_nr	=3D 0,
>  		.led_current	=3D 50,
> +		.max_current	=3D 100,
>  	}, {
>  		.name		=3D "lp5523:kb2",
>  		.chan_nr	=3D 1,
>  		.led_current	=3D 50,
> +		.max_current	=3D 100,
>  	}, {
>  		.name		=3D "lp5523:kb3",
>  		.chan_nr	=3D 2,
>  		.led_current	=3D 50,
> +		.max_current	=3D 100,
>  	}, {
>  		.name		=3D "lp5523:kb4",
>  		.chan_nr	=3D 3,
>  		.led_current	=3D 50,
> +		.max_current	=3D 100,
>  	}, {
>  		.name		=3D "lp5523:b",
>  		.chan_nr	=3D 4,
>  		.led_current	=3D 50,
> +		.max_current	=3D 100,
>  	}, {
>  		.name		=3D "lp5523:g",
>  		.chan_nr	=3D 5,
>  		.led_current	=3D 50,
> +		.max_current	=3D 100,
>  	}, {
>  		.name		=3D "lp5523:r",
>  		.chan_nr	=3D 6,
>  		.led_current	=3D 50,
> +		.max_current	=3D 100,
>  	}, {
>  		.name		=3D "lp5523:kb5",
>  		.chan_nr	=3D 7,
>  		.led_current	=3D 50,
> +		.max_current	=3D 100,
>  	}, {
>  		.name		=3D "lp5523:kb6",
>  		.chan_nr	=3D 8,
>  		.led_current	=3D 50,
> +		.max_current	=3D 100,
>  	}
>  };

Reviewed and found logically and technically correct
Signed-off-by: Joerg Reisenweber <joerg AT openmoko DOT org>

/jOERG=20
=2D-=20
()  ascii ribbon campaign - against html e-mail    =20
/\  www.asciiribbon.org   - against proprietary attachments
(alas the above page got scrapped due to resignation(!!), so here some=20
supplementary links:)
http://www.georgedillon.com/web/html_email_is_evil.shtml         =20
http://www.nonhtmlmail.org/campaign.html
http://www.georgedillon.com/web/html_email_is_evil_still.shtml   =20
http://www.gerstbach.at/2004/ascii/ (German)

--nextPart3680985.MF4FSAcEKD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlJAPN0ACgkQ7Xtwhpk1UgyFsQCdHuKXdNlV0g6nxGuAOaY4cpfs
excAn1OYeTzyYTJ2tMJA1+MrCZ7SA/zd
=yjhR
-----END PGP SIGNATURE-----

--nextPart3680985.MF4FSAcEKD--
