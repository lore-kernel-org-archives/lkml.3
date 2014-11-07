Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaKGSNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:13:15 -0500
Received: from sauhun.de ([89.238.76.85]:55950 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbaKGSNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:13:14 -0500
Date: Fri, 7 Nov 2014 19:14:20 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: bjorn.andersson@sonymobile.com, agross@codeaurora.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/3] i2c: qup: Remove .owner field for driver
Message-ID: <20141107181420.GJ3656@katana>
References: <1412840312-31402-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ONvqYzh+7ST5RsLk"
Content-Disposition: inline
In-Reply-To: <1412840312-31402-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ONvqYzh+7ST5RsLk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 01:08:32PM +0530, Kiran Padwal wrote:
> There is no need to init .owner field.
>=20
> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
> "mmc: remove .owner field for drivers using module_platform_driver"
>=20
> This patch removes the superfluous .owner field for drivers which
> use the module_platform_driver API, as this is overridden in
> platform_driver_register anyway."
>=20
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>

Thanks, but superseded in favour of a generic solution
(https://lkml.org/lkml/2014/10/21/594).


--ONvqYzh+7ST5RsLk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUXQv8AAoJEBQN5MwUoCm2Nn4P/Ag1/S18Z/c/F0CK0tYfae4r
8+8F+MXk0XbFecS0FHBIB22pa9XiEmNevhnRJFz/EwpiDNgfHWbEHFyUoE6gFY6s
hmAVjM7sQxqV7NnUWct6KyE0v5gSrKfU6JtxDlOrZ4l/MCxkzoz6s6eTxQruHH/6
sYVRh+zwOjNSwJFoDxUZ7BEMIbE52gYVYSj1pxb74csU/KgyK9vv+x49LBk3Y/9e
fH8Mjdmk3jXgCsrOZFSWfvWUaGxhoBjkljYikadNhcsH2Sqej+UoGMkTM7fxi9Yp
BVSctdjFugHIf5m/mPGgvuu3OyV6r/JYB/UnhN1IaQW/FjVxUp7xBLv6R3qT5iaQ
ee4f/ZoVhQv3bVjTlmst4Zhkcqu9DGlH7bIc3w7JoqvO7/crhrVRvYZkH/IEmgzF
OGN0FDAyw6CD54upHde0GvZLyWCiA5sDzFL2d40+j24jWzEeAkGpKuPBCRE1TMTx
lveXOGnlPNeMao3NRRgs/I7zbD3gLiwLqbDp+PC/wPhu8/1o4QC2YEw8OPpcYcGL
JhHDk41/dCfB7CGVDxaS+dKWkMJZGpYw2vCR9BD2pHR4qEezUSTMmYzR5RRi1FF1
YhvTmU+ppD0Vbk5aiwQiunvtxddaEiMl0y77VY8odqgLraDqUNfPlCeIoq5wt7Jx
RWJKp7X3MhtDfAGt6VOZ
=nlA5
-----END PGP SIGNATURE-----

--ONvqYzh+7ST5RsLk--
