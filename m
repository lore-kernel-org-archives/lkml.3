Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3FTFXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:23:39 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:47349 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab3FTFXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:23:37 -0400
Message-ID: <51C291D0.6000401@monstr.eu>
Date: Thu, 20 Jun 2013 07:23:28 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 0/2] Extend multi_v7_defconfig
References: <1371664384-24974-1-git-send-email-soren.brinkmann@xilinx.com> <201306192046.41005.arnd@arndb.de>
In-Reply-To: <201306192046.41005.arnd@arndb.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2RFCOLWGWLGWNQKCPPEOB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2RFCOLWGWLGWNQKCPPEOB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/19/2013 08:46 PM, Arnd Bergmann wrote:
> On Wednesday 19 June 2013, Soren Brinkmann wrote:
>> I don't know how much a defconfig is supposed to provide, hence as RFC=
=2E
>> This patches are needed for booting Zynq into a minimum ramfs based
>> system with a serial console.
>=20
> In my opinion we should provide enable all the platform specific driver=
s
> in the defconfigs, as well as everything needed to boot the system,
> to get proper compile coverage as well as the ability to test changes
> easily. Your patches look good. Michal, would you apply them and
> send another pull request or should I just take them directly?

Soren asked me 2 days ago if make sense to create zynq defconfig or not.
I just suggested him to better extend this multi_v7_defconfig.
But still question is if we can/should create zynq specific defconfig?
Or are you going to remove all of these platform specific defconfig?

Definitely agree that multi_v7 defconfig should enable everything needed
to boot the system.
Does it also mean that we should also enable all zynq drivers
to get better compile coverage?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2RFCOLWGWLGWNQKCPPEOB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHCkdEACgkQykllyylKDCF7GwCfY5iIT4JTvnX8vO/ZxOX8Z0Dl
jJoAnifoVTiQ+fbvTd8Qa5Ul6ZtNIYqZ
=AGyu
-----END PGP SIGNATURE-----

------enig2RFCOLWGWLGWNQKCPPEOB--
