Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaENTR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:17:59 -0400
Received: from sauhun.de ([89.238.76.85]:42204 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaENTR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:17:56 -0400
Date: Wed, 14 May 2014 21:17:49 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Baruch Siach <baruch@tkos.co.il>,
        Wan ZongShun <mcuos.com@gmail.org>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c/nuc900: fix ancient build error
Message-ID: <20140514191749.GA25709@katana>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-11-git-send-email-arnd@arndb.de>
 <20140514162725.GG12911@katana>
 <4944869.eRrWyMmW4d@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <4944869.eRrWyMmW4d@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> For the moment, I'd leave this up to Wan ZongShun. He has in the past
> at least replied to emails about the platform, even though there hasn't
> been any new development.

Agreed. Let's wait for his response. If there is none, I'll think about
removing the driver.


--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTc8FdAAoJEBQN5MwUoCm2E9QP/jxPLp8arOPDrRmvM3afFc5j
tioCbPk11VsNTwWN/eQF+ww4FHk4HXZIhXf1VUShBaVBAox3nSlowvYRjZrvam7E
Lo/z6bYsw4Zef2I94PgTxVKyvUvHX/csyhdKqaBPJ6AkAhBICDLUr2LSsmJCSZ2C
KqPdHeX63mdVXx/x8r4xQ9/mEnpDkCkn1fPmBHLcXr4INpp8O5S4SFZEy54rDLFh
03NR5cPGXRrilJ2D6sk+GLnpheNY8fj/QX/xatI2R4/jwIG3gTsmTwltCd9XUwYG
L1b2dpGlOwLW90OdCIrqT3PhasSlHyviojAuvaEA0gxiGJSKQuWGTbd3vVH9m/ql
qxC8s56C51WSl8ZAKwa5XOnIHlJ2NGy/4Rt+wzAj5c7/vAb6jQsS+H3L7NmrvJF7
L3J8f1STrAJYkCQHt71dq//RBnEoa7o7BPxR04SJWsxqW5ptsHHBaCLSdbfFE6VT
g4KwGYDoif3YdmxbQgyK7RUZY67j3mbFWLBFFFlnrEc+YUpNlYZxSsehwpmdTvJe
x2X+ZLVlUTxWt76DGQfra8E0yB9oNzI/UvzNpb4+oAqwVut51kKd3jdYKfRYaQRb
5ueKuFKqX6V5LL3Df9ZHSXVvJzBoylk/QNqeXolia7zrGGsSuQnqmR1hcxihrXZ9
RF2qx5fLOe2ONiE+KbR3
=fvlQ
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
