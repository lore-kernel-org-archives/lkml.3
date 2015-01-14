Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbbANK4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 05:56:04 -0500
Received: from sauhun.de ([89.238.76.85]:38955 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbbANK4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 05:56:02 -0500
Date: Wed, 14 Jan 2015 11:55:58 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c / ACPI: Pick the first address if device has multiple
Message-ID: <20150114105558.GC2615@katana>
References: <1419860928-195404-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Content-Disposition: inline
In-Reply-To: <1419860928-195404-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2014 at 03:48:48PM +0200, Mika Westerberg wrote:
> ACPI specification allows I2C devices with multiple addresses. The current
> implementation goes over all addresses and assigns the last one to the
> device. This is typically not the primary address of the device.
>=20
> Instead of doing that we assign the first address to the device and then
> let the driver handle rest of the addresses as it wishes.
>=20
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

Applied to for-next, thanks!


--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtks+AAoJEBQN5MwUoCm2kSQP/2A/U8P0Zg0X3+8vDaVFgmc+
p2pRkYeeHIwZfCcmtw/WiUMpGuiZdSnu42obpcy+srbPoWemmsvKolVCibn0lg6u
K98fAi+NYL3gNpJdJF7DTeKrlNsWb/Bzxf+dKZy22b6K4gSmk5z42p5ySod2ygKD
YJ/pc39ES2A+n5jYDVAvjto35YgipjiCSVxB5++yA3/zcmJv1Mcua6oWvVx9iRHe
DvBX3cs2QgBrZxbBFX8zawTKzAQvmGwV0cDQuU+pJ/RajvLoy+69PCSXaPEkLw5E
9CXWSFVqZp/LujRXneiiRmAP4FXDoctKXes0S5Agb65zWBoeOzE/H7sMtF+9/e/h
nmgesER5hrOr/WBN7aWpnRQxu6l8w/paPJ3kqjjjBCWQ5lziN95bHntWpRoHdOn3
phLKCqUewl5DXZrL0J6K9185gbmolBGIaDPWg27vNrCRzN/Rq0P303F1A9MRKhZW
3DZ/M9Vw2RxvfMK4E5PP4/lN0/h/fCBiXzffJZuwc6sQ2+yNNNHm4q/Cw8KVHLqI
1GJVZ0By319fJYEeDXxmYmsT49p72czTcUKkSZeLUadU1/iaDkLUujZgoiLB77Xn
tSLXkEuJT1Qx+nCbI5Q4rAL44p+Pa5guMRviZX0VJUY//yvvHltybKNaP/gZoxHp
jVorzLZo4TR+Lqj8Igg1
=/b9l
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
