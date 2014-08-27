Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935992AbaH0VwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:52:09 -0400
Received: from ozlabs.org ([103.22.144.67]:50684 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246AbaH0VwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:52:07 -0400
Date: Thu, 28 Aug 2014 07:49:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH percpu/for-3.18-consistent-ops] Revert "powerpc: Replace
 __get_cpu_var uses"
Message-ID: <20140828074937.47020590@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.11.1408271055030.17080@gentwo.org>
References: <20140827142243.6277eaff@canb.auug.org.au>
	<20140827152609.GA379@htj.dyndns.org>
	<alpine.DEB.2.11.1408271055030.17080@gentwo.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/6LbnKcWnXvg9yC_aXB7Bscb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6LbnKcWnXvg9yC_aXB7Bscb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Wed, 27 Aug 2014 10:56:27 -0500 (CDT) Christoph Lameter <cl@linux.com> w=
rote:
>
> On Wed, 27 Aug 2014, Tejun Heo wrote:
>=20
> > Chrisoph, let's route the updated patch through powerpc tree.
>=20
> Ok. Once I figure out what went wrong. This went through Feng's build
> system and I though he did a powerpc build. So it must be a difference
> configuration on powerpc.

Were the patches tested on top of v3.17-rc1?  My build was a powerpc
ppc64_defconfig.  It is possible that some other change interacted with
this, but there are not many other arch/powerpc changes after v3.17-rc1
and none seem obvious.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/6LbnKcWnXvg9yC_aXB7Bscb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT/lJ2AAoJEMDTa8Ir7ZwVh2sP/3SjFwo9P87mUYZBVwXr2gTQ
8i+1xBTtvNzAoPMLBgjNvZTLrohKMDRpHMtFW9TtUDZBlH+PmKxWl6BDpG93C6JY
szXJEDjs+ASLgV3j3q4lnebnHNVvztODGqyEf+QrgxVRMOJOmaH79fCdMI11SRN2
yyCx1Rxx4LAeGFMu637tngyD8wbGa7DCujNqdPP8CImvoIJUPrJFY6EqcZB1itzW
jXPNMCnuBBuD94dob5mIFgfWB7ZJHh54Dlo29oQ8M2rOkPVHqONcPpuRhUicYyAB
BsT+0GZsTN4rL9kWW54LMonboXlUEIUVkiH1YXX62/+DxuZuAorURer5QzEBTiif
sYIk3wAJzvz9QsgPU05sYtTG41KW4+NbKaVAg98klL0BXZK1lBN8842ALuQRnS2g
cHSkE+mF+3EIpSr4WhdXI3lbMv6CIiNapATOv1kLYrk/ebSNxFSqDiKiTAzZ2W1l
AlgdrzreDi424938GrzYQJi/qL401D9Ya6Kmnq+3IyXCPigUTBQSj5Fcj2y29se+
tMck0oMLGIJo+UYfKNT88eVTc3I8CpSJc9I7aRDQ/mNxNj0hsKaT/HlX2wtxy0Pk
sJCvst3K9TWqi4N5CtJpUV2KJICn5AwkD1WAoV9vRRhPYLacw2bOq8XVvba4fzAh
ezI6oUq2nMMXxz+4ZS9D
=//yM
-----END PGP SIGNATURE-----

--Sig_/6LbnKcWnXvg9yC_aXB7Bscb--
