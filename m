Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbaAPSEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:04:50 -0500
Received: from sauhun.de ([89.238.76.85]:59992 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaAPSEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:04:45 -0500
Date: Thu, 16 Jan 2014 19:04:41 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Phil Carmody <phil.carmody@partner.samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: Re-instate body of i2c_parent_is_i2c_adapter()
Message-ID: <20140116180441.GA2617@katana>
References: <1389648544-4201-1-git-send-email-swarren@wwwdotorg.org>
 <20140114161254.GA6442@katana>
 <52D8160B.7090205@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <52D8160B.7090205@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> I do see this in for-current, but it looks like that branch isn't part
> of linux-next. Should it be, or perhaps for-current should be merged
> into for-next?

It is upstream already.


--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS2B85AAoJEBQN5MwUoCm2GR0P/jo+b8k4gnwcG+Cd1AFcbVx4
XyrSxwe8nWDiYKjtSAZX7ibBfRduEcdiAx8t12t8tN0z0ptjARV8EQgVkvRlSXzP
WU43jYBzV6nOh/E/4I2H9ScoR4SDbtfBy818m10Zp4NutN+Gz/2xUT5WqAnBkt3d
2+D/8N/qotxCF7zjWq0HMC54zFSoSpESM61HwH6sYF3ynvCwEQU8csrQVj+TI9B3
L1CIz/29grnQl1wrlQPL2qftvhL5/5vfbPdtJ31YEctRjAswZ+qb48uU5E7Yus8Z
aOavx5NCy55GZogt8YYhJ0mFshPiJKMYDpydkL0Rj4wpsjEIgnMxiJdnsFc0hT9N
RbNc4W7ymHpRVNb29Gn8IuJKljGtPUakYQr7wa2X49F2w5nF6ZsP41Ps2lPoL672
yaIjeukbhkP425Kl+tsPvRI6K2o/xcf+d2yz88HXKeEO3Daj/pBQhUyvynqypcrv
l97KD6y8Tlr2g3ULceC2nY+161PvGThs9tvf0F7qVomgOcI0WMrBV6RCDQj0Old/
daCM/vQu4J93d9bvvI25qVCrWFImtq4MjjZWkBHDb82veD29PT4JeKIN402reDDY
0ek3fDq9WQpdAc1gPeeKj2AvTbWOqpYDrmYuqYJn+WCDqOQYYoCjpqTkiZ2m+ehr
/Fz56r4WorHf9FVFntCl
=24eK
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
