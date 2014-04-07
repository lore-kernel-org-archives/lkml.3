Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaDGM1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:27:13 -0400
Received: from ozlabs.org ([203.10.76.45]:46788 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbaDGM1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:27:10 -0400
Date: Mon, 7 Apr 2014 22:27:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Layton <jlayton@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [GIT PULL] please pull file locking changes for 3.15
Message-Id: <20140407222702.9773d7369c05918a6f16151f@canb.auug.org.au>
In-Reply-To: <20140407071130.672d7e8e@tlielax.poochiereds.net>
References: <20140331093120.10aeaba6@tlielax.poochiereds.net>
	<CA+55aFy_o-wDrbQSRnrThGqo8mcBS-pVXM6Kj0LqH8PzRr_0Kw@mail.gmail.com>
	<20140404205624.521f67d5@ipyr.poochiereds.net>
	<20140407113706.d213ca01fed70e3367611197@canb.auug.org.au>
	<20140407071130.672d7e8e@tlielax.poochiereds.net>
X-Mailer: Sylpheed 3.4.0 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Apr_2014_22_27_02_+1000_i3=ucyyt1Md+67Ui"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Apr_2014_22_27_02_+1000_i3=ucyyt1Md+67Ui
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

On Mon, 7 Apr 2014 07:11:30 -0400 Jeff Layton <jlayton@redhat.com> wrote:
>
> On Mon, 7 Apr 2014 11:37:06 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > On Fri, 4 Apr 2014 20:56:24 -0400 Jeff Layton <jlayton@redhat.com> wrot=
e:
> > >
> > > Thanks for the feedback and for pulling this in anyway. I'll make sure
> > > to do all of that on subsequent pull requests.
> >=20
> > Also, please don't rebase what you have in linux-next before sending it=
 to
> > Linus (without good reason).  Especially if you then leave the linux-ne=
xt
> > included branch as it was - since that may cause conflicts in my tree
> > (and so I notice the rebase).
>=20
> I don't think I did that though, did I? Both the branches I had in this
> case were based on 3.13-rc1.

OK, so the base stayed the same, but you recommitted all the same patches
(I didn't check to see if the commit messages changed) which due to some
other change caused conflicts in linux-next today :-( Not really a
biggie, but generally, you really shouldn't rewrite your commits just
before sending them to Linus.

> Now that Linus has pulled in the changes, am I OK to rebase the
> branches (or do a pull)?

At this point, you should just reset your next included branch to be in
Linus' tree beyond where Linus merged your tree, then it will be
effectively empty (unless you then add some more patches on top - but at
this point those should only be fixes).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_Apr_2014_22_27_02_+1000_i3=ucyyt1Md+67Ui
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTQpmcAAoJEMDTa8Ir7ZwVkXUP/0E4BoR73QNGnRYh6+2bcZNZ
TR+Ta3NmEy0qbM7Lrsk5a96i1ga8t7elh52b8CgoIURV0X7+bkO7JyVWtISyYXRW
HR5OO2cy0Py9sLzCF3xRKvzofjCu1YPUdRAp2OtdDM44MHIZxWyRdGpxxbuZY99p
Zx1zXmBefVglyCt652u7kcy6hO6v5JWQrXyN+seP77X7IF5O+5XALZlnDGUIja9w
vtb25E2I4XbzzJQLmbb70jTQ6dDDdT9SSh4hyrBadxIcIlts8y1SHhnwPE6jNvJW
NFOvtvjwJTtbqqt4PZMviLTWHI14HhVkfPpU19lrRApM667H6fSvuLHpx+l2nOgp
jutODrh6f/GTe2im0nJUjdqyBZU5zlWZLa41rbJ4xApITmxzLIXqDb+zL510JPKb
KkGozQgxcfbqT/zyKWE3ynFCfCbaUMGydCfADXnaKqD8T/7uitmAVsI38WLYVqQL
uFc+brnMO+dPkIUDfTbSv2ICyqpBJ9c8dee9UMczItQrnhHD44nNzjNrInE/5/Y3
weNoZ6nXqvwfAayH79loJL2l/ZflQQOK6hVdtCXlamvvVknE84xGhOtmvs+J74/e
CEqAllNtAMnUSLB3EKbMv2iRSEq1GPCuS6GscyM2cdZWTnzj6BHh9vVwZkGxxqkN
ffoE7OQq6WfCI7A9mOVE
=V+SF
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Apr_2014_22_27_02_+1000_i3=ucyyt1Md+67Ui--
