Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaE1UUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:20:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45929 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaE1UUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:20:23 -0400
Date: Wed, 28 May 2014 21:19:55 +0100
From: Mark Brown <broonie@kernel.org>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com, tim.bird@sonymobile.com,
        linaro-kernel@lists.linaro.org, arndb@arndb.de,
        linux-kernel@vger.kernel.org, dsaxena@linaro.org,
        gkulkarni@caviumnetworks.com, linux-arm-kernel@lists.infradead.org
Message-ID: <20140528201955.GJ5099@sirena.org.uk>
References: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851676-16389-6-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oplxJGu+Ee5xywIT"
Content-Disposition: inline
In-Reply-To: <1398851676-16389-6-git-send-email-takahiro.akashi@linaro.org>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v8 5/8] arm64: Add ftrace support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oplxJGu+Ee5xywIT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 30, 2014 at 06:54:33PM +0900, AKASHI Takahiro wrote:

> +/*
> + * arch/arm64/kernel/entry-ftrace.S
> + *
> + * Copyright (C) 2013 Linaro Limited
> + * Author: AKASHI Takahiro <takahiro.akashi@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/ftrace.h>
> +#include <asm/insn.h>

asm/insn.h contains a bunch of C stuff which won't build without
__ASSEMBLY__ guards unless I'm missing something (I'm working with a
non-mainline tree so I might be).

--oplxJGu+Ee5xywIT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThkToAAoJELSic+t+oim9ru0P/3Zb7Tf7LLg2jL9es5KkW2I8
Ua2BZla5oOG4fUp8B2pLL92+3kHFk61BNUVnvMg4RkwlvGN72uE9Eh4tr4KGoGFw
TG93XHNi1/XEP8Aj5PXeUd/SYa9YgEz8xWMLsg/aGK6bn8WIIKsKxDMYR0vN/+Q7
59LxpQJIpy82cWkDZCzGAVAymJHIETQ3nGkj4111K3QAA/GHF4NvfWN98fBy7/WN
v54KpwR8AAjPUPDeoQDG+Ymm/YXK5xXyfi+pwyjIed+HBRUWR2nyKtqClVVbbtj5
oJ7YKibqL8qNUA0crR9ys8lpWyECb2H+ER6uUyRRmiMte/wh5sgvypBRuApgZbcP
hA0BngGocb41LsuY9SjqgndtEnskFurAUlaSrVJWfOnnoq0xxdKu7iyrQCWWq4RQ
QKN1gsaXvqRxybMeyV5tp2mya4NOVuDoFipi226+m4LuWl3nmZyk3U/hOl2zcKgO
Ky5vQlyL81qhU6iNA72FMV88XiAr/pONnPdraDFOEjs/5+w7zYOh7t3n99W47zFT
s4R4Jt1lrpAHivS/8FuD+Sune815S40Y8suk57TBxcHZix8kc3HM86RvGC1BoL0y
mo6ZLWeSHc6j9cQwnr+GIATKMWzqZn0Z8v/02rrXm9oxNCa9ZWhjWXtoSTWw5S8B
Ky1Yo6ILDn5uq9cJviLL
=etWM
-----END PGP SIGNATURE-----

--oplxJGu+Ee5xywIT--
