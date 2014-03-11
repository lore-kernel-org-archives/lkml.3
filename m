Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbaCKSxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 14:53:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60572 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaCKSxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 14:53:16 -0400
Date: Tue, 11 Mar 2014 18:52:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Matt Porter <mporter@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140311185252.GX28112@sirena.org.uk>
References: <1394552775-31264-1-git-send-email-mporter@linaro.org>
 <1394552775-31264-4-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MPTQUV1vt+merpdf"
Content-Disposition: inline
In-Reply-To: <1394552775-31264-4-git-send-email-mporter@linaro.org>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 3/5] regulator: add bcm590xx regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MPTQUV1vt+merpdf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2014 at 11:46:13AM -0400, Matt Porter wrote:
> Add a regulator driver for the BCM590xx PMU voltage regulators.
> The driver supports LDOs and DCDCs in normal mode only. There is
> no support for low-power mode or power sequencing.

Applied, thanks.

--MPTQUV1vt+merpdf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH1uBAAoJELSic+t+oim9Y60P/2QI8WZIJenmRod/AjD7GsRn
hE0+/UVpMc71gq0OxNDqPJAWU0sxYuC/Vbn+5hbO2SVd7KjpurDxOk4xC3meWHUz
eg+56O8g4oomL9SlwTlR6D0/7WMY1Yz/DkDfIUz5HuQjc8ibhL6MhKhcpLLXnp29
1yq5lyPlj/lJXM0pkTf/IeG+jjHp1vZs/H0R+Xq1nqpsNROaHkhcM0IQq9JXhTsW
PYc2VFQcHZ/zGxP9YpG2K86UGT/bNStEpqg6ciyjd58HzfHf56dDr+3LCmcCv2IB
roLHFvpc2T9N6LAxjdMlAsDXb3R+rwLhW9IAHaf4LzpOzmr5gSODE4Ewyp2jUYMq
sUBVBsHlo3+sqcn1sZU+Z9xMoKPday7LfDM6AicPgrDj4uxpSWDGWHIl4BmwIgIu
4JNc5HuDTSKR6PhOoG6cR+06xGOTZ5YPVoobvge/IwYcrOWUVrECr3IEaj/LuKgc
4pzqU18J+z211jACMpCgUA33Rlx0ixee/PdpOwUK80kvs7+XFQnoY+HD06HLo6iK
2iRrO6avkPKLplq9C4skwMGkbhls7IVblClUDyB5IS1YGddaR0qe5IUfx48lHtky
bJeoYCSVkjIhz9//fOExtBcPopAnSXU3nePKmuhNU6qHJQ7BL/rKWq511v2OChi3
c+u+5SyumsYd7UJu1ZEd
=/huS
-----END PGP SIGNATURE-----

--MPTQUV1vt+merpdf--
