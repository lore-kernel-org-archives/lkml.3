Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaFLAnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:43:55 -0400
Received: from ozlabs.org ([103.22.144.67]:33797 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbaFLAnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:43:53 -0400
Date: Thu, 12 Jun 2014 10:43:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Santosh Shukla <santosh.shukla@linaro.org>
Subject: linux-next: manual merge of the samsung tree with Linus' tree
Message-ID: <20140612104346.4da3f0b5@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/6wZpVH.C8HyZeDUuU5pbY0N"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6wZpVH.C8HyZeDUuU5pbY0N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/mach-exynos/sleep.S between commit 25a9ef63cd2b ("ARM: l2c:
exynos: convert to common l2c310 early resume functionality") from
Linus' tree and commit af728bd84cc8 ("ARM: EXYNOS: Fix build error with
thumb2") from the samsung tree.

I fixed it up (the former removed the code updated by the latter) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/6wZpVH.C8HyZeDUuU5pbY0N
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTmPfHAAoJEMDTa8Ir7ZwVfTQP/0a1VkuMmgutmQlgUo3cXExB
y7K4F3eozqNKVhfUNN5FulpfRZYeSVXgWOM4KoEghtmvXpckVTN7Ehy4JWNScRab
YP4u8r7WvEdxvpc9ouoWYacgg4LvQKLwllXbCKoe/NwM9EOUz45dGIx6BPYAIais
UpS8U9C5N7QVhjGgWjzFKXy6KcJ6nZ+SVcemKp4FdnGpRWLMKDEdT8xyT2d3F9lO
fNgCUEBXutHtLkjNGlsyiqLXajj8qWJctL2DPY9bAjerqjytUjBr9neR7o6dXPCv
LaqstBmPa34wE3iwAsfGSiloafd+W86ntyUY5WM0m1hTyjKpa9ulKYH9Chmo0V2W
JV3dM9Anpn3ABhHaT0i7KQBzpM9oPADuJY38/AFgQeaai0uC2/42gL65VZTGdHfK
cvcxbo13hiy1hs1sFud9ZhGSRpfoQEeXkErjXoDo9omn+v8oCzjwHmGHn8dv7VJT
hJokrQzNE3sVJ//1b1M8zLKoJi7ikiSIH48Dnqv61ppLMmjA+c6SzEKQMR6eXb/z
xcZxRL/+O6fcLHRPA0QEhAxMnTrLCA3Z6yL/m3985hUTgY/oqXUSbfxCtemLlG7K
eVXS5VyvV+yf3xGeas6GJGlNgelBpj2SBI7FKSsv5bT9Xdcx/xxBU8NOxZW1qJe2
mz4DxS8Rs8+NvvjWiU3t
=C12Z
-----END PGP SIGNATURE-----

--Sig_/6wZpVH.C8HyZeDUuU5pbY0N--
