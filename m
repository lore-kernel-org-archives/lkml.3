Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967862Ab3HINch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:32:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40505 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967587Ab3HINce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:32:34 -0400
Date: Fri, 9 Aug 2013 16:32:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <grant.likely@linaro.org>,
        <idos@codeaurora.org>, <mgautam@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 3/3] usb: dwc3: Add Qualcomm DWC3 glue layer driver
Message-ID: <20130809133213.GJ12041@radagast>
Reply-To: <balbi@ti.com>
References: <1376042027-9798-1-git-send-email-iivanov@mm-sol.com>
 <1376042027-9798-4-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liqSWPDvh3eyfZ9k"
Content-Disposition: inline
In-Reply-To: <1376042027-9798-4-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--liqSWPDvh3eyfZ9k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 09, 2013 at 12:53:47PM +0300, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> DWC3 glue layer is hardware layer around Synopsys DesignWare
> USB3 core. Its purpose is to supply Synopsys IP with required
> clocks, voltages and interface it with the rest of the SoC.
>=20
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

same comments from previous version.

--=20
balbi

--liqSWPDvh3eyfZ9k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSBO9dAAoJEIaOsuA1yqREA5kP/26Un/6Qx06IuL2gpD2oTArR
qPGX3Ydweg/+my/XkO22FazWCqD/yUCjGZdAACr9nAmJM96F3ToTxNKFe9ZJ1ZOU
oagvIQoe/DjWZ91uEKif5PiFuRzsFyry4ukNP6J5WMToWuD1N4i+5Y/dup9QxGTo
lYpNdOAfbKGxpu0W/OzVkw2C90CIhJE8kh6IoalkxPwzPzjM3R7ehQzhdnmR4Rfv
sQt3JCmGmcBLTuZ5fNoRSXyaheBqxGD9AhooLMhC38nU7jqLybVPxxGe4icWQ8o/
hJDFQ8Eg6wI397H6E0p4oVwGKTHygdsyTBdc+91taXygyzGEwxVfQgv9N7eMxNJU
e3fFpQf1pJb2EjM2grAne3kHsNWDT3+8W/xIVC2J4S4HrfDcyXbza9bZu1/h0ibV
qAgtruO9Ejc1Iqd9h1nqIzm5WkJfXL5cBM3PLsCnLCG4gWqxvSu1kQjQVWhoL0WK
YPxf5RMz0cGoCWrgSce8lBzNgoykL/X6/kKGqwc8p7ZomiWLn52ywvV/s9+a62In
pGvLs4/O2U1wlNgZyY5Tz7/CQdTjACEtc6g9ukAJR5sZ0S4sEORlybgymTeOjCRx
gwxk/weuQYzqOf3FcAthZ5rY1/JBli7pB/qHHvCiIuFon57F09FIDP98YZ0RSqtZ
zbqxVJ4MUohhd+akh6Uy
=mSk0
-----END PGP SIGNATURE-----

--liqSWPDvh3eyfZ9k--
