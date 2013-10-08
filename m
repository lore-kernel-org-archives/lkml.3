Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3JHNit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:38:49 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:58643 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3JHNir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:38:47 -0400
Message-ID: <52540AE2.4060909@monstr.eu>
Date: Tue, 08 Oct 2013 15:38:42 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        viro@zeniv.linux.org.uk, vgupta@synopsys.com, catalin.marinas@arm.com,
        will.deacon@arm.com, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        vapier@gentoo.org, msalter@redhat.com, a-jacquiot@ti.com,
        starvik@axis.com, jesper.nilsson@axis.com, dhowells@redhat.com,
        rkuo@codeaurora.org, tony.luck@intel.com, fenghua.yu@intel.com,
        takata@linux-m32r.org, geert@linux-m68k.org, james.hogan@imgtec.com,
        yasutake.koichi@jp.panasonic.com, ralf@linux-mips.org,
        jonas@southpole.se, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, liqin.linux@gmail.com, lennox.wu@gmail.com,
        lethal@linux-sh.org, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        linux-xtensa@linux-xtensa.org, akpm@linux-foundation.org,
        oleg@redhat.com, tj@kernel.org
Subject: Re: Global do_signal() cleanup
References: <1381231701-4008-1-git-send-email-richard@nod.at>
In-Reply-To: <1381231701-4008-1-git-send-email-richard@nod.at>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="SA5Ph8vhsBrP3AmTBk0tM9TO97CenAh6r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SA5Ph8vhsBrP3AmTBk0tM9TO97CenAh6r
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/08/2013 01:27 PM, Richard Weinberger wrote:
> This patch series moves all remaining archs to the get_signal() and
> signal_setup_done() functions. Currently these archs use open coded
> variants of the said functions.  Further, unused parameters get removed=

> from get_signal_to_deliver(), tracehook_signal_handler() and signal_del=
ivered().
> After all we save around 350 lines of code. :-)
>=20
> The following archs are _untested_: arc, c6x, hexagon, metag, score, un=
icore, sh64.
> If someone points me to cross compilers for these arch I'll happily bui=
ld test them too.

Any link to the repo and branch with all these patches will be helpful.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--SA5Ph8vhsBrP3AmTBk0tM9TO97CenAh6r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJUCuIACgkQykllyylKDCFhZQCfesCBcVTG2rR0YU4ExRYPyNx4
IiIAnjMtbaaFcCxhGCL9QcNgfUlE9bba
=SREd
-----END PGP SIGNATURE-----

--SA5Ph8vhsBrP3AmTBk0tM9TO97CenAh6r--
