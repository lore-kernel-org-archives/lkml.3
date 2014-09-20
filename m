Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaITJQI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 05:16:08 -0400
Received: from sauhun.de ([89.238.76.85]:58280 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbaITJQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 05:16:04 -0400
Date: Sat, 20 Sep 2014 11:16:22 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mikko Perttunen <cyndis@kapsi.fi>
Cc: ldewangan@nvidia.com, swarren@wwwdotorg.org, thierry.reding@gmail.com,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH v2] i2c: i2c-tegra: Move clk_prepare/clk_set_rate to probe
Message-ID: <20140920091622.GC1612@katana>
References: <1409909298-11361-1-git-send-email-cyndis@kapsi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Content-Disposition: inline
In-Reply-To: <1409909298-11361-1-git-send-email-cyndis@kapsi.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 05, 2014 at 12:28:18PM +0300, Mikko Perttunen wrote:
> From: Mikko Perttunen <mperttunen@nvidia.com>
>=20
> Currently the i2c-tegra bus driver prepares, enables
> and set_rates its clocks separately for each transfer.
> This causes locking problems when doing I2C transfers
> from clock notifiers; see
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/268653.ht=
ml
>=20
> This patch moves clk_prepare/unprepare and clk_set_rate calls to
> the probe function, leaving only clk_enable/disable to be
> done on each transfer. This solves the locking issue.
>=20
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>

Applied to for-current, thanks!


--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUHUXmAAoJEBQN5MwUoCm28ZYP/iIYviAk+B8pKLMWEIh1eX9I
oKYcs4KqGu3tH5ArnHUHwaG0CAd/i/GWCKmNpaC3OQDhUxl39bZ5DIYMsF1dYtpL
eUaBOUfOOzO8JepOosvwwZfoW4dETpsmSabogNAOyQdtE+kLKJN26/Cl1wj6fQTR
753pdVN+2v4tEMQ4Thvo10gwyxS8yNzilhS/kBDWEcl3qyxE/RehpxZxGg8MFckj
dx3MlKGLZ0G8+NUkqpvKWid8cf7j+ApvZCCHSD1cUV9/LxgfX0XuKlZcE8Ac981N
vZxpLmvTt2u9NwPHFXbBXyFOH+Q49dWMYDrLayoBulvTLnbvH8YJ67RqzlRKFSOt
RwqHGkXgHWrzhBbmDFGXoKPn5d5Cv7OamWMg/jzNPu6YoHCRxatKeCoHrH8U31gG
0j+7kRdCtrNlUYKGurIHLiCimwLGCyqH9YoBW69mKuOmiP/IAr0P3IzoTAB2g5Nc
SZCpesj29QpO9ovqLQy4g0DBJl2qwli5haJjtXhcOJrjRgUW+aLTh8RKSAwmMm9/
HWwDnqPFG8EVhY/vi88DK94n1bRKbjK26Ivvvhr2S8FW6BkKnp8Uj9QmzHsduzJx
oDugZRlQNeATxHbnULQnUqnDPsPRpBjdhUMbI+l8YrxN90JDYelOUtOxXEMongwk
nX2KELemU4A30tSClQEg
=ZLCh
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--
