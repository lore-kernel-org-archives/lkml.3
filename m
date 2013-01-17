Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3AQM2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:28:20 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47552 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab3AQM2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:28:19 -0500
Date: Thu, 17 Jan 2013 14:27:57 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 15/22] mfd: omap-usb-host: Manage HSIC clocks for HSIC
 mode
Message-ID: <20130117122757.GO18978@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
 <1358422231-24736-16-git-send-email-rogerq@ti.com>
 <20130117114522.GF18978@arwen.pp.htv.fi>
 <50F7EA2A.2080705@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+wSiqF7c0ySQ2tNi"
Content-Disposition: inline
In-Reply-To: <50F7EA2A.2080705@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+wSiqF7c0ySQ2tNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 02:10:18PM +0200, Roger Quadros wrote:
> On 01/17/2013 01:45 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Thu, Jan 17, 2013 at 01:30:24PM +0200, Roger Quadros wrote:
> >> @@ -598,6 +639,24 @@ static int usbhs_omap_probe(struct platform_devic=
e *pdev)
> >>  				clkname, PTR_ERR(pclk));
> >>  		else
> >>  			omap->utmi_clk[i] =3D pclk;
> >> +
> >> +		snprintf(clkname, sizeof(clkname),
> >> +				"usb_host_hs_hsic480m_p%d_clk", i + 1);
> >=20
> > do we really need to know the exact clock node name ?
> >=20
> I think so. Do you have a better suggestion?

update CLKDEV entries ? I mean, what if we have a new OMAP or AMxxxx
device with a different clock name ? That will be a big bummer.

--=20
balbi

--+wSiqF7c0ySQ2tNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9+5NAAoJEIaOsuA1yqREuzkP/3BU7brjUqCad8Un6abf1Mzs
JORFCt1ZdYWaxCHbo1lhjGdNNBTV0/jXUSlzrPvszc13A2WODJ4r3EIuIUdyE1id
WL5sTQtJPFZCIhHLcaya/NCe9hXpgHf2KNyKe5Q+83QtduQe0bDOhdVgP3BncmLq
j5l8ZtZndNJCLBjCXT8+F7yO6XpTAxBW4woXdGOn2KGFwu9WWGibIC/JVsMv9qvR
l+KS1x+SaL1aEGUKuRh8PRmcmK//QYsFL6S4L2cKtfAgbaUd2TNUCQPLIOdwTeEJ
yArQ1H7WCYBXLmtbBp/2PzMmAVPImBURkgjFl/KovQRUhauOTZ0CxOD5ScfPr7kv
M9wesWCq9/ggHq/6vWWQB4AQ01NDjyhaVTXnJu5kNUdgOyrPrvYeRwFLkqnS5VWl
nVmYFr+9jbHr/7HEp/qLmGBbs78ter23Pdd3SQc4BL27yFm0cqGnY+qRvqSC8j/r
fTqq24p3ge0IL5TvPMUb278MrLFW1zKU7Srho8s7FO7Uo+o8VP+HkbZkotU07CFn
sI65CsM+7TWCodxN+YZxIVJbFbm5+kB6bpv+xxCQg/nb2gZqA8RrnHo37zj3SiWE
4SD1B8SodLmUJkduOFW8e+q5aqxk/knvyN11Jbz3T5VBCb2NrBFTB88gOUntWmOu
wnMP5xjHXqKP4AqgkqtN
=KBu5
-----END PGP SIGNATURE-----

--+wSiqF7c0ySQ2tNi--
