Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab3DWIsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:48:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51936 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255Ab3DWIsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:48:42 -0400
Date: Tue, 23 Apr 2013 09:48:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Taras Kondratiuk <taras@ti.com>
Cc: lgirdwood@gmail.com, rjw@sisk.pl, viresh.kumar@linaro.org,
        shawn.guo@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philip Rakity <prakity@nvidia.com>, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [RFC PATCH 1/2] regulator: core: Add regulator_set_voltage_min()
Message-ID: <20130423084838.GB5019@opensource.wolfsonmicro.com>
References: <1366372554-20866-1-git-send-email-taras@ti.com>
 <1366372554-20866-2-git-send-email-taras@ti.com>
 <20130422131904.GL30351@opensource.wolfsonmicro.com>
 <51756A21.3020405@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <51756A21.3020405@ti.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 22, 2013 at 07:49:37PM +0300, Taras Kondratiuk wrote:

> Yeah. Sure 4kV is not a real request, but
> max will be limited by system constrains.
> According to regulator_set_voltage() documentation
> system constraints should be set before calling this function,
> so I assume I can rely on them. No?

> Another possible implementation is below, but prefer initial one.

I just don't see any reason for this API.  The driver setting the
voltage ought to have some idea of what the chip limits are too for
safety.

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdkrfAAoJELSic+t+oim9ZR0P/ixRIwIPKdBXVQnQUnjHoktU
yxn3Xgv+jWxPxCWdkQtaiUZi8XKyfm+yVyWoWRHsGM+QbJ7WtxccRPXlm+wsqq9k
nNlNyTJ8RJjH0IouwRfwbGlNS4xQA+CePVy52IXg50R29+8MtF40cdH95sozq/XX
01857adCMwZ5pORv/SmBAEZj4FW+Z87bMlU2bGxIfof4f7iR4HGJ5aZkoQ+xVnbU
m5lNOgRpdAJBjShYGnDSt5vx1Uu5nUYal8QbDcurZNvXF5rpBpussrQEsCDYrp74
1w0vVIcB9eD6J6DuluvMEKIj82K25X55nyIyq+ToaYELG1wKpK3y1Yq15YGfnvIr
e1OsQ/NdpW9g42POR7HhM153Uy4DQ2wDtoWAP3H7vi4sPZvuaT9ue4YxHTD3kS3W
h0dnvaZ7ZrZ4qiGPL+60US4Wnvo7Pcz6dvWLK6+8K39syxNJtLar3S4deI27/T2j
mWmrAXDAH9tL85pRHeIMFLYz8Lx+d2Hydhuzfv2WiFfx1WQiB5Mil0Lcuk8nIC8F
93KIs59kAlFbwQGrYpoPfuzRPf+wdAOqfS+jps7bUgrzFwh95nccOAkTr81XiJ/1
gl0iM1rWYrOs4WCuC32lcwrZcqN1nelCv4PxMfOUTbqLfFt9rQbqwNnk63cSSH9r
J/MNQcLRpzNxa7AIBdop
=iBRB
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
