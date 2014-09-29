Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaI2Osq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:48:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52926 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbaI2Oso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:48:44 -0400
Date: Mon, 29 Sep 2014 15:47:52 +0100
From: Mark Brown <broonie@kernel.org>
To: zhang.lyra@gmail.com
Cc: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        mark.rutland@arm.com, m-karicheri2@ti.com, pawel.moll@arm.com,
        artagnon@gmail.com, rrichter@cavium.com, robh+dt@kernel.org,
        will.deacon@arm.com, orsonzhai@gmail.com, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140929144752.GP16977@sirena.org.uk>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
 <1411992293-7729-4-git-send-email-zhang.lyra@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AwNVUpjOmSj7UnwZ"
Content-Disposition: inline
In-Reply-To: <1411992293-7729-4-git-send-email-zhang.lyra@gmail.com>
X-Cookie: Your own mileage may vary.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/6] arm64: dts/Makefile: Add support for Spreadtrum's
 Shark64 SoC.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AwNVUpjOmSj7UnwZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 29, 2014 at 08:04:50PM +0800, zhang.lyra@gmail.com wrote:

>  dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb foundation-v8.dtb
>  dtb-$(CONFIG_ARCH_XGENE) += apm-mustang.dtb
> +dtb-$(CONFIG_ARCH_SHARK64) += sprd_shark64.dtb

It's better to keep lists in Makefiles and Kconfig sorted
alphanumerically, that way there's less chance of conflicts when
applying patches or merging different branches.

--AwNVUpjOmSj7UnwZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUKXEYAAoJECTWi3JdVIfQz24H/3JHUNCIIe+oQu0RDtsRRR5M
A3XR98tDOuUnFaLSiLRPfMuVwgUS1sXOBzPCwqawPqbS0vV3vs4RAXx7g68T4rLM
mWr/RMAm3Jw2Al8uRJNKYUMEZ0vjj+/0sBD7ISVoTOeod2l7qgRZucMkZN9buIcN
c166c8u5sXorr84Uljvdr9LSP4YRbaLY/KGhvg8xRJuj1aKkzbIGcmiKuuLyy8Pp
E458PH85D7Q+ph3hGn1jP9bKkpLk0mx2szb7BE2NTL8DFajblEMBE4m68Vrw6Fee
74CW+GqNpc2AzCo1WW5auwzmiuSYEXxHlV45DgDymsz/riTlJpqnPWvw+l5ekkE=
=aJWg
-----END PGP SIGNATURE-----

--AwNVUpjOmSj7UnwZ--
