Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaHLW7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 18:59:19 -0400
Received: from ozlabs.org ([103.22.144.67]:39751 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaHLW7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 18:59:18 -0400
Date: Wed, 13 Aug 2014 08:59:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Chinner <david@fromorbit.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [GIT PULL] xfs: updates for 3.17-rc1
Message-ID: <20140813085911.53e5fbd5@canb.auug.org.au>
In-Reply-To: <20140812215344.GY20518@dastard>
References: <20140812125313.GX20518@dastard>
	<20140812235612.684a9af7@canb.auug.org.au>
	<20140812215344.GY20518@dastard>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1YyK36QbUd5rdgnKeGq9nH6"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1YyK36QbUd5rdgnKeGq9nH6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 13 Aug 2014 07:53:44 +1000 Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Aug 12, 2014 at 11:56:12PM +1000, Stephen Rothwell wrote:
> >=20
> > On Tue, 12 Aug 2014 22:53:13 +1000 Dave Chinner <david@fromorbit.com> w=
rote:
> > >
> > > FYI, this will be the last pull request I will send you from a tree
> > > on oss.sgi.com. I'm moving everything XFS related over to kernel.org
> > > so future pull requests should come from there.
> >=20
> > Please let me know when you have the new tree set up so I can change
> > where I fetch from.
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git for-next

OK, I have switched starting today.

> It should be identical to the xfs tree you are pulling from
> oss.sgi.com.

Yep, it is.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/1YyK36QbUd5rdgnKeGq9nH6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT6pxEAAoJEMDTa8Ir7ZwVAgYQAIc2j31HcOScP1IyQxqPxGTc
ZhM/fjZplQVmi6aWu1QTNhVSsaxp3pAXMfFp2NgY8YqRBV4TqGeeAmhpajScoBA/
eB39G8lBliESfghGuz3hHTFFVJ0qgZPTJi1l/zf+BCwTZ/P8klKzoRKWPJQC+Sag
drx6s4/C/UinjLg9QkD3bPE+KRWhh+GFaoaIOl82xYQlDsHNCkBl5ofFp8UDJecg
Hu8zyVKVrFqYpT7tvVCf3YB5cFxu2rCeH3FjF+cX/K1eu1pV8iqq+HHmZks2Jni5
4hTMCluWrO1TVL0kfwBJRveoSUHK0gt0ZIq+RVH/TtH9fzsl8VW9wY29sr8SdDga
8Hs2wcLL5WFnomeInxL0Ouzm7FnMkVZi088K0tVnQGpIaLG0jBoAo1j1j3NMuqro
1iP+ehG8WrT/kGYIJhLwD+9DH/gzIDlrS8Q6DKiPLQL2w0pWhxFyhv5TqN+0QmCG
yfkTe9PnmPzo+CTDiuYYR8lM/WtUw4UeMf4rxooUs5ygPApl7epl5UeuHwt8Mnjd
PDCEZSHWYYfGFfyXH941bZOw3inlHJpNTptpjfZpZz8gnwaJPDx0GLa7eFLGXtOM
mHlkXZosCFlBvzC0ialekR5nQUh9xMN6ScFUrzhHAMyreKCEhfdbXYy+MmGtHS3c
WO5McYkEr2aw9c3K04yB
=uxmt
-----END PGP SIGNATURE-----

--Sig_/1YyK36QbUd5rdgnKeGq9nH6--
