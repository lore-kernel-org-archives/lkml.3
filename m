Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3AQPcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:32:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38313 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756566Ab3AQPch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:32:37 -0500
Date: Thu, 17 Jan 2013 17:32:29 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Venu Byravarasu <vbyravarasu@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] usb: Add APIs to access host registers from Tegra
 PHY
Message-ID: <20130117153229.GA21904@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130117135043.GU18978@arwen.pp.htv.fi>
 <Pine.LNX.4.44L0.1301171016550.1339-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301171016550.1339-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 17, 2013 at 10:21:53AM -0500, Alan Stern wrote:
> On Thu, 17 Jan 2013, Felipe Balbi wrote:
>=20
> > > Bits 31 & 30 from PORTSC register were allocated by our SOC designers
> > > to inform the host controller about the PHY type to be used.=20
> >=20
> > Wow, that's something you should never do. PORTSC register belongs to
> > the EHCI controller and those bits are reserved for future use and they
> > *MUST* return zero. I wouldn't be surprised if current EHCI driver
> > assumes those bits will be zero and/or makes sure they're set to zero
> > when writing to PORTSC register.
>=20
> In fact, those bits _have_ been assigned an official purpose in the=20
> EHCI-1.1 addendum.  Presumably the Tegra hardware only supports=20
> EHCI-1.0.

I see, they're used for device addresses now.

How can we make sure on Tegra systems we won't use those top two bits ?

--=20
balbi

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+BmNAAoJEIaOsuA1yqREP/sQAKubGrk2K+RTsxjb1B8oPdAP
H7m5GGzz9mQf0MIS17542fhbahzzTdJpqto36UdPTLE/EPaZJkRdXhXisq1LM/zG
6PniYhLv2IdY3dmhG6SkMZesi7v4OFsAUa5dpSLRXo6mIoI6VtG3DkRQdIyUJSWx
Z2UW5x3V9H/f0UCYWPzdEHtjgi7+0IoyRkgH9DzfE0GE0ATLtI/4Jw6/6C8REYO1
gwkyOGe7s60UhXt54pdFDPyLJIap+CrpXos7fg9eapV8NsYoE/C1g+SfpqPpLCAp
zcTQUtU7mqITPbW/bbZj5aWbrHYEzfS4JqXYvGZyizr4+Ad1Cne7SMQE2SLArq5Y
E9RQOrNI9yjlwAOgv6XCdRFkNogibR9YKcqQLMgTET6ntMyisI7dgTbFPKEEMnde
9x7wNYYdYg4zn5asyAEYlT55rO23fG29Mr9btFIjCzfTW4GYuz/X61iie2YjOljO
nhG65oXpbGJy87ftZJJdEeZzH8k97IBBPf/3jqLhmj/eTI3sB5EgRBzCzkgUz0d9
5ZOADfPn3TuS/rRsjepo5NSkBfAnV2IeplCvlXWLTHw27yVnf2tjKupozmDzPEqB
QVbDodkm6XFnPVyd0viK9RXu/ioDBed6QtqaXGYCEJwcPJySNWq9yXwhSMQ+ZkhH
TGFIqfvbDIyIZ7Ro3iUm
=vHn4
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
