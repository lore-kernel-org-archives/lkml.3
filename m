Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab3A2KNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:13:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:46582 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab3A2KNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:13:15 -0500
Date: Tue, 29 Jan 2013 12:12:30 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <stern@rowland.harvard.edu>,
        <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 10/30] USB: ehci-omap: Use PHY APIs to get the PHY
 device and put it out of suspend
Message-ID: <20130129101230.GO8708@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-11-git-send-email-rogerq@ti.com>
 <1359453032-20604-1-git-send-email-rogerq@ti.com>
 <20130129095758.GM8708@arwen.pp.htv.fi>
 <51079F97.6080109@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KDy5+/kaQUC2a3Gw"
Content-Disposition: inline
In-Reply-To: <51079F97.6080109@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KDy5+/kaQUC2a3Gw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 29, 2013 at 12:08:23PM +0200, Roger Quadros wrote:
> On 01/29/2013 11:57 AM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Jan 29, 2013 at 11:50:32AM +0200, Roger Quadros wrote:
> >> For each port that is in PHY mode we obtain a PHY device using the USB=
 PHY
> >> library and put it out of suspend.
> >>
> >> It is up to platform code to associate the PHY to the controller's
> >> port and it is upto the PHY driver to manage the PHY's resources.
> >>
> >> Also remove wired spacing around declarations we come across.
> >>
> >> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >=20
> > ideally, this would be done generically by ehci-hcd.ko itself. Alan,
> > would you have objections provided it doesn't break anyone else ?
> >=20
> Agreed, and PHY suspend/resume should be done at port granularity.

right.

> But considering the erratas we have in OMAP EHCI, I would still prefer to
> have control of the PHY in ehci-omap. We might even have to do some ULPI
> transfers in certain scenarios to work around some of the erratas.

fair enough, then let's start with your change and make it more generic
later.

--=20
balbi

--KDy5+/kaQUC2a3Gw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRB6COAAoJEIaOsuA1yqRE8I8P/jMBMy9WodHV4yAJ3noCCzql
T3rGtOV9t2V7lqjIOvy/juEFDO4gG8DRBDqKS948hQIIR4NuY4orRug1y9ec0fR0
1EK4+NeCetg2+bIDIiTqfirrbVCBfNnKUR1iz9XMNF9CCN+MC+1h9B/kYKoLK0Su
qfX0y0VURxGNtcoQ+ZWrHWx61QPzmI9YhNsKMdVCZ/c0lKAoW7360SC4sp45+VYm
c/gNYjz5lJ9cG+JdifOr9xHScOSzkly1EZ5elhrOdIJekZsXAe1bdJ8+iqK1mjyB
ydDw+ESbW/8PrCahjNqGP/GNSEwCnbebO954RghkakbiuYI3JVXnFs8sG3JN7QxX
J54Z65OEsUe1G0ZfA5LGnc2GibcNrQtlLPTphK/Qm77d8/esVDqj5LYKyj9VCeCg
kOueAZ/z97ZqePcgOWZWGjtKhutRX3jLUMJwajGMZf58A8ItEDkPP2tXAseF9S8s
007UPKjREAXyf4l/JDKn3AFiPtMrCxvvAdX6LCaY4+KGxlThWf8znj6p8FqQwEdF
AgqjPg88YdjXMWRDfqHjRjqrs89517S5NwrtrMc1TwfT2tAI408sBtNx5Bz/CXf4
lJ0tUlOCTtqWu040cEG5g7JNZQuCWaqKw9wO++3rVHBB6pSQSR3YAmho/pNwr3Ys
GPHBn+/RP7/s6adGXa8B
=s3Mj
-----END PGP SIGNATURE-----

--KDy5+/kaQUC2a3Gw--
