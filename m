Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3FDIrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:47:05 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53828 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3FDIq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:46:59 -0400
Message-ID: <51ADA97F.2010308@monstr.eu>
Date: Tue, 04 Jun 2013 10:46:55 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: monstr@monstr.eu, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] net: emaclite: include linux/of_irq.h
References: <2244203.EL457oABTU@wuerfel> <51ADA36D.7070607@monstr.eu> <2240834.ApHHSrFxQG@wuerfel>
In-Reply-To: <2240834.ApHHSrFxQG@wuerfel>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2FHDRMAWBXMTGTGBFVAMI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2FHDRMAWBXMTGTGBFVAMI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/04/2013 10:44 AM, Arnd Bergmann wrote:
> On Tuesday 04 June 2013 10:21:01 Michal Simek wrote:
>> On 06/03/2013 11:39 PM, Arnd Bergmann wrote:
>>> The emaclite driver now calls of_irq_to_resource, which is
>>> declared in linux/of_irq.h. Without this patch, I get a build
>>> error on ARM.
>>
>> What about to just change it to use platform_get_resource()?
>> I will test it.
>=20
> Yes, that would work too. It seems the driver predates the automatic
> generation of resources for IRQs and MMIO registers.
>=20
> If you change the IRQ resource to platform_get_resource, you should
> change the other one as well.

Yep. I have done that changes. Let me test them on real hw
and I will send them soon.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2FHDRMAWBXMTGTGBFVAMI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGtqX8ACgkQykllyylKDCEpbQCgizJAW3/LhmgEJ1mBp7478dN5
XaYAn23hcWq6XvgUkcczWYvXpYolP+t2
=PsTY
-----END PGP SIGNATURE-----

------enig2FHDRMAWBXMTGTGBFVAMI--
