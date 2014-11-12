Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaKLQ7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:59:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:38907 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbaKLQ7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:59:31 -0500
Date: Wed, 12 Nov 2014 17:59:25 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, dbaryshkov@gmail.com, dwmw2@infradead.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, smoch@web.de
Subject: Re: [PATCH 2/3] power: reset: imx-snvs-poweroff: add power off
 driver for i.mx6
Message-ID: <20141112165925.GA27681@earth.universe>
References: <1415780439-29728-1-git-send-email-b38343@freescale.com>
 <1415780439-29728-3-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <1415780439-29728-3-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 12, 2014 at 04:20:38PM +0800, Robin Gong wrote:
> This driver register pm_power_off with snvs power off function. If
> your boards NOT use PMIC_ON_REQ to turn on/off external pmic, or use
> other pin to do, please disable the driver in dts, otherwise, your
> pm_power_off maybe overwrote by this driver.
>=20
> Signed-off-by: Robin Gong <b38343@freescale.com>

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUY5HtAAoJENju1/PIO/qaYdkP/AgVUwvCivqytBuQLaByw3lg
hfpEc+62UTzBHWwhqI5QJ9Ni7Z5ap/116EKGRUPGESvwzwEgvfTedKtvAC6HHE+v
AdVnlciWj5SeqsY8n0madYp07vZrYSCvic/HGAv16ubJmzQCejYXx8L3Vc0/eKsY
8fZNEa2EyX9roH8USYJ7Klozko7a7mGeN28cWVA5EMscxbSJOR2FT88MuEduYg3B
M+MCjU+YpVY7u1VtWIHzXbJRLDtziLjUEudLIjcfzQpsc7W21HBA2Cw88R2iZ2Yo
A4NOU7rt9JQb5rX0gdcz1nIK/5LEAQMpHhwIiLfueDRTpS/fQKlOEgbxZgLKn2pw
rkJpzBAhMrGa8zzby2sBhPGhWQ0J61anVxm15m/cC9RoePpwgTfR/nhV3kQPJTYe
njrNNRh8JFsWXP/97kc+icr7twucW38kApJUVtPAskP7MwP745JGfse/XS/1C0MZ
aGNe75x5i83BO+bElkoAKYLSQKQ+vdvPsgYKCh4S9BgsBMy9EqpmID1l6xvJKQce
u18l/W2QeuzyZQN0VnUg6NZ9IhS1rUm/FuLEuDIXyHIJf+HyC2KFDZLd1COv/oxX
GQNT4mpTs8wQWT3fzU4GKM+x9G4Lqyue+a4E0GWZPBp4KteQvKKWWqxLhEx8uNDC
t+lJau0RoLV8NRW3NxWp
=dB4J
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
