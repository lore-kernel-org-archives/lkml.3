Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaHTJnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:43:49 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56546 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbaHTJnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:43:46 -0400
Date: Wed, 20 Aug 2014 11:43:41 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCHv6 2/2] dt/bindings: Add the DT binding documentation for
 endianness
Message-ID: <20140820094340.GC15414@ulmo>
References: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com>
 <1405398183-31345-3-git-send-email-Li.Xiubo@freescale.com>
 <20140820080549.GA15414@ulmo>
 <10ad24319e6a486db77c31a5a911140e@BN1PR0301MB0609.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
Content-Disposition: inline
In-Reply-To: <10ad24319e6a486db77c31a5a911140e@BN1PR0301MB0609.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 09:14:02AM +0000, Li.Xiubo@freescale.com wrote:
> > Subject: Re: [PATCHv6 2/2] dt/bindings: Add the DT binding documentatio=
n for
> > endianness
> >=20
> > On Tue, Jul 15, 2014 at 12:23:03PM +0800, Xiubo Li wrote:
> > > Device-Tree binding for device endianness
> > > Index     Device     Endianness properties
> > > ---------------------------------------------------
> > > 1         BE         'big-endian'
> > > 2         LE         'little-endian'
> > >
> > > For one device driver, which will run in different scenarios above
> > > on different SoCs using the devicetree, we need one way to simplify
> > > this.
> > >
> > > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > > ---
> > >  .../devicetree/bindings/regmap/regmap.txt          | 47
> > ++++++++++++++++++++++
> > >  1 file changed, 47 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/regmap/regmap.t=
xt
> >=20
> > Sorry for jumping in so late. I think this binding documentation needs
> > to be moved somewhere else. regmap is a Linux kernel specific
> > implementation detail and therefore has no place in device tree binding
> > descriptions. Furthermore the endianness properties described herein do
> > apply to drivers that don't use regmap.
> >=20
> > Perhaps we need some top-level file that describes generic properties
> > such as this?
> >=20
> > Thierry
>=20
> Yes, I do agree.
> And there are many devices that have the endian issue without using the
> Regmap in our LS* SoCs.
>=20
> And I also think one generic binding description of this will be much
> better.
>=20
> Where should we place it? In Documentation/devicetree/bindings/, or...?

Documentation/devicetree/bindings/standard-properties.txt perhaps?

Thierry

--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9G3MAAoJEN0jrNd/PrOhxHwP/1hfjJvDNoaUHLP2xKokiiq9
OXpL4zgiI/uWdUkrI/28zrbu9G8oiwobpIBWgqTfn8++YUmKlmLFzz22x0WWxq9p
DPt/ED5QBfeiwYISSNvfJUGhqoLZg4WhB8Au8ek3IX+yBzwfe0tVcliNmz9h8ySO
mJ/kOh4eGfvcqkfrXI8DKq6oac/+yvxWU55zobABoQj+SneeEjLcsWnH3ryesf45
e3WHkptPIWj9ibVN8ddXzcHsLF/eIewKcPBtARFsQ9QZRrGQWVqSFaAEjU64hbsj
4rYh0OovYfHe6v8XZCQHxxY256Z2kcq4XPJNMgI4WpNZ/VLbwyZsm8eCN+rF81To
/MgKlcPLdenpPWmmFnMfcNROBeAZCcRQnAUDsuIdILvV4GrCYiW+TEukr371yaMg
GMlafEzKXOBuKcCfwAjBLqtUJAut4O+S4E48hxQsAKqXsJy3WHTHl1s7c5zr/Eqf
j44mELZNJiOGiI7V9dXs731NYXj/M7STHsRKcnS0YZsT7w2WXNJE9AfDsBRDEHvO
IwyCrVIm6jSo/BT/rNfHB5qoncRtM4vHU02+J8CqisgtwcwB1fRdw+1rHs4K7qLo
kfZlsN9CRntMYH8DHHaH9H48fuGdc2hmFUP52W/VuAAWAIcPgXk3j96y55FLykrI
ulOtmhdIowAfkcArNtVz
=Q89J
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--
