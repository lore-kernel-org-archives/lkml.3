Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab3JKNkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:40:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34645 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab3JKNkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:40:09 -0400
Date: Fri, 11 Oct 2013 08:39:52 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v3] USB: gadget: s3c-hsotg: add isochronous transfers
 support
Message-ID: <20131011133952.GE25706@radagast>
Reply-To: <balbi@ti.com>
References: <1381300917-7468-1-git-send-email-r.baldyga@samsung.com>
 <20131010160428.GV28375@radagast>
 <52579967.6020306@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SxgehGEc6vB0cZwN"
Content-Disposition: inline
In-Reply-To: <52579967.6020306@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SxgehGEc6vB0cZwN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 11, 2013 at 08:23:35AM +0200, Robert Baldyga wrote:
> Hello,
>=20
> On 10/10/2013 06:04 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Wed, Oct 09, 2013 at 08:41:57AM +0200, Robert Baldyga wrote:
> >> @@ -2616,14 +2630,19 @@ static int s3c_hsotg_ep_enable(struct usb_ep *=
ep,
> >>  	s3c_hsotg_set_ep_maxpacket(hsotg, hs_ep->index, mps);
> >> =20
> >>  	/* default, set to non-periodic */
> >> +	hs_ep->isochronous =3D 0;
> >>  	hs_ep->periodic =3D 0;
> >>  	hs_ep->halted =3D 0;
> >=20
> > this hunk doesn't apply because of this hs_ep->halted line, which patch
> > does this depend on ?
> >=20
> it depends on http://www.spinics.net/lists/linux-usb/msg94025.html

I'll fix it up by hand this time, but new features shouldn't (ideally)
directly depend on fixes which you just wrote.

cheers

--=20
balbi

--SxgehGEc6vB0cZwN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSV/+oAAoJEIaOsuA1yqREWPkP/irc6IK56aUuI0lAeTHPqVhY
8mHySDoxDgO3OEIKYjo/Gf8MCPVoRCB+SFnjEoMNxWegJV9aIgf+pRbgoYjQswCs
KNlu5JeTSqomJuD9QYjC58Ut8RK04c2UDN8J0aPgL1Hhms4J4nCmEgZmP0qXz2x7
/YygQXV1b7HAvYcEZZKk0jZ/j8HMe1+yh1WtvYmcMP30wB0Q+YjQAfqv4QnOG+8e
6N84qqwiG1FWkfaXuwSmSxmfdpImyIO9SyFIR/j/4ynhQIVK2mNWbN96h9WevP8H
uWrxdJNfM6Bn+huaAK0Hwq8o+7WfcKiUhnaWGDLwb0LdLnEiD3wkmjSpSG5XHbel
rjv/Pn9f+8CPiD2tMVnqbr2HJaEWokJb7yxx22q71GW/RWrP1Hi6xlEzXGn+wkjF
1UEa0sjIKUDgG/AjEiac04B8Nv5YSoDqoOoGjzxJMerAriE5Om5fFwd08K9skYu+
2/E4r3Qrq5XLiLcN1eAQPKgCHO9aTV7Sw67Qe7nOwHOfmUP67WikshnziiZBnzWz
bchfq4T+Tc1W85QzbtMgkgTYGnAR0gdGdGc7K/UT+kijQglXR9QEdBHd/Rx+AOvb
ddLmWM4IJ145SVcJ1ENXbzGab4rlvfbYJCTLOinzbbpWK3P15m5Xxzk/LETu+guH
CtRoWNr/vcKSadiAwllA
=NyQW
-----END PGP SIGNATURE-----

--SxgehGEc6vB0cZwN--
