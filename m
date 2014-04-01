Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaDAN1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:27:06 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:64520 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaDAN1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:27:00 -0400
Message-ID: <533ABEA1.8030603@monstr.eu>
Date: Tue, 01 Apr 2014 15:26:57 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tim Sander <tim@krieglstein.org>
CC: "linux-arm@lists.infradead.org" <linux-arm@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: FIQ on xilinx cortex a9 zynq
References: <8605883.1pbkKagGpT@dabox>
In-Reply-To: <8605883.1pbkKagGpT@dabox>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="J6JrBRscfmxtmw8MTnCFKM1ih4gjMBQBw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J6JrBRscfmxtmw8MTnCFKM1ih4gjMBQBw
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Tim,

On 02/28/2014 05:53 PM, Tim Sander wrote:
> Hi
>=20
> I am currently trying to get the FIQ interrupt working with linux. I wa=
nt to
> have the FIQ to have an interrupt which is not masked by linux and give=
s the
> lowest irq latencys the hardware can deliver.=20
>=20
> In the case of the xilinx zynx i have seen that the ICCICR register ena=
bles
> the FIQ via the fittingly named config bit FiqEn. Enabling this bit "as=
 is" does
> not seem to work as the kernel works in secure mode and thus all interr=
upts
> delivered suddenly are delivered in FIQ context which is obviously not =
a good
> idea.

yes. I don't know why but Linux on Zynq in secure mode.
As I mentioned in u-boot thread there is secure monitor available
here https://github.com/serngawy/OpenVirtualization
where Linux is switched to non-secure mode.
Unfortunately this secure monitor is not done in nice way
but at least it proved that Linux can run in non secure mode.

Regarding GIC setup here should be experts to tell you how to do it.
If you need some help to get Linux running on Zynq in non secure mode
please ping me we can look at it. I tried it some months ago.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--J6JrBRscfmxtmw8MTnCFKM1ih4gjMBQBw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM6vqEACgkQykllyylKDCHjrACfRZUOeBp6YgzRPywmQbX9OBLz
HzsAn3jtbz0+djyM2iO964CgREgPMqLE
=EzEe
-----END PGP SIGNATURE-----

--J6JrBRscfmxtmw8MTnCFKM1ih4gjMBQBw--
