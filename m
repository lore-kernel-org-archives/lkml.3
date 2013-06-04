Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab3FDRrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:47:17 -0400
Received: from sauhun.de ([89.238.76.85]:45006 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021Ab3FDRrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:47:15 -0400
Date: Tue, 4 Jun 2013 19:49:02 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] i2c: Let users disable "Probe an I2C bus for certain
 devices"
Message-ID: <20130604174900.GA2992@katana>
References: <1370367222-19353-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <1370367222-19353-1-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 04, 2013 at 08:33:42PM +0300, Grygorii Strashko wrote:

> Currently the I2C devices instantiation Method 3 "Probe an I2C bus for
> certain devices" (see Documentation/i2c/instantiating-devices) is always
> enabled for all platforms (boards) and can't be disabled.

Not true. Set .class = 0 for your adapter. I always ask authors of new
drivers if they really need to set .class to something.


--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRriiMAAoJEBQN5MwUoCm2UO4P/RZGhzuhHA6Ps/hZg45o5Ura
DsENTFBlJNLg7hbHssv0jNkyw8RUR6S/8CY8hhHli6BwVoVd7+2WBxIAkSImmmE6
Yx88+RvBH8nBspR4YUqqrh0XIcTVtrfjV2XM17Cb6AKFoI6mBbVw1R1iOPZbg2XU
R0tT9P0PtE4H6lyOa2UEZv3LqBi7ywuDcwU6uaXAOeF2cKZl1/PFXEinMcJO8zXK
B1UkWGk1z6woPIYbk6lsTGripqMDe/B7zXlJFFN/JY74rmo8q1PMJEnPGmI9bAzc
gOHtDfiwOi59GSHJPBnJxQNNPcCIBFfME1JgQQoOuJBDMAk0U4fCmLJx7XAinzKx
Ih1KovGz2uqdUVU2nL20nXsErvPLKKp5g8f436pIUGEi/qGmF0YoSH4eahRcLZoE
8eihODJAhBP/gY4xB1vmO8vKSayIbFkTvN9zOcVTtTBTmSQ5vkzkvWOkVJFgj9kj
zxq+YsYCCigr3QBJLfVtauvcZcN6+QPpuw7REbgPmn5Hv9vy9Poo+3UsS7AVhvDB
ZYIHHVM5kSDlD+Ym0FMjlVpCYMZGlBZNcntQGP5y9cQng9xDNFoY4pZno0hUkX6C
5CusnbUw6SYmd2BPHaSBPq7kzdRUK1eZmLVumUrJD/edjtSGYlG4glKjV6GcdgIO
bTWtMOUM4AH6eQXIh2tK
=dmQs
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
