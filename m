Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab3JDN6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:58:04 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:36671 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab3JDN6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:58:01 -0400
Message-ID: <524EC965.70701@monstr.eu>
Date: Fri, 04 Oct 2013 15:57:57 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Pavel Machek <pavel@denx.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
References: <cover.1380727889.git.michal.simek@xilinx.com> <524C6D64.8080801@zytor.com> <20131003064915.GB17155@amd.pavel.ucw.cz>
In-Reply-To: <20131003064915.GB17155@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="rVBb0EiO2pAGqbkp2GA429jx0vbg7XQgK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rVBb0EiO2pAGqbkp2GA429jx0vbg7XQgK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/03/2013 08:49 AM, Pavel Machek wrote:
> On Wed 2013-10-02 12:00:52, H. Peter Anvin wrote:
>> On 10/02/2013 08:35 AM, Michal Simek wrote:
>>>
>>> Based on my discussion at ELC with Greg KH the new driver should
>>> support firmware interface for loading bitstream.
>>>
>>
>> As I have previously stated, I think this is a mistake simply because
>> the firmware interface is a bad mapping on requirements for an FPGA,
>> especially once you account for the vast number of ways an FPGA can
>> get loaded and you take partial reconfiguration into account.  I
>> happen to be at a face to face meeting with Greg today, so I'll pick
>> his brain a bit.
>=20
> Umm. Could the discussion be kept on line?

I agree with you.
But anyway what was resolution from that meeting?

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--rVBb0EiO2pAGqbkp2GA429jx0vbg7XQgK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJOyWYACgkQykllyylKDCE0uQCeL80MvvJy0yS4dd6sEJ+0fZF1
IcYAnjbZMfvN8H4r+qdW4SWIURwTQrRS
=hrMq
-----END PGP SIGNATURE-----

--rVBb0EiO2pAGqbkp2GA429jx0vbg7XQgK--
