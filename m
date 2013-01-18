Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3ARLtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:49:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53651 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab3ARLtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:49:16 -0500
Date: Fri, 18 Jan 2013 13:48:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: Roger Quadros <rogerq@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-sh@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <balbi@ti.com>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <horms@verge.net.au>,
        <magnus.damm@gmail.com>, <cbou@mail.ru>, <dwmw2@infradead.org>,
        <alexander.shishkin@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <leoli@freescale.com>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>, <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 1/6] usb: otg: Add an API to bind the USB controller
 and PHY
Message-ID: <20130118114843.GB4379@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358348462-27693-1-git-send-email-kishon@ti.com>
 <1358348462-27693-2-git-send-email-kishon@ti.com>
 <50F7C643.600@ti.com>
 <50F7DD2C.90500@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <50F7DD2C.90500@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 04:44:52PM +0530, kishon wrote:
> >>@@ -171,6 +188,11 @@ static inline void devm_usb_put_phy(struct device =
*dev, struct usb_phy *x)
> >>  {
> >>  }
> >>
> >>+static inline struct usb_phy_bind *usb_bind_phy(const char *dev_name, =
u8 index,
> >>+				const char *phy_dev_name)
> >>+{
> >>+	return NULL;
> >>+}
> >>  #endif
> >>
> >>  static inline int
> >>
> >
> >Controllers like ehci-omap which don't need OTG functionality would
> >benefit from this API. Can we make these PHY APIs not dependent on OTG /
> >OTG_UTILS?
>=20
> Actually much of whatever is in otg.c can be used by controllers
> which don't have OTG functionality (except otg_state_string). I
> vaguely remember, there was a patch that renamed otg.c to phy.c etc..
> I'm not sure what happened to that.

right, that has to be done eventually ;-)

--=20
balbi

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+TabAAoJEIaOsuA1yqREgncP/1NggeNZzkZbEl1pkZ1sB1a+
qA0bmIbEoEOUJxpCqdLwUsyg9FEnq46mThtN6zXEvxpwEFIwo0OE/Wncxow2xZZu
H8X5tr3lVO6ytFqLEjdiGh2QLdJaQZmBEi7s1/C/gGZVtcsr3ew9EGcHXILst1wa
SPn3GN4r9ywX5pEzzGjaG4Y1OPinFDFcyRhce1hw7qLfrPrcF4vUGtreFF/ZVu1r
JiqDegt28enVMJOa1AcMmojy5oF41FT4sOTVe4pfG8HQ7dbh/jv12MLdzgFjr7sI
KwaT1j3wEFq6Wt/TlvmV4FXPmQM0E+UKQuVluP/450Bu/vqP637Qg5jfpbQJ+SBm
o33oxFhQ0wBa89Fer8PRFCPlbSEz1KDlxpZ8h9iXBvgf95yeI1wC8FwlgR6DrC1+
S7MFYSnXPbMARyT3SQysgWmYTYNUiIlSTdI1+VsNcd3hg0oc+27kCnXH3s5Mggwn
DVKjVUnGCgXoqe3pxBOlHG4roSyVRABg62tOPEcfqYzzOZ+5rtUx8rMeGeM71dit
mRNmQABiyP9kNgP8wKjonX025bjQkGpHSECEjZv3edKcgTWB6/Et6WuXPqJbesqT
k2nbuiotOLb3Xl8ktDntPnxJHlZaY3RS1bYBjaIBSC/3RJig0QGrJvkMEZwrdQcE
pgbna7YCHExTNw2BA0ez
=+ptv
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
