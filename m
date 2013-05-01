Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3EAGu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 02:50:26 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:45345 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab3EAGuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 02:50:19 -0400
Message-ID: <5180BB21.2080306@monstr.eu>
Date: Wed, 01 May 2013 08:50:09 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <joshc@eso.teric.us>,
        Mike Turquette <mturquette@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 1/7] tty: xuartps: Sort #includes alphabetically
References: <1367366284-28304-1-git-send-email-soren.brinkmann@xilinx.com> <1367366284-28304-2-git-send-email-soren.brinkmann@xilinx.com> <20130501000048.GA1840@kroah.com> <cbd8c55c-066b-4396-9a4b-97d58a93b573@DB8EHSMHS005.ehs.local> <20130501002321.GB7435@kroah.com>
In-Reply-To: <20130501002321.GB7435@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2HHIMRCGXHWASFBPUPLRX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2HHIMRCGXHWASFBPUPLRX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/01/2013 02:23 AM, Greg Kroah-Hartman wrote:
> On Tue, Apr 30, 2013 at 05:05:40PM -0700, S=F6ren Brinkmann wrote:
>> On Tue, Apr 30, 2013 at 05:00:48PM -0700, Greg Kroah-Hartman wrote:
>>> On Tue, Apr 30, 2013 at 04:57:58PM -0700, Soren Brinkmann wrote:
>>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> CC: Jiri Slaby <jslaby@suse.cz>
>>>> CC: linux-serial@vger.kernel.org
>>>
>>> Why would you need/want to do this?
>> I often come across duplicated includes. Having some kind of order hel=
ps
>> avoiding that, imho.
>=20
> We have a tool to handle duplicated includes, no need to put them in
> sorted order for them to be detected.

What's the name of tool which does that?
I have seen results from it but have never tried to find it out name and
how to use it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2HHIMRCGXHWASFBPUPLRX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGAuyIACgkQykllyylKDCEAJwCcCF+pLdFSrpn3D1i3UzlHfmpo
+rUAn2wVsWO82kPG118bE5NwICbEhIRS
=NX8z
-----END PGP SIGNATURE-----

------enig2HHIMRCGXHWASFBPUPLRX--
