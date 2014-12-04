Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbaLDSct (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:32:49 -0500
Received: from sauhun.de ([89.238.76.85]:34372 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455AbaLDScr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:32:47 -0500
Date: Thu, 4 Dec 2014 19:32:43 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Harini Katakam <harinik@xilinx.com>
Cc: mark.rutland@arm.com, michal.simek@xilinx.com, soren.brinkmann@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, vishnum@xilinx.com,
        harinikatakamlinux@gmail.com
Subject: Re: [PATCH v2 1/3] i2c: cadence: Handle > 252 byte transfers
Message-ID: <20141204183242.GJ7944@katana>
References: <1417610126-7957-1-git-send-email-harinik@xilinx.com>
 <1417610126-7957-2-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ou9v+QBCNysIXaH"
Content-Disposition: inline
In-Reply-To: <1417610126-7957-2-git-send-email-harinik@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1ou9v+QBCNysIXaH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> +		/*
> +		 * If the device is sending data If there is further
> +		 * data to be sent. Calculate the available space
> +		 * in FIFO and fill the FIFO with that many bytes.
> +		 */

This comment looks broken. In general, I think there should be more
comments explaining why things have to be done this way.


--1ou9v+QBCNysIXaH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgKjKAAoJEBQN5MwUoCm2QNYQALFSMcFaSdbuQdzFfDGCUSNQ
QCBKi1yuVOAArsXzWiPqedR62xNJ2r4AfUhNxAQF+wu6ZZtztOTT1XMFtkNvuGhM
1VYOqRuq84LjduhW19OFCdO0Vli2Zgr9qLKNMLoJxnLviwHx2HPsYyOjG6mM6IdZ
hCLGe1y/he6IhImAyTheqF4VMawyQQ8mzWGGIvuyp/ry5amnUMHVYfWk0FSAm+iV
+fTxLC/9AHmUIUPPu1b5NPHfkaY3R/blgZVkWxSe+sK62+TV+gNJhOh1260NQkq/
9qfQdVm8kYSxfCv0BRWmS2tOCtO/A42zFnkdNbN74OzEZPsxWWMeWb7sb5bMdr3P
i3da2tyQaurODcY6rZah0lfpl7bct3mUhZjWrLyL/yTbe59Kmo9pEFwC4l21uKFo
szK5Rn9vf2MRWJfEQ6C3eOs+LRxJ4wgdDAR4pEJuqO/7aKQoaRF0jchxGNWJhu0G
BJjtY+GLb/OrE9Qu1U6kFrvSCoYX1jHit3d2l1rZNQHLTLnLQFKD0gq2mAvD5AQ3
0SNfFV2HifTy+2jvAfTbQpCxIDp83c+7aT+nasFTPJWj2P50qzMs6+kARX/ujRIR
aBxOgQhBQvgwzyMAI7IQhJhdMRJiFX+POF3hE6qyLK22juapEvdB5x796PhdyGFr
7OwvbsXXapolMMpTh8UX
=4GSX
-----END PGP SIGNATURE-----

--1ou9v+QBCNysIXaH--
