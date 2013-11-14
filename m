Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3KNGxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 01:53:20 -0500
Received: from smtp.citrix.com ([66.165.176.89]:51871 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab3KNGxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 01:53:13 -0500
X-IronPort-AV: E=Sophos;i="4.93,697,1378857600"; 
   d="asc'?scan'208";a="74350355"
Message-ID: <1384411989.29902.6.camel@Abyss>
Subject: Re: [Xen-devel] [PATCH 0/2] xen: vnuma introduction for pv guest
From: Dario Faggioli <dario.faggioli@citrix.com>
To: Elena Ufimtseva <ufimtseva@gmail.com>
CC: <xen-devel@lists.xenproject.org>, <akpm@linux-foundation.org>,
        <wency@cn.fujitsu.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>,
        <mingo@redhat.com>, <david.vrabel@citrix.com>, <hpa@zytor.com>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>,
        <stefano.stabellini@eu.citrix.com>, <ian.campbell@citrix.com>
Date: Thu, 14 Nov 2013 07:53:09 +0100
In-Reply-To: <1384400179-24404-1-git-send-email-ufimtseva@gmail.com>
References: <1384400179-24404-1-git-send-email-ufimtseva@gmail.com>
Organization: Citrix Ltd
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-DXwN6zffJwrACBajzl1T"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
MIME-Version: 1.0
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-DXwN6zffJwrACBajzl1T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mer, 2013-11-13 at 22:36 -0500, Elena Ufimtseva wrote:
> Xen vnuma introduction.
>=20
Hey Elena!

First of all, let me state this once more: thanks for keeping doing
this, even after the official conclusion of the (OPW) program! :-)

> vNUMA topology is constructed by Xen toolstack. Xen patchset is=20
> available at https://git.gitorious.org/xenvnuma/xenvnuma.git.
>=20
Is it me or the repo is empty?

> Example of vnuma enabled pv domain dmesg:
>=20
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009ffff]
> [    0.000000]   node   0: [mem 0x00100000-0xffffffff]
> [    0.000000]   node   1: [mem 0x100000000-0x1ffffffff]
> [    0.000000]   node   2: [mem 0x200000000-0x2ffffffff]
> [    0.000000]   node   3: [mem 0x300000000-0x3ffffffff]
> [    0.000000] On node 0 totalpages: 1048479
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3999 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 14280 pages used for memmap
> [    0.000000]   DMA32 zone: 1044480 pages, LIFO batch:31
> [    0.000000] On node 1 totalpages: 1048576
> [    0.000000]   Normal zone: 14336 pages used for memmap
> [    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
> [    0.000000] On node 2 totalpages: 1048576
> [    0.000000]   Normal zone: 14336 pages used for memmap
> [    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
> [    0.000000] On node 3 totalpages: 1048576
> [    0.000000]   Normal zone: 14336 pages used for memmap
> [    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
>
Wow... Cool!

Let's see the patches. :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://about.me/dario.faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)


--=-DXwN6zffJwrACBajzl1T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iEYEABECAAYFAlKEc1UACgkQk4XaBE3IOsSeLwCfQpyvSMjGh+iGwZ08dYM02nt8
VkQAnj35qcFZf/IWe+asqhe+uQ+fDmcT
=GUwr
-----END PGP SIGNATURE-----

--=-DXwN6zffJwrACBajzl1T--
