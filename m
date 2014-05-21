Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaEUSZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:25:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:55501 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaEUSZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:25:22 -0400
Date: Wed, 21 May 2014 20:25:14 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv5 09/10] DTS: ARM: OMAP3-N900: Add SSI support
Message-ID: <20140521182513.GA26285@earth.universe>
References: <1399739870-13526-1-git-send-email-sre@kernel.org>
 <1399739870-13526-10-git-send-email-sre@kernel.org>
 <20140514215503.GM27426@atomide.com>
 <20140520003538.GD15793@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20140520003538.GD15793@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 19, 2014 at 05:35:39PM -0700, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [140514 14:57]:
> > * Sebastian Reichel <sre@kernel.org> [140510 09:40]:
> > > Add SSI device tree data for OMAP3 and Nokia N900.
> >=20
> > Picking this patch into omap-for-v3.16/dt thanks.
>=20
> Just noticed that this patch seems to somehow break idle
> modes on n900, so dropping both dts changes for now.
>=20
> Basically the n900 debug LEDs won't ever go off with
> these two dts patches enabled, even without the modem
> drivers loaded. I did not dig deeper, but it's probably
> something related to hwmod using this data for some
> settings.

Is hwmod data interpreted at all without the DT entries?
The hwmod data may be wrong. The information from commit
398917ce161e10d3c66afaefdb89c73c64c4b02d was simply
interpolated from all information I found. The OMAP3
public TRM does not contain *any* information about the
ssi IP-Core.

> Sorry did not notice it earlier as I did not have the
> PM regression fix patches merged with my testing branch.

I hoped to see working modem in 3.16, which will probably
be used for the next Debian stable :(

-- Sebastian

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTfO+JAAoJENju1/PIO/qaa5wP/i+jGUtLwNgMyVplgZdMvC6W
NzJnNZN6um2eipY5aHNXn6SdLPM+EqhopTPrsVopm01xXHjRAJxzHI2skSjQgnP7
ipEIHRNceMr946NTJtP8YUGO04pOhu6HiXmsfqBp00LbWvFeGSTTMNhY308WU+LQ
A/jvVilsfItfUvy1mG9ZYlDUGvpz8GptheTw3bPbZ4oW9XgnNiUWgfpvgbPkFu8n
iw4hcBY5TLeLAcUEBSbpPXfy370h86PSvfmX9LmOTEKwNgtIMi7+dPl6vRjHUbIi
H8dCdPlaRBOIUlqCTVfHqE8kJx628hI/6RJKYAWe/+LuWdzZrnY1lqgxidJUd2Xc
bgB+2qammupvS6Xw3wv35cniUT3h8x0LrTIAHxK/7RiEzXRzj7PVX9N4ygv2Wk9Y
SR3ZU8oAPld0xKOiDiaDX8LEt3AdD+f4Ok5KYhj5wKX4tRnP45NfOR6Vzg5tnFvg
II1f+xWRvv7TtwnSekMWov2SzNwvblja1GuOnkULoAIJAPM+Bkrb1It98bqOTthO
6VsXW2OSVcBNeUrkViNTo0mtgKtKglxE41lmdJ0kuGRjv/XPk0e+MY+afo2NBdnB
uhuA53YHvpRs04xLt/RhdFcar15IfZw2YzyZpUYeEkWbFcPx6clTI948EqzmSW7b
OHDamv85gjC5+n6ZDR8x
=uNaS
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
