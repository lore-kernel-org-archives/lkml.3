Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaHTDT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:19:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52816 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaHTDTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:19:24 -0400
Date: Tue, 19 Aug 2014 22:19:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Chen, Alvin" <alvin.chen@intel.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: Re: [PATCH] USB: pch_udc: USB gadget device support for Intel Quark
 X1000
Message-ID: <20140820031919.GB12639@saruman.home>
Reply-To: <balbi@ti.com>
References: <1407172974-22485-1-git-send-email-alvin.chen@intel.com>
 <20140819141534.GC16085@saruman.home>
 <4656BEB6164FC34F8171C6538F1A595B2E97D609@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E97D609@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 20, 2014 at 12:46:33AM +0000, Chen, Alvin wrote:
>=20
> > Hi,
> >=20
> > On Mon, Aug 04, 2014 at 10:22:54AM -0700, Chen, Alvin wrote:
> > > From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> > >
> > > This patch is to enable the USB gadget device for Intel Quark X1000
> > >
> > > Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> > > Signed-off-by: Bing Niu <bing.niu@intel.com>
> > > Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> >=20
> > Can someone confirm to me this is not another incarnation of chipidea ?
>=20
> No, this is not another incarnation of chipidea. And its cover letter is =
as following:
>=20
> On Mon, Aug 04, 2014 at 11:00:07AM -0700, Chen, Alvin wrote:
> > From: "Alvin (Weike) Chen" <alvin.chen@intel.com>
> >=20
> > Hi,
> > Intel Quark X1000 consists of one USB gadget device which can be PCI en=
umerated.=20
> > pch_udc layer doesn't support it. Thus, we add support for Intel Quark=
=20
> > X1000 USB gadget device as well.

hehe, right I *know* what the patch is doing. I can read the diff and
figure out that you're adding support for Quark to PCH UDC because
Quark's USB IP is the same, what I wasking was if that IP was actually
an instance of the chipidea UDC. After looking at the address space
definitions on both drivers, I see that it's not.

So tomorrow I'll look at this patch again.

--=20
balbi

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9BO3AAoJEIaOsuA1yqRE+8AP/RWNKvnShtYuOuIgutkJ8Coz
IVqk9nZmQ+DCstnQnlB2b9E6pmDCdH6P4ED2/Fpb6HuVvloaM3Ocv2soKXezECTv
aTblkrTtxaelN4qFeZbY8PQvVqlCn5DSogy9Ho6AIILHJLouIGdP3kbKoX4ETqEj
SWc4/wSmN1I/dHr6c+pwkBueI6llA9amZjlec5//8URElTr0hX0XHTUv6wBOcFNP
ao8CdhWlUKgLlRDkSGxEslt+37r1yis4UpjtlqfN7JrxRFb1snARfpc16sMijMbC
Mk5p3T4lrY6prTmbXXqWNdVeI86a0b83XCwyaTFHmZOxQAwpmjY5qyiAR3RbVmze
xrJ+qBF+mym2PnzTwZE/0V+OGXdUblnoIgzwr2eaAHbQDao7D3Onn+5lh+0KxhsC
SLsRqQYw/8aGSe35vsK3TSmqUf3GAPUvkDGapTE4TiZuSToO5Z+XS6f4ChdRRhme
VFXknoACBZY3NEu8l46O+Y+q1b09h0zYn8f9B5wRNIwazaDs2iR+c5o0O9QWjTPf
7kjbpWGKQcnVAsHn2fgAAJVxA0QKUjTDpVBSfb7OP7fZhBgkhs03FSuoatAHXaCw
FpodZUN8pqj58i2NRgQiRZvnfbqr+QDdO6NgHw8rhSyREPP3GwxMJ6BEseXcj3X5
TYNYsjG95jfUhcqyP+vv
=eNkN
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
