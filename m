Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbaAWTg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:36:58 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58711 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965AbaAWTgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:36:55 -0500
Date: Thu, 23 Jan 2014 19:36:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Tushar Behera <tushar.behera@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Message-ID: <20140123193633.GG11727@sirena.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
 <1390208555-27770-2-git-send-email-tushar.behera@linaro.org>
 <20140120100530.GY15937@n2100.arm.linux.org.uk>
 <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
 <20140123180423.1a62611a@www.etchedpixels.co.uk>
 <20140123184022.GC11727@sirena.org.uk>
 <52E163DC.1090002@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m972NQjnE83KvVa/"
Content-Disposition: inline
In-Reply-To: <52E163DC.1090002@samsung.com>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
 device probe
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m972NQjnE83KvVa/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 07:47:56PM +0100, Tomasz Figa wrote:
> On 23.01.2014 19:40, Mark Brown wrote:

> >We'd need to leave it user selectable rather than enabling it for ARM,
> >the whole reason this got noticed is that people are trying to build
> >kernels that support a wider range of devices for ARM.

> What about making it depend on !MULTIPLATFORM and enabled by default?

That'd work, but if we're doing that then substituting in the dynamic
assignment only when we hit a collision seems smoother and more general.
Or we could just make the core ignore all hard coded numbers if this is
set rather than putting ifdefs in the drivers.

--m972NQjnE83KvVa/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4W89AAoJELSic+t+oim97lgP/2bSE4u2+XgI7zAZj4sXR5iI
7tohhlVPD7DOxGMBp3uK00DN25VoiIEXVOaaTy5lvj9OKMC9O23rCEU1WKzO5aNR
Y0bHW+IWFTsP3FtLZvXTx4UlLoZwt0p/DwNRYUDdWDMEkmgLfFUC5sZMbYqGAr4r
Luan3lCgejzZ6/15HYhfX6lDYS349aJQ+GijJ/9T214ABDUdrqxwIUWmTdTk9SQF
hk0IZWeubMGErSTrCy8ySL/fPVxx/6YfwRlJz3PZIqKm67OgGfLaC1nrb033Qjsw
7SQABO8C5ktjthTI725/IbS/2kU1/0O/2DoBHxPzwB7JO7r8CO4dxlyVeJeJzWF4
f2G4lko3h3Wp+61Zn/J4relN2iuvaMFO8v76W0rs/1GxDMMmq9xMQdRUukq0ExLS
32MjSqq2HgBAnBBKPciOSuMLYKkXmXE3shibGg0JB7Kh38KhfweAfZEmpXyrIyqD
/JXg7OikRBWMakoYdRqDv24rhbF+VkbWxE0lU1dYGH7gLfpmJMNl9Vb22zeSCFb0
YG0uEAnDKocELCzX9vBMYlZ4yngpfh+Bcs7nBDSzSRzJcsopBq5jZllRhaLYH/O+
YJYjOLGWHD2EjN++hkvANT7ENdNaXnS4KMF34u+lczju8QjTHrBoAZgDF8FUpJLA
/ZDtiRug0uBTDAyelXIV
=Gt4l
-----END PGP SIGNATURE-----

--m972NQjnE83KvVa/--
