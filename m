Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699Ab3GaN6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:58:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53195 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3GaN6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:58:20 -0400
Date: Wed, 31 Jul 2013 14:57:51 +0100
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
Message-ID: <20130731135751.GT9858@sirena.org.uk>
References: <20130731084645.GB1754@pengutronix.de>
 <20130731090512.GD9858@sirena.org.uk>
 <20130731094434.GC1754@pengutronix.de>
 <20130731095411.GA2810@htj.dyndns.org>
 <20130731111853.GJ9858@sirena.org.uk>
 <20130731113244.GI2810@htj.dyndns.org>
 <20130731115027.GN9858@sirena.org.uk>
 <20130731115527.GR2810@htj.dyndns.org>
 <20130731132708.GQ9858@sirena.org.uk>
 <20130731134215.GS2810@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MPy0Cpsqru2KSrV4"
Content-Disposition: inline
In-Reply-To: <20130731134215.GS2810@htj.dyndns.org>
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


--MPy0Cpsqru2KSrV4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 31, 2013 at 09:42:15AM -0400, Tejun Heo wrote:
> On Wed, Jul 31, 2013 at 02:27:08PM +0100, Mark Brown wrote:

> > It's really only interrupts that affect most devices - if there's DMA or
> > anything going on after the remove() then as you said earlier the driver
> > is probably doing something wrong.

> Hmmm... it depends on the specific driver is converted but if the
> deactivation sequence - shutting down of command engine - is also
> handled by devm as in libata and if you have non-devres resource free
> in the exit path, you have the same problem.  Again, in general,

That's the only API I've ever heard of doing that.  Everything else is
just using it to do deallocation.

--MPy0Cpsqru2KSrV4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+RfcAAoJELSic+t+oim9QlIP/RWyvJrWqq5Wo5lQ9Jfgvghw
RIbF8pEILyf7oBaaL+baibB8LW+BbtjPfADFkwtI3Y6PRl1Hk5hExb0rQWr6CQ9K
rmwv2LSUA/F/AV6y1hAcR005vUMN8f3rTBb3REqpZNpIeWbMJLB2c2j2Quf0mc4w
o2XB79+ebc8epJ3eRSsvBO8BE6WtLyPqsU7NlG6giyp18ZVbZPCsa0Hdh4JnQpju
0wCnjRLDW1EJAlt5gV3AhCMLEZhqWthf9UoN16/BuwUuam9hJIRks9tqCmhcLL7k
ZNrblDfpnJOelkB9GzrLNGEsw9UfDrISaXPuprC1ZReIq5ZXKRIAt/WJchfaJRbv
nvLTsFBgMdacPpZHoQh+HRnW7sMlsk/mEOVHWMiCwsQyKKWoJ4FLxAjLal7bv7Wl
iSt4qSw7E7YjV9q+WQM6IYVriojeqDv5+x0QGrR7yOgqUePn6S82Y+K6q7WKgvQs
ql8IcolpbAfSlq1zuwqF7xOoAqqmexIvyrfk/ymdQs8dvTx+sF9I1DLNsA84+5JE
p8DZLKKq+4uU6IPLACalhe2FLdtjY2FjKBFnOTgBX63+UU4NFLYU7F7bjojpB7Mz
+I3j181M+Hyka/rjUiVJmoTkavNNHOuXKZpig8wn+lY56I0FAisvmTW06XZ0KULS
P4qlXJjd+2KCePqWTp2I
=7LCC
-----END PGP SIGNATURE-----

--MPy0Cpsqru2KSrV4--
