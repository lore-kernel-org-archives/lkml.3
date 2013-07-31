Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398Ab3GaQxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:53:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37395 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab3GaQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:53:05 -0400
Date: Wed, 31 Jul 2013 17:52:43 +0100
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
Message-ID: <20130731165243.GX9858@sirena.org.uk>
References: <20130731111853.GJ9858@sirena.org.uk>
 <20130731113244.GI2810@htj.dyndns.org>
 <20130731115027.GN9858@sirena.org.uk>
 <20130731115527.GR2810@htj.dyndns.org>
 <20130731132708.GQ9858@sirena.org.uk>
 <20130731134215.GS2810@htj.dyndns.org>
 <20130731135751.GT9858@sirena.org.uk>
 <20130731140758.GT2810@htj.dyndns.org>
 <20130731152523.GW9858@sirena.org.uk>
 <20130731152932.GV2810@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="htcamZYLtaLycLnV"
Content-Disposition: inline
In-Reply-To: <20130731152932.GV2810@htj.dyndns.org>
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


--htcamZYLtaLycLnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 31, 2013 at 11:29:32AM -0400, Tejun Heo wrote:

> Yeah, sure, thank you very much for your input.  It is of course
> strictly ordered and the documentation needs to be updated.

While I note the way you're saying this given the widespread adoption I
think there's a bit more effort needed on making sure people are aware
of this model and that it's possible to do it - most of the APIs with
devres support really ought to have things like a devm_clk_get_enable()
(an example discussed further up the thread) added to them.

devres has been quite widely adopted but not in a way that supports this
usage model.

--htcamZYLtaLycLnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+UDYAAoJELSic+t+oim97sEP/0u75THsXKjt8hV7/hNNi/gz
4HN1OVAima4BLyDi8OyELO8H9tFrQuHjYkOP5hhs7bVC5eb3mJ+P9fAIXbGeZAqf
eGDBNgBXrxdNMxb4hAyhMUG3qHFKjbRvjxEmiuFGwdUc3d5jfMkf+PiG+u4HcUna
MVr9HunbrfCJ8kiq6ih+H3gf2cyYCGGkzPxX//qLrsC+KdLFam7mfhSJubGNbAze
NGuOxWygJF9hB0X2+0vMk90kPYVZjK+uNjqR5r8nFAlRDBVv+CyARUoQuqVzO1ta
T+iwdXxQP/9V/7bPe1Ss02B6ka4iYgxJg5rlgnB/5cuFuyrDwH/Cj/C3cOsK+MHk
fnuA1/FagFKrmYGXD+tZzwA/w6eMrE/Twmu3fCkvvk1vAKBea5UXdEfywvQ+jjUV
3NOFVtlIRVE2qzxtaPWaNfsj2YeYwNjLk5hJ78jTAYZpmObO9fIuop2u2DZgx2rK
aasudzOnzFnEMc6k2duVbtKxrWu/iePbrpU87dj02hgeyIwWxCLvNuj2Y1BTF1rZ
vrpuReTK3vTolf2oBfL4NrYyW71MQmVzyJnzR6kdl7dUR8oq2K++IKZ/F+t7Ndas
j31h4BoSSnKTMrKEB6QfVmGof4o+B1Vaa5Oy3W2Sin2flbXgIVY9OJ61+/hfUEnh
Q+ZeeXzNW6AqlyI6g1sC
=0caO
-----END PGP SIGNATURE-----

--htcamZYLtaLycLnV--
