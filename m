Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab3LFUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:16:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36885 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab3LFUQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:16:56 -0500
Date: Fri, 6 Dec 2013 14:15:30 -0600
From: Felipe Balbi <balbi@ti.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, Roger Quadros <rogerq@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <gregkh@linuxfoundation.org>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] usb: dwc3: get "usb_phy" only if the platform
 indicates the presence of PHY's
Message-ID: <20131206201530.GA21086@saruman.home>
Reply-To: <balbi@ti.com>
References: <1381866857-3861-1-git-send-email-kishon@ti.com>
 <1381866857-3861-2-git-send-email-kishon@ti.com>
 <525E8E93.9010503@ti.com>
 <525E9046.3090209@ti.com>
 <525E943E.3080706@ti.com>
 <20131017145425.GE11611@gimli>
 <20131203103950.GB26423@xps8300>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20131203103950.GB26423@xps8300>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03, 2013 at 12:39:50PM +0200, Heikki Krogerus wrote:
> Hi,
>=20
> On Thu, Oct 17, 2013 at 09:54:26AM -0500, Felipe Balbi wrote:
> > On Wed, Oct 16, 2013 at 04:27:26PM +0300, Roger Quadros wrote:
> > > On 10/16/2013 04:10 PM, Kishon Vijay Abraham I wrote:
> > > Do you know if there are users of dwc3 other than exynos5250 and omap=
5?
> > > If not, we should get rid of the old USB PHY altogether.
> >=20
> > Intel's Baytrail, at least. But they don't use DT.
>=20
> I don't see any use for the generic-phy when the device is enumerated
> from PCI. If dwc3 can live without phys, there should not be any
> problem dropping the old USB PHY support.

yeah, I don't want to drop PHY support, I want to require everybody to
provide a PHY, otherwise we have too many options to handle and that's
never clean.

--=20
balbi

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSojBhAAoJEIaOsuA1yqREUR4QALLZQaPF8HS/RvsATcqHZ/Ez
Uay3F7tSpIuxcQsJFoQVkXiS8Me49/I3fTUx6DIV84B68cVBqtpWq5+MMRZxt9dP
5XBZgk+NWcfTto9q/4bU0BTRu3N6qNttL3bpH7jtofSV3k/zDfeNiKaQABSt9qfs
/Mt66wLuIoh1e3qBmE1+b1BrBpBkVAn0uw4kWrCulG0mGdhtyh8GeaMDej3XE9eI
xWEmX6uy0xhq2v7coFvAGjv1pyOBiovzKVeIazwLmfHEtT0QrR4JBZ9dRcrtV7IF
Ay7N7ZSPR9wSuGB91e/Vb8qvAJIIi8birHMCIeRJ4DRo9x+cIYkThBUzQyl8MYSg
1LtI2+8Jcn/YpEbHg/9ZFNni3ZdOgVVllCwsWKJ4aIfuEzkLtC9/8OYRux9y4CT9
1+4rrM5LwnHBuLfIwNlfAcOddxakPMTbv0JFnuxvykIT6z1OwqDHUURkQ0k/zvFu
hjeamvA8wa+IkEmVb+ya3n+VMEEPbXN4AjfBTYelSl6ElpxQchO6Xna+mW8jZVf+
uowmIVoLIeMh0i61xsjNb+7WyKhS3o6ZG3wMwPNjwYAEJs78wWTt4OvqhnLuYZUm
bLph99N4cwtANHtbfNvS68RfHSatjhSjjNkXKMYIt0zEQgW0qgsaSVx7NnClJdOV
J6zOq19aM9RG+Ycc+BPa
=Bozc
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
