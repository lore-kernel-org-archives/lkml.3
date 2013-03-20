Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab3CTWJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:09:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42273 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab3CTWJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:09:40 -0400
Date: Thu, 21 Mar 2013 09:09:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (cgroup
 tree related)
Message-Id: <20130321090938.f40b9e66276d295e8d6a3ea8@canb.auug.org.au>
In-Reply-To: <20130320145135.GV3042@htj.dyndns.org>
References: <20130313161236.760c25633a4e8ea8d4847ccb@canb.auug.org.au>
	<51401DAB.1070602@huawei.com>
	<20130320154328.4b164061f7a58af5fb3f62e4@canb.auug.org.au>
	<20130320145135.GV3042@htj.dyndns.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Mar_2013_09_09_38_+1100_+MkQJp4LB_L3qApw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Mar_2013_09_09_38_+1100_+MkQJp4LB_L3qApw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Wed, 20 Mar 2013 07:51:35 -0700 Tejun Heo <tj@kernel.org> wrote:
>
> On Wed, Mar 20, 2013 at 03:43:28PM +1100, Stephen Rothwell wrote:
> > It has returned today.  Please be more careful.
> >=20
> > In file included from include/linux/memcontrol.h:22:0,
> >                  from include/linux/swap.h:8,
> >                  from include/linux/suspend.h:4,
> >                  from arch/powerpc/kernel/asm-offsets.c:24:
> > include/linux/cgroup.h:742:13: warning: 'struct cgroupstats' declared i=
nside parameter list [enabled by default]
> > include/linux/cgroup.h:742:13: warning: its scope is only this definiti=
on or declaration, which is probably not what you want [enabled by default]
> >=20
> > I have reverted commit c2c9ad164fa3 ("cgroup: remove unneeded includes
> > from cgroup.h") for today.
>=20
> Oops, my bad.  I mistakenly reverted the original commit from
> for-next, not for-3.10 and got confused after applying more patches on
> top.  Fixed up now.

There has been no change to the cgroup tree
(git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git#for-next).
Forgot to push?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Mar_2013_09_09_38_+1100_+MkQJp4LB_L3qApw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSjOiAAoJEECxmPOUX5FErKsQAIH+3NbLlobBBtWjpXXMMZ0s
k4jw2YyKwrfpR0zhIwYZSlvmhlxDndiMVQvosfIoNEG0Ux3nqMvtSmRht6DP9bWX
RLg4ceiGad6SRY86zX5uYjZFjE+K1BK/pyfRWneED4WFOsGoo1iIqr2ibtRmBW+P
b6d1WJcoTIMKoA7L5l+3sG+cSIca06ugTStNqRzeRVO3NPWgB/I53WBsJAez03oz
m+QVU/eL2HhxljKHGQKvkEXkpHoNfkmxqW1FpObKv4NiSwthnAK+Q1OV/pbBJrUv
xIoxGVvAOU8gg1xVAE3fOwrx49Wo6p+uU90wNQejSyg8WM+8gIWVnSqMLXHkqgSe
uo5QLRnoFVBerJW25oeqw1aG6ZG/gtMU0ojwtYNIoWrezvzReHGhw9A2LrZRMzWZ
kN8vMYBjKrI9n4hG+zUMJI/cokpHPjR8UIc9CyyKt2Sj7AbMbOWZnC/uGGGKb/YC
b/amD1Xtm8I+SiKnCqMi8SG7mAt/lBO2sGe9EDpaDdIcDUYLDznW9znhJZFKcdZh
yO/Z7gCjPjuOJmWyImQLHrYiXjXOWxXJdIkKihywuZKkgdZraXvESypL/qJFo0zH
WzSADv9RCrPdcOzJIJlWkG0rgeJJTgzAsRPhevHARiLZ/Cg4xj8n5R+5gO0kByBN
WYM+QDIvZqRow1CkpNDm
=bxIw
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Mar_2013_09_09_38_+1100_+MkQJp4LB_L3qApw--
