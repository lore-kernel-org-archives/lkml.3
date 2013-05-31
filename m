Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3EaFSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 01:18:15 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:62418 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3EaFSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 01:18:08 -0400
Message-ID: <51A83287.3010604@monstr.eu>
Date: Fri, 31 May 2013 07:17:59 +0200
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
References: <1368467199-8702-1-git-send-email-soren.brinkmann@xilinx.com> <51961F37.3030202@monstr.eu> <20130530184443.4470.73215@quantum>
In-Reply-To: <20130530184443.4470.73215@quantum>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2UIXPQOTFNHWOCXMDBWSC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2UIXPQOTFNHWOCXMDBWSC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/30/2013 08:44 PM, Mike Turquette wrote:
> Quoting Michal Simek (2013-05-17 05:14:47)
>> Hi Mike,
>>
>> I have sent email to Greg to take this patch from this series
>> though his serial tree because it is unrelated to this clock stuff.
>>
>> Can you please give me your ACK for these patches or add them
>> to your CLK tree?
>>
>=20
> For the four clock-related patches:
>=20
> Acked-by: Mike Turquette <mturquette@linaro.org>

I have already sent pull request to Arnd and Olof.
Or is it you who should take these patches through your tree?

Thanks.
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2UIXPQOTFNHWOCXMDBWSC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGoMocACgkQykllyylKDCExkQCeNuXl+/iGBGs1vorh5My0M8tL
MTgAn3V2p28ky2ufZ4S0wuj5F2aiuzSj
=KPaW
-----END PGP SIGNATURE-----

------enig2UIXPQOTFNHWOCXMDBWSC--
