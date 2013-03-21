Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3CUX2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 19:28:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32873 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3CUX2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 19:28:10 -0400
Date: Fri, 22 Mar 2013 10:28:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
        Jiri Slaby <jslaby@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-Id: <20130322102808.5bdd9e5e0d98733e202e49c2@canb.auug.org.au>
In-Reply-To: <20130322095423.799b201fd0f6671e8127c2ac@canb.auug.org.au>
References: <5149D1FD.90400@suse.cz>
	<20130320151511.170EC8017A@viridian.itc.virginia.edu>
	<20130321001628.GC27981@kroah.com>
	<20130322095423.799b201fd0f6671e8127c2ac@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Mar_2013_10_28_08_+1100_NbWBw0/kZnv2VCOb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Mar_2013_10_28_08_+1100_NbWBw0/kZnv2VCOb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Fri, 22 Mar 2013 09:54:23 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Wed, 20 Mar 2013 17:16:28 -0700 Greg KH <greg@kroah.com> wrote:
> >
> > On Wed, Mar 20, 2013 at 11:15:11AM -0400, Bill Pemberton wrote:
> > > Jiri Slaby writes:
> > > >=20
> > > > On 03/20/2013 03:42 PM, Bill Pemberton wrote:
> > > >=20
> > > > Asking Greg to revert should suffice. I commented on that patch, bu=
t in
> > > > a different thread, so Greg missed the comment the patch is not nee=
ded
> > > > IIRC. What was the title of the patch, I cannot find it immediately=
 :/?
> > >=20
> > > "USB: quatech2: only write to the tty if the port is open." (commit
> > > 27b351c in v3.9-rc3).
> >=20
> > I've now reverted this, so it should be ok.
>=20
> That patch needed to be reverted in your tty tree, not your usb tree
> since it breaks a patch added to your tty tree (see Subject).

Except, of course, commit 27b351c is not in your tty tree :-(

I will continue to carry a revert of 27b351c as a merge fix for when I
merge the tty tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__22_Mar_2013_10_28_08_+1100_NbWBw0/kZnv2VCOb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRS5eIAAoJEECxmPOUX5FEzcoQAJktoCLabQlt67ZHYZmzlZQM
7rMx5R1k9os09Ak1jChzpg2cNpkvNCYLa9p4DdRNEQiuCxhcUwx4DyXqd1sEdpBp
gJNWEDTt9dAtjlta4XYse7wv6ic+6DpCVDkeo1P6iX5iI3QMq8kYBLab4XfA44Ph
dxXDNc5XGgJz1Z5e1TkSH6ygSQaAW3hDj+bWK3y009Ad2/Kl+kF7EwDJsbjgrdzT
QqAQxn23R0oqgA1EzfC7cXhMu1T9Zgne97DSamnCalLQpno/g9nt6IPwXbhm0w5V
39RntN6QSTXvzUUsPPbe16TWjjQdYkuy08XTGKW8I55i0geDbuVDu21e1vDfElFX
BOA4HnAyEW6pqn5rBUTMSTamKnyE/O9SpBUwtpIaHWAIjX9g0dCgvb6RJdmojLEy
v7gZVqrSmlUghRAUNPIZdXkupY6CfIDUzupJ0fMX6rUaC/kBhJPKD5BDH6BJbhsc
qNe1g1lIbNsVp32rO8O/vvflxzGRwX73D4aXOrI3NCUJXRyG9P2ubKCSSlUcpxGg
URD3THuDY/2z/3U2mU6hVwY/abMBY7YhKQAYIM9OKZN8VQUNih1jwEVT4rWTQLka
QRS5rWdzV0IpWaWHaWF2eaZmLke2SbbIBBuZB7LSVmesIx6F8aw05LguD57tNMZP
1N1Xb3tKWYMHwW7JZBnZ
=KrZO
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Mar_2013_10_28_08_+1100_NbWBw0/kZnv2VCOb--
