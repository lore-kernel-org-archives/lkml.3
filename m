Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaLYIsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 03:48:45 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60183 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaLYIsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 03:48:43 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: nick <xerofoify@gmail.com>
Subject: Re: [Intel-gfx] 3.19-rc1 errors when opening LID
Date: Thu, 25 Dec 2014 09:48:38 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
References: <201412241951.48652@pali> <549B926B.1050000@gmail.com>
In-Reply-To: <549B926B.1050000@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2668000.RjPbr6p80n";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412250948.38808@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2668000.RjPbr6p80n
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I know how to use git... first I wanted to report errors because=20
maybe it could be known problem or somebody else can come with=20
quick patch even without bisetcing (like for other problems which=20
I reported).

Anyway those acpi devices which are mentioned in log do not exist=20
in 3.13 kernel (I do not see them in /sys/devices)

Any idea why 3.19 kernel create new acpi devices which 3.13=20
kernel did not?

On Thursday 25 December 2014 05:28:27 nick wrote:
> Pali,
> Do you known how to run git bisect as this is probably the
> best way to continue. Otherwise, I can teach you how it's not
> hard if your willing to learn :). Cheers Nick
>=20
> On 2014-12-24 01:51 PM, Pali Roh=C3=A1r wrote:
> > Hello!
> >=20
> > With new 3.19-rc1 kernel every time when I open LID on my
> > laptop, kernel prints these error lines to dmesg:
> >=20
> > [25566.368133] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]]
> > *ERROR* Unclaimed register detected. Please use the
> > i915.mmio_debug=3D1 to debug this problem. [25566.368134]
> > [drm:intel_uncore_check_errors [i915]] *ERROR* Unclaimed
> > register before interrupt [25566.368192]
> > [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR*
> > Unclaimed register detected. Please use the
> > i915.mmio_debug=3D1 to debug this problem. [25566.368232]
> > [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR*
> > Unclaimed register detected. Please use the
> > i915.mmio_debug=3D1 to debug this problem.<4>[25568.446011]
> > i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has
> > bogus alignment
> > [25568.447018] pci_bus 0000:02: Allocating resources
> > [25568.447055] pci_bus 0000:03: Allocating resources
> > [25568.447135] pci_bus 0000:04: Allocating resources
> > [25568.447168] pci_bus 0000:05: Allocating resources
> > [25568.447195] pci_bus 0000:06: Allocating resources
> > [25568.447228] pci_bus 0000:0e: Allocating resources
> > [25568.447323] i915 0000:00:02.0: BAR 6: [??? 0x00000000
> > flags 0x2] has bogus alignment [25568.447557] i915
> > 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus
> > alignment [25568.447735] i915 0000:00:02.0: BAR 6: [???
> > 0x00000000 flags 0x2] has bogus alignment [25568.447847]
> > i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has
> > bogus alignment [25568.448399] i915 0000:00:02.0: BAR 6:
> > [??? 0x00000000 flags 0x2] has bogus alignment
> > [25568.448438] i915 0000:00:02.0: BAR 6: [??? 0x00000000
> > flags 0x2] has bogus alignment [25568.448566] acpi
> > MSFT1111:00: Cannot transition to power state D3cold for
> > parent in (unknown) [25568.448572] acpi INT33C2:00: Cannot
> > transition to non-D0 state from D3 [25568.448577] acpi
> > MSFT0002:00: Cannot transition to power state D3cold for
> > parent in (unknown) [25568.448581] acpi ELAN1010:00: Cannot
> > transition to power state D3cold for parent in (unknown)
> > [25568.448587] acpi INT33C3:00: Cannot transition to non-D0
> > state from D3 [25568.448590] acpi INT33C0:00: Cannot
> > transition to non-D0 state from D3 [25568.448594] acpi
> > INT33C1:00: Cannot transition to non-D0 state from D3
> > [25568.448598] acpi INT33C4:00: Cannot transition to non-D0
> > state from D3 [25568.448602] acpi INT33C5:00: Cannot
> > transition to non-D0 state from D3 [25568.448623] acpi
> > device:41: Cannot transition to power state D3cold for
> > parent in (unknown) [25568.448627] acpi INT33C6:00: Cannot
> > transition to non-D0 state from D3 [25568.448890] pci_bus
> > 0000:01: Allocating resources [25568.448905] i915
> > 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus
> > alignment [25568.449064] i915 0000:00:02.0: BAR 6: [???
> > 0x00000000 flags 0x2] has bogus alignment [25568.449472]
> > i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has
> > bogus alignment
> >=20
> > With older kernel (3.13) I do not see these errors, so it is
> > regression. Can you look at it? If it is needed, I can
> > provide other logs, ACPI/DSTD dumps, etc.
> >=20
> >=20
> >=20
> > _______________________________________________
> > Intel-gfx mailing list
> > Intel-gfx@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/intel-gfx

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2668000.RjPbr6p80n
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSbz2YACgkQi/DJPQPkQ1LTBACffymKs/mb3MVgVqL7fu6Sl1dR
apQAniQ+/nK1we981m/9b4jwjFfBWo7Q
=uIZ1
-----END PGP SIGNATURE-----

--nextPart2668000.RjPbr6p80n--
