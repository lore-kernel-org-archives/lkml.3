Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaADB1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 20:27:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:29961 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbaADB1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 20:27:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,601,1384329600"; 
   d="asc'?scan'208";a="433724350"
Message-ID: <1388798859.2275.5.camel@jtkirshe-mobl>
Subject: Re: [net-next] pci_regs.h: Add PCI bus link speed and width defines
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: David Miller <davem@davemloft.net>
Cc: bhelgaas@google.com, jesse.brandeburg@gmail.com, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org, gospo@redhat.com, sassmann@redhat.com,
        linux-kernel@vger.kernel.org, bjorn.helgaas@hp.com
Date: Fri, 03 Jan 2014 17:27:39 -0800
In-Reply-To: <20140103.193008.684316024702680161.davem@davemloft.net>
References: <CAErSpo7K3OBuTEZrXmhQ3iXtLf3M5JNnEqmAvaceroJ46VAOKg@mail.gmail.com>
	 <20140103.185607.1380379872647540168.davem@davemloft.net>
	 <CAErSpo7TJXTCxpFKWXLTaHmqXXnYQdnpNeWt+cehSaES2Jh30w@mail.gmail.com>
	 <20140103.193008.684316024702680161.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bc8+RZ/we7a+7iRUIBQh"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bc8+RZ/we7a+7iRUIBQh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-01-03 at 19:30 -0500, David Miller wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> Date: Fri, 3 Jan 2014 17:00:42 -0700
>=20
> > On Fri, Jan 3, 2014 at 4:56 PM, David Miller <davem@davemloft.net> wrot=
e:
> >> From: Bjorn Helgaas <bhelgaas@google.com>
> >> Date: Fri, 3 Jan 2014 15:15:57 -0700
> >>
> >>> However, I do raise my eyebrows a bit at drivers that poke around in
> >>> the PCIe capability.  I would prefer to have PCI core interfaces that
> >>> handle that instead.  But I haven't seen Jeff's changes yet.
> >>
> >> The changes just read the link status to interpret the speed at which
> >> the PCI-E link is running at.
> >=20
> > Several drivers want to do that.  It'd be nice if somebody abstracted
> > that out somehow.  Jacob added pcie_get_minimum_link() which is
> > similar.  But maybe Jeff needs something more in this case.
> >=20
> > In any case, it's not a blocker for this patch.
>=20
> Ok.
>=20
> Jeff, please merge this via the Intel submission process and don't forget
> to add Bjorn's ACK.
>=20
> Thanks.

Ok, will do.  What do you want to do with the current series of patches
(mainly the ixgbe LER patches) on my tree?  I know that there is a
thread going on between Joe Perches and Mark, but it sounded like Mark
is working on a follow-on patch to address Joe's concerns.

Guess I want to know if I leave my tree alone for you to pull or toss
the current pull request series and get the i40e series applied.

Cheers,
Jeff

--=-bc8+RZ/we7a+7iRUIBQh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABCgAGBQJSx2OLAAoJEOVv75VaS+3OD0YQAJYpxBJNhXgmwleu7tbOAbUU
1W2HBbDfZmBt6AnQb12HqPDYcoGUedYEYUf/PCwBJhSEqcRkOKOCypQ9SXS7rodv
CDyD0HmYgh73xgeSj8KHz4auWhqQ/YmrOWCegFzl+E81vgsqCad+K6geN7Gd4Y6Q
DLrsl9y8s2llbky96NI8/UbJAgQvyml3oxEi+ylXiAp+Ct2DOsJ9ddJM29fM944N
BYPZQft1Fc9wVK4G12cHtB0ebCnx8+jAU/IPjobOGL0Tbpx6HfeN/KQJ1WAYnd0c
R4HCndqYjqf2cQMRJ8jLKmhIWUlD8jvdE19oJ+lsbTuF0CXBB7AFS6CAbSTZ8/NJ
d8x+k2Dy1LlxIf2u6uOX9QkMdJckIsoJ8U6DClnbxYzEHpDzF47ewsI+0lWx4h7S
vBk2UaxU7esIzDQTX9dCIy9Vl4c7htQMdkxCqvdy2YFDL2XpW8iUJ+eResClA5oO
KEIaOq65B4K/HLQSiFaZYhAJKM5L0F08QxoxmdgugNsF3UG33kFAsKm1KJTb5zap
ARlTM+1GK3+5dwVV8a+PxKkXBj60z+ZQg/lhrhkj0hTEkAKc0Shapcgv2Jcn/1t8
negrW1A8pHb9KhSsYrXyE4x6Ur3TxBlNBKqzO2jkzOdrqx1kob9uH9edysO9L2qo
P5EcvYhxN2ljxx7fDpc6
=1RgL
-----END PGP SIGNATURE-----

--=-bc8+RZ/we7a+7iRUIBQh--

