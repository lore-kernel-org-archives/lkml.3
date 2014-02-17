Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaBQXuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 18:50:44 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52810 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaBQXul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:50:41 -0500
Date: Tue, 18 Feb 2014 08:50:13 +0900
From: Mark Brown <broonie@kernel.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk
Message-ID: <20140217235013.GD2669@sirena.org.uk>
References: <20140120100415.GX15937@n2100.arm.linux.org.uk>
 <20140213181216.GB24155@kroah.com>
 <20140213181559.GB30257@n2100.arm.linux.org.uk>
 <20140213182701.GA32578@kroah.com>
 <20140213184249.GC30257@n2100.arm.linux.org.uk>
 <20140213232606.GA27372@kroah.com>
 <20140214000717.GG30257@n2100.arm.linux.org.uk>
 <20140214001436.GA16287@kroah.com>
 <20140214003834.GH30257@n2100.arm.linux.org.uk>
 <20140217153518.30891455@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
Content-Disposition: inline
In-Reply-To: <20140217153518.30891455@alan.etchedpixels.co.uk>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.99.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] serial: pl011: Move uart_register_driver call to
 device probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 17, 2014 at 03:35:18PM +0000, One Thousand Gnomes wrote:

> We've identified a correct working approach which is to simply add a
> CONFIG entry to the ARM tree and a few ifdefs to the problem drivers to
> make the "problem" (in fact a complete fictional non-problem) go away and
> to get rid of the mess over time completely as the drivers are set
> dynamic and it turns out that all the userspace happens to already handle
> this just fine.

It's a very real problem which affects actual kernels that distro style
users are building.

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAqAyAAoJELSic+t+oim92UwP/0m0dRoUHXGOGX5r1ff+rubV
ZY50YbYvRmLF9X2UUYw4V1+eg0Sb0iKZMQZ2MBddZH04A2OY6YEZ/mqbUwHtJKBz
tLJjmoitQbZfUdenDPer2Sl9uxquyHdr5EMdQCO3qI0AQvVtA5tNRMszopRJTU7o
/sE+j4HI4tIdsyC7CAms3Upsn1Q6CTvH5w00CfxTlniaomk0dHj1HxKfVVXR9XZ5
WBYbkTG+1iTMpTD8pdgBKrQzhESaxiBPBEKQIjFyp7xyOFF7l8NUi2rRF0f/Dc4x
QVT3kz4uLO4C2mICqy8UcNxGpU/OLyqhix/CMP7JVNotqcQ9b1+WYQ1O/c4nx94C
UI9L2jBRxqTw8rsSYp+Gg+uJVjWKv2IYtrQOxaRFoyiQyGnNwh0XAFaPdpf4uZgg
ORT6fywjFRdPI9DshWSo8TnpnU+UchEBUNP7oOV1BBz+eOsPVt4KZYc81Hh+sFsK
JfCUExznM6p2hlxsSoVbgRS6xNxFHit98cmsv7xk2C59wCN3Zlej2Uad4ISIhyJL
OiJPVEb19w0xP/g8WYB1DcP8n0OMrp+4HtW/MjVON0rCa3tWdaiaiu4GBr/MeTXP
sswnTBHioiy3CQdQs5aerrSaHd1GoqtdWt+Q7u/9Lkv3LT1ViE/bn6I4IK+57bVy
OLbyJj69YT3nQts5tFNp
=lMha
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--
