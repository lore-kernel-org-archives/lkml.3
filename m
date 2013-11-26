Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab3KZNAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:00:21 -0500
Received: from sauhun.de ([89.238.76.85]:37823 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab3KZNAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:00:19 -0500
Date: Tue, 26 Nov 2013 14:00:14 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: Re: [PATCH] i2c: i2c-bcm-kona: Fix module build
Message-ID: <20131126130014.GH7427@katana>
References: <1385409678-4398-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uJrvpPjGB3z5kYrA"
Content-Disposition: inline
In-Reply-To: <1385409678-4398-1-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uJrvpPjGB3z5kYrA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2013 at 12:01:18PM -0800, Tim Kryger wrote:
> Correct a typo that prevented the driver from being built as a module.
>=20
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>

Applied to for-current, thanks!

Have you also tried repeated module loading/unloading?


--uJrvpPjGB3z5kYrA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlJteAAoJEBQN5MwUoCm2gHcQAJpgTYtr1ji17RZs4GZnfUQs
8jxC7N/pyIzYuiy0n9cY+1HYzltiOho58skPvMdGzonodxoIECNy6ReR4NCfL/e1
VQbnNHKAByOZAhV0KZpBOBABc9HwauFnmhe+tfkThWzyczNZACjMYRGRaat1/RX3
nK/EEX0BNRGaqdKlCbGrrZFcfoVtw/s/BuVwiGaGYbp9JgvQ8TOv9eFwrDnF1Syr
U1w0kSQI8dT/WBdc9MNUyOED/niV0ATyW1kRUHQrP4158Oq0+8od+c5OiZdLq82O
mzO39ZIpnZcsy6vYIgo8+snh2OFaq2g8ro/jUasK4zzPTa/a1g3vRaiqlsO15kWK
ye15Ev9kS1LlHX4TvoUwp+v5IpJ+lf3+dBtsXxC4MVsotnkaW+zwW3bRWfQk/ugu
CoENTgTpIDXLLB7t5TYbNcIAejkohojXTRNImnfRXZhcU+ULOHxy2qVRyno+y+k2
OHQOOG+cedSxOfEsMQIehPq5fMlVc6C8+lAV84IWyc0WdqON7bRd58H2ydDDrgFC
06upR/rqNUOQ5U5oGGg7YJsqK978R9g11dDozM/uYywieuxGiAGopV4M3GVbrNd3
H0uAjxRsBA5CBaE1VV4bPaBXTwu22hk6d3Ca5iQwHJY8NfD5hannR4aEYYazw4EO
HHiaQFsWd0xEgoYOFa9d
=l2+p
-----END PGP SIGNATURE-----

--uJrvpPjGB3z5kYrA--
