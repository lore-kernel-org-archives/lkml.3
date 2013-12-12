Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3LLSUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:20:25 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41850 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab3LLSUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:20:23 -0500
Date: Thu, 12 Dec 2013 12:19:09 -0600
From: Felipe Balbi <balbi@ti.com>
To: Matt Porter <mporter@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v5 2/9] staging: dwc2: update DT binding to add generic
 clock/phy properties
Message-ID: <20131212181909.GJ1939@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386854770-2173-1-git-send-email-mporter@linaro.org>
 <1386854770-2173-3-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KjX7LgAomYr70Ka9"
Content-Disposition: inline
In-Reply-To: <1386854770-2173-3-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KjX7LgAomYr70Ka9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2013 at 08:26:03AM -0500, Matt Porter wrote:
> dwc2/s3c-hsotg require a single clock to be specified and optionally
> a generic phy. On the s3c-hsotg driver old style USB phy support is
> present as a fallback so the generic phy properties are optional.
>=20
> Signed-off-by: Matt Porter <mporter@linaro.org>
> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>

Here I need Acked-by from any of the DT folks. It's pretty obvious
patch, so I woudln't expect to have any issues.

--=20
balbi

--KjX7LgAomYr70Ka9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSqf4dAAoJEIaOsuA1yqREKBcP/iBwHjsIpA/WTu42Kf09b6lX
rHxNaiBqGqvr9hEhpvHdlmymdCrtllLx2R+VKaK5V2muIROX4WkfdQrrMIP/juub
WfuosqQf298DuXDyWgymiAbzwnRB8czodmMrXgglXYXV5fTfkW5h0hapFwbroDtB
Hu3YWD3ipf7wC8I8DlZYhCDRLuXbpntKhy2yk3tZFwKiEtYUtjzNqK/NSV75QuYw
gJuvPEslcZ/NaMEbavBKw833Adxt0Wc4Qe9F8hXA1+5mSksxNi5x+EXfJnNTo9zJ
FQ6GQKQLEWRpCI0nyLfmfD1oIIsKMCpXzzf4VBOpbg93hH/SRRnBEZpuR5yDDi8j
O0+mAF3h7ll9HWameoXinr+QjFQKlar6WqduoU3mCnysPxctDCr3FPTFQprAHjbl
olFNmn8JCdTkWKDpjcuiuVc1/YXQGtstZbhHP1JGsJl7Bih+818cy0KrdcpuzUKD
pJ3qD2kn380mq6Q0eyw6A8Z+3u+jz7XSoN2boHCmtI2qynlKoetFYliz7dJVB9f7
wHr/Yh15EjMi2b9jpJDU+HgRB2kUs7X07UWlXbYrIZH4N7Yu2uVHp1lYttCmwNlz
OeGI2N3z7dLz9QMlVNOw/ca5QAm8dNU9ddNNkEiVbVPUy75c1mvnSwRmWF6LWGun
P1JLqQWFEoisrZxFJjXe
=6Yfc
-----END PGP SIGNATURE-----

--KjX7LgAomYr70Ka9--
