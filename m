Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaAWI6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:58:43 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:36816 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaAWI6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:58:41 -0500
Message-ID: <52E0D9AD.1040409@monstr.eu>
Date: Thu, 23 Jan 2014 09:58:21 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Brown <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc C <marc.ceeeee@gmail.com>, Matt Porter <matt.porter@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 7/7] ARM: brcmstb: dts: add a reference DTS for Broadcom
 7445
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com> <201401161219.01038.arnd@arndb.de> <20140116134732.GB17314@sirena.org.uk> <201401171804.30572.arnd@arndb.de>
In-Reply-To: <201401171804.30572.arnd@arndb.de>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="AKaUerVwI6LMuuVxib5JgnEqqbliEUWie"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AKaUerVwI6LMuuVxib5JgnEqqbliEUWie
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/17/2014 06:04 PM, Arnd Bergmann wrote:
> On Thursday 16 January 2014, Mark Brown wrote:
>> On Thu, Jan 16, 2014 at 12:19:00PM +0100, Arnd Bergmann wrote:
>>
>>> 1. Other platforms also require the syscon driver to be active before=

>>> the regular device driver probing starts. Michal Simek has the same
>>> issue in the zynq clock driver that you have for SMP initialization.
>>> We have talked about this with Mark Brown already, and I think we wil=
l
>>> find a solution for this in the end, but it's not as straightforward
>>> as I first hoped. We can probably use help in this area.
>>
>> I thought the solution with deferring registration of the resource for=

>> dev_get_regmap() until a proper device materialised seemed simple and
>> enough, did you folks run into any problems with that?  I had assumed =
a
>> patch was likely to materialise so wasn't worrying about it myself.
>=20
> I'm still hoping that Michal will do that patch.

And what was the resolution/recommendation how to do it?

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--AKaUerVwI6LMuuVxib5JgnEqqbliEUWie
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLg2a0ACgkQykllyylKDCFGKQCaA18apnuO36qPgCQdCuCPBPFB
HhkAnic918oEawOlDrUNrgIQk/KJ07j8
=SzUS
-----END PGP SIGNATURE-----

--AKaUerVwI6LMuuVxib5JgnEqqbliEUWie--
