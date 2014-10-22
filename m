Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166AbaJVVfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:35:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:45776 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933443AbaJVVfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:35:05 -0400
Date: Wed, 22 Oct 2014 23:35:01 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: Re: [PATCH v2 29/47] power/reset: ltc2952-poweroff: Register with
 kernel poweroff handler
Message-ID: <20141022213501.GH28840@earth.universe>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
 <1413864783-3271-30-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Hlh2aiwFLCZwGcpw"
Content-Disposition: inline
In-Reply-To: <1413864783-3271-30-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hlh2aiwFLCZwGcpw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 20, 2014 at 09:12:45PM -0700, Guenter Roeck wrote:
> Register with kernel poweroff handler instead of setting pm_power_off
> directly. Register with low priority to reflect that the original code
> sets pm_power_off only if it was not already set.
>=20
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--Hlh2aiwFLCZwGcpw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUSCMFAAoJENju1/PIO/qax28P/1yShqGpVeH0oACAebx9dw01
3jSb5r/RjAyPdVk0K/bRxcVz23nbZHxbMWwvx/OUaJ6uSWhXT/yTz0Yt7BL4cD44
2UpXmA5xHWKOSWCljBmBJS6NdaoYZc/JOv8J+HhJTepIDGR4H1H8nQyfKWWcpVeT
2GuSyfWP0HnvSL+wihSQQAAtfVLxvfBmGaGv/NWkK65dAzR/rO9gj2la2wMkncuF
ZH/eHJbyQKlzea5JovfYvySfzwwKaRr0trS7JrlI1lpnMqGNCPKV0jgcmwlkKZAT
fW/dpUbFgurdxekA1XD7sbF9SPs8eLn90Ets7PboI7ozhQSFpgUYbLmYtj+6gWhe
eNQ3q3wP0BRRPaaxhrvQLWRuFlXXtDNULNSfxAai+jBfn52fkVPn6iJNdDXtEm+X
KQ7MoME3gCD+T/8qf5Fo5yxcno+qUFdvCOSE/wsJAiXUKuj4EfTG4GAB1N+JujFb
LP0fT2vXxGsXWfM8aSxMj8IAr3PYp+lLaEEYVEsKWOiTUUzk9ifRXXYI67Z2Id3b
cYCkTQNbFNJZCq5x84B1VRI4/8T1eWMfjl35S3QxkTp4t7tzo7OH6w29lUO3Hdvi
5BS/awdK39AOkS60DsEyGAlNYfMe5pnMekfV2qu8+ODQgjoeyxCCSaomZi+X+DkC
p0S2VU7/70NhqMd9ng/u
=VGcz
-----END PGP SIGNATURE-----

--Hlh2aiwFLCZwGcpw--
