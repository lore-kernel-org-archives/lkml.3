Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbaJVVeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:34:46 -0400
Received: from mail.kernel.org ([198.145.19.201]:45701 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542AbaJVVep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:34:45 -0400
Date: Wed, 22 Oct 2014 23:34:41 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: [PATCH v2 28/47] power/reset: at91-poweroff: Register with
 kernel poweroff handler
Message-ID: <20141022213441.GG28840@earth.universe>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-29-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Fnm8lRGFTVS/3GuM"
Content-Disposition: inline
In-Reply-To: <1413864783-3271-29-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fnm8lRGFTVS/3GuM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 20, 2014 at 09:12:44PM -0700, Guenter Roeck wrote:
> Register with kernel poweroff handler instead of setting pm_power_off
> directly. Select default priority to reflect that the original code sets
> pm_power_off unconditionally.
>=20
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--Fnm8lRGFTVS/3GuM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUSCLxAAoJENju1/PIO/qayAUP/35e3DJcYpPLNRsKt8MXU+yt
sdU+LEdlPnyvcKepbXNJVUvHyCHoKeS8llVK0qGOWI+vqkPOSVgAeJgtVFoGWSPb
EqQrckhjt6vsuvs4mYTWji5cJWf7wNOMjKxwtL4+SKSCIjBbSrfH9KwhTyv+uZNU
8wMqBxsDI7Ca1+cV6FEt7ugvoKQJK03/QLizsHSfkNJVfyuUb74WOf+VGKfQIXus
GJMXuqRfO1m8OooK52c08HoypOtv09znUcfp8V8Eb80y+djwHRdpxyNmp2UQkByT
n6JYEoyQSsYwye+2Cf/RVQFvUqETVzE7/zPAeOCe2gr1S+IEcCiSpe2ET4rnqREm
ItmwGm5ucpUB3CVHB0Mm2bFZZWzyyCQL1plDWAhlqLWC1+otsd9jgZIWzwmfAVAO
OZQf0TnfJ1jrIiBDircohFP1o+hJBPoOxKsuKn933cxMpyLLO5ZhkVkbJrUC/O8Z
Ep6xm6aXJhzX033pltjm3Nmt4dMsxmPAJ1VCHOkao3Ak+3S7GtQyJzBRC8miH9NI
fwhTwuUelhnW2j6PWctwyMVPkdC5+9pwxLIZvFuisJ7oP/B/yW9O59L/Us8R3LHm
qMQkKV9jleddeLK6uldk/P/doSMyQtlpdpmJQ4Rv5W8/M02nRuhGZBvY0JOFjDya
KpLSWxDTAHY0oy5+73iN
=oBWW
-----END PGP SIGNATURE-----

--Fnm8lRGFTVS/3GuM--
