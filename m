Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab3I3JQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 05:16:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41319 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3I3JQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 05:16:52 -0400
Date: Mon, 30 Sep 2013 10:16:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Libo Chen <libo.chen@huawei.com>, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org
Message-ID: <20130930091622.GW19304@sirena.org.uk>
References: <1380518035-5319-1-git-send-email-hanjun.guo@linaro.org>
 <1380518035-5319-2-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DLfA7Wi+Vmsdqq5j"
Content-Disposition: inline
In-Reply-To: <1380518035-5319-2-git-send-email-hanjun.guo@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] driver core: introduce helper macro initcall_driver()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DLfA7Wi+Vmsdqq5j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 30, 2013 at 01:13:52PM +0800, Hanjun Guo wrote:
> For some devices especially on platform/I2C/SPI bus, they want to
> be initialized earlier than other devices, so the driver use initcall
> such as subsys_initcall to make this device initialize earlier.

We're trying to move away from needing to do this and to using deferred
probing to resolve init ordering issues.  Should we not be able to
convert the drivers to module_X_driver()?

--DLfA7Wi+Vmsdqq5j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSUFjAAoJELSic+t+oim9+lMP/3nb/zrTbqdioZC48mvq2kO+
4EwbBpjnMjB0JrbnIM6J/h5I6HGKz9P+1wxYsv5Nu2Teh12cyx12PO27RJSesGHf
d+R9EEdmqy0ytwkEydJGjksSJ0P52l7TimRhOeCcJCzDxojTqyii2ZJVLgDFvzqS
JpsItNUBVa0mI+DNG1fK9b2f8Wfo0vIJ3UTooykynOglvB65uTu1+YtEDOoN6Z+F
5l8NcbotLAuP+hRZsksK9CSyegtuaWb8iSAnsa/84AqxsNLElNRt12q7V7BN6JuM
HQvUAj9XRz3P7ZhsJ1RWrl5H/htZAOXynwCLDlK8LoniXUBBLKpUVVAGpI343/RK
jSsGYaLSHA0CVHEDsBqxaXLNBBSlCqNblGroeUUsSi6dYBDuIv6UcXixvYNirDw1
ljF/PhZTW82mW43S+ZfYF8GQxYpEOd8zHHykdqzEWIrXFlNqTILlkKADzGxpN+Ap
twtw0MpcFGRJQACc1Ri2YF/5XoadC11auHN540snLJial7e9czEx+Sd7SERNQ4Ic
IWXiPbf0l+1vxh52SWG4h+jPM9iU5SBeBdVn9HPQEi/hBpA2KK6mZPo5nWgEtnrv
H4tWehrnxea2s2L0VT73EjDCSUNUPvmJxju+JAXnFdHc0rdnTfM+Oa4siDE0oBbr
d7r9quujl2EJoGRuOPLI
=togJ
-----END PGP SIGNATURE-----

--DLfA7Wi+Vmsdqq5j--
