Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaF0XFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:05:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60247 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaF0XFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:05:05 -0400
Date: Fri, 27 Jun 2014 18:04:33 -0500
From: Felipe Balbi <balbi@ti.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>, <sebastian.hesselbarth@gmail.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v2 05/12] usb: phy: add the Berlin USB PHY driver
Message-ID: <20140627230433.GC762@saruman.home>
Reply-To: <balbi@ti.com>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-6-git-send-email-antoine.tenart@free-electrons.com>
 <20140627155622.GL8069@saruman.home>
 <20140627160557.GA6622@kwain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <20140627160557.GA6622@kwain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2014 at 06:05:57PM +0200, Antoine T=E9nart wrote:
> Hi Felipe,
>=20
> On Fri, Jun 27, 2014 at 10:56:22AM -0500, Felipe Balbi wrote:
> > On Tue, Jun 24, 2014 at 12:35:14PM +0200, Antoine T=E9nart wrote:
> > > Add the driver driving the Marvell Berlin USB PHY. This allows to
> > > initialize the PHY and to use it from the USB driver later.
> > >=20
> > > Signed-off-by: Antoine T=E9nart <antoine.tenart@free-electrons.com>
> >=20
> > since this is a brand new driver, it should go to drivers/phy instead.
>=20
> This PHY is used by a ChipIdea USB driver, which uses the provided
> common function for ChipIdea. These functions use the usb_phy framework.
> That's why this PHY driver is there.

right, but you can add support for the new PHY layer which would help
other users convert their PHY drivers to the new PHY framework.

--=20
balbi

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTrfiBAAoJEIaOsuA1yqRE+jcP/2MTPeE8myy+i7CRNagDApsq
9vMSZDEjxu68jxaeUes1X0dGl5hbeOs91UWP56PtcEDOsw1UQX2nP+kQnO8L8YCm
L9d8GYs0XtqhwgkLT5mn56cJB4AbkRkE5FEt2OLseYQEPpoaRWgFZsv5ofjxr2zV
PtUwMNcUrV4jUVxdYPs8Vvt0mjTp0yRm+jDMair2uAJa6B8yXLVDtEfXRT0I4bDh
fvGgHk6mQB7QqIBPDK/1kXJHGbwTmFxaPuGTjJTWsKSs9wfAoDwTlppSkUqlhY5C
4VKoN9eT9j4C5merWO/NUq5r/kflNScYYHLY4KmVSiKPmJQT9CLUx26pfP1mLL61
vdH1fXTSMggBVNNNcyOHmWxcGG0l5INiE9bjb1d8QYJrMI7n+rnWqsFACpWkU3ya
2MFFwq6rGc9i0X5aaozYkEkadKvQbBHIKnXEjvvsujTmjYkzBEhSPUpKFrCIFSzV
rwBAZH/9H0ccO5j0I76lu4Xzm7PInFU143j+YIoTji8EJEVQqfr+C60KJ3yZkV21
/eY40/WldYD6tpQ7Tw0q09ALQQNpOs3ffrDFKvTLRPNB6eQFiNmI2PKlSRoFyUyW
bPA5OXmfXO8XpkkvblHvupJfNjAD3rhsBVR5sh8FNUTbXk72JkrUQdt4mlO4rkHt
K8KPBQ4g3QXEHN/m7Kqo
=BaoT
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
