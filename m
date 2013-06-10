Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3FJI70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:59:26 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:48396 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3FJI7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:59:24 -0400
Message-ID: <51B5955A.8090708@monstr.eu>
Date: Mon, 10 Jun 2013 10:59:06 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Graeme Smecher <gsmecher@threespeedlogic.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] xilinx systemace: Fix device name assignment for
 SystemACE (from "xs`" to "xsa").
References: <4b5d6615a1338145a461a6d4e1c7d3e42d4f4522.1369312303.git.michal.simek@xilinx.com> <51AC9068.7050203@monstr.eu> <20130603142242.GB7024@kroah.com> <51ACA928.4090601@monstr.eu> <20130603143722.GA7651@kroah.com>
In-Reply-To: <20130603143722.GA7651@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2GGPETVBVDQNEHCHRLSOG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2GGPETVBVDQNEHCHRLSOG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/03/2013 04:37 PM, Greg Kroah-Hartman wrote:
> On Mon, Jun 03, 2013 at 04:33:12PM +0200, Michal Simek wrote:
>> On 06/03/2013 04:22 PM, Greg Kroah-Hartman wrote:
>>> On Mon, Jun 03, 2013 at 02:47:36PM +0200, Michal Simek wrote:
>>>> Hi Greg,
>>>>
>>>> do you want to take these two patches through your tree?
>>>
>>> Why would I be sending in drivers/block/* patches?  I don't have a tr=
ee
>>> for that, do I?
>>
>> Ah ok. I took you because you are 3rd based on get_maintainer patch (5=
0% commit signer)
>>
>>
>>>> Or should I take them through my microblaze tree?
>>>
>>> Please do, or send them to the block maintainer.
>>
>> Who is drivers/block maintainer? I can't see anyone in MAINTAINERS fil=
e.
>=20
> Jens is the block/ maintainer, so I imagine he's also the drivers/block=
/
> maintainer as well.  If not, he would know who.
>=20

We have nice follow up on this. It was applied as different patch to Linu=
s tree.

commit 585dc0c2f68981c02a0bb6fc8fe191a3f513959c
Author: Gernot Vormayr <gvormayr@gmail.com>
Date:   Fri May 24 15:55:03 2013 -0700

    drivers/block/xsysace.c: fix id with missing port-number

    If the port number is missing from the device-tree the device gets na=
med
    xs` instead of xsa.  This fixes the check for missing ids.

    Tested on ml507 board.

    Signed-off-by: Gernot Vormayr <gvormayr@gmail.com>
    Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Cc: Jens Axboe <axboe@kernel.dk>
    Cc: Grant Likely <grant.likely@linaro.org>
    Cc: Rob Herring <rob.herring@calxeda.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

M


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2GGPETVBVDQNEHCHRLSOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlG1lV8ACgkQykllyylKDCF8tgCgi7fvIv92J7w6sLnlQ2MT37gb
FHQAoIREVLzLh7OBqjwS1rsGwkF4cVvC
=f7SQ
-----END PGP SIGNATURE-----

------enig2GGPETVBVDQNEHCHRLSOG--
