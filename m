Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaI3GGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:06:53 -0400
Received: from sauhun.de ([89.238.76.85]:36844 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaI3GGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:06:51 -0400
Date: Tue, 30 Sep 2014 08:07:22 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>, Dave Jones <davej@redhat.com>,
        rspangler@chromium.org, sjg@chromium.org, sameo@linux.intel.com,
        wfrichar@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: cros_ec: Remove EC_I2C_FLAG_10BIT
Message-ID: <20140930060722.GC1325@katana>
References: <1403558406-14519-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRj9sO5tAVLaXnSD"
Content-Disposition: inline
In-Reply-To: <1403558406-14519-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2014 at 02:20:06PM -0700, Doug Anderson wrote:
> In <https://lkml.org/lkml/2014/6/10/265> pointed out that the 10-bit
> flag in the cros_ec_tunnel was useless.  It went into a 16-bit flags
> field but was defined at (1 << 16).
>=20
> Since we have no 10-bit i2c devices on the other side of the tunnel on
> any known devices this was never a problem.  Until we do it makes
> sense to remove this code.  On the EC side the code to handle this
> flag was removed in <https://chromium-review.googlesource.com/204162>.
>=20
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Applied to for-next, thanks!


--QRj9sO5tAVLaXnSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKkiaAAoJEBQN5MwUoCm2fgoQAK97o4xEQtivdf/lLpO5jZlA
ksEV1/lcPE5mmJl0JmVXWO5kblhw5fBLlq6bqSE+JdNuV845FPpyUOJGrKarc0NJ
6GC4IvZJdgCaOUyeBstcIEw52p0MdkiBsHjCkmR3bwj+2I4+HjWQHEbIeruUGfl2
KRkefHtvZon96mXFER4L2Wah5z4AWzKc+YHYPbF6cvxzddPR9boyY/SnDy6sjteM
uA42HUTsJUbpTljnh8nKKPg3jfYTYlviFJ4KQc41Z2gdpiZN2q7tWVCxii5a8Qz9
xU138STABXWeDjgYT4e/7xmMe7oEfZyDHBn6yJVJvJgqZWgH0DsXX0vW0TMnOqOe
HAx1dhisK+9x/nFipScqjkazDExAiQn6gte/Tpd5vXY6kAS4RIrWJB0UKSL73iYG
3W0Sl5m3vm+I+F8QpoJePNPJK3/p8TqghSnFUpJzhsb4oetPjQRajMTzJ+a80rN0
kFNW7odq+UXu4sZEMsBhP263ptWEEXNzFQiKdWjLgWxvIbxfRhrK5DPOfiQPQQYg
oU75DDS7w/nGZSodSvzS5cZyjInbU257WPoF0OUQ7Pn/LFOSUijKlI+Iz3UPIpmB
iaL8nRZxkzx4h5RjFEY9Q5Orl2EaLr/fBfOrGJBQGaatznUX01UfNvKOnKKdoyto
Him6w/b8JEKvOC5xKrr3
=LIKw
-----END PGP SIGNATURE-----

--QRj9sO5tAVLaXnSD--
