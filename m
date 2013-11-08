Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab3KHPqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 10:46:14 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33554 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab3KHPqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 10:46:12 -0500
Date: Fri, 8 Nov 2013 15:45:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <b42378@freescale.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, s.hauer@pengutronix.de,
        timur@tabi.org, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, rob.herring@calxeda.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk
Message-ID: <20131108154532.GO2493@sirena.org.uk>
References: <cover.1383910029.git.b42378@freescale.com>
 <1045921af1119333da2d14628473a20ed7a202bd.1383910029.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JIgDBBEDRU2Tt5Ar"
Content-Disposition: inline
In-Reply-To: <1045921af1119333da2d14628473a20ed7a202bd.1383910029.git.b42378@freescale.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.69.173
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 3/4] ASoC: fsl_ssi: Add dual fifo mode support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JIgDBBEDRU2Tt5Ar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 08, 2013 at 07:32:53PM +0800, Nicolin Chen wrote:
> By enabling dual fifo mode, it would allow SSI enter a better performance
> to transimit/receive data without occasional hardware underrun/overrun.

Acked-by: Mark Brown <broonie@linaro.org>

--JIgDBBEDRU2Tt5Ar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSfQcYAAoJELSic+t+oim9B5MQAI2hUJqc2K2G9SSoRLNfYlqF
s1znFLKOQ1cTecd5jwJj/Akt19icp1fcEwwQi/mOGZxhAoKUic6tMuzDDfRKbxZB
eccwytknKUWQncezIZz6u384W49bBABPTKCmAkKSJHstzXiVVxSWeRgMTvRVkGEC
kjKLQQDON30zmLcT/8mEtEt6nT0vT3dimRXIHEiBi31SK1kBynYqDDd67SuICKPB
YLsRY6f7cpw5+Bs3Pk+HHIdnMtMMl3gj51Hr0xO9THGJu3PoLIqW24mCvV2qXK4U
zALThl+fgQRJ+PN9Oz/lXUE4gDgLNLKMDVXKe//8upl52Q7B27APZcSZG22IlYDb
Qvg+JgMunRpZaHQGd1/cA/lgFSF8dBYcbysWao9xqf+IPzrW6o8HELrwIWFO+og/
a20Jekpn6WFpsVJSLxOrUORDN/IfmlyCu18YQHAC7uYKDGNgLjVa7wGVVXk6XyF1
BCw+EBPF7+t2H3oobFwcR5gaD1+omJ7A2FB9gdK1I+zSDeaz7edSqbWFnEMzvdTx
Ynlpf6PR04g+UvHQr+Kn5RxofSKLJPdD1sumQPvArfw+fdKeKUUCSMAtH72BupvV
g/HqT99wyMcQiPyWPToDe3M1iNABmi7jHWyUEv8C/AcoZn4IdLJQ4Hnfh3EKXK/8
NRwu3wOKk0FhDaJwhzG0
=eddQ
-----END PGP SIGNATURE-----

--JIgDBBEDRU2Tt5Ar--
