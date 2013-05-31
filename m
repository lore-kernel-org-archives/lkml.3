Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3EaHDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 03:03:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59945 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3EaHDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 03:03:37 -0400
Message-ID: <51A84B45.3070804@monstr.eu>
Date: Fri, 31 May 2013 09:03:33 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <joshc@eso.teric.us>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2 0/5] Zynq: revised CCF code
References: <1368467199-8702-1-git-send-email-soren.brinkmann@xilinx.com> <51961F37.3030202@monstr.eu> <20130530184443.4470.73215@quantum> <51A83287.3010604@monstr.eu> <20130531063225.21525.49143@quantum>
In-Reply-To: <20130531063225.21525.49143@quantum>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2QPTIUGRIVICCSIKCKMDU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2QPTIUGRIVICCSIKCKMDU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/31/2013 08:32 AM, Mike Turquette wrote:
> Quoting Michal Simek (2013-05-30 22:17:59)
>> On 05/30/2013 08:44 PM, Mike Turquette wrote:
>>> Quoting Michal Simek (2013-05-17 05:14:47)
>>>> Hi Mike,
>>>>
>>>> I have sent email to Greg to take this patch from this series
>>>> though his serial tree because it is unrelated to this clock stuff.
>>>>
>>>> Can you please give me your ACK for these patches or add them
>>>> to your CLK tree?
>>>>
>>>
>>> For the four clock-related patches:
>>>
>>> Acked-by: Mike Turquette <mturquette@linaro.org>
>>
>> I have already sent pull request to Arnd and Olof.
>> Or is it you who should take these patches through your tree?
>>
>=20
> Either way is fine.  Since you have already sent the pull request to th=
e
> arm-soc tree then that is probably the best path.

ok. I will keep my eyes on it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2QPTIUGRIVICCSIKCKMDU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGoS0UACgkQykllyylKDCHrfACePczcmEO0O3XKitWN36J999U7
uvAAn3WtiVCerkFHGn6hs3iCAW3fA4SV
=V2Lo
-----END PGP SIGNATURE-----

------enig2QPTIUGRIVICCSIKCKMDU--
