Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbaGQKCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:02:49 -0400
Received: from sauhun.de ([89.238.76.85]:36352 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580AbaGQKCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:02:44 -0400
Date: Thu, 17 Jul 2014 12:02:41 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        sjg@chromium.org, linux-kernel@vger.kernel.org, cpgs@samsung.com,
        broonie@kernel.org
Subject: Re: [PATCH 2/2 v2] i2c: exynos5: remove extra line and fix an
 assignment
Message-ID: <20140717100241.GC2740@katana>
References: <1403759698-15624-1-git-send-email-ch.naveen@samsung.com>
 <1403759698-15624-2-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3siQDZowHQqNOShm"
Content-Disposition: inline
In-Reply-To: <1403759698-15624-2-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2014 at 10:44:58AM +0530, Naveen Krishna Chatradhi wrote:
> This patch does the following in exynos5_i2c_message_start() function
> 1. Fixes an assignment
>    As, "i2c_auto_conf" is initialized to '0' at the beginning of the
>    function and HSI2C_READ_WRITE is defined as (1u << 16)
>=20
>    Using "|=3D" for the first assignment is more readable.
>=20
> 2. Removes an extra line=20
>=20
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

Applied to for-next, thanks!


--3siQDZowHQqNOShm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTx59BAAoJEBQN5MwUoCm2xH8P/2/JLNN190AO7IldNUKeExXD
mEUOIKIRVDSrIONixZuLBtEK79Po0jfIJSOJLueyqHTEvZQTEMQSHYKq2O2EKPZP
RBvSA6CgKAFXU0boYqaovh0aOG/lYcas+MowrwoS3bNV51zuopEv7FuwEBZCVRip
FRiJTOxw7Up/qtbq6etdgBF2AwnWvBqAN7s+w1CK/gPGUwM80bqo+sSZGnLXRYtu
VzI8cG4g1BxfkdajgFizg7JZOKFyi/wQ7D8pUvN8e83hVVB4kfilVm08thzlvnhZ
Mq7oDcKCiXkTz1v0tlBAWgYsN0xAZcDN1LJNZzvYhB17CG5BtwS/w0nKqcbD97oQ
mA4zNrYMtlIVyEz40p0CVXhBkIbJZBX8pBJFwY6i4DKG+izEUX8DVeD2nYw10t3g
FDNluprhdP/VGyzYA1JdZ1Lwkju7VU6discpCHN8AbB5H+X0mIsmdU/8QWOF0oG1
4hekT8llzwAiU/+G7g7+1PlahPKgHPfj+DSaxrSm55a0KWacOEdOFV6mFt8dELlU
408TC1tu6nkfxd/Yu9Sydh8PmRTfSKwVsC4juSPu90bPAMrl2yTFc1W0Gtyy1CpA
iZgD8Ut43soHfxv8Jqki23l+7ZKmSfro4+WixRN7pG0RU12OrIliv68KSOAtujQU
IjQF1hjwxuxSvwCiEQhG
=bJww
-----END PGP SIGNATURE-----

--3siQDZowHQqNOShm--
