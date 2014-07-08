Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaGHO73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:59:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52971 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaGHO71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:59:27 -0400
Date: Tue, 8 Jul 2014 16:56:05 +0200
From: Mark Brown <broonie@kernel.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: heiko@sntech.de, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com
Message-ID: <20140708145605.GZ30458@sirena.org.uk>
References: <1404176639-3315-1-git-send-email-addy.ke@rock-chips.com>
 <1404784397-5157-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D+UG5SQJKkIYNVx0"
Content-Disposition: inline
In-Reply-To: <1404784397-5157-1-git-send-email-addy.ke@rock-chips.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.127.83.212
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/2] spi: add driver for Rockchip RK3xxx SoCs
 integrated SPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D+UG5SQJKkIYNVx0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2014 at 09:53:17AM +0800, Addy Ke wrote:
> In order to facilitate understanding, rockchip SPI controller IP design
> looks similar in its registers to designware. But IC implementation
> is different from designware, So we need a dedicated driver for Rockchip
> RK3XXX SoCs integrated SPI. The main differences:

This driver is already applied, please send updates as incremental
patches against the current code not as a completely new patch.

--D+UG5SQJKkIYNVx0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTvAaCAAoJELSic+t+oim9DcwP/jSXromLc5Pc7peD3nrv4ONE
ny6alpVNbvS4X6OcSbXYv+NYghvxgTL85qqQZ314l6N0CA9DpFkJTD40iv3cnuwd
w0vWjMtZXZk3Mhv94HOi35OLNZdBTIBkYnjpmVy1zwhrAozYfuR9Ta3KhiufJdCF
FjOE06L/qAPCvhkBy3p4fpFuaZiT9vqSCtY6iSss2BK6iZQfjD+wZg0xGXLEJCJp
9KwdT96Q6oOJA+Rki+y24A3cDqRi3OKMZ44ioSxf0IB4fUsX+2KPGuiOhESV9mz6
NDSEoL5kJei461si1brY3zcvbh2AxDReBTXpjGecc0kvU1jQE2+CYzoywmGpDFN2
0wtKNwgO3qM9o1hMkWrhrM+rZ76EdGi8AmXGf4e6umSw8z6x0GPkZEHfVCzfcpd+
w+Ajs4/pV9W/AcYzy+AsFiQ6Rb2GiZk/9qanSrfG1bv1NaEcGbcU8xVk5BTiuy1y
17pV+fRESb6fZ/LEadoqN3qDMFbbNxhvZzk0Vl7G9hziRmN9rEsxkuw6ZsNhBZI6
bUKsmaGnVtnV4QKeFCwhsbA3FWWCeEPJ9cjyJvApLoA6cUjTbdRf1F+ufWNg5VeC
fN5O+Jy7F7MQuIZcZuGnH1+7/AYr82oPRed56CiuwNRCPjT16fYU94FffOUZrqXn
mZ8ricoRpkUBDmMLonsV
=7chh
-----END PGP SIGNATURE-----

--D+UG5SQJKkIYNVx0--
