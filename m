Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324Ab3FUJGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:06:33 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:49254 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab3FUJGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:06:25 -0400
Message-ID: <51C41789.8070903@monstr.eu>
Date: Fri, 21 Jun 2013 11:06:17 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] uio: Add two platform uio drivers to one
References: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com> <71c482e15ee32fa304db73b984f6d5a63441cd92.1369317710.git.michal.simek@xilinx.com> <51A5E644.1040901@monstr.eu> <51AC8D43.100@monstr.eu> <20130603210513.GA22606@kroah.com> <20130620160126.GB22115@amd.pavel.ucw.cz> <51C337D7.1040404@monstr.eu> <20130620231346.GB1589@amd.pavel.ucw.cz>
In-Reply-To: <20130620231346.GB1589@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2PCIJVSQDUHONFXTUVCWT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2PCIJVSQDUHONFXTUVCWT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/21/2013 01:13 AM, Pavel Machek wrote:
> Hi!
>=20
>>>>> can you please comment this?
>>>>
>>>> I'll let Hans handle this, as he's the UIO maintainer now.
>>>
>>> Looks good to me.
>>>
>>> Anyway, Hans disappeared, so Greg takes patches, again. Take a look,
>>> it seems I already did some changes you wanted, they are in char-misc=

>>> tree.
>>
>> Can you send me link to that repo?
>=20
> I googled a mirror...
>=20
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/gregkh/char-mi=
sc/+/char-misc-next/drivers/uio/uio_pdrv_genirq.c

Ok. I see.
Yeah it can be done in that way too.

I can rebase my patches on the top of that because they are still valid.
1/2 is not there and it is nice way how to simplify the code.

The purpose of 2/2 was to remove that uio_pdrv.c which is not needed
when uio_pdrv_genirq.c also support no IRQ case.

Will be good if you can look at my patches and test them.

Also we should also simplify the driver by using devres groups,
devm_kzalloc, etc.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2PCIJVSQDUHONFXTUVCWT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHEF44ACgkQykllyylKDCGyWgCfaLhs21M/1wJXD0YUjYc2mXIG
6W4An369dnRgHwTSROmS6ywI7o5KMVmf
=wzEw
-----END PGP SIGNATURE-----

------enig2PCIJVSQDUHONFXTUVCWT--
