Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaKREhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 23:37:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60021 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaKREhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 23:37:38 -0500
Date: Mon, 17 Nov 2014 22:35:20 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kever Yang <kever.yang@rock-chips.com>
CC: Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        <romain.perier@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        <dianders@chromium.org>, <sonnyrao@chromium.org>,
        <addy.ke@rock-chips.com>, <cf@rock-chips.com>, <wulf@rock-chips.com>,
        <huangtao@rock-chips.com>, <linux-rockchip@lists.infradead.org>,
        Roy Li <roy.li@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc2: resume root hub when device detect with
 suspend state
Message-ID: <20141118043520.GA19332@saruman>
Reply-To: <balbi@ti.com>
References: <1416273684-11300-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <1416273684-11300-1-git-send-email-kever.yang@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 09:21:24AM +0800, Kever Yang wrote:
> After we implement the bus_suspend/resume, auto suspend id enabled.
> The root hub will be auto suspend if there is no device connected,
> we need to resume the root hub when a device connect detect.
>=20
> This patch tested on rk3288.
>=20
> Signed-off-by: Roy Li <roy.li@rock-chips.com>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>

looks correct to my eyes. It's the same thing XHCI does.

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUasyIAAoJEIaOsuA1yqREhukP/0squ1lgCa7wvtNYIAmRVzg0
Mp2YZBO14iXf0tRLo2N1L+OC7NxZFB6jd6bReX5y72Z6qie8rcW7XCBwpXMIDigQ
FkQ5STZRbsl5+T57jrmCouS9HywLYac4QlH2l5ZIxwbkeKOvt417/7srCDq0+N9i
LF+AU3P4MWLyq+0pXCjnCGyZGuCalTz45MImRq5ZHxAqxNN6+nQ0Fp1AMp0RBMKb
pKr4lahcYG6IHd1aWo83HYJI2Nj2Hm/xp5MUvrVpwtDkpjuue7wHOvBeJrgkQjeg
Y8JzpoCCSELpEJH6kov/dgO9vhbAZa8IbKQ1gb665Vhwa5oHE37+7uzZ7awpOm7l
iXN4qemjtiam92Nb5jLaC8vk5lR5kbjP8e4565FKRWhalvRBlnhCiE57lAqy76+s
AQjgxI710bPxhPOIZM1kyLbqYxHz0pJEhXSSzlLlDh9XWJGPHv+6Cjm1x1D5pj6t
I4oJb57yOB4rIR3OLzHwrE+4ObJPHUR0ItOX3cxKw/grQZ2vkauELF/tKuT3y3V1
s5DIu8fVQ67tpVkbCmUG4getZtAocxFvj9aue5pQv8N75C/AoeMcdCaogyBkfifq
sFGhQq6rHYbrl0ct3lj4IvTGsbBolybvxl4vuOhlAb1a+WqnaTzd3xE88kBPZ5UM
mqbs5Rd584OsFzd9+GAp
=vMtc
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
