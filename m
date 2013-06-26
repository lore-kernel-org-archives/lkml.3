Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3FZLmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:42:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39155 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab3FZLmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:42:10 -0400
Message-ID: <51CAD385.8060400@ti.com>
Date: Wed, 26 Jun 2013 14:41:57 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <monstr@monstr.eu>
CC: Arnd Bergmann <arnd@arndb.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Timur Tabi <timur@tabi.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-fbdev@vger.kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v4 0/7] xilinxfb changes
References: <cover.1370254386.git.michal.simek@xilinx.com> <20130617085640.GE305@game.jcrosoft.org> <51BED093.1040207@monstr.eu> <201306172307.19114.arnd@arndb.de> <51CABC2A.50209@monstr.eu>
In-Reply-To: <51CABC2A.50209@monstr.eu>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2UIAOQTNPGVXGEMFPLXBL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2UIAOQTNPGVXGEMFPLXBL
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

On 26/06/13 13:02, Michal Simek wrote:
> On 06/17/2013 11:07 PM, Arnd Bergmann wrote:
>> On Monday 17 June 2013, Michal Simek wrote:
>>> On 06/17/2013 10:56 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>> On 07:23 Mon 17 Jun     , Michal Simek wrote:
>>>>> On 06/06/2013 06:23 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>>>> On 12:13 Mon 03 Jun     , Michal Simek wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>
>>>>>> Arnd can you take look on it again please
>>>>>>
>>>>>> I'll take a look on it next week
>>>>>
>>>>> Any update on this?
>>>> look ok but I want the Ack from Arnd
>>
>> Sorry for the delay, everything looks good to me.
>>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>=20
> Jean-Christophe: Will you apply this series?
> Or should I take it through my microblaze tree?

I've added this to my fbdev-3.11 branch.

 Tomi



------enig2UIAOQTNPGVXGEMFPLXBL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRytOFAAoJEPo9qoy8lh71xjgP/0fcVcyg77HowYq0FLm5lDW1
lyV2s6OQy6umgnNKaxoWETjtoi/zDWQIekOwexTbaBPd4UEzg7oQBb2ETOxbE/IW
5BoaBgpM8YJ3XBInLzQjP2Yi45DO9bGyvCYzh5VgrgYr2xaQvnKe9KeeS5mqE7vI
YRx/i9NfEDl5lzNCa0+HWbmO+bHfrqhvJjRjj2P/KEnmgAPWlWC/JF1nw+cDG+r+
5aZn4Y1M586aLPKQz1Qx318QMKFe5W9hhCFAuKNO7cYQcyGHGvZBnkfQKyxhkE3u
nfCMBkAKasOwXo5QB7t4+cLcASkmB+xp1ivirtgFVpnmpTjLRi7Lq+Cb2HD0NUZA
04GdTJv4iNYAYUydtIucGWPpBvuYbWxt2NHae84MgclAdENIQvL6XgIv4Upi5Dgp
+mIpAM96g1uAePfygetCYiKLnDu1Xuj4LZLLUpAGVX+UHePWYX6D4O75o6+OJbua
6WgvXdo3pW6gNlHL5Kkyki3VH5Axa/VduU5GC9PuGCDSpI9mZzZjyXB53l/2eix1
QA1qBFTtGatbGyrY2U7RWPFxVIcw0jvDfCK5HrGKUQREclMScpwZyRkIC6Z/6p/Z
f36v6Ct4sYNFpFEx+RAaSPdeO8tv8HvaDYpIktwyA6a1xQpKBYkx35jIP+KoeYDP
/uXigGCpNrfgOCAGuB9N
=PjFZ
-----END PGP SIGNATURE-----

------enig2UIAOQTNPGVXGEMFPLXBL--
