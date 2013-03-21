Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab3CUWyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:54:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44033 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab3CUWyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:54:36 -0400
Date: Fri, 22 Mar 2013 09:54:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
        Jiri Slaby <jslaby@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-Id: <20130322095423.799b201fd0f6671e8127c2ac@canb.auug.org.au>
In-Reply-To: <20130321001628.GC27981@kroah.com>
References: <5149D1FD.90400@suse.cz>
	<20130320151511.170EC8017A@viridian.itc.virginia.edu>
	<20130321001628.GC27981@kroah.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Mar_2013_09_54_23_+1100_0Ba.XP8ggyZ9BPSI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Mar_2013_09_54_23_+1100_0Ba.XP8ggyZ9BPSI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 20 Mar 2013 17:16:28 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Wed, Mar 20, 2013 at 11:15:11AM -0400, Bill Pemberton wrote:
> > Jiri Slaby writes:
> > >=20
> > > On 03/20/2013 03:42 PM, Bill Pemberton wrote:
> > >=20
> > > Asking Greg to revert should suffice. I commented on that patch, but =
in
> > > a different thread, so Greg missed the comment the patch is not needed
> > > IIRC. What was the title of the patch, I cannot find it immediately :=
/?
> >=20
> > "USB: quatech2: only write to the tty if the port is open." (commit
> > 27b351c in v3.9-rc3).
>=20
> I've now reverted this, so it should be ok.

That patch needed to be reverted in your tty tree, not your usb tree
since it breaks a patch added to your tty tree (see Subject).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__22_Mar_2013_09_54_23_+1100_0Ba.XP8ggyZ9BPSI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRS4+fAAoJEECxmPOUX5FEScQP/iciMGso1KV3fHdBCGzwUO40
H3B8c+QGXLjmvp06+dLO6ol8kzxGGNNhoL+/vMM1bCwXrDQOIwlryFhFnOoWuHTA
fWXXpxZesbkHvwUQkstVMsIT73ibn8hV0RJezgeGclFL7XlG1sBmW1/sJBFby3Fu
ZrMQLI8V1CtRr5sNhKvbmDSh6Id7K6BPLq3sxQK+AH1TGoIiJJo9cH8V3glqN4cs
va5rlBDNjZ5PkpJpC4HRWZRRrjI2NJ1sBqAWX8MfygcDCayCFSK0EdHuso3yBFZs
Kwg3Lig3nzZr/aMTGUCbM7hoa1mdtBXYmEBu7Zq3rD9jhLZsgsGqWbFKKFv1nwut
19VMOvhias3eqqYRumryN+vX2UMdaQJ8RM0PnuKAT0aCSVbaufOVGmuj3nv+TfOP
YObt9b4IYS5wvrKKjaqjRnEhZO5gVCxNBySPM3zq/FGTPDQscBL6SL8niPsbAK5O
WFpbxah1Dy3xltV4YWZp3re9MqbtOo6ewoMo+LCBrfFcsl2mqNpFKhAOKVMym5MK
5O1RDTLWPuPh7UykEWd9GJRhLvkTG97RBurWjifiXfFnVuldIzDDgu0IQb/7p2H8
tNCrMP3MNI7tteu/yoeejI7DqGpqhui+Y4MA+Ng/DmKTWbplLj1ZpdHpGKgCZdKk
piytPn6lN9ll5qsaMSMC
=9DpX
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Mar_2013_09_54_23_+1100_0Ba.XP8ggyZ9BPSI--
