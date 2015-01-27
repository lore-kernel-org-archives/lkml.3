Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbbA0AA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:00:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757120AbbA0AAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:00:20 -0500
Message-ID: <54C6D510.6090105@suse.de>
Date: Tue, 27 Jan 2015 01:00:16 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Heiko Stuebner <heiko@sntech.de>, Pawel Moll <pawel.moll@arm.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Beniamino Galvani <b.galvani@gmail.com>,
        "ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH v4 6/7] ARM: zynq: DT: Add pinctrl information
References: <1420818231-13451-1-git-send-email-soren.brinkmann@xilinx.com> <1420818231-13451-7-git-send-email-soren.brinkmann@xilinx.com> <CACRpkdZ1jfTUqfLKonJxar2Jn25+4wTF-D4XUXOszSsoJrA07w@mail.gmail.com> <1a749692196d406a8229d4891f3563f4@BN1BFFO11FD016.protection.gbl>
In-Reply-To: <1a749692196d406a8229d4891f3563f4@BN1BFFO11FD016.protection.gbl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="8mQWRri3kJkN9UuGQwMJaJsDMH8oXU6vd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8mQWRri3kJkN9UuGQwMJaJsDMH8oXU6vd
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 12.01.2015 um 08:27 schrieb Michal Simek:
> On 01/11/2015 10:38 PM, Linus Walleij wrote:
>> On Fri, Jan 9, 2015 at 4:43 PM, Soren Brinkmann
>> <soren.brinkmann@xilinx.com> wrote:
>>
>>> Add pinctrl descriptions to the zc702 and zc706 device trees.
>>>
>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>> Tested-by: Andreas F=C3=A4rber <afaerber@suse.de>
>>
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> Beautiful and in line with how I want things to look.
>>
>> Yours,
>> Linus Walleij
>>
>=20
> Applied to zynq/dt.

Did you maybe forget to push?

https://github.com/Xilinx/linux-xlnx/commits/zynq/dt doesn't have it.

Regards,
Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,=

Graham Norton; HRB 21284 (AG N=C3=BCrnberg)


--8mQWRri3kJkN9UuGQwMJaJsDMH8oXU6vd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUxtUQAAoJEPou0S0+fgE/RRMP/RZHAQiHg6u0mD61B6ST7w6S
OMMxjzGLQGPlfOzh50cJS+7f2Ij/P8SXYAqV5deYS9QirMhM7IkDmFE1B72eyjs0
QiIEb9Vwvk4nUpIqFCJq5jcRj+Ka/t3XACisbsE0H3U8jMHy2Qq6oSxnq1UR4wfR
W5T2BeO6ih3imA9Y1NTuql7A8/xiyokBgN+ofx9R4a3yb9nrGXbNlzm2Nw5Alc8o
K1Mf2FyOBVlbTNUKHMOT/UFfFYdHAoliJJsX+Dfp+Ow8OkaqzOjEQtmDWzpvKFOv
G6XfJ8ay66LAoY8yHBIN6Vd2aEA9z/EY9u/BwKDi8dDLSVZ2av80LVQBnXeXCIUB
HxAMH16IQr5eUe3RiaQvQCZoNWjH4kiGohS3UYT21tMxvE9M6iJXMdIRwukwE2KI
646mlADhWBFo9NOELvXspTjS7AciVy6PQ1L7kzot4DX2KLJgR/LPj9hjzKv/lFsH
f3y4jqBzhZASrQZZY6VyPUnxNZN3P4u66aD2PuVFvJ1ucwrr7TW1XBA+QjJpSBgm
vrdoxM5jD+kbIdfB2Uk/LhAYpISY4flJgSb6kGQlAMsoj5fvZ6F6jNmuFpoz84b3
kkzOUAe/n1q6T460ko4cgT4k3WDHBehwBpjliLVXoiwhbigNX2qQ/RNUT1WdoILI
6XHQOxPJOl3bI9VL39CD
=YBeu
-----END PGP SIGNATURE-----

--8mQWRri3kJkN9UuGQwMJaJsDMH8oXU6vd--
