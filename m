Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbaJHMTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 08:19:45 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61145 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbaJHMTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 08:19:43 -0400
Date: Wed, 8 Oct 2014 14:19:37 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Bart Tanghe <bart.tanghe@thomasmore.be>
Cc: matt.porter@linaro.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH v7]pwm: add BCM2835 PWM driver
Message-ID: <20141008121935.GB7357@ulmo.nvidia.com>
References: <1412763272-24269-1-git-send-email-bart.tanghe@thomasmore.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
In-Reply-To: <1412763272-24269-1-git-send-email-bart.tanghe@thomasmore.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2014 at 12:14:32PM +0200, Bart Tanghe wrote:
> Add pwm driver for Broadcom BCM2835 processor (Raspberry Pi)
>=20
> Signed-off-by: Bart Tanghe <bart.tanghe@thomasmore.be>
> ---
> Changed in v7:
>  - clean up the shameful clk_enable error handling introduced in v6
>  - clean up the code nits
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt b/Docu=
mentation/devicetree/bindings/pwm/pwm-bcm2835.txt
> new file mode 100644
> index 0000000..d5162db
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-bcm2835.txt
> @@ -0,0 +1,27 @@
> +BCM2835 PWM controller (Raspberry Pi controller)
> +
> +Required properties:
> +- compatible: should be "brcm,bcm2835-pwm"
> +- reg: physical base address and length of the controller's registers
> +- clock: this clock defines the base clock frequency of the pwm
> +hardware system, the period and the duty_cycle of the pwm signal is a
> +multiple of the base period

This needs to document the #pwm-cells property. I can fix that up when
applying, though.

Let's give Stephen and others a chance to give this another look.

Thierry

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUNSvXAAoJEN0jrNd/PrOhIKwQAJOKirjXjQqBxSzQ1FTDuJt7
hX3Pe/rnvUyl5ZE3yQBUBp9sMrhCAaiKl5FPmMkncnDRibqgf0SDPDifA7gbSBIk
bEAKvCsK694nj7y5HKcZIHrpnRMAD6ORF5yKbnCRHCCR5DvjRWN8YAkstQd+0DRO
miI6MI4rvVzE5M6BckfFdEeM/ptr3qZPlroN3CZhjwZQhLms9rXJqSBzaVGDfcQ+
RIqcM+jsu6jMtTUci8FJgfQ4FTox2Fbd+0MK712yi87LM1LPK/67yiDiDZsH7t16
ennB9MJzK+mJMYMwZtE/Y6UBUxX0LGKn4NjY6Aaop+Qvniwa823I+Crx0k55cR8+
TzDCI7V6sxEAMqs7zG083T0GtNKnZFSP3wsY1EbrNu4hosZ8AxZV6GZ4Ai4obeZY
uj+aTus2YEK5ss1NZgcdUN90L6l63Nw8RAlND1+cYar5LYNDMD6gkE4Qrx15NyYx
Zwxg1RsP5d27yglGwavc74HqrKxHl7AsEGW15iz7DmijzSwbGFQOvI+wECnk4Sjr
C+EowDgo09zTUzaMh7YbPzjC9rYGOcUlFM986Y7MNDCqLsVQhuU/36kTGNOXGhKZ
9Aspn+A3LC4+2fr5EZkhnhMPUtXWbocHgVd79I8jwbigej57sLDZiQPxMoRSCA+d
KQG7qnjplUm4avnlbM/w
=slUT
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
