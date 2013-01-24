Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3AXWcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:32:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36900 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab3AXWco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:32:44 -0500
Date: Fri, 25 Jan 2013 00:32:21 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <kgene.kim@samsung.com>,
        <thomas.abraham@linaro.org>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <sylvester.nawrocki@gmail.com>,
        <dianders@chromium.org>, <jg1.han@samsung.com>, <cpgs@samsung.com>
Subject: Re: [PATCH v2 2/2] usb: dwc3-exynos: Fix compatible strings for the
 device
Message-ID: <20130124223221.GA14320@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359035130-22667-1-git-send-email-gautam.vivek@samsung.com>
 <1359035130-22667-3-git-send-email-gautam.vivek@samsung.com>
 <20130124213213.GA21329@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20130124213213.GA21329@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 24, 2013 at 01:32:13PM -0800, Greg KH wrote:
> On Thu, Jan 24, 2013 at 07:15:30PM +0530, Vivek Gautam wrote:
> > Using specific chip in compatible strings. Newer SOCs can claim
> > device by using older string in the compatible list.
> >=20
> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> > Acked-by: Grant Likely <grant.likely@secretlab.ca>
> > Reviewed-by: Doug Anderson <dianders@chromium.org>
> > ---
> >  drivers/usb/dwc3/dwc3-exynos.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> Felipe, want me to take this one, or will you?

I'll take in few hours after sleeping ;-)

cheers

--=20
balbi

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAbZ1AAoJEIaOsuA1yqRELIoP+wVoZaBNk79FI2uUGNPu0gp6
Yw1FVUvwvwNAzQtkjaOHm85TDVlxPMMu3KCFXeOLtdad+5oOPkO4jznmgbIFj0gq
H4Y0Bjgybhh88tep0aYOwgmP2ygw3/l1I12Yqr0DxnKkTawa+divVuYH/+fPfuNR
kSUCe9pu6eLMCQ+tlthDOOUvdr/M0aX5aHgEpsRFfUdgG5fJ1HQVOTZIbz+2BbQb
6XWhYvVnNWi8W+o8mkiFWtdm1IDDzI24EbzGUmPc4EvP0vcYdQS0luDba7fcgOZU
nf+cx1lTAbRSf0tET1l8jUkfS/AF/0V1M7cbtGVZEKug8j3ESfMe75Bu69dHBR5W
oKhwxX8wZIeKA8RVsxbcEhWgCadx7CdGKq/IKh9jALYQvCHwq01lV0GUeM9rl1pN
78AaqAGRnGDvsH1AJAYwYhmVLP3IWrU5n08SwgIvIbNwO59SrU9f/0ji+C696QIA
OFHLuXTdYoayS2fkiv9xOpzXBScV/QDLPSc9svDYu84ft5/xJrogWghZ/hsqfPs1
/YM/WZqO609htbHZ7OXA+Qocbti8m+ttPH+XzbkwnyokNGhXM8hQDpcdysePi4d6
eagvLNlWRXFp2CvvOkqN5ify8a5NDQ6DzVPwz5qQTevyOBgKNa9NFKKeic3jMJZM
amV/Om328v5V8xOSDwu2
=nFz6
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
