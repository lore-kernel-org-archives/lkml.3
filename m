Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbbALLGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:06:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58467 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbbALLGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:06:03 -0500
Message-ID: <54B3AA86.80601@pengutronix.de>
Date: Mon, 12 Jan 2015 12:05:42 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 01/04] can: kvaser_usb: Don't dereference skb after
 a netif_rx()
References: <20141223154654.GB6460@vivalin-002> <20150111200544.GA8855@linux> <20150111201116.GB8855@linux> <20150111204952.GC8999@linux>
In-Reply-To: <20150111204952.GC8999@linux>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4PlGDeJOEFVMrRB3MARqu2Kfs0klrlCr2"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4PlGDeJOEFVMrRB3MARqu2Kfs0klrlCr2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 01/11/2015 09:49 PM, Ahmed S. Darwish wrote:
> From: Ahmed S. Darwish <ahmed.darwish@valeo.com>
>=20
> We should not touch the packet after a netif_rx: it might
> get freed behind our back.
>=20
> Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>

Applied to can/master.

tnx,
Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--4PlGDeJOEFVMrRB3MARqu2Kfs0klrlCr2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUs6qJAAoJECte4hHFiupUIo8P/As2NRoUap9CJAq1ryczTUof
TwOkhzFgCdXQO+h9jwP5QCeKWxHjNZyLsT8cJ7M+5S1fWzG4XMPHJ9PRnyNi8+l7
7pDcMy7t0Ag53r0lumErv+Du9h/SoPZUOWknzUlPnIxNSevjZiVjiGLLZY6ultEq
KwGK1e4xOYCvmD1EWSFMb4Z6zo+YrSVPGKf1Goan6pnMRCU9gtXYfAYAixpTOiiq
p5PHgRP8qNJZ2q4u7F/M4a06v7SN9zckSYJgFAmN90AFU4DrllduRZwDt9BChWdF
C6vHG5Ziyf2fJovq3QHnuuRrMc93fGxJpkNVOJLXWo5bGpuu+WPYbiJ14hkHFw+J
CEbw5+HlxkyyZVUbjVsDYZcWcIit0o1ugbWnARmxa9yLqT//3staTzZ2IL5RnbON
lu84vWMoTCaw3z8QrbGPNUsdVTJO4oibbB6n2YCD9snHIws069HI+7tyztYl6wOn
dvgjzw3hDEuq6MmAEJqcmLqqq2jyAJ47B6xsi8ZASSBMq4wENH0OsV3AcEcBEQ0N
OsJ4U0mJyg0o8Vht+AapsNowEbXAM21BoTjBGIbv22xa9AAryg+YIf0uEU36UiET
5Mfrgz9wDyCfdp9mgewx2OfPoL8npVJDAld4ltWwIJANfguYM4I0/42Am85zrRB6
5qEGMDPUTcaMlM8vwv3P
=jS76
-----END PGP SIGNATURE-----

--4PlGDeJOEFVMrRB3MARqu2Kfs0klrlCr2--
