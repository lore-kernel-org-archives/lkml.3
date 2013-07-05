Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab3GETzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 15:55:19 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51494 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab3GETzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 15:55:18 -0400
Date: Fri, 5 Jul 2013 20:55:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Bin Gao <bin.gao@linux.intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-ID: <20130705195512.GJ27646@sirena.org.uk>
References: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFi9av0ukRdmw+ig"
Content-Disposition: inline
In-Reply-To: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: i2c: introduce i2c helper i2c_find_client_by_name()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UFi9av0ukRdmw+ig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2013 at 11:33:46AM -0700, Bin Gao wrote:

> A good example is that an ISP(Imaging Signal Processor) driver needs
> register i2c camera sensor devices via v4l2, so it has to unregister
> all i2c clients that were previously registered by calling
> i2c_register_board_info(), and then re-register. For this case we
> can use this helper to get i2c_client by passing the client name.

Please look at the work that IIRC Laurent Pichart (CCed) was doing on
developing generic DT bindings for v4l in embedded systems, it sounds
like you're working on similar hardware here.  The general ideas should
apply to any enumeration mechanism, not just DT.

--UFi9av0ukRdmw+ig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1ySdAAoJELSic+t+oim9a6kP/29Q1GxQGBt3MEdD0V1Czybn
UAxzHzwoXqWae+KcvY0hXMD1G29IYnFE2SsB9VETAgsGJZH+ETTWV8FacCsLZ1EG
QRquUEoJfAl1hANEbnCyZ9+8wOhdPpctVd3jZTFl58pHdD4YAxXsyD82Ah6TnGxp
Iy/nuYYNyu6OZfpBXpDR1ofo+AQM7poXrlueITDZosP530LirBQ/JsPbdh8Y1WkX
lBIqkq6ggfCmTVH0QNhl/puNTp8hPNgcW2kGPwH5oRNrf7rgEkdBmAu6Gfo7byVW
JvE/flIq/f/YtyoHox990ei04frv9sPgG6EZTp0UdlIact8ucCEolYvoROfw16SI
AFNn4tQ2TPrutGiz5Y+oQJRzGtOX6W1hKGBlauy4dFZC1LrN/uXO0yheZPfTVSjE
IT3h2Qk9BRVngrSowcOPshSmUuipV/r0sKu/qNOdbTqKCQ4PWjpjgMmcTpbNhY43
H+j1QkooRhmsy9eSsGKOHH7/OXk2EZhFUW1JM27htK8o3taPWkR3bTh8g7k81ucy
rFziwv+ZONrLJ/uOLF2xcHBU2cAXfHXkrN1l0/qXZ+NSRSkeP3v3MQTL5gQWfS37
KN8WYSJz5WOHn2CsiOH7eoc3G/WirHku2aazx77GH0HrNkpk3LEakBYO9Uc7U9Yz
00vY3YR7P4M/e5Mtrzvu
=AER7
-----END PGP SIGNATURE-----

--UFi9av0ukRdmw+ig--
