Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaCIIaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:30:20 -0400
Received: from sauhun.de ([89.238.76.85]:34628 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaCIIaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:30:18 -0400
Date: Sun, 9 Mar 2014 09:30:13 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        xinhuix.pan@intel.com, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: designware-pci: Cleanup driver power management
Message-ID: <20140309083013.GA2579@katana>
References: <1391517427-16204-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <1391517427-16204-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 04, 2014 at 02:37:07PM +0200, Mika Westerberg wrote:
> The PCI part of the DesignWare I2C driver does a lot of things that are n=
ot
> required anymore. For example drivers aren't supposed to handle PCI state
> transitions themselves. This is all provided by the PCI bus core already.
>=20
> In addition to that there is no point scheduling RPM suspend on driver's
> idle hook but instead we can use RPM autosuspend for this (which is enabl=
ed
> in the driver already).
>=20
> As a bonus, this patch also fixes following compile warning which is
> emitted when the driver was compiled without CONFIG_PM_RUNTIME set:
>=20
> drivers/i2c/busses/i2c-designware-pcidrv.c:245:12: warning: =E2=80=98i2c_=
dw_pci_runtime_idle=E2=80=99 defined but not used [-Wunused-function]
>=20
> Reported-by: xinhui.pan <xinhuix.pan@intel.com>
> Reported-by: Jingoo Han <jg1.han@samsung.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied to for-next, thanks!


--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHCaVAAoJEBQN5MwUoCm2QQcP/Ap6b8PlZxbuFR+DoYFsqjIN
TUTy/UXJSsQJZzec4ix5f4rjgA6WB3pQTTaS+PlDMMKd8I4DYI/zzZzX7apArbCm
Jgwt/wqd75EWTK1IhsMRrUTXBuLiOyZOm0gBANwH64648zlhvSw9byG1T4pHTbK9
qBajGkqDn68PKvUPB3CgzXZBwD/+8cTneTuVD4gXqxt9qcbPVb0EDE4aTZVr3BTB
EWjW1tKRy+JWbef8iCtywK8AY1YFVee6Nzehf2pFuKdZCsfDZMpHgJ4OY8+jpZ4I
b+BTY7PemDpxJfhBMxyTRiW8G/FcqGbnYyUedbuJTqx+3x1uoO73Psv+Otto7YIB
H7MuIvYYo+ccgmfeTdZ6yh3o5zvJaVkh9ULpuzgman/uyuYsNsh3tBrv5w0HmXes
cWJk85MNhHPKiXF+oGeZGK/v/R80bvtwZeSDZwjjW9SBk6z4kTCuSi7BSkeAtwd7
Eza9b20Dke7jnktiYp8UqNX2v04xBRbZsTVGY6tH+SiQ6+IiDmfPoSnT+92qqUCM
GhueU6QEJBO/PVzCvVSLGUjkxpUFKHmiCfKlcmEFoEAqSd5RciCyXxgZsfvu78fh
kJiNMTsi96RefzuWBAptIjy1H2CnWvhW6s4b5I5Xzd7c0rnEnus6hfJT5SB41106
agg0a87OesKXxiupwZGt
=6qdw
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
