Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbaAWOt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:49:58 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:47346 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaAWOt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:49:57 -0500
Message-ID: <52E12C11.4090008@monstr.eu>
Date: Thu, 23 Jan 2014 15:49:53 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] tty: uartps: Initialize ports according to aliases
References: <c1882ea5f2e45b19cc1930b624254cb1b59b2fe0.1390488303.git.michal.simek@xilinx.com>
In-Reply-To: <c1882ea5f2e45b19cc1930b624254cb1b59b2fe0.1390488303.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="udadgKURhCcQeKGE52NmVSj188lsgXU76"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--udadgKURhCcQeKGE52NmVSj188lsgXU76
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/23/2014 03:45 PM, Michal Simek wrote:
> Register port numbers according to order in DT aliases.
> If aliases are not defined, order in DT is used.
> If aliases are defined, register port id based
> on that.
> This patch ensures proper ttyPS0/1 assignment.
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---

oou - Ignore this version - will send v2.

Sorry,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--udadgKURhCcQeKGE52NmVSj188lsgXU76
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLhLBEACgkQykllyylKDCEJ5QCfduCqJCBtG/4F9P4Fm8TGH5vg
RTAAnRX0YL5/eYgCTa7r1fcXFrJbWfiK
=47Jj
-----END PGP SIGNATURE-----

--udadgKURhCcQeKGE52NmVSj188lsgXU76--
