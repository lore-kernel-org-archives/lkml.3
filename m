Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbaFSPJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:09:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51119 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663AbaFSPJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:09:00 -0400
Date: Thu, 19 Jun 2014 10:08:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <m.szyprowski@samsung.com>,
        <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: gadget: add claimed field in struct usb_ep
Message-ID: <20140619150853.GG23782@saruman.home>
Reply-To: <balbi@ti.com>
References: <1402906836-12733-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lHGcFxmlz1yfXmOs"
Content-Disposition: inline
In-Reply-To: <1402906836-12733-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lHGcFxmlz1yfXmOs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2014 at 10:20:36AM +0200, Robert Baldyga wrote:
> This field allows to mark ep as claimed in more clear way. Claiming
> endpoint by setting driver_data to non-null value is leaky solution
> and makes code unreadable.

how come ? How can it be unreadable ? how can it be leaky ?

--=20
balbi

--lHGcFxmlz1yfXmOs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTov0FAAoJEIaOsuA1yqREiIAP/0xbaw+HtzVP8WGzNgkxTUQ3
2NRpPXMnoiDyN7T9+zG2EegdaKZDNSG/yhGl5pZr7EVeV05pb4q1gITrY3p5OClV
TXVwlvA3fi5hUzPV9tcaLjHhoikksHcLGo3MXilYeYYzbXSGUYRMym93bSm3Q29g
c1C1Fj/I8CBaK6OvHAIeet2E4e/cWjHrggyko+dbbOvptgJHt3a+LBQ9aHN26ygF
isAr0j6EtjfxiScl2PpYKi17xBV1rXJJUh0mNo0wzoltQ1VNBXsfrlFczLSqeR0n
39fwmBLZaslvGF1Z0gRfAdxLcEHm8vFcCdEi+JMsJODX1CqEgA0Uxb5FR/51ns7d
Dy0nqosjyTAbkMMR9ezcWz+3ImzmOUjRHSUaGnoI8lp4/DXPOGrAk4veJCicQs5C
eYnjqxMHFF8l3yLfOkdJd/6VLZWLwP1/9i4znYOmlnebIDAkLJ4KT/FKRjvnAX9R
Ga0WTcf/swSAKQ7uSvIUDtv6kCJy+sa79bJ+MpkldsUP24uWaLjfZloUUYxZG2HO
vs3fr+8AdNrAOmn2sbodU4vqKC3CNTaPMrEgUVKfgG3rov7VcuPPcef1MHOyfJW8
ATWgtLvn1AblUuir2JMnJO7TXUs3mZcsgFCoZJTUlgZmynCW5uTqFyuTq8YDJ5sR
gZ42sgDxq7VJo+Mtu7en
=m95y
-----END PGP SIGNATURE-----

--lHGcFxmlz1yfXmOs--
