Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab3GRFYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 01:24:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35387 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3GRFYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 01:24:12 -0400
Date: Thu, 18 Jul 2013 15:24:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Phase 2 of __cpuinit removal
Message-Id: <20130718152404.4148e4ae5ad91ca9791f814c@canb.auug.org.au>
In-Reply-To: <20130715145735.GA23381@windriver.com>
References: <20130702174402.GA21817@windriver.com>
	<20130715145735.GA23381@windriver.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Jul_2013_15_24_04_+1000_rqsWz8nYvauN5+2c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Jul_2013_15_24_04_+1000_rqsWz8nYvauN5+2c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 15 Jul 2013 10:57:35 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> Please pull the following to get phase two of the __cpuinit removal.
>=20
> With the __cpuinit infrastructure removed earlier, this group of commits
> only removes the function/data tagging that was done with the various
> (now no-op) __cpuinit related prefixes.
>=20
> Now that the dust has settled with yesterday's v3.11-rc1, there hopefully
> shouldn't be any new users leaking back in tree, but I think we can leave
> the harmless no-op stubs there for a release as a courtesy to those who
> still have out of tree stuff and weren't paying attention.
>=20
> Although the commits are against the recent tag to allow for minor context
> refreshes for things like yesterday's v3.11-rc1~ slab content, the patches
> have been largely unchanged for weeks, aside from such trivial updates.=20
>=20
> For detail junkies, the largely boring and mostly irrelevant history of
> the patches can be viewed at:
>=20
>  http://git.kernel.org/cgit/linux/kernel/git/paulg/cpuinit-delete.git
>=20
> If nothing else, I guess it does at least demonstrate the level of
> involvement required to shepherd such a treewide change to completion.
>=20
> This is the same repository of patches that has been applied to the
> end of the daily linux-next branches for the past several weeks.
>=20
> The branch below represents a direct "git am" of the above patch repo
> (that is similarly tagged with v3.11-rc1) to mainline's v3.11-rc1.

It would be good if this could go in soon as I am already seeing (so far
trivial) conflicts against some of these.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__18_Jul_2013_15_24_04_+1000_rqsWz8nYvauN5+2c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR53v4AAoJEECxmPOUX5FE1ZAQAJJORnF1ujZJziADkk0l/kdQ
WCNOAYZHEgVsbgJAkwMrZ/t+EdE0s9RlLJEo1MNFRSZ3Hej2pKx90+0RVZg8RoAS
wRFVp6uz+9QNJjay4h6XauSFaxAPlnzGRAzarmyg6DfIZvg8Sgvw2CEgyYNIpn2O
thSebuc5PctRZkAwdUkR4iuKgPIenII6Jl80ywYSN/d+jodg++5kLMLbVOOw71y3
8FgPmAuTWXZdukrEEZ/pQSq7D2FBvOq2xOQu2fK/SIZz1f5TRqRqAlN2dGuMtIRo
Zhdq6GspPrFBARBlZIgOpNOOFPt3pMvLjgtqFZSVamESNpDudOOAfND9Isw3veSd
HZ1lkIZMdgWQPnUFcAIZQHuW8YlUDXEBvPXn2+jhWyC8SUzkyFaRg6nPHH8yU3E7
FNkFJqaBTqYZeEHX0yunA6JvWLkNHwHwwi++CuhEOyXpS6/tMRvozY+ts+ufP0WQ
iEprdFyR6lBYhtfi37p0QSjKG+pUPiydhdP1tYtyfxToix2W2HgTztXYUPdN4sZj
l9d/R1mbCjghlKLkadxDSlnS8JYpT/OfHnxvJIYLMXWIr8/d5aP2F8s7Z0P0LiNm
x/FQVxfQRiPtnFOHHdOlWNJoi3KXlw5g4iEOFe/nJhnvVcydFx8oQaIu8q4Y6ETE
5cmB/6yEGNIM4FwUmPwV
=Dujn
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Jul_2013_15_24_04_+1000_rqsWz8nYvauN5+2c--
