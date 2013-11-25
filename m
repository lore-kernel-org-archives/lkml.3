Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3KYVda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:33:30 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57348 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab3KYVd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:33:27 -0500
Date: Mon, 25 Nov 2013 15:32:13 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] usb: dwc3: get "usb_phy" only if the platform
 indicates the presence of PHY's
Message-ID: <20131125213213.GV18046@saruman.home>
Reply-To: <balbi@ti.com>
References: <1381866857-3861-1-git-send-email-kishon@ti.com>
 <1381866857-3861-2-git-send-email-kishon@ti.com>
 <20131017163828.GH11611@gimli>
 <5280EB5C.1040001@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwhGNBny+TwOF9uv"
Content-Disposition: inline
In-Reply-To: <5280EB5C.1040001@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wwhGNBny+TwOF9uv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 11, 2013 at 08:06:12PM +0530, Kishon Vijay Abraham I wrote:
> >> diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platf=
orm_data.h
> >> index 7db34f0..49ffa6d 100644
> >> --- a/drivers/usb/dwc3/platform_data.h
> >> +++ b/drivers/usb/dwc3/platform_data.h
> >> @@ -24,4 +24,6 @@ struct dwc3_platform_data {
> >>  	enum usb_device_speed maximum_speed;
> >>  	enum usb_dr_mode dr_mode;
> >>  	bool tx_fifo_resize;
> >> +	bool usb2_phy;
> >> +	bool usb3_phy;
> >=20
> > This would look better as a quirks flag, then we could:
> >=20
> > unsigned long quirks;
> > #define DWC3_QUIRK_NO_USB3_PHY	BIT(0)
> > #define DWC3_QUIRK_NO_USB2_PHY	BIT(1)
>=20
> Should this quirk be used for dt also? Currently we find if it has usb3 p=
hy or
> usb2 phy from the dt data only. But if we add a quirk, we'll have to add a
> property to populate the quirk no?

either we use the quirk, or use the fact that no <&usb2_phy> phandle is
defined, would work both ways, no ?

--=20
balbi

--wwhGNBny+TwOF9uv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSk8HdAAoJEIaOsuA1yqREsoQQAIBfzbu2z/Pk8DFRqvkWyMnY
xvT4K/UrePZwqHJbY2LpQFlSpMi1rIIptw+3195cGtyV40IO+BK1wmJpAa7o2F7q
ImMLm1ORcIWkSYrJb3wPVLcH+m4qVmGyS6bZrtKOjX7o4jM6IEL4f8BcYf71W2Yr
B/UuZB+R327zebZDlQFoOWK1s4X5sEPzpFMTn8LXzfgwRRD3xM+XkVArT7578AYw
eBjEyDU3TODEXjgPpTcugVXYZCt+ogBiTnMpJrr17kLYHNed3/ScWkYOwuID8R/p
gL9bJ89/2TWgyf12m+512NjcbA2/Wv+L3MpfkJPO4YH+98re90EN6UqZ3tnXLLAz
LFehog7DQOmjtbid8uiWEGkjL/xu6+Y7UU7gdQ+MTBjcLLDpYr5tkjln5g8PdvVt
RbSbTqRRb3s4kM4ZYu9CKxr0clysLgYHnsrZos9oFCxEzmLunCYN2r4a89XqowtN
csxtimWn+LqCsiAOCo9M7927povga+8AgKTNPd9t5ocuGp6O+3olAuo6bWAdoYH7
/JfSVWOq6pZ6753k9m9voOfoCjv3bh445QmRGSLNpMs9z/LyaAWu/HtD/ojc3arb
mbhfC3AlFWUIquA3iBX1DIUIcORTpLD8vvqYe/IHh/bZcRH2P1P9EK0ORnwfml4Y
ElEXVlIR3vCmphyn9SXo
=Kfhf
-----END PGP SIGNATURE-----

--wwhGNBny+TwOF9uv--
