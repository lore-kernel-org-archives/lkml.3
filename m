Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161261Ab3FTRMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:12:03 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61291 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161248Ab3FTRMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:12:01 -0400
Message-ID: <51C337D7.1040404@monstr.eu>
Date: Thu, 20 Jun 2013 19:11:51 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] uio: Add two platform uio drivers to one
References: <086bdaf83fe546bd3c7fe163e565a0887770770f.1369317710.git.michal.simek@xilinx.com> <71c482e15ee32fa304db73b984f6d5a63441cd92.1369317710.git.michal.simek@xilinx.com> <51A5E644.1040901@monstr.eu> <51AC8D43.100@monstr.eu> <20130603210513.GA22606@kroah.com> <20130620160126.GB22115@amd.pavel.ucw.cz>
In-Reply-To: <20130620160126.GB22115@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2KWGJPOPTXHQTXDMBVRCP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2KWGJPOPTXHQTXDMBVRCP
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 06/20/2013 06:01 PM, Pavel Machek wrote:
> Hi!
>=20
>>> can you please comment this?
>>
>> I'll let Hans handle this, as he's the UIO maintainer now.
>=20
> Looks good to me.
>=20
> Anyway, Hans disappeared, so Greg takes patches, again. Take a look,
> it seems I already did some changes you wanted, they are in char-misc
> tree.

Can you send me link to that repo?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2KWGJPOPTXHQTXDMBVRCP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHDN9gACgkQykllyylKDCGu4gCfVbZStfyz7wbe+jmYGP0wgYQ7
VDQAn0PZzOVvQQ9HXmPeFsK2TqycTYfR
=Qx1S
-----END PGP SIGNATURE-----

------enig2KWGJPOPTXHQTXDMBVRCP--
