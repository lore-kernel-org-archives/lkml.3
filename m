Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966495Ab3HHUPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:15:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51909 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966472Ab3HHUOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:14:25 -0400
Message-ID: <1375992837.2853.78.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] linux-firmware/AMD: add readme files for amd-ucode
From: Ben Hutchings <ben@decadent.org.uk>
To: Sherry Hurwitz <sherry.hurwitz@amd.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Thu, 08 Aug 2013 22:13:57 +0200
In-Reply-To: <1374273832-5228-1-git-send-email-sherry.hurwitz@amd.com>
References: <1374273832-5228-1-git-send-email-sherry.hurwitz@amd.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-pByiP7KpdktdGvgtpOOg"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 80.83.48.229
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pByiP7KpdktdGvgtpOOg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I don't think this documentation is currently very useful.  See further
comments inline:

On Fri, 2013-07-19 at 17:43 -0500, Sherry Hurwitz wrote:
> File: README
> File: microcode_amd.bin.README
> File: microcode_amd_fam15h.bin.README
>=20
> Signed-off-by: Sherry Hurwitz <sherry.hurwitz@amd.com>
> ---
>  amd-ucode/README                          |   46 +++++++++++++++++++++++=
++++++
>  amd-ucode/microcode_amd.bin.README        |   29 ++++++++++++++++++
>  amd-ucode/microcode_amd_fam15h.bin.README |   13 ++++++++
>  3 files changed, 88 insertions(+)
>  create mode 100644 amd-ucode/README
>  create mode 100644 amd-ucode/microcode_amd.bin.README
>  create mode 100644 amd-ucode/microcode_amd_fam15h.bin.README
>=20
> diff --git a/amd-ucode/README b/amd-ucode/README
> new file mode 100644
> index 0000000..a92831d
> --- /dev/null
> +++ b/amd-ucode/README
> @@ -0,0 +1,46 @@
> +This package provides latest microcode patches
> +for AMD processor families >=3D 0x10.
> +
> +See http://www.amd64.org/support/microcode.html
> +for details.

As Marc Dietrich pointed out, this URL is currently broken.

> +Microcode patches are included in container files:
> +- 'microcode_amd.bin' (for AMD CPU families 10h - 14h)
> +- 'microcode_amd_fam15h.bin' (for AMD CPU family 15h)
> +
> +Please read the file INSTALL for install instructions.
> +Please read the file LICENSE for licensing information.

These aren't the filenames used in linux-firmware.git.

> +The container files include following microcode patches:
> +
> +    mc_patch_01000083_PUB-v4/mc_patch_01000083.asm
> +    mc_patch_01000084_PUB-v4/mc_patch_01000084.asm
> +    mc_patch_010000C7_PUB-v1/mc_patch_010000C7.asm
> +    mc_patch_010000C8_PUB-v1/mc_patch_010000C8.asm
> +    mc_patch_010000D9_PUB-v1/mc_patch_010000D9.asm
> +    mc_patch_010000DA_PUB-v1/mc_patch_010000DA.asm
> +    mc_patch_010000DB_PUB-v1/mc_patch_010000DB.asm
> +    mc_patch_010000DC_PUB-v1/mc_patch_010000DC.asm
> +    mc_patch_02000032_PUB-v3/mc_patch_02000032.asm
> +    mc_patch_03000027_PUB-v1/mc_patch_03000027.asm
> +    mc_patch_05000029_PUB-v1/mc_patch_05000029.asm
> +    mc_patch_05000119_PUB-v1/mc_patch_05000119.asm
> +    mc_patch_0600063D_PUB-v1/mc_patch_0600063D.asm
> +    mc_patch_06000822_PUB-v1/mc_patch_06000822.asm
> +    mc_patch_06001119_PUB-v2/mc_patch_06001119.asm

Are these filenames supposed to be meaningful?  Are they referenced by
some other documentation?

> +***********************************************************************
> +Copyright 2008-2013 ADVANCED MICRO DEVICES, INC.  All Rights Reserved.
> +
> +AMD is granting you permission to use this software and documentation
> +(if any) (collectively, the =E2=80=9CMaterials=E2=80=9D) pursuant to the=
 terms and
> +conditions of the Software License Agreement included with the
> +Materials.  This header does NOT give you permission to use the
> +Materials or any rights under AMD=E2=80=99s intellectual property.  Your=
 use
> +of any portion of these Materials shall constitute your acceptance of
> +those terms and conditions.  If you do not agree to the terms and
> +conditions of the Software License Agreement, you do not have
> +permission to use any portion of these Materials.  If you do not have
> +a copy of the Software License Agreement, contact your AMD
> +representative for a copy.
> +

Isn't this redundant with LICENSE.amd-ucode?

