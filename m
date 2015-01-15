Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbbAONoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 08:44:22 -0500
Received: from mail.kernel.org ([198.145.29.136]:49664 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803AbbAONoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 08:44:19 -0500
Date: Thu, 15 Jan 2015 14:44:01 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND V2 1/2] power: gpio-charger: balance
 enable/disable_irq_wake calls
Message-ID: <20150115134401.GA512@earth.universe>
References: <1421287238-23522-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <1421287238-23522-1-git-send-email-dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Thu, Jan 15, 2015 at 05:00:37AM +0300, Dmitry Eremin-Solenikov wrote:
> enable_irq_wakeup returns 0 in case it correctly enabled the IRQ to
> generate the wakeup event (and thus resume should call disable_irq_wake).
> Currently gpio-charger driver has this logic inverted. Correct that thus
> correcting enable/disable_irq_wake() calls balance.

Thanks, applied:

http://git.infradead.org/battery-2.6.git/commit/9a2fb8ac9677ab9cf17ab336e06b59d93a57f4a4

-- Sebastian

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUt8QeAAoJENju1/PIO/qaigcP/398h9E7Sxd7qF2uSnK/896o
Zgf/Chpp3xskn7VgpkEdv1v+NRP6PTWMf3n4xQnCaURO4QZ1wM53LlgXjvvEkXU1
6zjdTsjt6NOTvHzygSmuVnG9nMttXpSllUKZdnlMwqXMCvcRNFc3mQAlgvCeutM4
lmp/i8vDtDPcG9yLa1RzfLylEQufxIuESAFyzYxRK6CfKB7nCrVW1UTi46jfhDYy
EGj3ub0Hw4VcIGsuK35Ux3wGzZo+5K4bviX915QsBBshTddKYniWYc8ZzlKfQMgZ
2zw3gc8jAVWpcFTpW7Kzyoeo1pipKO+TyxIUdVC7QHzdHpy3EUuqBstl8d2rSeUm
3Nvezru4H1Ikss4ekud3hLNBh8rBRJdLkX9ti7S4oO91QMpj2lNTw6k/9sS2Jf7p
PfkK6AJvUrrK0oR2e9Uv39Hijw6oklF2QdDTvz7bDLqIdeX72aOdO0WOeHMY+V9z
/E4Z5tljxCWjKTDnqn3gd9jXJbYa82iu0UJsKvm09GAMs6Bi40xvvN3W71H+tHJ4
PMJ9NC7myo+lF+Ok4jIIw6lSb+Cqv60pc38zGacgKgZtcgvY62T05digf8Nra/BP
Yo8ZlOl5ye8nogudnZcTHQxZYv5Iy46hIy+f42rD4EsQ/bYwfjxUnbIdOIY3jL2y
sIjNb6L8hGpQacpIZydB
=3B6e
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
