Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab3BSCCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:02:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47877 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027Ab3BSCB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:01:59 -0500
Date: Tue, 19 Feb 2013 13:01:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the drm-intel tree
Message-Id: <20130219130149.a3762b8a2f38879d3e0e6243@canb.auug.org.au>
In-Reply-To: <20130215081626.6cbb2e74@jbarnes-desktop>
References: <20130215133714.6f55139ad1a037b7b9fa1b70@canb.auug.org.au>
	<CAKMK7uGG4R68ED4M1uYRUZAhxRMzao0vk9oFg_vxZ8ofhx1=yw@mail.gmail.com>
	<20130215081626.6cbb2e74@jbarnes-desktop>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Feb_2013_13_01_49_+1100_MrUVldn9EGF7b8Jk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Feb_2013_13_01_49_+1100_MrUVldn9EGF7b8Jk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Fri, 15 Feb 2013 08:16:26 -0800 Jesse Barnes <jbarnes@virtuousgeek.org> =
wrote:
>
> On Fri, 15 Feb 2013 10:30:16 +0100
> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>=20
> > On Fri, Feb 15, 2013 at 3:37 AM, Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> > >
> > > After merging the drm-intel tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > >
> > > ERROR: "pm_vt_switch_unregister" [drivers/video/fb.ko] undefined!
> > >
> > > I have dropped the tree for today.
> >=20
> > Meh, that fail was already reported from Wu's kernel builder a few
> > days ago, but no patch yet showed up to fix things. Since the i915
> > side of that work isn't ready yet either I've dropped the offending
> > patches.
>=20
> I sent a patch yesterday for this.  I'll bounce it over again.

I am still getting that build failure.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__19_Feb_2013_13_01_49_+1100_MrUVldn9EGF7b8Jk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRIt0NAAoJEECxmPOUX5FEV8cP/02gjDo1iZ2sDfzxWCdSSKgy
klRFZf0Y6/8ipsDSdLeRN2MSu9JmsrthHvH+dlqPxlWmsAGV+bAUDTxL2Kd5Mq/z
WQN73qtiVNaiWSSQKA5dgv1Z1awrOu/5hXYyqdMPto/HP8N7AaKhvqJlO1t9/YB2
2z3BAY/9EUY4jMHcj9LrIgQ7OmED+qZz3HpOBNQAF7ptvrvkzOV8V6v6ifPUqvmI
WaZ55VtnxGnh6V8ndCV/IwQRiuNIkTZkYa17HYxt0kRtDt7FQd31Xbz+rcTHmHD7
Mh0DGQeqWIYo8KWJpYS3lh64z0aSNZj4rUtUC/sMBeM8aPxPE54d4YT9ND1cIWyD
tgkWTUeM1UssVZUZCWrXtt4r4EsFQhMGlnzQP2IGq1T+M3/6DIjBKHDqFIxC8Loz
wsWwapuohLvfm/zuvBrnIPaKRj4jbDf6yCrtAi3+x7JxSvHBmI/aqwtypwdW8XVn
OzamX04FEFkHeH6oNyXn13ZvjeR4rTDakrz+OvrhXq1pCC6aPekFf3rM5NM2mlVM
QushcSQlm2XUsmvttYRXvaPGxm+CIi8WIaQnJYkXYKzfZlb1Zjfp/E9Igj6W5ni3
2UUqi9gw2+U3GrOTX6LVyWqhFvTomAuuVC8UnpnDO6WG6odgyTH6IDOPa+nbJ6xv
yEplGlechG545bNqAvkX
=w4Yt
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Feb_2013_13_01_49_+1100_MrUVldn9EGF7b8Jk--
