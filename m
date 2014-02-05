Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaBEJl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:41:27 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33506 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaBEJlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:41:24 -0500
Message-ID: <52F20732.6070209@monstr.eu>
Date: Wed, 05 Feb 2014 10:41:06 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, monstr@monstr.eu,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-doc@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 09/10] watchdog: xilinx: Add missing binding
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <201402042027.15898.arnd@arndb.de> <52F20387.3090709@monstr.eu> <201402051036.19428.arnd@arndb.de>
In-Reply-To: <201402051036.19428.arnd@arndb.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="iV47Pw35bIR3Xv1MleWW58p6Q7CUJFdhR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iV47Pw35bIR3Xv1MleWW58p6Q7CUJFdhR
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 02/05/2014 10:36 AM, Arnd Bergmann wrote:
> On Wednesday 05 February 2014, Michal Simek wrote:
>> I am not quite sure what you mean by reports to user space.
>> If you mean to get timeout through ioctl for example - then yes it is =
working
>> through standard watchdog ioctl interface and timeout is calculated
>> from hardware setup.
>=20
> Yes, that is what I meant. I believe most other watchdogs let
> you program the timeout, but I don't see anything wrong with
> having that fixed in the FPGA in your case.
>=20
> Still, the choice of putting the timeout into DT in terms of
> cycles rather than miliseconds wasn't ideal from an interface
> perspective and we should change that if/when we do a generic
> binding. I can definitely see where it's coming from for your
> case, as the cycle count totally makes sense from an FPGA
> tool perspective...

Thanks. I take this like ACK for this current binding description.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--iV47Pw35bIR3Xv1MleWW58p6Q7CUJFdhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLyBzIACgkQykllyylKDCEXeQCglyMKvS5UGY3Hse+7jfXrpCSH
U94AmQHYUc38A/inV4GSGGu2HkCwZMtF
=DWv1
-----END PGP SIGNATURE-----

--iV47Pw35bIR3Xv1MleWW58p6Q7CUJFdhR--
