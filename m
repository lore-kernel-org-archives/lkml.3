Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab3FMDEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 23:04:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35964 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757019Ab3FMDEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 23:04:38 -0400
Message-ID: <1371092666.10688.39.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 3.2.46
From: Ben Hutchings <ben@decadent.org.uk>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org, lwn@lwn.net
Date: Thu, 13 Jun 2013 04:04:26 +0100
In-Reply-To: <51B1A5DF.7030703@huawei.com>
References: <1370005571.3469.505.camel@deadeye.wl.decadent.org.uk>
	 <51B1A5DF.7030703@huawei.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KO9OozZ4crC1pySAy5AX"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KO9OozZ4crC1pySAy5AX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-06-07 at 17:20 +0800, Li Zefan wrote:
> On 2013/5/31 21:06, Ben Hutchings wrote:
> > I'm announcing the release of the 3.2.46 kernel.
> >=20
> > All users of the 3.2 kernel series should upgrade.
> >=20
> > The updated 3.2.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le.git linux-3.2.y
> > and can be browsed at the normal kernel.org git web browser:
> >         http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable=
.git
> >=20
>=20
> I guess you'll get compile error if you enable ftrace but disable CONFIG_=
DYNAMIC_FTRACE,
> and you need to backport 7f49ef69db6bbf756c0abca7e9b65b32e999eec8.

Thanks, I've added that to the queue for the next update.

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-KO9OozZ4crC1pySAy5AX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbk2uue/yOyVhhEJAQqNWxAAt2mgPi9lUeoKc9knvGu8IwQVzgUT6iy9
hIjhWWuptNp59MBw132n9Huiq5ZKmm9MruOgF/d41aAo+mwusI94Ia2CKHkj2uWX
y3ii0HSJOtas5CqYRIjXNG0Ze6H3c/RAnXUxsRHqj4TxiABF8K712DmAEvckGm58
0/RxdhBVD/4N5xe+qYWwaD8M9C+y0acZbSB8y9RDK6g0NpJNGLWlZ1dP9P9jhSMT
8VuDwNfsc0b5KW/0eb8Pm5exmr8iI2W5CmYZcqbxha3ibbbbt6PEdr/IQZaLaSPc
vQx9BCizazrD3FfiCjeeBb5LCGq2r46yRXDm1tQKU3xICy4fyoJWqhUIR92+XNpB
lr6ljojU9TgAWfzVnifRPZPbfjo2CEwpME1AhB+QuXnqfXWREV/YXq5HjwD6a8x+
pc2Bp8pLanhrbfYJEDkLkZpFkVrYOs6KYxo80Aqb+tPPhfL3u84XePxlebU/58wH
KuVxbIoTgVrmHN5DhWWLXYtbiAylmduztYWLRFqmIusb4Tdoqmf1IjLUq9ap+whn
WA/688mebjIsBNr7YRPC38Tl6QG3Ha1PHUBG6m4Dvp9updLnBZTvbik2uBmK9lPL
P27tUGo55pWnHaxeirQX+sLc5cHgJEX5Gijm1wBvrjVmGuUPrufJEJOJNbuRe62T
7CrVSzVcgQ4=
=XXq7
-----END PGP SIGNATURE-----

--=-KO9OozZ4crC1pySAy5AX--
