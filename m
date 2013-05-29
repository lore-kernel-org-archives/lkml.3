Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965880Ab3E2LYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:24:52 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:41562 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965798Ab3E2LYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:24:50 -0400
Date: Wed, 29 May 2013 13:24:46 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: airlied@linux.ie, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, tbergstrom@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/7] Miscellaneous fixes to host1x
Message-ID: <20130529112444.GA18195@mithrandir>
References: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 29, 2013 at 01:26:01PM +0300, Arto Merilainen wrote:
> This patch series fixes two issues in the host1x driver: First, the
> command buffer validation routine had vulnerabilities that were not
> detected in earlier testing. Second, the return codes of some
> functions were misleading or completely missing. This caused the
> driver to give wrong return codes also to the userspace.
>=20
> The series is based on top of 3.10rc3. I have tested the patch series
> on cardhu by running host1x and gr2d test cases (available at [0]).
> I would appreciate any help in testing/reviewing these patches.
>=20
> Changes from v1:
>  * Rebased on top of 3.10rc3
>  * Split firewall fixes to smaller patches
>  * Reworked no-reloc case in firewall code. Fix in v1 was not
>    sufficient in all cases
>  * Dropped patch "Fix syncpoint wait return value" as it is not
>    critical and discussion on it has not yet settled.
>  * Fixed style and whitespace issues
>=20
> [0] https://gitorious.org/linux-host1x/libdrm-host1x
>=20
> Arto Merilainen (5):
>   gpu: host1x: Check reloc table before usage
>   gpu: host1x: Copy gathers before verification
>   gpu: host1x: Fix memory access in syncpt request
>   gpu: host1x: Fix client_managed type
>   gpu: host1x: Rework CPU syncpoint increment
>=20
> Terje Bergstrom (2):
>   gpu: host1x: Check INCR opcode correctly
>   gpu: host1x: Don't reset firewall between gathers
>=20
>  drivers/gpu/host1x/dev.h          |   8 +--
>  drivers/gpu/host1x/drm/drm.c      |   3 +-
>  drivers/gpu/host1x/drm/gr2d.c     |   2 +-
>  drivers/gpu/host1x/hw/cdma_hw.c   |   2 +-
>  drivers/gpu/host1x/hw/syncpt_hw.c |  12 ++--
>  drivers/gpu/host1x/job.c          | 135 +++++++++++++++++---------------=
------
>  drivers/gpu/host1x/syncpt.c       |  26 +++-----
>  drivers/gpu/host1x/syncpt.h       |  13 ++--
>  8 files changed, 85 insertions(+), 116 deletions(-)

Applied, thanks.

Thierry

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRpeV8AAoJEN0jrNd/PrOhxAUP/3PVv4UAt3ZQ0rGwL1Tnh1uX
9pUclkVHrj7dWx3v4gZAXPlhC3CrEstrU9hU081Xu9YCi1gN8zBCTy/h+rTYKRN3
MSIAhDQhPd+UtDJRyikjYfar195/9h0Z22SGmLklqj9pDUJGVeZC/0fqahZvTq3l
/J+1HFfjAmMq2LWHpBRcRLjpSqNIa53AFKQp9gk2muW6ztEtAabpyHT7spFTuNIj
beKfzPFUvw4SOzv12ECwwEKT3+Mkz1PN5qo162woPcgwmHIVFV6iJv2VgSWdapHt
Gz5H1Yv3F7+6AsYmCUTNnZWHgHWS/ssJiCmhQLAZlYg/Se7Ly1iqAz/f+6pwXFsh
o3yGlFwRXfqVTuzSrGkSXTXIW3fM5+8J8q4Atogo4yYBCUhBMUbZZqXyTwabXbnr
4iqjjMHdB5ViAtTEDk8yJF60wNT8dV47G0aKDxS5JD1XJrMI1j2d+G56NYYCwA7v
0ML94yKVRcUJdFxsuGZgLIZNgTbB3fdwvLN9lCguDfPeWfXnwRaW4vB2hf6Q8Otw
xstgt5ONuK3tShe+34mTs4VMg29Ue7vft50hWqLTeFUUAC3HzX7wLXFGDfongStW
C7FXK54idO2MVKmFkACoh/u4P32sLYJc1b66xcqmRJj7W2w4A89QmIztvmw8D/Y7
Yyb8zlReeSP/EbBt23Yi
=A2fB
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
