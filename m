Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab3KZIWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 03:22:17 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:54661 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3KZIWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 03:22:14 -0500
Message-ID: <52945A2D.3060609@monstr.eu>
Date: Tue, 26 Nov 2013 09:22:05 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v3] video: add OpenCores VGA/LCD framebuffer driver
References: <1385094870-6962-1-git-send-email-stefan.kristiansson@saunalahti.fi> <52944976.4060003@monstr.eu> <CAMuHMdVx_jkUMB=gS0CtguBPB4f3fNRx0z4hB4zRz9OC09SvsQ@mail.gmail.com>
In-Reply-To: <CAMuHMdVx_jkUMB=gS0CtguBPB4f3fNRx0z4hB4zRz9OC09SvsQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="90eg0j04mle2pLMcM9CcV4Vm1qT8wPlCQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--90eg0j04mle2pLMcM9CcV4Vm1qT8wPlCQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/26/2013 09:19 AM, Geert Uytterhoeven wrote:
> On Tue, Nov 26, 2013 at 8:10 AM, Michal Simek <monstr@monstr.eu> wrote:=

>> On 11/22/2013 05:34 AM, Stefan Kristiansson wrote:
>> This construction seems to me too complicated and can be simpler.
>>
>> What about this?
>>         res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>=20
> Don't forget to check for res being non-NULL here.

yes. you are right - you have to do it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--90eg0j04mle2pLMcM9CcV4Vm1qT8wPlCQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKUWi0ACgkQykllyylKDCHtjgCeLRDFAkz6taISawsAzgFWRrp1
a8QAmwaYWpLHZcf2iR0sC9kg0CO+k1eI
=zqTk
-----END PGP SIGNATURE-----

--90eg0j04mle2pLMcM9CcV4Vm1qT8wPlCQ--
