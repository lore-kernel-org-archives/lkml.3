Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3BEJ1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:27:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37168 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3BEJ1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:27:47 -0500
Date: Tue, 5 Feb 2013 11:27:36 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Roger Quadros <rogerq@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <sameo@linux.intel.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 12/30] usb: ehci-omap: Remove PHY regulator handling
 code
Message-ID: <20130205092736.GU32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-13-git-send-email-rogerq@ti.com>
 <Pine.LNX.4.44L0.1301281235130.1997-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pzbqGaOtRNiVr7w4"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301281235130.1997-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pzbqGaOtRNiVr7w4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 12:35:25PM -0500, Alan Stern wrote:
> On Mon, 28 Jan 2013, Roger Quadros wrote:
>=20
> > PHY regulator handling must be done in the PHY driver
> >=20
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
>=20
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--pzbqGaOtRNiVr7w4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRENCIAAoJEIaOsuA1yqREMt4QAICveHKcQ3iGqRRcVEhnQxEC
6+t6wA0Hxm60aTbo5R7LwzEpJRqyFGLrewRzDaN17oprGxVpFmJCNw9gRTjGzliA
3qo1Bwr38BnG3LUWav2u2HJU5imBIumSD86lL4ffChuVQOvw05LaS8k9oreoGsFn
llud1BY/lWzg4SACgDWlrb+jfzzeWLpAlDx4JFp+EWx2h/6YY4XehVUDiO0hqpDw
E2DzATWsXc7k8GtgQwahMqtvcD8kt2/DNF/wYqyiR8KMWUmt9GxjJ/LAQoj6Z2CK
OGXoLcLsYbHulSf3nFRtWkCIsFoca6ja2NUByEu/W+MFdtCmmXs4BhyjAlTbwYfL
R/YX8RCiDw3u3kp/WW6u2PCTCXg2o3Em46/ZfoHmPAZd6XLUboSvCQsKhs8mcdso
we4KNhHnIG/fCldS2TNIRxgztA/Amf5Yygh0SxIu9FUXkbvRR/qUBvs1J4n/+yeZ
I3JN0RRLFbMljYNxIve5k+Nv7CmNarY8W1OKDFd1vhxKFYGBqAEbDRMKzDwGd70L
n/870hmZ0CXyGwl+GKYQFR2Ur3ZasD2zxCNZHGqC8BCIH6MewFtVjc7DlyV4Q7dU
D7fwzDdgRV6advjDfUa+Z1+uKadehTYHxqE/D6cJnw0HQwxRBw1Ha9YSpK1ZyORd
FgVz3S4NFbL/GThOuTPM
=vKqA
-----END PGP SIGNATURE-----

--pzbqGaOtRNiVr7w4--
