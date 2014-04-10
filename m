Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030473AbaDJMWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:22:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47703 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030399AbaDJMWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:22:13 -0400
Date: Thu, 10 Apr 2014 13:21:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harinik@xilinx.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, michals@xilinx.com
Message-ID: <20140410122146.GY6518@sirena.org.uk>
References: <1397132030-2440-1-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7tPHY7RFL01rOa8z"
Content-Disposition: inline
In-Reply-To: <1397132030-2440-1-git-send-email-harinik@xilinx.com>
X-Cookie: This report is filled with omissions.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] SPI: Add driver for Cadence SPI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7tPHY7RFL01rOa8z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 10, 2014 at 05:43:49PM +0530, Harini Katakam wrote:

> Firstly, the timeout value obtained from this is a too low.
> This timeout is typically used for an error conditions such as
> hardware hang etc. and using a value >1*HZ would be better.
> This driver used to use similar timeout and as I understand, other
> drivers also use similar values.

Send patches...

--7tPHY7RFL01rOa8z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTRozXAAoJELSic+t+oim9yQUP/RheMmc5lFwvXa2yuTAe3Lkv
dgC8+WEke3iYWHQNJHJIYewKdZtVzucbMDX4JhnQfkdtkA7w34RHxU79YBADfYD3
Q9Aig63VvE+1VvM+bh3qNPnERNlilH1TBRCGO9P2FOqEGLCt0yy6btka0HcsUnny
xD8QFLEQHxxrJLi6WtwkfAEHOxCBqaey+IwDMfU/Mbr7ZpdL8yP/RIcXgKNlXj9V
8m+L3TEhjyeaEWdjwvIIrHuhQUwOIABMCnWJsBMdX/6kjWOe6oIZK+Y7JJ5GAHZd
mHwDCUv5cyo10OmJQvgVM4k61oHDZ0ZPrOPxy+U6MQcUNsrcvMBTRLVyQeDp4p36
pAquchakenME1mcdjjKM4eXer5RYQs2gdny6VPG4lAG2ySGt2bb5gJMGlgPqDS3d
iN80Kdbu+eWqRtN+uOaVbUEOlaK/qd+WvK0TxfsqeE+eJukBDv4e3viqY/YRI/Se
DCIXYgfCbApjDbIMU2ylHXFvsGXD88dSN62dX5OiukqnE2Wfia+rrOkUU4XOwd2r
+NABGhbjsm1QOgbptKXzTYRgenO68qaQ6DWrwBZ9YZGn2sI0mHQk25IaaY6SKoa9
wFMguYks2jLTwX0IPOAQ3E/L2ou4jd0I7u+kmR+R4wCIPSTofHBThp65ir+NgVfe
rPeQWyiAUoAgu2azgYzD
=EaHN
-----END PGP SIGNATURE-----

--7tPHY7RFL01rOa8z--
