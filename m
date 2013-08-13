Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab3HMOaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:30:23 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:37296 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab3HMOaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:30:20 -0400
Message-ID: <520A42F8.9050108@monstr.eu>
Date: Tue, 13 Aug 2013 16:30:16 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Zynq clk fixes
References: <51F26716.6030701@monstr.eu> <20130726200703.7598.86150@quantum> <a76b3a5d-dadc-43b3-87ee-3c65258c15d7@CO1EHSMHS029.ehs.local> <20130726222501.7598.33060@quantum>
In-Reply-To: <20130726222501.7598.33060@quantum>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VM1JQGvt87arbNRmCOOPqhVa6RD8AACcb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VM1JQGvt87arbNRmCOOPqhVa6RD8AACcb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On 07/27/2013 12:25 AM, Mike Turquette wrote:
> Quoting S=C3=B6ren Brinkmann (2013-07-26 14:11:52)
>> On Fri, Jul 26, 2013 at 01:07:03PM -0700, Mike Turquette wrote:
>>> Quoting Michal Simek (2013-07-26 05:09:58)
>>>> Hi Mike, [cc: Arnd and Olof]
>>>>
>>>> Soren has found two bug fixes in zynq clk code.
>>>> Can you please add these two patches to your tree?
>>>> Will be great if you can add them to v3.11.
>>>>
>>>> Arnd, Olof: I expect that all these clock changes should go through =
Mike.
>>>> If I am wrong please let me know.
>>>
>>> Looks right to me. Do these fix regressions in the current -rc cycle?=

>>
>> I doubt there are real regressions. But since it's still early in
>> the release cycle and the driver was added in this merge window, I'd p=
refer
>> having it hit a release kernel with these fixes included.
>=20
> I've taken these into clk-fixes and added the following to the changelo=
g
> for each patch:
>=20
> "This does not fix a specific regression but the clock driver was merge=
d
> for 3.11-rc1, so best to fix the known bugs before the release."

Can you please tell me where you have added these two patches?
      clk/zynq/clkc: Add dedicated spinlock for the SWDT
      clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet muxes

I can't see them in clk-fixes branch (this branch is pretty obsolete).
http://git.linaro.org/gitweb?p=3Dpeople/mturquette/linux.git;a=3Dsummary

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--VM1JQGvt87arbNRmCOOPqhVa6RD8AACcb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlIKQvgACgkQykllyylKDCGmZQCbBGvcNc20esnPtuT3tQA9QnmI
q6YAn19WbDXc1fJcZDfgKgn9rY6GPajL
=iAYq
-----END PGP SIGNATURE-----

--VM1JQGvt87arbNRmCOOPqhVa6RD8AACcb--
