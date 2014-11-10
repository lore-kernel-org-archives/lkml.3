Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbaKJGEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:04:09 -0500
Received: from mout.web.de ([212.227.17.11]:63497 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaKJGEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:04:08 -0500
Message-ID: <5460554A.1060701@web.de>
Date: Mon, 10 Nov 2014 07:03:54 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: AMR: sun7i: CPU hotplug support?
References: <545FC215.7010802@web.de> <20141109231744.GC2989@lukather>
In-Reply-To: <20141109231744.GC2989@lukather>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="mmDuBgaPDwXX7Xq393Tb3PftVlTtM2FsD"
X-Provags-ID: V03:K0:dbYsWUbLbYRFuqK99jxNIyzwziOp28ZoogfYxoe1qQLK/c+sNKl
 7dPTiY/zwmdwYC6njeAG7oCtXKMSb+1/ip6IPwmb04H+j5mkTjSpwvds59/ghL3Kh37A2LT
 fv/6xy43vk58FZKqWx5PY1T6vuUrbNrwyoob2FD6sjkebha5Nah9BM1OAHCawx5TCaPVFYH
 Aci0tkqaglLVUYle+ktog==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mmDuBgaPDwXX7Xq393Tb3PftVlTtM2FsD
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2014-11-10 00:17, Maxime Ripard wrote:
> Hi Jan,
>=20
> On Sun, Nov 09, 2014 at 08:35:49PM +0100, Jan Kiszka wrote:
>> did anyone already happen to look into enabling CPU hotplug for the
>> Allwinner A20 in upstream? I'm currently running the sunxi-next branch=

>> on Banana Pi, and echo 0 > .../cpu1/online just hangs the system. The
>> old 3.4 LeMaker kernel works fine in this regard. I can try to look in=
to
>> details and port things over, just want to avoid duplicate efforts.
>=20
> Having hotplug support would indeed be very welcome.
>=20
> However, it should be done in u-boot, through PSCI, and not in the
> kernel itself.
>=20
> As far as I'm aware, no one worked actively on it, beside some WIP
> commit from Marc a while ago:
> https://git.kernel.org/cgit/linux/kernel/git/maz/u-boot.git/commit/?h=3D=
wip/psci&id=3D45379c0f9cf812f0f62722f4015ec907fa5dc144

OK - I guess I will need a little guidance in then: Is there a good
reference board to study and to derive from? And maybe also: What is
missing or not working in that u-boot branch? If I get this interface
right, I just takes some device tree bits to enable this for the kernel
afterward, correct?

Thanks,
Jan

PS: That the GMAC on B-Pi has some TX reliability issues, both with
kernel and u-boot, is known, right? If not, I'll open a separate thread.


--mmDuBgaPDwXX7Xq393Tb3PftVlTtM2FsD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlRgVUoACgkQitSsb3rl5xS17QCeL4t4+24h0khlaDl9yUW1NPpT
qQ8AoLp/Xq9r6gFeJyTOWs2xarBJGpfi
=Xu1Q
-----END PGP SIGNATURE-----

--mmDuBgaPDwXX7Xq393Tb3PftVlTtM2FsD--
