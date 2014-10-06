Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaJFKtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:49:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38734 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaJFKtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:49:20 -0400
Date: Mon, 6 Oct 2014 12:49:17 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-pwm@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 01/11] mfd: add atmel-hlcdc driver
Message-ID: <20141006104917.GF25202@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
 <1412175188-28278-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bqc0IY4JZZt50bUr"
Content-Disposition: inline
In-Reply-To: <1412175188-28278-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bqc0IY4JZZt50bUr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 01, 2014 at 04:52:58PM +0200, Boris Brezillon wrote:
[...]
> diff --git a/drivers/mfd/atmel-hlcdc.c b/drivers/mfd/atmel-hlcdc.c
[...]
> @@ -0,0 +1,122 @@
> +/*
> + * Copyright (C) 2014 Free Electrons
> + * Copyright (C) 2014 Atmel
> + *
> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
[...]
> +MODULE_LICENSE("GPL");

Should be "GPL v2" according to the header comment.

Thierry

--Bqc0IY4JZZt50bUr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMnOtAAoJEN0jrNd/PrOhGW4P/jXfxgQLWe1g0LYFNcrokYOs
upOvspDWjmRuM+o3oEgM1NqmUuilnhbPU6kMtmVKyJbPrnWa0PXrz4h6ooM+KHBM
t9KgsuP5Yrk2yWf+LDTklawEgUj7tNkyvF3wXOgV3CU6Ko4Yir8ZzoSoccUMNqpQ
mgzHDWJ+P/CdoMyNFBJGX7Hmmkou/LngrKu2fg4/KQaCu+iYsbreVQp7NMkbiqqQ
iqZgBIrqmQgYgbAWdLRoAk+1IerWWZBPXoYIisrBWsc5QsJXNw3fqRKYAUivUiuv
vl4v5lhQD7J65agYR9kECTR/OBRIMhv8bWM4eNjF7WCdUiYzKO45HDUsVvOucMQu
tihj5pdJgpKBnNL9g1PaJXhuNJ+Ae9CqIJlwt94qCMabNRQZMwKXIk3eXGrijEtt
otUfwD23cZOTtjGn35ZyLmcrbS7Lv7KgaDDPSyn/uE7G/4tDi6vp0vq74HA5ElQn
+OQzvMBh2W/qP+MhywtnUbH7aSrH6P+zuk869U7yR8GWp94rbGHSvzEAwyJBq4rT
3NBGtit2er18ejzLgxvc/f9AGGaXbYewC+Uja/v4w7fa2p5/Ji6xL/GTNYJoAVl2
gPsTbypToLC40E0gsIvVK865yI76fywuLvh9AfhVvx/GxQ7TWNePau5cX+qZrPBh
NWnYvZA9CEETUrzZmdoj
=ZLAW
-----END PGP SIGNATURE-----

--Bqc0IY4JZZt50bUr--
