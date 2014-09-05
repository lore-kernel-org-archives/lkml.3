Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaIER5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:57:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47479 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaIER5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:57:30 -0400
Date: Fri, 5 Sep 2014 12:56:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, kishon <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v6 4/4] phy: exynos5-usbdrd: Calibrate LOS levels for
 exynos5420/5800
Message-ID: <20140905175651.GK24449@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409656338-20337-1-git-send-email-gautam.vivek@samsung.com>
 <1409656338-20337-5-git-send-email-gautam.vivek@samsung.com>
 <20140902143438.GB16872@saruman.home>
 <CAFp+6iEyqmbwMLFrBKD7NVLDAC=b+h1hPKFS=BG4k9D69hn_dg@mail.gmail.com>
 <20140903144225.GD31855@saruman.home>
 <CAFp+6iETPJCWMMkjHrpDcdCv=K0PbefYLa4eBOwN=aUY2=EHLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEfPc/DjvCj+JzNg"
Content-Disposition: inline
In-Reply-To: <CAFp+6iETPJCWMMkjHrpDcdCv=K0PbefYLa4eBOwN=aUY2=EHLA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PEfPc/DjvCj+JzNg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 04, 2014 at 12:01:19PM +0530, Vivek Gautam wrote:
> > Don't we have phy_power_on()
> > for that ? It looks like you could just as well do this from
> > phy_power_on() ?
>=20
> No, unfortunately keeping these calibration settings in phy_power_on()
> doesn't help, since we need to do this after XHCI reset has happened.

teach xHCI about PHYs ?

--=20
balbi

--PEfPc/DjvCj+JzNg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUCfljAAoJEIaOsuA1yqREmEYQAICfR5n9uBT/iokNYNyKxgoW
mX6DTm2pLA/KRBF2n7NzCYpzGmwPZ3sDNAZgQE8Pi8MkGaayTNm0Y8IjYufn/Tt6
Hj97lCwfoFnCrNPWiSh/PFsFDEstfbynMZHn9Vo0MRu/rL3UUf9iuYlwBbU6Fyxp
gzc5bN9pwyESIxf90GraZscQcsbnqX8g38s04q/arAyqWozaxVJPjxH5WLd0VR7R
qFpeSbWs4R429T89nL8qZFri7yasWf9IRMRC+RNRb3k0HK6YLy0zTRqyAgDZtvJ/
F4WWS4FL1MyGZr155M0tT0JhxZgCfhQ/alUwOMdn42qyHYnVreibHfjZiASl6A7b
S3p5zTnHkbVi4BBfwOgTHTZA+KbotmWsDcZeOphBbEBdbdrqJkP8t9sM5WAmthan
nHmwi8InPgFh96/BCVlKu5zCr4XZu9lnVUIBNNCqq4WAoyXJZnXWe2WLBliI2YkF
1WDi560mToD3JU5jFTUKoB2N8ma0CJAccofgp7CzALsiQW3SyAj4Ubopult5egE0
1lFoYHEBueXM+GnQ7d2iYTf1405gbxPFbfzwKpw8VPQslgMJrIq22c8eX0DjWd0b
yBfYOs7HY605iA3vFH+TxgOcLzuDdn65fOW1ZRxQqr50z0sii3bFfiSQ9VZHvdQ5
51GFCiEgiirjz9BVUgKV
=0If6
-----END PGP SIGNATURE-----

--PEfPc/DjvCj+JzNg--
