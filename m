Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaJPGNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 02:13:53 -0400
Received: from ozlabs.org ([103.22.144.67]:42377 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaJPGNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 02:13:51 -0400
Message-ID: <1413440004.20705.7.camel@concordia>
Subject: [git pull] Please pull mpe.git for-linus branch (for powerpc)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bhelgaas@google.com, linus.walleij@linaro.org, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>
Date: Thu, 16 Oct 2014 17:13:24 +1100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-NksMaltrWCP8aPwOPI+U"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NksMaltrWCP8aPwOPI+U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

There was a bit of a misunderstanding between us and the ARM guys in the de=
vice
tree PCI code, which is breaking virtio on powerpc. This is the minimal fix
until we can sort it out properly.

cheers


The following changes since commit 0429fbc0bdc297d64188483ba029a23773ae07b0=
:

  Merge branch 'for-3.18-consistent-ops' of git://git.kernel.org/pub/scm/li=
nux/kernel/git/tj/percpu (2014-10-15 07:48:18 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git for-linus

for you to fetch changes up to aeba3731b150188685225b510886f1370d8814de:

  powerpc/pci: Fix IO space breakage after of_pci_range_to_resource() chang=
e (2014-10-16 14:19:07 +1100)

----------------------------------------------------------------
Michael Ellerman (1):
      powerpc/pci: Fix IO space breakage after of_pci_range_to_resource() c=
hange

 arch/powerpc/kernel/pci-common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)






--=-NksMaltrWCP8aPwOPI+U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJUP2IdAAoJEFHr6jzI4aWARvEP/jGscqO0rkyONPO1EOxVBjoE
ft+a7qcUHDCM1CQxYGk6MP4CThbomCvmDfGCBma8nYy6BpxYYEDHLts8X1tZ7gqL
Q+OSS5zI1UyLlZjFs0kT6eGGT/9Gxf9r5Fp+nGX5sHcUYyvUWn75KwDguojxx1pZ
c5I5PfjLea3DTAZKqMqVHw2WaYYiFAxt/AwvbjAEufzsrN0QdCNCOcpmi0XCNZjZ
kZpXElA9AJ7wJKsIpGeEPayMaDPd0V4S7zi0NvKuvAnr1ZTXfbtk9to49XYvXdXb
H7uKj2VsksbPmGhgS+VTllySSubKao5AYtJZ+K/4PUNnkWlz/oiZSNGExoTCnVIr
6lk+m/fUszC2Ill9WfCsYfTGumXyIw4PxBc1jdf30mNTQC4H2Us+sMAskxqOOEZV
qxkA8djXU5aYkZdPJy349w7qNAu0dJRO/V/YdolHl7ux0HXtWRHpKqsy7IT5HKu3
DrrkKj4jxCTAort8+ui+kiDhL6Qs/uY5Rw1JTSpeTGgf1zdb44QvJ4Z8TVUtRR6f
xdrJ2e0aJjPlTHiHuQB4ubL8i2n/WNSUJGtinnN2OJoVVTdPnrE79NavFofZVw5q
C+mrD0qeTegt1dfBFZyEJSmeBNZ381Nwffws0MPNAPyDF0nHad+aykTXibsrPp7G
i4ssU5j5qAQ7pO2qK5Ll
=K7Wa
-----END PGP SIGNATURE-----

--=-NksMaltrWCP8aPwOPI+U--

