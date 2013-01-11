Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3AKA4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 19:56:20 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58480 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3AKA4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 19:56:18 -0500
Date: Fri, 11 Jan 2013 11:56:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: please cleanup the cpuidle tree
Message-Id: <20130111115608.dffec30f37e42a8f15a3f117@canb.auug.org.au>
In-Reply-To: <20130108102227.19d4102cb1ddf516ad4082d1@canb.auug.org.au>
References: <20130108092751.4bd60a67280e284369553c18@canb.auug.org.au>
	<50EB5636.4080705@linaro.org>
	<20130108102227.19d4102cb1ddf516ad4082d1@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Jan_2013_11_56_08_+1100_eGTcyFv0JR9g9Sw."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Jan_2013_11_56_08_+1100_eGTcyFv0JR9g9Sw.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Tue, 8 Jan 2013 10:22:27 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Tue, 08 Jan 2013 00:11:50 +0100 Daniel Lezcano <daniel.lezcano@linaro.=
org> wrote:
> >
> > On 01/07/2013 11:27 PM, Stephen Rothwell wrote:
> > >=20
> > > All the commits in the cpuidle tree have been included upstream before
> > > v3.6-rc1.  They were rewritten before being merged upstream and so are
> > > now causing merge conflicts in linux-next.  Could you please reset the
> > > head of your tree
> > > (git://git.linaro.org/people/dlezcano/cpuidle-next.git#cpuidle-next) =
to
> > > be somewhere in the tree that yours is merged into (pm or Linus').
> >=20
> > Sure. I believe it is done now.
>=20
> Yep, thanks.

Unfortunately, you reset your tree to be a version of the pm tree that has
now been rebased :-(  This is now causing more conflicts in linux-next.
Maybe you should reset your tree to be the same as one of Linus' -rc
releases for now.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__11_Jan_2013_11_56_08_+1100_eGTcyFv0JR9g9Sw.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ72MoAAoJEECxmPOUX5FEKsIP/RWRjf+BORnS0pR/uRxTK4Z+
G3qP0thizEjY9rIN+PCaOnOttYhLhoSu31x6r+djmUf3FxLpoSs7Ej33PX/R9IjJ
cK52KCxE/mfUWFiTu8VRJEJ3RM/pPNvPZacWMK0ui8XlMOymQ86ssuFBGqBTkKsg
EJrlJbFbS2hHh6kw4MhnEoB63iSsnmKhlZPRwRemhy7ZCiuVZagkQpSuSDefRS5X
K9FtyzDlCpIE0ZL7R35BEnuhcP2Y3unBnv9BejcW6pigVFGw1gW5jCz1EwuT8sLn
7Zwm7XRKwH2ZBbsS/4X3kpzfymJnVKzMI5787MBfq+rg6cEdlyOSSz+Epfmxo9oo
yNx6DckeST6wGgVd3N3Lw+PyE/bcTvX/MU6DMFwshNa23cVD3peaHdZXM9x4Ih86
eT1JY7fW5gzWXZofBgor7CGDg2PcbloSGTIVI6e3hthiyb5qG3ij8rPlIerWb+XN
wSfTCMnF0zJKjzWJnP0RDgJfBgkp3T7RFCekwbe8Owrp9tFts9TY2wfqPB3vU7tB
q9SCBXT/8ZrRk4ctryxAxuRSaUZVqy48nkzYGavYlRcbnOWpKUg094hfd+ESHgzp
bOXTMg0ACyjBZNWhVMxChzkB3cFvjqnA8GKZNqVTGO7kwAODjIDVw5BoXGWpBHqV
bo8PeyShFHL6yi7+FLvu
=h8mv
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Jan_2013_11_56_08_+1100_eGTcyFv0JR9g9Sw.--
