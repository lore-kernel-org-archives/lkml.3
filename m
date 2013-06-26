Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab3FZMvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:51:45 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:53069 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3FZMvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:51:43 -0400
Message-ID: <51CAE3DB.8060002@monstr.eu>
Date: Wed, 26 Jun 2013 14:51:39 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Timur Tabi <timur@tabi.org>, devicetree-discuss@lists.ozlabs.org,
        linux-fbdev@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v4 0/7] xilinxfb changes
References: <cover.1370254386.git.michal.simek@xilinx.com> <20130617085640.GE305@game.jcrosoft.org> <51BED093.1040207@monstr.eu> <201306172307.19114.arnd@arndb.de> <51CABC2A.50209@monstr.eu> <51CAD385.8060400@ti.com>
In-Reply-To: <51CAD385.8060400@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2FEHLABGMIBFNQDVDNGVV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2FEHLABGMIBFNQDVDNGVV
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 06/26/2013 01:41 PM, Tomi Valkeinen wrote:
> Hi,
>=20
> On 26/06/13 13:02, Michal Simek wrote:
>> On 06/17/2013 11:07 PM, Arnd Bergmann wrote:
>>> On Monday 17 June 2013, Michal Simek wrote:
>>>> On 06/17/2013 10:56 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>>> On 07:23 Mon 17 Jun     , Michal Simek wrote:
>>>>>> On 06/06/2013 06:23 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>>>>> On 12:13 Mon 03 Jun     , Michal Simek wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>
>>>>>>> Arnd can you take look on it again please
>>>>>>>
>>>>>>> I'll take a look on it next week
>>>>>>
>>>>>> Any update on this?
>>>>> look ok but I want the Ack from Arnd
>>>
>>> Sorry for the delay, everything looks good to me.
>>>
>>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>
>> Jean-Christophe: Will you apply this series?
>> Or should I take it through my microblaze tree?
>=20
> I've added this to my fbdev-3.11 branch.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2FEHLABGMIBFNQDVDNGVV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHK49sACgkQykllyylKDCHpkwCfcmGFZavhyTY4cSbMT45Lu5Lw
aKEAmgLW1MPFxOEAZY5z+r/GvZAtFzku
=vWNR
-----END PGP SIGNATURE-----

------enig2FEHLABGMIBFNQDVDNGVV--
