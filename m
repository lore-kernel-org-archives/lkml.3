Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbaJ3K7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:59:50 -0400
Received: from ozlabs.org ([103.22.144.67]:52229 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744AbaJ3K7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:59:48 -0400
Date: Thu, 30 Oct 2014 21:59:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: unnecessary merges in the v4l-dvb tree
Message-ID: <20141030215939.5ab46078@canb.auug.org.au>
In-Reply-To: <20141030080934.154ff729@recife.lan>
References: <20141030092445.519a86ba@canb.auug.org.au>
	<20141030080934.154ff729@recife.lan>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/0Qo1J/UNvrq6gTOp686CGsP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0Qo1J/UNvrq6gTOp686CGsP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Thu, 30 Oct 2014 08:09:34 -0200 Mauro Carvalho Chehab <mchehab@infradead=
.org> wrote:
>
> Em Thu, 30 Oct 2014 09:24:45 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> escreveu:
>=20
> > The only ways I know around this is to either merge the commit
> > associated with the tag or do a (hard) reset to the tag.
>=20
> A hard reset to the tag would likely be a bad idea, as it would break
> the sub-maintainers trees that are based on my tree.

I should have said that I don't expect you to change your tree at the
moment, just for that reason.  But maybe next time.

> I generally use "git pull" for that, as the man page says that the
> default behavior is to do fast forward:
>        "--ff
>            When the merge resolves as a fast-forward, only update
> 	   the branch pointer, without creating a merge commit.=20
> 	   This is the default behavior."
>=20
> It seems that the man page is then outdated for signed tags, or,
> eventually, we need to make --ff explicit on this case.

I think that --ff overrides this behaviour.  Doing "git merge
'<tag>^{}'" works, but you can't use that with "git pull".

> I'll try the approach of merging the associated commit next time,
> but this is something that it is easy to forget.

I don't think it is a really big problem but it would be nicer for
everyone.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/0Qo1J/UNvrq6gTOp686CGsP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUUhohAAoJEMDTa8Ir7ZwV87YP/Ah97/AsB2Lg6H4X1eULzYtR
kfHepUKbI+F/8b+mXZSey8Nn+APDhSiaT8Q1L1dra607wEYeDfGIdTgNFlsrW5Bq
5qSJBE6FTtzenyZ01zx5vQzvadand8eENp7Zn4Mrqa37BG3sfWRBLlqRuhBXYi82
YWppNenfev65ySQjNRHFWk/43VVYJ9okwhMsIPwjBw+FcVnVGzVH+tOKLEZvqhwj
zSCvpVqN5ZBtqMV3Qo4bdPbRYJAxBEJjiky8LTHP+jX1yWNQCRKiNjnsjDt2ZnFJ
Dh7erpvIgEc8JHfVitFmp3j5BY8tGP/y72Yu5aXQn5QKwDvWoStz5huE5jZe+sKD
xOkt/YndmuHN8rsTc3W3UMhLMF3n5vlqBTWMzjvxn61ianyE0Kvc6fWnsaZH2nr6
EbsqdIq6LvjWoBISeZ1U/I8cNLZM6Ig7rMwz3uTVQ4ha4XNdixn0/VmxYsP5QIuw
k+NX6O+qSRV7sX9ZI92Oy0cnZCKYewus5RbGLmnG48hCAf4c0dOoiNh/lMRcVIKp
DkUGE7zrJLejEBXBNZrHwnjIF406DxQCc5fb44Mxrkue07cFjPJ8V7xFmkZIt3ZS
9mTR8voJDId8n/ZKjk3us/xUs1NMlcs9M4GJQOJlZf/u6o6Ob4wn/F3rMqfVZVnn
GVCbENF9dEXWPCPvDr5k
=aLHg
-----END PGP SIGNATURE-----

--Sig_/0Qo1J/UNvrq6gTOp686CGsP--
