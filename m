Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbaHGKGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:06:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51161 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaHGKGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:06:10 -0400
Date: Thu, 7 Aug 2014 11:05:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Nicolin Chen <nicoleotsuka@gmail.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        timur@tabi.org, Li.Xiubo@freescale.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        b42378@freescale.com, b02247@freescale.com
Message-ID: <20140807100553.GF17528@sirena.org.uk>
References: <1407223925-29678-1-git-send-email-nicoleotsuka@gmail.com>
 <20140807094527.GC17528@sirena.org.uk>
 <20140807094404.GB3088@MrMyself>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RPBrhutAYpIit0OE"
Content-Disposition: inline
In-Reply-To: <20140807094404.GB3088@MrMyself>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Add asynchronous mode support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RPBrhutAYpIit0OE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 07, 2014 at 05:44:05PM +0800, Nicolin Chen wrote:
> On Thu, Aug 07, 2014 at 10:45:27AM +0100, Mark Brown wrote:

> > Might be worth printing an error here.

> Hmm...Do I need to send a v2?

Send an incremental patch.

--RPBrhutAYpIit0OE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT409+AAoJELSic+t+oim9ysYP/A0CFYRbS/nhwGKrxjI9PRJt
/xGfd+Ke39ZYSMy+lW2rXlvmK3yHnHQd68fr64cdH148dEZD2eYlfrzcjpC0kGOb
Ax0tkjXhRjd5axgmPLqCmSTLXmg+DeTiqk+ReOsXLj/M6qYrPhMY5p39/9KvnGwj
Hw5PuUWaeS7+K91NIwFgWFYilxQx+Z3WXXN7++3UfRdh6v7Xr/czp4CgzaBGO94z
idji4VUxO66tERbU8iakdXlwSpzCuT6WhuN1taKZboCyPEQh/CFZdJtMm/NDzKwI
XrtLnA5o6HATngQpRw+lwOUsdZZUvvsKD1ob8dFOeTUXFE1mPDMiL5GN4tAkOFJy
WaFQiX9JjZoF0TYr3YsI5hNwgJL9mJNeo+bcSsfZ2p+EAMptkk28apRsVXiRKC1r
vBet+/vba6MbQAP9TakJICUMdUBbqRw8GM+u1uT2+0VqCypAls7gv/ojwKhisyuh
2v33tiBtqhI0Ho99QyCBpEXNlzU78T1xMAgkcXST1RFrBLoomYJxwXSaDa7wyLi/
SyiHRZYgvoKgni446skmTt7NYFCZmAEjpBhzjTyQ/Bk9ADm7r/qdOyNl6pWc0PUE
tlpX6K4Btr/KGQPgdIhruXgYh8jjNpcfJKaKK/dP5jRQ14PL3ow3pC5MBN4Kpj4H
gsjT/Dl07Fg9DDTt4wRz
=KJ79
-----END PGP SIGNATURE-----

--RPBrhutAYpIit0OE--
