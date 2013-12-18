Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab3LRSbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:31:42 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53097 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab3LRSbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:31:40 -0500
Date: Wed, 18 Dec 2013 18:31:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, timur@tabi.org, perex@perex.cz, r64188@freescale.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        linux@arm.linux.org.uk, tiwai@suse.de, grant.likely@linaro.org,
        fabio.estevam@freescale.com, LW@KARO-electronics.de, oskar@scara.com,
        shawn.guo@linaro.org, b42378@freescale.com, b18965@freescale.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org
Message-ID: <20131218183106.GF31886@sirena.org.uk>
References: <1387250684-23406-1-git-send-email-Li.Xiubo@freescale.com>
 <1387250684-23406-5-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l+goss899txtYvYf"
Content-Disposition: inline
In-Reply-To: <1387250684-23406-5-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3 4/7] Documentation: Add device tree bindings for
 Freescale SAI.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l+goss899txtYvYf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 11:24:41AM +0800, Xiubo Li wrote:

> +	      big-endian_regs;
> +	      big-endian_data;

I've applied this and fixed these two typos, thanks.

--l+goss899txtYvYf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsennAAoJELSic+t+oim99IQP/3BNIkRro1y+W29acaoe8U8t
L62vvE1U6htu+XEcy/2mQJt86bwG7oz1Mh7/ApE/0zZ41nBq8hLOiFDol4rzW/kk
AOSasrmEtHxfmjxSOHirsnM8katw29nWEJAN04ZzbHyiZfrPanpi9RrG+0gaEPAC
GGuFKkK9bs+Q5S7MUlKOm4ENWXUvDHmEtaE6tPGCD2TJ7PgUCdrlI5xdhuEPUzbJ
/o9AIHbeog7N61blhui+tn1HkZzPxnqRpByWSFIAb+PUEpP7doXzT52V57RN5D9z
13LLZh1CH9pcrldZ3ext2+LuHbwIUV4QE//nXvDko3TZWew/ZA05nnMkvxeFHGPe
NUJ5e/NqXGcCcTZjM9TBV+lcSEgVcm+t8LajLQFbm+l2CNin59CMUlIvHj1jYJbw
NM8yPHeuTXTxIs0gWfU/N5jpRF60YJkngX5JEvj4kHFuIe5wXu2x3+aPSes91C8x
YBiGHyZubdGYjr4t3uFbjIjRUR3NROCYXu19uSGIQHWo0lIEIevXjq8l3qw0udbb
DuxvlQRYKbxP5/RtrmYWc7PitdoKRzKwXW+EULHALTAmwrAL8grKpuS4Xy36dteH
5WHRWhSUzDs0VrpqRWQuI1Iy9MGUATwwY5tifOiamje74ec/as/Crm9Qymtpguzk
S1N2v02gyvbuOVYqn5yI
=NasZ
-----END PGP SIGNATURE-----

--l+goss899txtYvYf--
