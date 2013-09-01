Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3IAE4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 00:56:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:57041 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab3IAE4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 00:56:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1000,1367996400"; 
   d="asc'?scan'208";a="395086657"
Date: Sun, 1 Sep 2013 09:40:45 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@gmail.com,
        Vinod Koul <vinod.koul@intel.com>
Subject: [GIT PULL] slave-dmaengine fixes
Message-ID: <20130901041044.GB7376@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Please consider the pull request for 3.11 to recive a fix for the resolving
TI_EDMA driver's build error in allmodconfig to have filter function built =
in.

The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:
  Linus Torvalds (1):
        Linux 3.11-rc4

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Guenter Roeck (1):
      dma/Kconfig: TI_EDMA needs to be boolean

 drivers/dma/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Thanks
~Vinod
--=20

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJSIr5EAAoJEHwUBw8lI4NHAZsQAIjnK9Cl04gh0dm8nOExP70+
aYPohvRDuBvewr7gQReb8DZy6/1FmybKyXeMokK4JndtVYRoLtIyCrQ8tNgz5P9l
+eHfaN+JLl8HG2xeAOo/wD8SF2a2LQtTjjJuUauUph3WtsJHaxZZ1ioWBV2DF1ek
u70UaFABlAPjxjlatk/c9BOaMAp4JOrA2ntE7lIOY5HvrGm5ytryBPoCZfXKkIOz
ijbWPqqIDRhkxKTQj6FrUUnprPXVrMZ4NQUufp6aWnTxi46v8V226CZX94dQGgPq
k2sOkAGOVgphOmF54as/DoNJxDAFwrz/WNrMJmTn+XIxjOapCTFA00C2mv11ZLPf
uj6xi7a6kbA4AcC1zVCuhbum31mq+M0kOBgPNqtVt3GzVz17q84pqkoJdQPMw5IU
gafnvIFQPTD4yL4wV7r6Ky2qz1bDTDRelOmGaOcQFP5T8mZ4FqZxpWCMmuoixmsl
aai6MHj01AtfJzPelOKjrmdt5NzInOkcv/8A1Z03l4hhC1QZgPqL2WTU/TxO+kY/
JV4YxNHAKNFsW97CUBo+L4QvjsdeZHkapcpgfusZpsHfJptei7ZjqmChCwERD4rm
NMT8v6U5n3VxFFN3+PPO0ctzH8W8X8ls8Y9uE6XUgvgMFg48Pa9D6BlCOgbk4OW2
tkDRn22yFglrKRhgnuBJ
=H/NF
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
