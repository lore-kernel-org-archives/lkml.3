Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaBXKNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:13:12 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:47748 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaBXKNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:13:07 -0500
Message-ID: <530B1B25.5090601@monstr.eu>
Date: Mon, 24 Feb 2014 11:12:53 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        devicetree@vger.kernel.org, Wolfgang Denk <wd@denx.de>
Subject: Re: SPDX-License-Identifier
References: <20140220182257.GF23217@saruman.home> <5306F458.9010706@monstr.eu> <20140221160442.GA17506@kroah.com> <5307790A.4050806@monstr.eu> <20140221161246.GM31902@saruman.home> <53077C5F.9000407@monstr.eu> <20140221162045.GN31902@saruman.home> <20140221165633.GA5465@kroah.com> <53078C30.7060703@monstr.eu> <20140221175720.GA21660@kroah.com> <20140221190125.GL31047@thunk.org>
In-Reply-To: <20140221190125.GL31047@thunk.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="6kCPkRWvEhKH4Md15meI4LeV38MOB8m0i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6kCPkRWvEhKH4Md15meI4LeV38MOB8m0i
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/21/2014 08:01 PM, Theodore Ts'o wrote:
> On Fri, Feb 21, 2014 at 09:57:20AM -0800, Greg Kroah-Hartman wrote:
>>> But shouldn't we at least write somewhere
>>> that it has connection to spdx.org where you can find out that licens=
es.
>>
>> Why?  Are these licenses so unknown that no one knows what they are?
>> And, as part of the kernel-as-a-whole-work, they all resolve to GPLv2
>> anyway, and we have that license in the source tree, so nothing else
>> should be needed.
>=20
> Note that not all lawyers are in agreement about this, so if this is a
> driver being developed by a company, you may want to ask your
> corporate counsel if they have an opinion about this.  I've received
> advice of the form that it's not obvious that regardless of whether or
> not us *engineers* understand what all of the licensing terms mean,
> what's important is whether someone who is accused of "borrowing"
> GPL'ed code and dropping it in a driver for some other OS can convince
> a judge whether or not it's considered "obvious" from a legal
> perspective what an SPDX header means, and what is implied by an SPDX
> license identifer.
>=20
> Also note that with the advent of web sites that allow people to do
> web searches and turn up a singleton file via some gitweb interface,
> the fact that the full license text is distributed alongside the
> tarball might or might have as much legal significance as it once had.
>=20
> But of course, I'm not a lawyer, and if your company has is paying for
> the development of the driver, the Golden Rule applies (he who has the
> Gold, makes the Rules), and each of our respective corporate lawyers
> may have different opinions about what might happen if the question
> was ever to be adjudicated in court.

Thanks Ted.
Aren't all these points already answered by SPDX project?
I believe that they should know how this should be handled properly.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--6kCPkRWvEhKH4Md15meI4LeV38MOB8m0i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMLGyUACgkQykllyylKDCFZbwCfXdMV+R4jytSBF70ufER8bYU8
lasAnjqJTcpYVxQImAKrRvq17xntlI4n
=sXfG
-----END PGP SIGNATURE-----

--6kCPkRWvEhKH4Md15meI4LeV38MOB8m0i--
