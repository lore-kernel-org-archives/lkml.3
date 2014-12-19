Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaLSIus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:50:48 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36352 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaLSIur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:50:47 -0500
Date: Fri, 19 Dec 2014 09:50:43 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: linux-pwm@vger.kernel.org, Jim Davis <jim.epost@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: atmel-hlcdc: Prevent div by zero
Message-ID: <20141219085041.GB7352@ulmo>
References: <20141218094442.GA24383@ulmo>
 <1418933131-12270-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <1418933131-12270-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2014 at 09:05:30PM +0100, Boris Brezillon wrote:
> The slow and system clock should never return a rate of zero, but this
> might happen if the clocks property defined in the DT is referencing the
> wrong clocks.
> Prevent any division by zero from happening by testing the clk_freq value
> before calling do_div.
>=20
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  drivers/pwm/pwm-atmel-hlcdc.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Applied, thanks.

Thierry

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUk+bhAAoJEN0jrNd/PrOhyagQALm8xHE/lu+H9Wy4bqirQSyQ
kbVI6bZ5fmgz66XqOmvmL65cBIgp5914SZcgmiduHtBbIHP1dJpLP7RfTb0bsKQ2
ID1XxhiBaW+SBfpKDuElg2gYluE4OY33xxDcrYaRKI9prL3o/ufAQHxXpImwJgUA
jUBYdKLJgxXm1NE82p9WDVhRKP/U8VRsUbWYIAKacabB0J/EkTpjZ0PfO375LzXK
zZJLj4OLja3V5FDMv6Zwung3Rt5G/W2it5uJJvlmMkAAnc3keZdzai3EqZLz+XbS
nOZwoHQXR9AKHcwz1/mpYB3/Z/G/vJWH8iiI2sqiq4M/VVhBkffXIyThgZ5J6Dve
pQ3HFd6IaEnasZiX6Y1+O9cYwyqRvecriZH5PTP7czShaky/jLXc8mZbt/Uap5VD
5pyvw/IarYrWvtVnkoUxQWF9slAlbPudCTFQaIADuZgGKr/nmer+CPjRwBuzBiJC
r4poO4u4XPcZlyWV0oJbdFUjUjLDHhEiDUEE21cTlGhVo2gaYzNOU3kl2bLkw3xR
o04ZjUk1BzrkR1YMSOR/LFdVUGySCM10Sc7mWJcctDJofTE8Nz8p+3gDJiYGOQaZ
/Rd7AXkZvwK34MJS4Vw9RvviS504bjAqERTfSSiIWZf4ymKp2SCI0lzk8JhIprgI
xzetzLL3WHLTCiCxB6ca
=aQqC
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
