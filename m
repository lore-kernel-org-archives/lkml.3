Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaEUK2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:28:38 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:36913 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaEUK2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:28:36 -0400
Date: Wed, 21 May 2014 12:26:18 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pwm: atmel: set pwm_chip can_sleep flag
Message-ID: <20140521102617.GD22783@ulmo>
References: <1397067969-19905-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Km1U/tdNT/EmXiR1"
Content-Disposition: inline
In-Reply-To: <1397067969-19905-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Km1U/tdNT/EmXiR1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 08:26:09PM +0200, Alexandre Belloni wrote:
> atmel_pwm_config() calls clk_get_rate() which might sleep, so we need to =
set
> pwm_chip can_sleep flag.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/pwm/pwm-atmel.c | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

Thierry

--Km1U/tdNT/EmXiR1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfH9JAAoJEN0jrNd/PrOhEogQAIUKRCAry7ZiGcK+pSOh+Syg
0hd8OtjJguCu1EpNHxUhE/4tdCALjCIJZ84OZVTguQ/jVFRRLiMrDJqnL/tS7nh2
mNjxCEMPBYYZ7h/bXzPTrhzlT21Fy8ht2y9TOQ7EJtZ4+3El2z9g5HIn/09T9G7V
3AaY/fOpusN9KVWi/uyqRUYwrGVWQWq3dOK+QMT0BFjSSXWo6ngNfrkwbniUA7OO
IQWmlF6B9w93nVfKk8W5rAj1S4fhfoGEhExDg6XZPLSdWhYaWia8lWS5BibVDQAu
o0I4vj9Cmzyv6VGeKTtm+/bIAj0ZiW9OIVqpyLTqav5FK/iiGd68PDKJln1lGNXt
NRdX2GKSaM5Ckewnnzij8khrrUeEyYCVvex6AuS8jlvmGgDuHMZJGQJQyg0uLsE/
x3rOLMJ1VsjdqpgV1GK6AK2DmB27vGJ8qcGQjLOyAT98hFxmkLpak/T6XcbBvahN
dlnm3N0EAtVRWK9CCl2oiqdQC/TKsHB+xHULLKcsdT1/GaFC7R0scWmUfws6UC+7
535LBz7dzfzBQVECF1Xx5WvRZTg/c4PocykNG3BYOoqmGzQNqLIeMjCgl4maFEco
lYFHegjQ5ul+4tl2B0pk5CqrhXODhpdjCWq0El8fRh7iBTdd6AU94Ba2cPspQeeA
CEEjJRvVP0FWkO+d+CTo
=47Rk
-----END PGP SIGNATURE-----

--Km1U/tdNT/EmXiR1--
