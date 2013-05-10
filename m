Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750849Ab3EJEIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 00:08:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55655 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699Ab3EJEIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 00:08:22 -0400
Message-ID: <1368158889.17344.11.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [stable 3.0] s390 build breakage [was: Linux 3.0.75]
From: Ben Hutchings <ben@decadent.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Date: Fri, 10 May 2013 05:08:09 +0100
In-Reply-To: <51826176.2070104@suse.cz>
References: <20130426043017.GA22553@kroah.com> <51826176.2070104@suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JGF8UOSEwz2IrW1APTUv"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:4022:769e:a966:672f
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JGF8UOSEwz2IrW1APTUv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-05-02 at 14:52 +0200, Jiri Slaby wrote:
> On 04/26/2013 06:30 AM, Greg KH wrote:
> > Linus Torvalds (5): vm: add vm_iomap_memory() helper function
>=20
> Hi, this one breaks s390 on 3.0:
> mm/memory.c: In function 'vm_iomap_memory':
> mm/memory.c:2363: error: implicit declaration of function
> 'io_remap_pfn_range'
>=20
> It looks like 4f2e29031e6c67802e7370292dd050fd62f337ee is needed:
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Apr 17 08:46:19 2013 -0700
>=20
>     s390: move dummy io_remap_pfn_range() to asm/pgtable.h
>=20
>=20
> But it depends on the s390 PCI support...
>=20
> Whatever, it should be OK to take only the second hunk from that
> patch, it seems.

I'm going to do that in 3.2.y.  Thanks for the hint.

Ben.

--=20
Ben Hutchings
For every action, there is an equal and opposite criticism. - Harrison

--=-JGF8UOSEwz2IrW1APTUv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUYxyqee/yOyVhhEJAQomiw//YwMk4NFBVCGAkM9EmyGVgakfAjiHXqPj
Zl5fgoUlruloHe7xfksW9Kdcv8d8ct0NWs5VfsidVzfkrozRxkGwAKLckexnp5fA
thRQfklKZB2t07p90vK7RfW5j49RJktPguim0kNISwKouMUBq7wUyaSTYufNpUSI
VqjX/WJZF5GbW+48aAu6x7SMjjcgFHnUNB3mYM8TiFyivRYclEja9cZ5rBf1ZQkz
DReH+a60qacx14K/+koagS76lCEQI+2e7gM0+QxONvstc12C+NrJlx0gDWVOR9AC
aaICmipVfFmzIRFGiibVMVt4tLp7mavnln2XTU4Yk/AM51frJj8IzWd4tkwygZoK
kHkqNevK/b5PtUeWiSRprIUBM8m0CgzHvPb3B0Jhk4+bqEIjlxQk2hJ5N7F3mcZG
YGE98KFVwPNCtwQphmOJMNNfS6ZcpR4sHp10gdOvQgUNZ2I0y9GzZj86PXrpEjNT
iQb5XZSb4NmhOrpaS1txBLENYE+bP1tYzNiwywcAbLr1VrrNh7FChETGLLhhdTHb
QWh1hMWt1NnK5YBMhFs39GWLvjU+BwE5RkENMP/mwhpgVOaqU7SciQocL0Z8Q4ic
HMpSJsLuBzeYWx4LdPAujV/+4/rDZNksmnzFayHJSZXxjfJVwj+w6BMNDg1usJ2t
/1vJDG7uLoM=
=rpz1
-----END PGP SIGNATURE-----

--=-JGF8UOSEwz2IrW1APTUv--
