Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3AZHXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 02:23:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49233 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705Ab3AZHXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 02:23:12 -0500
Date: Sat, 26 Jan 2013 15:23:03 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, cxie4@marvell.com,
        ytang5@marvell.com
Subject: Re: [PATCH v3 03/10] spi/pxa2xx: convert to the pump message
 infrastructure
Message-ID: <20130126072302.GK10580@opensource.wolfsonmicro.com>
References: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358850393-23111-4-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ELVYuRnMxQ5nnKRy"
Content-Disposition: inline
In-Reply-To: <1358850393-23111-4-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ELVYuRnMxQ5nnKRy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 12:26:26PM +0200, Mika Westerberg wrote:
> The SPI core provides infrastructure for standard message queueing so use
> that instead of handling everything in the driver. This simplifies the
> driver.

Applied, thanks.

--ELVYuRnMxQ5nnKRy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA4RPAAoJELSic+t+oim9SE0P/jUapQAVqCJhz1V7LvHbDPnz
DyL+IdTBIz/72RNdibns919M/Kg7bTvaYNHhdahDrGwW1mpP5DZ+2oLALiTGYS98
/aijcgUhAVLevgYganKJzREJUT10nxX6fpZesDWYQdMaeQTv2APXBjc+n/AKVNz2
BDBapPpSdE/IMkus9nTDHAZvmbprZjRY/YfPR2piBuZNwbx06KaU2cAqdLueKWXb
N69/iSk7oCbRTe8h7LTQXCOiRxbj5lSkbmpDsIjjlpPvVWK4g0uRko6gqPV+B0eT
j9gwf6LnsgtWr7XIO82htsWJE6W6hiUPipcPDevjaVc8AdE/Q8RPn064MQG5Wk6u
jAg1O3cWSBhlTosFuxFCwyCtB9dz/Wdu6wuM/+Bu9vUWGc46lrtGUHYAZaEGRdgk
/0MU6BwAlNTf33UGtXSV4wCyOR0UV4Gf46dO5eKFDiZV/KIWXXrE0F8K6CKsb0PY
k97DurDYsSX+gM5AXiwRYhq5PNzhm5NAEpqS+YQWebsoAoMJTAxY2tOm3XHpLbv3
ctS5r4pICAu7+t8n38FKs0srg4vjajkzKuqWkqlTsCxK75Ph3uxhwx7m+RCgnRli
LthY23hJoiTQIMET0NymgzkeyE+nXOyqwj7JGURvSQ13LXw2nKMThe6/NZitr89m
ZlyFBXwRUabip13Gns2x
=5IXu
-----END PGP SIGNATURE-----

--ELVYuRnMxQ5nnKRy--
