Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbaBUQEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:04:32 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62971 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbaBUQEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:04:30 -0500
Message-ID: <5307790A.4050806@monstr.eu>
Date: Fri, 21 Feb 2014 17:04:26 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: balbi@ti.com,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH RFC] usb: gadget: Add xilinx axi usb2 device support
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local> <20140220182257.GF23217@saruman.home> <5306F458.9010706@monstr.eu> <20140221160442.GA17506@kroah.com>
In-Reply-To: <20140221160442.GA17506@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="NFBtoLn9bBvstbEFMJBCl4OhE42XGNsJJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NFBtoLn9bBvstbEFMJBCl4OhE42XGNsJJ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/21/2014 05:04 PM, Greg Kroah-Hartman wrote:
> On Fri, Feb 21, 2014 at 07:38:16AM +0100, Michal Simek wrote:
>> BTW: u-boot started to use SPDX-License-Identifier
>> which will be nice to start to use.
>=20
> I agree, feel free to start sending patches to use this type of
> identifier for drivers.

But we probably need to add that Licenses to one location.
Documentation/Licenses?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--NFBtoLn9bBvstbEFMJBCl4OhE42XGNsJJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMHeQoACgkQykllyylKDCE0VgCeMlf17c37nXT/49QH6B5RjTZj
//EAn2Al4c1nttfUka6upstB+VbMysl5
=kwZC
-----END PGP SIGNATURE-----

--NFBtoLn9bBvstbEFMJBCl4OhE42XGNsJJ--