> diff --git a/amd-ucode/microcode_amd.bin.README b/amd-ucode/microcode_amd=
.bin.README
> new file mode 100644
> index 0000000..617d951
> --- /dev/null
> +++ b/amd-ucode/microcode_amd.bin.README
> @@ -0,0 +1,29 @@
> +;***********************************************************************=
*******
> +; The associated microcode container file fixes the errata as documented=
 in
> +; Revision Guide for AMD Family 10h Processors, order #41322,
> +; Revision Guide for AMD Family 11h Processors, order #41788,
> +; Revision Guide for AMD Family 12h Processors, order #44739,
> +; Revision Guide for AMD Family 14h Models 00h-0Fh Processors, order #47=
534,

Where can these be found?  (I found *some* revision guides with a web
search, but nothing with errata numbers above 400.)

> +; for different revisions of AMD processors as follows:
> +;=20
> +; CPUIDFn[0000_0001]_EAX; ID;         Errata fixed;
> +;
> +; 0x00100F22;             0x01000083; 244, 260, 280, 302, 308, 315, 342;
> +; 0x00100F23;             0x01000083; 244, 260, 280, 302, 308, 315, 342;
> +; 0x00100F2A;             0x01000084; 244, 260, 280, 302, 308, 315, 342;
> +; 0x00100F42;             0x010000DB; 342, 440, 573;
> +; 0x00100F43;             0x010000C8; 407, 440;
> +; 0x00100F52;             0x010000DB; 342, 440, 573;
> +; 0x00100F53;             0x010000C8; 407, 440;
> +; 0x00100F62;             0x010000C7; 407, 440;
> +; 0x00100F63;             0x010000C8; 407, 440;
> +; 0x00100F80;             0x010000DA; 419, 440, 573;
> +; 0x00100F81;             0x010000D9; #406, #407, #440, #573, #669;
> +; 0x00100F91;             0x010000D9; #406, #407, #440, #573, #669;
> +; 0x00100FA0;             0x010000DC; 438, 440, 573;
> +; 0x00200F31;             0x02000032; 311, 316;
> +; 0x00300F10;             0x03000027; #564, #573, #662, #686;
> +; 0x00500F10;             0x05000029; #461, #564, #594, #595, #784;
> +; 0x00500F20;             0x05000119; #461, #564, #594, #639, #662, #686=
, #784;
> +;***********************************************************************=
*******

Presumably when I see this in /proc/cpuinfo:

cpu family      : 16
model           : 6
model name      : AMD Turion(tm) II Neo N54L Dual-Core Processor
stepping        : 3
microcode       : 0x10000c8

this means the relevant line is:

> +; 0x00100F43;             0x010000C8; 407, 440;
[...]

But can you make the documentation explicit about how to look this up
based on the information Linux provides?

Ben.

--=20
Ben Hutchings
The two most common things in the universe are hydrogen and stupidity.

--=-pByiP7KpdktdGvgtpOOg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUgP8Bee/yOyVhhEJAQq4Mw/8DmlTOFOvgGsiaJEC7Ynt7ibtqVQ4V34W
BudGrelIuP3wVDkBokvdh1GrKE8/BYw2QMKzqYOKS3zy9yc7ZhPkTul9niBmW5Nv
3uZLb717Oao7WtqzjzbXVKZO1rsp8b4TlOlnzLrF/lHtGyly47ki1407LdJv3f3z
dhgY6ZZP5TunPMHb19ulyD5CMC3PAGYVKy7zDGn2eUX88Jlu7Pe/629BczklRI/E
zr9EoY5nOilpi/hqsFtxshy17l+ApmhISYhrdpSEz5/70Z5j3k65FMTL9gqShZ1o
iAKwsKqlKmoC9wR9zizgqjQGtcQ9HX0jM/iwq3YRfygOmlnsr2XtZCVEUwqY2A+Z
CvBHsJv5cDLBsOXUHkomx2PNwIrfYfZQ+67juzZEEBt80j6vSpLgqC3o0RhjQafX
fWOABkfMusMRQF/+ETUzw1Gez96X5lhvvDOLTj+QymTj3ufpa1ULqVb3MK7pDAGv
1D4hQX9reArKL90ZnowC/SaoEpVe/fCW3HHcOoNyER6C/cvQT1P4RHhVMsf1A1o4
GoiOymfqt0HAUXoOAlbfFSzxpdKf5bmNyr8awi65XkE2ApTe1+b8Ox8xVwxaTxaO
g+VpNSf5tXK4hEX30cjLUWKXlrE+oahZnwh7XYweyW1JHr8qwjF+Gr9VvVyaITNo
KoonEMizmYM=
=TCXM
-----END PGP SIGNATURE-----

--=-pByiP7KpdktdGvgtpOOg--
