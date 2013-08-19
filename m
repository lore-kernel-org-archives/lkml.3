Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab3HSS4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:56:39 -0400
Received: from sauhun.de ([89.238.76.85]:36580 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab3HSS4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:56:35 -0400
Date: Mon, 19 Aug 2013 20:56:33 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RESEND] i2c: move of helpers into the core
Message-ID: <20130819185633.GA12011@katana>
References: <1376918361-7014-1-git-send-email-wsa@the-dreams.de>
 <1376935183-11218-1-git-send-email-wsa@the-dreams.de>
 <5212624D.5090708@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <5212624D.5090708@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> However this patch fails to apply onto either v3.11-rc4 or v3.11-rc6:

Argh, did not drop the MPC patch before rebasing :( So either pick the
patch "i2c: powermac: fix return path on error" before, pull the branch
[1], or force me to resend ;)

Thanks!

[1] git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/core-with-of

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSEmphAAoJEBQN5MwUoCm2oSMQALA/vPFqMuszNie+wpNeFLTx
ndq9K7tvwvyV6ix/QtfrneDKM17i0G/OljSqOXMuO3YddSvGKIvs956j6te7Tor0
INyTIzc59ycgiF10Zt6egrZOa4CTwka0IyozuU9tiue9VIIL2u4SnTkS7aEOH7rI
rSFgyaDAFjvcMLAVrw/nsTcM5GRLVsFwZJklQ4m5m6ntXOs8cVDsEhkFUbMabLEA
ITNMspH4KtEQr3v5ij+tl6rhUGJzWu8IARf4C7f8Gxas3y8NuADXlXgFjtd5xccR
6Qgex4Wuv9yOLK9oCiXHrg3J7iXR46po/VM5BEHxT013Wxde8784u8Hv8FaPxC9r
r1FkkadCnWaJWe0nIq2eFTU6pECwuSBT3Bu5d4kOrhr4S3a9Z+3s4KpmWZEmaNkz
nN5hBURGFQIdLY7BzGJWiBRLqa7kq97ATfMr9N9Pg7Rpqa9TezMDF2Sm5DP2p0Ha
fR764qsVds2fPT8+DIEnNiwfgBFJYcXhV0yv5T5pkncE5C6x6RQoK+RmRXMPO8hx
l3xL9yV9GHVITzzgah/uaCKHCh7dboPYlKoiEqwHb0GxGbaEq3kMqaJ0D99mIss+
k9sAe3Nfq02mwMN+2pGEZX7Rzs3d4CD84Yi0NC/csPSzkAHuC0qD1qdEw9nGrw4v
ptWWV5ABSl7wqbZKZ0Rc
=96ic
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
