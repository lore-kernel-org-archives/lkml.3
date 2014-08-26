Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbaHZPIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:08:21 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38012 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413AbaHZPIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:08:18 -0400
Date: Tue, 26 Aug 2014 17:08:14 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] PCI: tegra: Fixes and Tegra124 support
Message-ID: <20140826150812.GA26603@ulmo>
References: <1409065064-17617-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <1409065064-17617-1-git-send-email-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 04:57:38PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> This series implements various fixes and adds support for Tegra124 to the
> Tegra PCIe controller driver.
>=20
> Patches 1 and 2 were already sent out separately earlier on but haven't b=
een
> applied yet, so I'm including them here for convenience.
>=20
> Patches 3 to 5 are various fixes that should make the driver more reliabl=
e,
> though they don't (except maybe for patch 4) fix any known issues.
>=20
> Patch 6 finally adds support for Tegra124.
>=20
> Thierry
>=20
> Eric Yuen (1):
>   PCI: tegra: Make sure the PCIe PLL is really reset
>=20
> Peter Daifuku (1):
>   PCI: tegra: Fix extended configuration space mapping
>=20
> Thierry Reding (4):
>   resource: Add device-managed request/release_resource()
>   PCI: tegra: Implement a proper resource hierarchy
>   PCI: tegra: Clear CLKREQ# enable on port disable
>   PCI: tegra: Add Tegra124 support
>=20
>  .../bindings/pci/nvidia,tegra20-pcie.txt           |  25 +-
>  Documentation/driver-model/devres.txt              |   2 +
>  drivers/pci/host/pci-tegra.c                       | 257 +++++++++++++++=
+++---
>  include/linux/ioport.h                             |   5 +
>  kernel/resource.c                                  |  70 ++++++
>  5 files changed, 323 insertions(+), 36 deletions(-)

Hi Bjorn,

Right after sending this out I noticed that this series is missing a
change to the device tree binding that I've only had in my local tree,
so please don't apply this. I'll send out a v3 with that fixed shortly.

Thierry

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/KLcAAoJEN0jrNd/PrOhqy8QAJJz/7sn8q1x3zNl3rfJvUS0
3OC1wh8w9ZR0OPz5d215xnzQnJx8bBOF4vzXzJicj+Jibg+19FzfB905Atqam8KI
4vGh473Vms+FNHuz1EkDtJDkCN3iufj11Eic4s5cfn9vqEDygdphATQPUIAwKnux
FDlpm1SI254j5voIXmyfflH5dTI/4Ms1FkTgOudoQBhpv3QCw08DqBSHqdzAM7Ph
T9ItnrjOymbyS5iRHG8ETY+vPDXNXGuxrxfRSKDY4VdtwaDQugi+xtLWkO/foGTZ
1rSJjg4YwY9EBLjoXo81U5lz971Hwe2YA+zET0HScluwIyRFGI9kw7IVHB4ixc+n
smhlRW0p154li2p4pvKPAE3fWv7MuSS3MG7lRjJCQ6np1JjQp7wFHhRE8LawySfJ
s6L0eYIJiIorlvBt6MLF6loxboXm6xBsEYHn9kxXF9uqWFFXR3PrFSmieUbwC7ib
zpoLUAyIy14Zk9F6plDKCRn7ikYSwbuVpujnvd4ou9Tj2Vd9aOIalXy9Zo3bNE8Q
3cgebwv5+PuY9Kq3PH17u8F/2DkjeKb4Qho8PFJTmmJV1u9/uLSUw3S4mhtaBMG4
gg/ZhpfETTOGpsNkev9FuCH3jMy5uz/4c/4QLUqFtGWZP+ZcvkQwuzX8no9bDDJw
d+9cl2VrFmBba2MI4zlB
=7vkZ
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
