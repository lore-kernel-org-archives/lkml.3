Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3LLJFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:05:16 -0500
Received: from top.free-electrons.com ([176.31.233.9]:53193 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750873Ab3LLJFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:05:05 -0500
Date: Thu, 12 Dec 2013 10:04:15 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: srinivas kandagatla <srinivas.kandagatla@st.com>
Cc: Chen-Yu Tsai <wens@csie.org>, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 04/10] net: stmmac: sunxi platfrom extensions for GMAC in
 Allwinner A20 SoC's
Message-ID: <20131212090415.GQ3651@lukather>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-5-git-send-email-wens@csie.org>
 <52A5A52C.50605@st.com>
 <CAGb2v67WiCaMpJEzA_X6o7uOu6i3w3FCEz7=N5HY0amQb01SZA@mail.gmail.com>
 <52A72C6D.60100@st.com>
 <CAGb2v64qQvqJSicA6MTAxeh1sGjWY=Pk=vDq=9J3pTQW+wkXrA@mail.gmail.com>
 <52A87A74.8040807@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tRcR9GoWqjXrt11v"
Content-Disposition: inline
In-Reply-To: <52A87A74.8040807@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tRcR9GoWqjXrt11v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 11, 2013 at 02:45:08PM +0000, srinivas kandagatla wrote:
> >>> 1. .tx_coe
> >>>    This is not exported in the DT bindings.
> >>>    Looking at stmmac code, not setting this seems to disable all
> >>>    checksum offloading.
> >>
> >> Why cant this go via DT as well?
> >=20
> > If you and Giuseppe are OK with this, why not?
> Am Ok with it.

Please note that I'm opposed to this until someone explain why putting
it in the DT is relevant (and not just convenient).

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--tRcR9GoWqjXrt11v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSqXwPAAoJEBx+YmzsjxAgG/kP/2S70fcVXrFmA91M3G7MI0bq
FXb1w7wojQiXDcHv4zvGmkpAI0MzmY3iSVbinAK+vv/ChC06hn5PUD5oQaQJHG1i
/uPADPCdgMjbv3aG2ig4/LsSoVe75nQ/EwY/KIgpJeWkRa1dZEVLsjcH4n8jCzVb
1qLqUTgSGtBiS+e+0JcsqfuHhH3tr7JIUCuJ6JuJs4WauKePnde0GvmANZ5o1uJe
6Dmb/Wgqbi2qh0hryAd26+XSmonz5aVPGFZ3Iw1OaoDQNUaW/y5nD+GGbR8Qsq7V
puEndZu4+0RyjL96GpYDT8sSc/KoVbKMVZXvwYDk6U1/DSNz2D0ASkqjVGgMTIzs
C0n1id13BZAD2FtUghLga2Zv2gm8GQ7N/IcDf5OYrO2+AgT7V07C/PurxZzBJBPt
SaumoPhUD+avRM1Iw1XVg8DlNB/bcbWQm4YpVQ/pe98LmxkPAkIqrxzWDQQ0P9EE
4HjHcdBo5QJNGjgXtQ/Xo23niO1XEKOb17PcSqndf6PRS/VUR23P8i/RxAzV280K
+lcpTXumIhOTGvjIpCTABjOxAehqdpd5FWWMYve5IMZakbpEHw79DV6R3VvDdHY9
o7kb4Mwk1kxHOKFAk5aXElYQH4tYxv80hjOeeO5gCBlE/++StCuS/kHTSMjEKA1Y
WzVCmVv92XJbpMKFk2xg
=yDB+
-----END PGP SIGNATURE-----

--tRcR9GoWqjXrt11v--
