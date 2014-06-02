Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaFBQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:16:29 -0400
Received: from sauhun.de ([89.238.76.85]:46622 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbaFBQQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:16:27 -0400
Date: Mon, 2 Jun 2014 18:16:23 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Yao Jin <yao.jin@intel.com>, Aubrey Li <aubrey.li@intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] i2c: designware: Fixes for Asus T100 and Haswell PCI
 IDs
Message-ID: <20140602161623.GH2654@katana>
References: <1400164644-3222-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o71xDhNo7p97+qVi"
Content-Disposition: inline
In-Reply-To: <1400164644-3222-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o71xDhNo7p97+qVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 05:37:20PM +0300, Mika Westerberg wrote:
> Hi,
>=20
> Patches 1-3 are needed in order to get runtime PM working properly on Int=
el
> Baytrail based tablets, like on Asus T100. We need to re-initialize the
> controller on resume.
>=20
> Patch 4 adds Haswell PCI IDs to the driver. It is independent of the
> preceding patches but I decided to include it here as well. Haswell based
> chromebooks need this.
>=20
> Mika Westerberg (4):
>   i2c: designware: No need to disable already disabled controller
>   i2c: designware: Disable device on system suspend
>   i2c: designware: Add runtime PM hooks
>   i2c: designware-pci: Add Haswell PCI IDs
>=20
>  drivers/i2c/busses/i2c-designware-core.c    |  4 ++++
>  drivers/i2c/busses/i2c-designware-pcidrv.c  | 22 ++++++++++++++++++++++

Patches 2-4 applied to for-next, thanks! Patch 1 leaves a question to
me.


--o71xDhNo7p97+qVi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjKNXAAoJEBQN5MwUoCm2kDoP/22Ogi7vGBZPAPmChQUTS2Nu
k59LAyjLaJpMZ+QkD04DEvN8CKAiWHrEpE07vzUHHH1aezk/2vHBu0oWPA4zaS4D
9fq7GEoIZpDleBu85im2R88b9l4x6cyghH79MkyU7Y9gxilBcbCSuOLOeMkbME9W
dT86/ILv3y9hA8Z2eMldl4Z1Jb1N396wTIRFcPMZ0IuO4cEgh0fr4bVPtGC5l+AB
vNQ0Z8xuimhWLLM7R1A+5JIAs8dS7MCqX92B+I/AXKngBxhwPTTkJjcD1ULqbX8K
i3dAxNgYRIc9iMGWy+E2IPZq932i9TcfdEzc9hcLcns0lgkGrKe+80NP4HOOIQpY
pYNnINXOZ8HVabiG1mnkrQjR+IjLSeiY2/O9qozqtU8GMZlwMqBgT8U6hX1RtHej
R8Bc51BBzqJm6fOo8Xy7Qf2sbcZEyVr5alkj2dX6RUKopzHz1zNg/lRWfgINJ1MQ
koXbcg/glr2SEcn/tZAp6TIYaqYSLsZPRt53ezDYNJsMd82pOYqVaeKArOq2Dkbc
ZMSOIoCP6aRG5DZ1GlHdE+aQCHjVeW7VWCQczNqwi75bDHStj7sj7QjXxk/zYWmP
na/zaZXcxHWyxOH4EEo/1QeRljYectfRxskohf7DBTR1VfFGJJCNu/ySGwPOMCnm
eQu6ypajm2pp09F+7eXE
=KFJo
-----END PGP SIGNATURE-----

--o71xDhNo7p97+qVi--
