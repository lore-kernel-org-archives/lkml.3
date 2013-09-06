Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab3IFDbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 23:31:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36474 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab3IFDbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 23:31:10 -0400
Date: Fri, 6 Sep 2013 13:31:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: back merge of Linus' tree into the vfio tree
Message-Id: <20130906133101.14da90edd4f8c32cf29ce146@canb.auug.org.au>
In-Reply-To: <1378422869.3246.282.camel@ul30vt.home>
References: <20130906090826.947212e7d5383837bff881f5@canb.auug.org.au>
	<1378422869.3246.282.camel@ul30vt.home>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Sep_2013_13_31_01_+1000_=2ZhhLnEUQXl2Jsx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Sep_2013_13_31_01_+1000_=2ZhhLnEUQXl2Jsx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alex,

On Thu, 05 Sep 2013 17:14:29 -0600 Alex Williamson <alex.williamson@redhat.=
com> wrote:
>
> On Fri, 2013-09-06 at 09:08 +1000, Stephen Rothwell wrote:
> >=20
> > I noticed that you have back merged Linus' tree into yours.  Linus
> > usually takes a dim view of that - especially when there is no
> > explanation in the merge commit message.  i.e. you shouldn't to that
> > unless you really need to - and then you should explain why you did it.
>=20
> Hmm, I was hoping that wouldn't be a problem, especially with no
> conflicts in the merge.  I did it because the first commit after the
> merge in my next tree depends on PCI changes that have already been
> merged by Linus.  Re-basing is an even bigger sin and I felt it better
> to do a merge than ask for two pulls or add an unbuild-able commit to my
> next tree.  How do you suggest that I resolve this?

See above ... you should have said all that in the merge commit message.
I guess that you should just own it now and explain it to Linus when you
ask him to pull your tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Sep_2013_13_31_01_+1000_=2ZhhLnEUQXl2Jsx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSKUx5AAoJEECxmPOUX5FErE0QAIdjE5z6ea7tblT5ad017OGn
KCArJEu5y9CngkXF1fUY+lTM38x22VkwB2gvbS3b9mNcK6I23JRrwQN0Epp98wyo
899DjPKk0JC/wXARQ7Tu/2SKMryRaKBHm1Mp010IqLgCPzTsRvlBuCjHQ4hJrHNi
TQe6HZCwPNBQjZMKii7OzAr/tdpgFIZ255uzK4ejJoCoS5mFolSfnL5+9/ivDETA
d7IOmI5HuBQLagNv1oBq+Za4GP5yGZHwvTQWPJuohtYrMNNBvOn3Db3Loly2hVw6
r8w36e7tyzGhbHu2Dx18LZWT8xggjGsCBQEdGjOnk7qN5J8p2TPo0cvXB+0finsK
BBUwmANKij1ezkeu8n1urhWKtiWAd48k+7jTYIp4yQScx/CCIB8Gi9XDfAkMapS0
TcVqZ/jyyEWqRgk44h+y0YGHC5AecsKMMdEykZwNqykfNMvJUslRJnPNhUYOMJLj
PMvmVJPswHvnAoaf0yaqftWnCn6aPGo3TuvatPWEiqr6z+pIgNSw6JWyJ5qBgz4M
gSwWfx4Euc2dYN5dFSciaG9f368C7ZGz3zfg4qxuq4UFXslwE71iGeulKbhm2qlH
TmTg3m7FeXczwra+gacmOzy2PoYnDgZJGsEKf3ZR1yAPEm01TOnqRP01bIHpzyR1
RcHRrAFuGIdmaA9OLbYA
=HkKb
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Sep_2013_13_31_01_+1000_=2ZhhLnEUQXl2Jsx--
