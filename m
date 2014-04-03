Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaDCPZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:25:18 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51319 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbaDCPZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:25:12 -0400
Message-ID: <533D7D53.80301@monstr.eu>
Date: Thu, 03 Apr 2014 17:25:07 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        dougthompson@xmission.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        michal.simek@xilinx.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, kpc528@gmail.com,
        kalluripunnaiahchoudary@gmail.com, punnaia@xilinx.com,
        Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH] edac: add support for ARM PL310 L2 cache parity
References: <1393770760-32550-1-git-send-email-punnaia@xilinx.com> <a1a9e47a-069c-4285-9899-d5a58cf532c2@CO9EHSMHS003.ehs.local> <533D7806.8070002@monstr.eu> <20140403152425.GH9616@pd.tnic>
In-Reply-To: <20140403152425.GH9616@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="95U8XeOrD7Ta3uBGChsef1kILHeIAM7Ci"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--95U8XeOrD7Ta3uBGChsef1kILHeIAM7Ci
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/03/2014 05:24 PM, Borislav Petkov wrote:
> On Thu, Apr 03, 2014 at 05:02:30PM +0200, Michal Simek wrote:
>> Any comment about this driver?
>=20
> It is all on the TODO list. I'll take a look after the merge window
> closes.

Ok. Thank you,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--95U8XeOrD7Ta3uBGChsef1kILHeIAM7Ci
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM9fVMACgkQykllyylKDCHQugCcDByygIyqIadBFJ95SEgasKBp
1jcAoIaZVy199rYYAuEwel1SPq75+hsa
=F9wx
-----END PGP SIGNATURE-----

--95U8XeOrD7Ta3uBGChsef1kILHeIAM7Ci--
