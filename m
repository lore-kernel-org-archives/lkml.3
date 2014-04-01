Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaDANLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:11:42 -0400
Received: from ozlabs.org ([203.10.76.45]:53820 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbaDANLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:11:39 -0400
Date: Wed, 2 Apr 2014 00:11:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the audit tree with Linus' tree
Message-Id: <20140402001132.95744f11fce5fe34373b2356@canb.auug.org.au>
In-Reply-To: <20140401125413.GB21711@madcap2.tricolour.ca>
References: <20140401150721.1e9d4e6c36660d5411c10f37@canb.auug.org.au>
	<20140401125413.GB21711@madcap2.tricolour.ca>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_Apr_2014_00_11_32_+1100_2w2BjzUtU060KwrX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Apr_2014_00_11_32_+1100_2w2BjzUtU060KwrX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Tue, 1 Apr 2014 08:54:13 -0400 Richard Guy Briggs <rgb@redhat.com> wrote:
>
> > [Eric: that audit tree commit has no Signed-off-by from you even though
> > you committed it ... there are a few like that]
>=20
> I added my Signed-off to the list posting.

The point is that Eric (Paris) committed your patch to his "audit" tree
(at least the commit in his tree indicates that he was the committer) and
(presumably) will ask Linus to pull his tree, but did not add his
Signed-off-by to the commit (which he should have done).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__2_Apr_2014_00_11_32_+1100_2w2BjzUtU060KwrX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTOrsKAAoJEMDTa8Ir7ZwVgqEP/03PdDQwMg1ZxGbIpFlSenwN
Csts8XB0IRGBKj6ZPaCRfZQmOde9ZEsqexpvYppIPVfJTxDjo2p98gMoPISOcLMh
GvDQQCOsh3/7ae0vPDjyC/UFxxInTvaZ7z3h24VufXDcOmYbg0MuUs7HBkqo6/18
FuZibm0zTD9OzHFJP1IsLqOsPmzuQC/YiP3RuDJ1PZS2jXa4HupCHbYrCNi+Muf1
PRfej5KpVkxxdKOxkkk+78MONB5FFxB4kgmTkV6NZGmcjevNfCi7iEMZztqKMb5k
Xp0NbaLa5lLJJVxRrKaV8mibcSgKcNlwnqw10A6fbuI8882RBU3NhyF+ilHS9Sns
3r90w0VZfDmpW+dyp+SPFCpmjvv2ZVJr8T4T8XycaTX97zn39uE+xW0RtzYv1QHJ
CgiF8Lhe0vK4qZS7oxFjImxcwiYIKx9LP1N+5mpxRCYbkrRjl10eJ+fV6e/tetL6
o4Z47Ss+GbIaWybE4xOEApsIbwj4iuSTQ1jbGJib4Q9pbQYHOfL2e0Q7NPDbtj2m
FM33/RWen9yCfHwXozxXfRdDfV2SblcmnVmAb3RW/kUk+q44CDb9ptnKt3YFANcj
IDfOivuhleUGo9rP0S8SdjHGi0eI+0BwfK7PNjxRnDcw7Esh+skZbDHOv3QtFJmf
CUFjX0d51up5044C2BSS
=4jnE
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Apr_2014_00_11_32_+1100_2w2BjzUtU060KwrX--
