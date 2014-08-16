Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaHPVeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 17:34:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38890 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaHPVeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 17:34:19 -0400
Date: Sat, 16 Aug 2014 13:59:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tim Kryger <tim.kryger@gmail.com>, Chris Ball <chris@printf.net>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Haijun Zhang <Haijun.Zhang@freescale.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140816125903.GC28623@sirena.org.uk>
References: <1408019940-11153-1-git-send-email-javier.martinez@collabora.co.uk>
 <CAD7vxxKvzxvmzgx=S5ZZn54ts99ca2TqBYFvY1SXZQZDkhjq3w@mail.gmail.com>
 <20140814151958.GY17528@sirena.org.uk>
 <CAD7vxxLHtk2ywHGoBtDp6x3-5BtDdaFnCdc_pfgMwq63Cg8Qow@mail.gmail.com>
 <53EDBB5B.4000209@collabora.co.uk>
 <20140815095528.GH17528@sirena.org.uk>
 <CAPDyKFpm5nzXp5p0qxDof2NcOML911eYkjPNMsn9a2ttdnW7gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <CAPDyKFpm5nzXp5p0qxDof2NcOML911eYkjPNMsn9a2ttdnW7gQ@mail.gmail.com>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] mmc: core: Use regulator_get_voltage() if OCR mask
 is empty.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 15, 2014 at 04:51:38PM +0200, Ulf Hansson wrote:

> Just wanted to add some input regarding the errors in the mmc case.
> These are of high importance. In principle if you get, "Failed getting
> OCR mask: -22", likely you will be using a wrong OCR mask while
> negotiating the voltage level with the card.

> So, somehow we need to address this issue.

Perhaps a WARN_ON() would help here - I'd not blame users for just
ignoring the current warning?

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT71WUAAoJELSic+t+oim96VgP/2jbHcBpAmIOtWRxUYHsiKUk
QAbWtkW+xpUnG9+BGfnGTUKvY9EMl/rIVjyetsxWl85u3l5MxP89XQas59/ftRw5
DVk/aJEqSP8e5KkPTl9S726ZRjAVAlGzqCFM4EtQfv5ySQH0UYVXsftKSlCkNmFV
lYfPkEjdT7UuuZ6L2QcitkRTtzpn08rPTx7+e0JCdnO2/mNgu7Kr6z/H45cpuBvW
UD55rxupcFf+MNQWosj3IscQH2QhT4GQzHcezHRAkoCLHi5BYGauNbjRchvrpFvL
f0GSyjOSqe3LChIXvXeVL9/2ddypQz84neuC7WkqLkA3GT27t6Fy9Khi8I9f+a2K
d6eHnaGxQ8HOf++CCF3hu21Vs6sOhSowR0NUJVK/YwtRkpdz4lTJq+MgIa5zv/3I
Tnme1lvh88yUDWMQrwgq1Y7T97wC+/WKw/vcNKftVh83gnUSHcynB4fHx5qarik6
x4GYsv8v0DV0XheexiafWZvsKqVxgcLIhlzIpWZSLB096ixCLOFU81LBLTEhCMaV
p+VBebdR8PbGTs9IUsvvNY8ugaO0qfq7NZAD+ZaQ+aBMLiGL7NZgwmy9nZZHHrlC
GaVxFULaHO8dhn2KJyMliGW7ZCOfiyFVRmDoFiNCwfz9pxqYxJFLu+YlYwwlluZv
lAEmAzabsaYjYFsKokea
=ebub
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
