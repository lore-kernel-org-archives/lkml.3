Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaJCLuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 07:50:17 -0400
Received: from sauhun.de ([89.238.76.85]:38773 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaJCLuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 07:50:15 -0400
Date: Fri, 3 Oct 2014 13:50:48 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Anders Berg <anders.berg@avagotech.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3] i2c: axxia: Add I2C driver for AXM55xx
Message-ID: <20141003115048.GD1349@katana>
References: <1412334482-20720-1-git-send-email-anders.berg@avagotech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BI5RvnYi6R4T2M87"
Content-Disposition: inline
In-Reply-To: <1412334482-20720-1-git-send-email-anders.berg@avagotech.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 03, 2014 at 01:08:02PM +0200, Anders Berg wrote:
> Add I2C bus driver for the controller found in the LSI Axxia family SoCs.=
 The
> driver implements 10-bit addressing and SMBus transfer modes via emulation
> (including SMBus block data read).
>=20
> Signed-off-by: Anders Berg <anders.berg@avagotech.com>

Applied to for-next, thanks!


--BI5RvnYi6R4T2M87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULo2YAAoJEBQN5MwUoCm2Y1kP/RfjWt5XHUteCijbnSjB1p3O
j6KUATQY06csp+zjHyu82TzE2hieP4Wsgc6ELJcJgZa8DPd8mDScbJAS5tyelCa2
oAhmRcQZURiMzGXx+nvDGfjmqE9Pd42vUReMQkoBSHTB1YQyZHzLm+pOZZ5a+aUX
aYq3Eag71YXMx2+T1jVGkDBBdvSkWt0EQJiJw6R0p+SQwcu5BKmU1Vlmm6nkHW8j
TdUpZd1zSb2FGvS3N/s1s58SFCnxCafcvU793tU0osyGZUUzCpRxAIEBMWC9c6qN
HyIrw0bYeL0YmCoA830wlmAiZnPRgi9/ebMdCEVq1AAW7wOL7L0P/KeOju+fRxch
ZVx4qq81KCaZJ62O1MDehMbKPQ5J2Z02RxyU5GbNpC4f1H9dZaUQMwGVZOByr1Oa
dsbfsqATXG5TrJxwzSmhBZYLKHmhNg6BX8i6Uoubb3WiaFHf5eor1Suvd3imTmiW
SVrasCiZfaVXz/pxK4BmotdLRY2rz5ifPgQ7QdaSsUsni92AGAr/0oiL8DA7M1Fc
ctez0VQT6ysPxC1mAMlvcJFzyjR2fXOtkINh/TTQLGWb9R5VnGGVLDltknZFLDHa
GLW1SyxtYSJgH7YzmqAec7hO9QcMagBcWIDkJTLKyTOPIs/IPeZwKhobFUcMwVfr
zKRFAYb+7Omgxe2ZTWCM
=MJII
-----END PGP SIGNATURE-----

--BI5RvnYi6R4T2M87--
