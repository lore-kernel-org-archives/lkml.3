Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaJFRud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 13:50:33 -0400
Received: from sauhun.de ([89.238.76.85]:41024 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaJFRuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:50:32 -0400
Date: Mon, 6 Oct 2014 19:51:06 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Carl Peng <carlpeng008@gmail.com>, Huang Rui <ray.huang@amd.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] i2c: designware: Add support for AMD I2C
 controller
Message-ID: <20141006175106.GA2000@katana>
References: <1412071495-15323-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <1412071495-15323-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2014 at 01:04:52PM +0300, Mika Westerberg wrote:
> This is second iteration of the patch series. First version is here:
>=20
>  http://patchwork.ozlabs.org/patch/390694/
>  http://patchwork.ozlabs.org/patch/390695/
>=20
> In order to get source clock to the core driver we need some way of
> creating it in the first place. For Intel LPSS it is done in
> drivers/acpi/acpi_lpss.c but that is not applicable for AMD I2C host
> controller which is too different from private parts to the LPSS one.
>=20
> We solve this by creating the clock in ACPI parts of the platform driver
> when we detect the AMD I2C host controller. Doing this requires small
> refactoring to be done to the probe() which is what patches [1-2/3] are
> doing.
>=20
> Changes to the previous version:
>  * Rebased on top of i2c/for-next branch
>  * New patch defaulting ACPI probe to fast mode
>  * Instead of direct dependency to COMMON_CLK we depend on (ACPI &&
>    COMMON_CLK) || ACPI. (suggested by Wolfram)
>=20
> Carl, can you test that this still works on your machine?
>=20
> Carl Peng (1):
>   i2c: designware: Add support for AMD I2C controller
>=20
> Mika Westerberg (2):
>   i2c: designware: Default to fast mode in case of ACPI
>   i2c: designware: Rework probe() to get clock a bit later
>=20
>  drivers/i2c/busses/Kconfig                  |  1 +

Applied to for-next, thanks!


--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUMtaKAAoJEBQN5MwUoCm2LlcP/AuMRTiPqVGjPUQ/hYHYEe4k
YN4Nvya/t4ntR+o0VBEzWiaURKnVE1omqUbQEFUm8SJL9GTqpOoIF7bod/01GPiB
bMgMKgVp40Hdr8qedKuU/PRLAsOKz4xHKFNY2Pxa/VoobtKHCTK8nZrX4lpKa3c/
acGpA2c6p3urGAfG/UWJnZbtoShCspI2CpU/U8InCJmNwqzEEPYULwLeeBFR5c1n
1or8aj/s+XmDaC6aCgLhMXZ0da5h6qDgX7XtDEnjM5AIlehYhIv/0Ad4ccnUbcco
sZppOkiWdfe+HVkMoI72/UYkv/ORbu150m9e+AmJ5h+UTZonS6cteEwkYphhNbvA
KObS9mNNR5tOra1+xPQocYz9oGvpUOs+xttE4FuWlvjuP+pWmx0fxSyAhHfL3x1y
KV1ezYOf7wn/IYpJQ/k9bfO8MQQh7zbXk998V1Ae9eLq+5PHHdNBJ+kbs+41bTBP
1q0jZrJ7m/kLxtXM18axLpe0JxSuS395AgKLfrthWnnfzT6j2D1AnSG6CHCMEK7c
8eH5rZhuxBhWfl1xtZc7XduO42AcFn1jKW9Tj5q+Yo12XcJgJcYiersJGC4kr5p9
AC7P+dVksvjfuA/52RZxghm5tgCbIKiHUgipDho1vug1gowKcjs6bdUoeqNN//DT
8t4EpoqSh8FDzr9T2JfM
=B0to
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
