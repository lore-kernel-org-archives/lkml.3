Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3BEMBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:01:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43065 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914Ab3BEMBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:01:38 -0500
Date: Tue, 5 Feb 2013 12:01:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 05/73] ARM: ux500: Vsmps3 controlled by SysClkReq1
Message-ID: <20130205120134.GY4720@opensource.wolfsonmicro.com>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
 <1359978868-28736-6-git-send-email-lee.jones@linaro.org>
 <20130204193737.GU4720@opensource.wolfsonmicro.com>
 <CACRpkdYWZOa=bbJYpG7owxVJXxPq5sx7jHmo5UpRe8pmPGYKMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7tPHY7RFL01rOa8z"
Content-Disposition: inline
In-Reply-To: <CACRpkdYWZOa=bbJYpG7owxVJXxPq5sx7jHmo5UpRe8pmPGYKMQ@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7tPHY7RFL01rOa8z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 04, 2013 at 10:21:36PM +0100, Linus Walleij wrote:

> What is needed is some way to model that
> electronic relationship into both the regulator
> and clock subsystems (Ulf Hansson is working on
> the ABx500 clocks as we speak.)

> Maybe the actual place to have it would be
> somewhere like drivers/mfd/ab8500-core.c.

> Have you seen similar stuff in other PMICs?

Yes, it's fairly common to at least have hardware enable signals.  If
what was going on was actually understood by the driver in some way it
might be better but right now...  Especially in a series like this it's
really bad to just see loads of patches which boil down to "change the
semi-documented magic value" - this just makes the series depressing to
read.

--7tPHY7RFL01rOa8z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREPSYAAoJELSic+t+oim9S1UP/i8ISUj8yYo9M7b9ViaAiqDa
x5cT8yn6DK0aCeNV2bnva49AhMxbvYOqXlB2tOlkniXperH/coDHdmqqIv1S8TNU
2/B7d5oNBjBmdtTpG2Kf0Jl3ByBVEnnzaMt96gl7GWLL4qyb0Oem7WWlQ2ybuqBD
h45cEVY0j3iXgXsfP71oxAJs2IP3B2vBEt77WO/hH1PAhDV4Qi7Hn93+ySE3e/1q
a9CVk+zJ/Evsn5C2KfXC3qX//y0zqraqz+sZQTfFhzTYRdyAZhb3WslkeBMdFzwm
mYlA1OkMXYHEZ+V533rwX3mmH0GxZyz2XBQEpYGbfurOBK2ZN6QZUjQX4o/ASGYW
2i7ielvkspwKs/PAMYvkP2DyHmJlLvka2qWpiltqbXXQIWHmSGQC5exta8UKAiTM
SRBXX+lbPcpNLHV+lrrY8x0tXPIomRtM6xoc7X9+SzTvDuvPh/yLmsVhbo+Zh1LQ
8qjG2WeIuOGUP3HtBUN/ida7DxILvsTlbqOlCorWvN/vjnC6EX9xeFzegtbbpj2R
dxel1yTBaaVKGGZZjP9w5sjqCjQzpAwJMFMdwR1j2N/18bl6Jom9W0pMxCgfpGs1
YD36ahJhwXXU68dQ+sjD0+5fgRU5LWRVm7o1pRZd3SVmVJ76YLMc1tYBe42LUtzR
i+UlMUGKCW3iaoO4uW/W
=FNBK
-----END PGP SIGNATURE-----

--7tPHY7RFL01rOa8z--
