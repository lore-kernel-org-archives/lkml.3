Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310Ab3LIRE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:04:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59443 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab3LIREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:04:52 -0500
Date: Mon, 9 Dec 2013 17:04:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kevin Bracey <kevin@bracey.fi>, Kyungmin Park <kmpark@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131209170422.GT29268@sirena.org.uk>
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
 <528BB1F2.4080107@wwwdotorg.org>
 <CAD=FV=XS0dbE7zfgDGVdp84h4fHH6tfO8aN_HNh1LbOjYy51aQ@mail.gmail.com>
 <528BB913.6080409@wwwdotorg.org>
 <CAH9JG2UjnL5bZzNUuJhWY3GpwPD=rJvR2O4Hcpm33G+prSS=BA@mail.gmail.com>
 <CACRpkdbyjm0X9RX+8WjqQxBPyRjBOAunkqVcO-0KUd1PTdGavA@mail.gmail.com>
 <5293ACA6.7060403@bracey.fi>
 <CACRpkdYrPd9tnO48bA_5n+-k=KEDyhY7czkCNhTZfpgF3ar+LQ@mail.gmail.com>
 <20131205150747.GW29268@sirena.org.uk>
 <CACRpkdZ7YCt7NvDDqgv6CZS07wkfVJ1NRZHFhqKxcYbdW7pXnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4TSNxiJ5t2iBNdYs"
Content-Disposition: inline
In-Reply-To: <CACRpkdZ7YCt7NvDDqgv6CZS07wkfVJ1NRZHFhqKxcYbdW7pXnQ@mail.gmail.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized
 using pinfunc.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4TSNxiJ5t2iBNdYs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 09, 2013 at 11:22:44AM +0100, Linus Walleij wrote:
> On Thu, Dec 5, 2013 at 4:07 PM, Mark Brown <broonie@kernel.org> wrote:

> > Or should we be going and applying the default state to all devices on
> > init without worrying about a driver appearing?

> That doesn't really work: if you have an unused device not in the
> DT you usually mark it "disabled", and then the DT core doesn't
> even create a platform_device for this node.

> So doing this would involve parsing the tree and ... yuck.

Hrm, yeah, good point.  That's got a low awesomeness factor even though
it should work.  Boo.

--4TSNxiJ5t2iBNdYs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpfgTAAoJELSic+t+oim92kAQAICF9OgQeeOIPRJS1DY0Bq9x
1QbNxgERbCzn8JEanIgmDCPls5943cHVj77/R22gcwaF53hGDlwJT+wqXLQykVL8
zR/xaTGmtXQZm5TbXsNbxkb/SU54gdH3bdnl9ytyL5hqgRVCko6CyMoifH8dfZZy
pyI7FA1zDSbozk+DQp4l06hmemw+wrJfAwvjq4hUBCGl/VmCp6qqfPyH6iGv9XUU
2KpSVcpUMOHGagl6oGqIE8cACeYR2850O8SLg/k/QtbYLijqgJnb6nQWZlu4uow6
Z7425g1MiHQub01pH78iW6U+zAyYfnYMP/j2I4hgS2gBlHsU4jO5pSHnlwT2EPcA
LqlduWXdb5wLYRoaWdTVwf0B2WFTmKvbVbnzilCen9pEX/wRRpewTw9nTHq6pqbi
yoBGCA+R00U+ulK6FIU3ZfzIR//vxdUSFzSljdKJLt6nFL2iuOI6norfCLa0/vNF
zvl8vZtTifXQZAne7NREpBDzk/vg8a6bLX94VHgK2l/FYmChVBlqATjlV/PwRPZh
BDkLEsQsCiaHALopTmWi7/vRh89ZwNFGVYqILAOahIcQgPmuO+Y8/UKgxjygi5+i
esSbmFgsYv6b2pwXYfRDo+8xwQIh4VQObIOwOvbZDarJ+pP3IrjXTpMAPkFT3W7D
/4lw4JVOsvd8chZcF2nK
=n3fD
-----END PGP SIGNATURE-----

--4TSNxiJ5t2iBNdYs--
