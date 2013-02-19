Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab3BSFas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 00:30:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3BSFar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 00:30:47 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jeez3CPDrQkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=p5DEV8tQUMAA:10 a=VwQbUJbxAAAA:8 a=ankguWfssnWlHO32Y0EA:9 a=QEXdDO2ut3YA:10 a=U62fhAwekXMA:10 a=-elahiuVKyh-JelgvK8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130219053021.721159211@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 19 Feb 2013 00:30:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] [ANNOUNCE] 3.0.65-rt92-rc1 stable review
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

This is the RT stable review cycle of patch 3.0.65-rt92-rc1.

Please scream at me if I messed something up. Please test the patches too.

The -rc release will be uploaded to kernel.org and will be deleted when
the final release is out. This is just a review release (or release candida=
te).

The pre-releases will not be pushed to the git repository, only the
final release is.

If all goes well, this patch will be converted to the next main release
on 2/22/2013.

Enjoy,

-- Steve


To build 3.0.65-rt92-rc1 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.65.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.65-rt92-=
rc1.patch.xz

You can also build from 3.0.65-rt91 by applying the incremental patch:

http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.65-rt=
91-rt92-rc1.patch.xz


Changes from 3.0.65-rt91:

---


Steven Rostedt (2):
      acpi/rt: Convert acpi_gbl_hardware lock back to a raw_spinlock_t
      Linux 3.0.65-rt92-rc1

Thomas Gleixner (2):
      x86/32: Use kmap switch for non highmem as well
      rcutiny: Use simple waitqueue

----
 arch/x86/kernel/process_32.c    |    2 +-
 drivers/acpi/acpica/acglobal.h  |    2 +-
 drivers/acpi/acpica/hwregs.c    |    4 ++--
 drivers/acpi/acpica/hwxface.c   |    4 ++--
 drivers/acpi/acpica/utmutex.c   |    4 ++--
 include/acpi/platform/aclinux.h |   14 ++++++++++++++
 include/linux/sched.h           |    4 +++-
 kernel/rcutiny_plugin.h         |    9 +++++----
 localversion-rt                 |    2 +-
 9 files changed, 31 insertions(+), 14 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRIw4CAAoJEOdOSU1xswtMREkH+gOdLaab7PjC1NJHuGZuEkLX
BITkwm1rdlD9HYAmcO46DpWuvPaYDncw0wzhlXb8zi/vwaDUpkO7p8u2RzCn/+sQ
v2NXBRfvsR4u19wMJ6N2j1TuaWQSU4K8N2PPPZLz5B9zhebGaWMZvzZbbFs8ml/Z
6clyYQrME9uDDerODcwo+W2uFQ7BXT0JVu2If2E1XmzDjVbQLngt1xg6oiabmcbZ
SJi22n5wTAMGAS2bgRqpLaw3SjoB1lll6CyYt2UC2+XMy+2TTCILDxVYK4YBacIn
6rYWeEc82XYCb7H5XsQJGOgX8ud3r20Qxs3KePVWxTa+vmmpDm7v+zgoY+uc36A=
=Jfo0
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
