Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaKGSH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:07:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35647 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaKGSH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:07:57 -0500
Date: Fri, 7 Nov 2014 12:08:20 -0600
From: Felipe Balbi <balbi@ti.com>
To: Peter Chen <Peter.Chen@freescale.com>
CC: Antoine Tenart <antoine.tenart@free-electrons.com>,
        "balbi@ti.com" <balbi@ti.com>,
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
Message-ID: <20141107180820.GO15036@saruman>
Reply-To: <balbi@ti.com>
References: <1414690879-7184-1-git-send-email-antoine.tenart@free-electrons.com>
 <07c7cfed25af4bdb9e34b6ad1aaed0c7@BN1PR0301MB0772.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FbmEh7Ek6NM6xKh/"
Content-Disposition: inline
In-Reply-To: <07c7cfed25af4bdb9e34b6ad1aaed0c7@BN1PR0301MB0772.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FbmEh7Ek6NM6xKh/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 07, 2014 at 01:33:25PM +0000, Peter Chen wrote:
>=20
>=20
> =20
> >=20
> > Antoine Tenart (7):
> >   usb: move the OTG state from the USB PHY to the OTG structure
> >   usb: rename phy to usb_phy in OTG
> >   usb: add support to the generic PHY framework in OTG
> >   usb: allow to supply the PHY in the drivers when using HCD
> >   usb: chipidea: rename transceiver and phy to usb_phy
> >   usb: chipidea: move usb_otg into struct ci_hdrc
> >   usb: chipidea: add support to the generic PHY framework
> >=20
>=20
> Hi Felipe,
>=20
> I find you queue the patch 1st-4th and 7th in your next tree, how you que=
ue
> the 7th without queueing 5th and 6th, they have some relationships.
>=20
> Will you queue 5th and 6th, or I queue them (5th- 7th) through my chipide=
a patch set?

argh, somehow I missed them. I'll add both to my testing/next. Sorry for
the confusion. I thought I had them all.

--=20
balbi

--FbmEh7Ek6NM6xKh/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUXQqUAAoJEIaOsuA1yqRE9msQALOz9oiFrFxUae6AhrYrNJGe
8CKmqrxr1DrypV3NbKVRxahkls+tiLpm/0+lFhomtlIPUkSOEJlB6kQhdiNlNnj/
zSc8uF4OcTy75Q7qCjZCiemxSzCJGZ+YheasCMOnWpykttHHy577OQQdlWGszLmG
hVGriwm2QKWHi0bNYl2h4taHzIqB3V4kOa+fuTTf6tF7x/ASlyCqTqWAaiJXlYrN
6hZe0IoPNlBCJGNgOP0Fiapq6GMzJnz5gjvismHm6RUw2ggh+1FeQZlyDvzlfNad
mu5p+bw7HfsmQg2Gbya7Rnb8+w7WneWtFsH+nEE5sjtFd11EqWOg1eOAL4BBdFKZ
8hR9iuAuXeehfKOghiuj0FZpmGtbKSjmG+GpU+BKq3GDh4aodyLw6wdgIFMGCgax
Bw/t+HWZpzTfKqJ7DD/BvR6nTm1Ai8Ho9Nb0Qx2jlfU9on9FrsPOjp93B2iU27E2
asBTIJzCs4T3xLbwWtUpqB8U/fONvIqR0zAYRKh3++BobzxzpLBIoIvypIo6KD9G
Eq1UbY4vpC6GNSIDQ1FEbRG6cjobZNe6QHqlOOVwXgmUs9dpVemtmEArE8mS2r17
yDW2pHcCm/ekNYT1VAEE3xh8MgzGXzVyNZcdXRP2zL41H/0Tu0PZaDthwTasKHFO
F3ezI/ruSScpwLeZvmnr
=hKMo
-----END PGP SIGNATURE-----

--FbmEh7Ek6NM6xKh/--
