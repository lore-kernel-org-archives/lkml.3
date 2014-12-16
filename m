Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaLPJnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:43:09 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:50982 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750789AbaLPJnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:43:05 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Tue, 16 Dec 2014 09:43:03 +0000
Message-ID: <548FFEA0.1060905@imgtec.com>
Date: Tue, 16 Dec 2014 09:42:56 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        <linux-metag@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 16
References: <20141216154622.7c2ded16@canb.auug.org.au>	<20141216063549.GA1060@roeck-us.net> <20141215224444.dc7f0f3c.akpm@linux-foundation.org> <548FD746.1050904@roeck-us.net>
In-Reply-To: <548FD746.1050904@roeck-us.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="qqeNvLeg37pPuErDifolw1fMKCMRI58jc"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: da4c5968
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qqeNvLeg37pPuErDifolw1fMKCMRI58jc
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 16/12/14 06:55, Guenter Roeck wrote:
> On 12/15/2014 10:44 PM, Andrew Morton wrote:
>> On Mon, 15 Dec 2014 22:35:49 -0800 Guenter Roeck <linux@roeck-us.net>
>> wrote:
>>
>>> On Tue, Dec 16, 2014 at 03:46:22PM +1100, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> Please do not add any code destined for v3.20 to your linux-next
>>>> included
>>>> trees/branches until after v3.19-rc1 is released.
>>>>
>>>> Changes since 20141215:
>>>>
>>>> The infiniband tree gained a conflict against Linus' tree and a buil=
d
>>>> failure so I used the version from next-20141215.
>>>>
>>>> The userns tree gained a conflict against the vfs tree.
>>>>
>>>> The clk tree gained a build failure so I used the version from
>>>> next-20141215.
>>>>
>>>> Non-merge commits (relative to Linus' tree): 3588
>>>>   2582 files changed, 123494 insertions(+), 135748 deletions(-)
>>>>
>>>
>>> My metag buildbot test fails with this kernel.
>>
>> Thanks.  What are the error messages?
>>
>>
> Nothing. It just hangs until killed.
>=20
> qemu log:
> char device redirected to /dev/pts/5
> Unable to load ROM!
> qemu: terminating on signal 15 from pid 17843
>=20
> http://server.roeck-us.net:8010/builders/qemu-metag-next/builds/60/step=
s/qemubuildcommand/logs/stdio

Thanks a lot Guenter for report and bisection. I've confirmed on real
hardware too. I'll try debugging it.

Cheers
James

>=20
>=20
> Normally output would be similar to the following.
>=20
> /opt/buildbot/bin/qemu-system-meta -display none -kernel vmlinux -devic=
e
> da,exit_threads=3D1 -chardev stdio,id=3Dchan1 -chardev pty,id=3Dchan2 -=
append
> "rdinit=3D/sbin/init"
> char device redirected to /dev/pts/29
> Unable to load ROM!
> Linux version 3.18.0+ (groeck@server.roeck-us.net) (gcc version 4.2.4
> (IMG-1.4.0.300)) #5 Mon Dec 15 22:50:31 PST 2014
> LNKGET/SET go through cache but CONFIG_METAG_LNKGET_AROUND_CACHE=3Dy
> DA present
> ...
>=20
> Guenter
>=20


--qqeNvLeg37pPuErDifolw1fMKCMRI58jc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUj/6mAAoJEGwLaZPeOHZ6RRgP/3SbIwh+YPbdaq4RPdxefW8Z
sNUln7dkew+KoSEmZZwH7aBcPIXzTAD/swA9xwl6KNLK60tLv4FO1umjqnIAkKSB
1L2xO3xJfEcbDriwMH+jXM0wTYHVkMPdNEk2COUf8Y5X3rBM8fmiMftOjfnMOVH5
zP5LJynXRZ0Ud/yrx86HSznBl2UnT8qjhORwuDWgSVT+IoTmOCMnyZ6k/sThIRWk
pxQdt03NN8QgpA0YO3Hwdvkm0ObskklXv3HTiHaikPEF7ZjIqQiKu4Xcfmbsawfw
Mt0RE5lePp6H6nTKBnPF/g7zDVcIBc/K/X3MiI2tOBX3gh/9p3WePowmLWuEQmzC
w1WJBFYqtiVjjun/8WP8GxsMvpvNCLcDZJzciNum5wxDH6BHHt2msboaOzK4tz8U
yi07UPZDFS1aLyfNDyHcCB2Tmysc8ffEFdKysGA6qVYNBznp1CC7jcwW0glccYw5
pT6uk512rOh6BeBP4sd3zqPt6PK30PPTgrfT/uM4syS1/MXoH6/5TlqZxf5eqV9a
yRi/hkwuqOR+oWPsfDXiCHdcbUpHHv80EvtPnhMJQh7Mni6c4IblQNMG6Ddg5x3w
cXjLc0YBtdx28RDOMh9OH5UbLv+qXBBHUgQgBWHCa7HNiygkI8H1i7RemHkEW1Um
Iezh8Le5CVJPf5LtaUrn
=M9IB
-----END PGP SIGNATURE-----

--qqeNvLeg37pPuErDifolw1fMKCMRI58jc--
