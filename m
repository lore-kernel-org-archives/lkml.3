Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaKLO6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:58:44 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45913 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbaKLO6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:58:43 -0500
Date: Wed, 12 Nov 2014 08:59:00 -0600
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <peter.chen@freescale.com>
CC: Felipe Balbi <balbi@ti.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 0/7] usb: add support for the generic PHY framework
Message-ID: <20141112145900.GC641@saruman>
Reply-To: <balbi@ti.com>
References: <1414690879-7184-1-git-send-email-antoine.tenart@free-electrons.com>
 <07c7cfed25af4bdb9e34b6ad1aaed0c7@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <20141107180820.GO15036@saruman>
 <20141107180852.GP15036@saruman>
 <20141112013308.GB15348@shlinux2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KdquIMZPjGJQvRdI"
Content-Disposition: inline
In-Reply-To: <20141112013308.GB15348@shlinux2>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KdquIMZPjGJQvRdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 09:33:09AM +0800, Peter Chen wrote:
> On Fri, Nov 07, 2014 at 12:08:52PM -0600, Felipe Balbi wrote:
> > On Fri, Nov 07, 2014 at 12:08:20PM -0600, Felipe Balbi wrote:
> > > Hi,
> > >=20
> > > On Fri, Nov 07, 2014 at 01:33:25PM +0000, Peter Chen wrote:
> > > >=20
> > > >=20
> > > > =20
> > > > >=20
> > > > > Antoine Tenart (7):
> > > > >   usb: move the OTG state from the USB PHY to the OTG structure
> > > > >   usb: rename phy to usb_phy in OTG
> > > > >   usb: add support to the generic PHY framework in OTG
> > > > >   usb: allow to supply the PHY in the drivers when using HCD
> > > > >   usb: chipidea: rename transceiver and phy to usb_phy
> > > > >   usb: chipidea: move usb_otg into struct ci_hdrc
> > > > >   usb: chipidea: add support to the generic PHY framework
> > > > >=20
> > > >=20
> > > > Hi Felipe,
> > > >=20
> > > > I find you queue the patch 1st-4th and 7th in your next tree, how y=
ou queue
> > > > the 7th without queueing 5th and 6th, they have some relationships.
> > > >=20
> > > > Will you queue 5th and 6th, or I queue them (5th- 7th) through my c=
hipidea patch set?
> > >=20
> > > argh, somehow I missed them. I'll add both to my testing/next. Sorry =
for
> > > the confusion. I thought I had them all.
> >=20
> > oh, they don't apply.
> >=20
>=20
> Oh, I know the reason why you can apply 7th, without apply 5th and 6th.
> At your next tree, the 4th, 5th, and 6th patches were squashed, and
> it becomes "4th" patches in this series.
> The shortlog is:=20
> usb: allow to supply the PHY in the drivers when using HCD
> commit id is:
> "ef44cb4226d132146e44f8ea562a16b27ff61126"

hmmm... not sure how I did that. Probably squashed them to avoid some
build failures...

--=20
balbi

--KdquIMZPjGJQvRdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUY3W0AAoJEIaOsuA1yqRE6SAQAKEP68W9V7yKPtgtGgJe6C1f
GlA/6P5NUT0hB2YXD8O+56qRVbtmsRD108qCfrhMiKbyI0AMxmuOzhpzULTUl5fW
j6YWP1R6f6YSqv7mLg+JUC69Klyd8PtkXRRQp9AstZhZaScL+3++o8ktEGsVOyzt
xRI6IFOZi3eHzi44GyfbjtCmZm5/JVTmsu8htpO7wvtXTmbk/Kprt3Ks7QcZmQhh
g3XEV+RXVQtnrm/e6dhbraG987ef5ObL1TOWHk+yP9qZ80k36gv7oGpKyYEU/xfz
Ys4utZzEnZXYg8JgbUI5sTBVhhW8EflnwW5sMrJlxC3OcfW5abJVrwcNIPtgw/Ne
IzLCqMzC/MiuMrhqb5HQkNXAaFowf9VA+/9dCu6kUFBMSiVsUdVx5WofAVhjOYqa
jxzuOGNRJcCkQ75VYMcfnyY6iQNbDXloi82hfvHsyoSKidxWp3wmIv8aCMuPATzZ
NVRphUjobu/XcEMuOIry4qx3WSqx0Qd9Bo3ePEQdPwQlpJ4l4RP66gVXqZ5B6Kvj
954roPskyQoTPmBBKVMS8zpQMrJz9w4nfo2eWOBEcZiG2TIqTIjiXbZyXMxuGaK4
DR1dN9sZ0q/I41X0SYWFHedTgLNWDeKO9ecWgMyOzhiUU8u5Y5R1LqFd8Ct0CQwO
urVwhCVEXPvyfjshfFkp
=g7kp
-----END PGP SIGNATURE-----

--KdquIMZPjGJQvRdI--
