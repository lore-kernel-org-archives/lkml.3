Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbaGQKCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:02:43 -0400
Received: from sauhun.de ([89.238.76.85]:36349 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850AbaGQKCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:02:41 -0400
Date: Thu, 17 Jul 2014 12:02:36 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        sjg@chromium.org, linux-kernel@vger.kernel.org, cpgs@samsung.com,
        broonie@kernel.org
Subject: Re: [PATCH 1/2 v2] i2c: exynos5: remove an unnecessary read of
 FIFO_STATUS register
Message-ID: <20140717100235.GB2740@katana>
References: <1403759698-15624-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <1403759698-15624-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2014 at 10:44:57AM +0530, Naveen Krishna Chatradhi wrote:
> This patch removes an extra read of FIFO_STATUS register in the interrrupt
> service routine. Which is read again before the actual use.
>=20
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

Applied to for-next, thanks!


--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTx587AAoJEBQN5MwUoCm2NakP/2SHmIRNVYzhGZnt5ExXLyq1
kpKycVraGSvQ4B3+X4bILSHltQuo2ZP5IhfokCSGv7yF2PdHQ/BUmeaA8gyxOHSb
SlRyRDQhVLoDccVGKQfy1sCsiPrF+kZN612KBJEjXqtwhY/fbDDCwBpbxOFlUg81
K+JB90b1ta/vns5eqa7nF+4mbZSqgHINm+4xVLR9Y2cdnId3kQ3vCnyaGiOKmYHx
GcL82oHzdwyai4PqYMJ2QThYC/57ErfPuSSmclY81H2m4ZaJ4SVvPZEGGo6qDgJw
w6A87Xvalv8Nf5eMxmp6L46C/PJQkWAM5QtjEztR/RWsofX2l7MFTCUKtiiSAyCz
c76UOPtmAAbm8vDrhfM8LjBp9H9NlXZG72EPS9lWsrUuGNK6d86A5rDZBO/hqWz3
jw8zvClt1BluCw/qjG3ya59V8dzHy4WTEQTeq5zUHJyYIVPGGUgaVMMGqurxrotJ
ezXVM5hncFG9AQp5tu+0UsM6sEjrBrNdiM9EGNTX1kNj0pyK3E/BddrIXmre7D/E
GWOFtsbVF1Aj1gEmQAr2Zy4ghmW3rYhmcKceBwWGQsNN/gaaodnLxKm9gBQ+A5eo
HO72FBxwfNoyJuEonDZfceJefF0mlDEHiavWxKLdcilsjVy/P7V3WNulBPSlcHHc
Ta9nsBZ/wwajUn7A3ynO
=q1w0
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
