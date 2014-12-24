Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaLXSvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 13:51:54 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48060 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaLXSvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 13:51:52 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Subject: 3.19-rc1 errors when opening LID
Date: Wed, 24 Dec 2014 19:51:48 +0100
User-Agent: KMail/1.13.7 (Linux/3.19.0-031900rc1-generic; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5943893.pKyMBm5Emp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412241951.48652@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5943893.pKyMBm5Emp
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello!

With new 3.19-rc1 kernel every time when I open LID on my laptop, kernel pr=
ints these error lines to dmesg:

[25566.368133] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the i915.mmio_debug=3D1 to debug this prob=
lem.
[25566.368134] [drm:intel_uncore_check_errors [i915]] *ERROR* Unclaimed reg=
ister before interrupt
[25566.368192] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the i915.mmio_debug=3D1 to debug this prob=
lem.
[25566.368232] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
ed register detected. Please use the i915.mmio_debug=3D1 to debug this prob=
lem.<4>[25568.446011] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]=
=20
has bogus alignment
[25568.447018] pci_bus 0000:02: Allocating resources
[25568.447055] pci_bus 0000:03: Allocating resources
[25568.447135] pci_bus 0000:04: Allocating resources
[25568.447168] pci_bus 0000:05: Allocating resources
[25568.447195] pci_bus 0000:06: Allocating resources
[25568.447228] pci_bus 0000:0e: Allocating resources
[25568.447323] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
us alignment
[25568.447557] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
us alignment
[25568.447735] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
us alignment
[25568.447847] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
us alignment
[25568.448399] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
us alignment
[25568.448438] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
us alignment
[25568.448566] acpi MSFT1111:00: Cannot transition to power state D3cold fo=
r parent in (unknown)
[25568.448572] acpi INT33C2:00: Cannot transition to non-D0 state from D3
[25568.448577] acpi MSFT0002:00: Cannot transition to power state D3cold fo=
r parent in (unknown)
[25568.448581] acpi ELAN1010:00: Cannot transition to power state D3cold fo=
r parent in (unknown)
[25568.448587] acpi INT33C3:00: Cannot transition to non-D0 state from D3
[25568.448590] acpi INT33C0:00: Cannot transition to non-D0 state from D3
[25568.448594] acpi INT33C1:00: Cannot transition to non-D0 state from D3
[25568.448598] acpi INT33C4:00: Cannot transition to non-D0 state from D3
[25568.448602] acpi INT33C5:00: Cannot transition to non-D0 state from D3
[25568.448623] acpi device:41: Cannot transition to power state D3cold for =
parent in (unknown)
[25568.448627] acpi INT33C6:00: Cannot transition to non-D0 state from D3
[25568.448890] pci_bus 0000:01: Allocating resources
[25568.448905] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
us alignment
[25568.449064] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
us alignment
[25568.449472] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
us alignment

With older kernel (3.13) I do not see these errors, so it is regression. Ca=
n you look at it? If it is needed, I can provide other logs, ACPI/DSTD dump=
s, etc.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart5943893.pKyMBm5Emp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSbC0QACgkQi/DJPQPkQ1L9KACgzMwbQF94zSRALCAR+HrQfdYB
zTwAnRpeZ4/yZhjkv9C1K49F3qrRXRw7
=5Mtp
-----END PGP SIGNATURE-----

--nextPart5943893.pKyMBm5Emp--
