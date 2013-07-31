Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab3GaN1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:27:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60276 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759912Ab3GaN1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:27:20 -0400
Date: Wed, 31 Jul 2013 14:27:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Peter Chen <peter.chen@freescale.com>,
        Fabio Estevam <festevam@gmail.com>, alexander.shishkin@linux.intel.com,
        kernel@pengutronix.de, linux-usb@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jeff Garzik <jeff@garzik.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130731132708.GQ9858@sirena.org.uk>
References: <20130731073306.GZ1754@pengutronix.de>
 <20130731082054.GF8540@nchen-desktop>
 <20130731084645.GB1754@pengutronix.de>
 <20130731090512.GD9858@sirena.org.uk>
 <20130731094434.GC1754@pengutronix.de>
 <20130731095411.GA2810@htj.dyndns.org>
 <20130731111853.GJ9858@sirena.org.uk>
 <20130731113244.GI2810@htj.dyndns.org>
 <20130731115027.GN9858@sirena.org.uk>
 <20130731115527.GR2810@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cqlcXVgniU+wVEjx"
Content-Disposition: inline
In-Reply-To: <20130731115527.GR2810@htj.dyndns.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] chipidea: Use devm_request_irq()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cqlcXVgniU+wVEjx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 31, 2013 at 07:55:27AM -0400, Tejun Heo wrote:

> If you have DMA / IRQ / command engine deactivations in devm path
> which often is the case with full conversions, freeing any resources
> including DMA areas and host private data in the wrong order is a
> horrible idea.  It's worse as it won't really be noticeable in most
> cases.

It's really only interrupts that affect most devices - if there's DMA or
anything going on after the remove() then as you said earlier the driver
is probably doing something wrong.

--cqlcXVgniU+wVEjx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+RCpAAoJELSic+t+oim95fkP/R3cVtEyCGU5Vvzbm4GjBfAL
YmAxsfQEoWi9SPK22v25O7KxqX+YtJKpqtdlSLsZnmUJw8fZJhEN6smemU0TAbRT
rORIH1mIuzqkyrT6f9j5FkJDyARefBCDoryvD20VPWHiJBdGALpQ0DZCoevvvmf3
oHFVzO81FzM7BKMBgd2v9o24zWBaXSAw2JrDtPNBl0bYvcZi4r1WWWDb66aVrKdh
fW8E4IlZDTmmk3Dl0ozsPcE1aRamPIVp/ydGvT0mYaJNVrtyJ7BA9Wm+30WGbMiu
eDTku+okyCi0ETeL+W+EOtdSxZUrtkCw58zKWS1HkROMPrV5q51ncKGQq53aQwU9
wCgxoYjTVIXZTKhjtJE0+Qm7ynUyxN/R7d9XqyUR7GQo7/I4ECHG2i56oFK8U59l
P25WP9ykVjgWj3J8ZpYrpLjT5vjvXj4n8f2mT4lyH7j5GnncoUPFg4BC02nud097
La0UISqR6QBLcvwTKCe+GJP8KMicxYdZyOQt+Db5bb2RDs4N0rq99PoqoQ9QHF1m
+MIDt0NNuPFdB8e+1KL/ggge5Gkzya+2erP0exh1J4uBVC56Mjk6EjRQEwWq36IG
zA2ikPA2TkV51FOcLW6BSCuewD/sFmS//xWICt6nwLaTjOAaDnr0irS7uOd3LRN/
ympfimHJoxlje68hvIgF
=cv3r
-----END PGP SIGNATURE-----

--cqlcXVgniU+wVEjx--
