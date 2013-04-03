Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868Ab3DCOGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:06:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58951 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab3DCOGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:06:39 -0400
Date: Wed, 3 Apr 2013 17:06:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 0/3] check regulator_enable() return value
Message-ID: <20130403140622.GI14680@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364997747-20830-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xsn3knLL3qrmRbVI"
Content-Disposition: inline
In-Reply-To: <1364997747-20830-1-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Xsn3knLL3qrmRbVI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 03, 2013 at 04:02:24PM +0200, Fabio Baltieri wrote:
> While testing your 'next' branch merged with today's next I got some new
> warnings, caused by a recently introduced __must_check in:
>=20
> c8801a8 regulator: core: Mark all get and enable calls as __must_check
>=20
> These patches introduces a check for regulator_enable() return value in
> all three affected USB phy drivers, and issue a dev_err() in case it
> fails.
>=20
> TWL4030 and TWL6030 patches has been build-tested only.

Sorry but I can't change my tree anymore, we can send these during
v3.10-rc.

--=20
balbi

--Xsn3knLL3qrmRbVI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXDdeAAoJEIaOsuA1yqREaB8P/ApxvU59IQ7xBnYBJkCos5dk
c6kynpvFKf8aYo6ZWZR4mvj6p8MJMAh5h6vbxOHOBXwFbvz8LipPIunmMHD54LyP
V/NnJ/SKCTyA2n8ab10Yj6ywd5LUqsHIUvmQ+/yNrR5yXW7f7VffbH/Vi5Ro/RYF
atXJTLzJ9qjD4pahIBhqDz7yF8al1rH0wVPXHJs4mgqIuz+X17oAePSwkFere/9U
iaGg1ccpiTTbqZ1U4RoiLv+endBEvCG+M5rmGWY4f2yU7TFspWMdtFK++Bko8brm
gSZhfl9OM9HBtSBoi3Olj2SX6ZQLCWxJA+u0CeQfVf8f2yK7M8jGVuxAam2wXroj
ByTM6Wil1PfQBQPwZDHiAxLew25fHAEqK1B28oAiU/WdZc+/vGJBrpotoQj3C4Ug
rASdqLk5IDSLjIa3qixS7P1wvD6jK3vAfdIc16OrQFzZF3x4Q/S87cIV16y7uKZP
iqmi7c+XZwBMrIbbdGOdV8rPK0wrUKVP+WliAGEX+fGRhIA/oXdXAx5FpxJru9SC
/3vwWLOuxqyDQdwN8m4Xct9Llwc7nDQKmbs8DSFVTBm89hTuCbvEW4En06qW5F43
lhLYx8DPPPNn1tJt2vgq8mMmTE36lFWmDfAxbUz9yONIbm5eQFULMTD0ozxfmEca
aigACdw88is5SpeNXASG
=mRg0
-----END PGP SIGNATURE-----

--Xsn3knLL3qrmRbVI--
