Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3FXXlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:41:02 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39567 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3FXXlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:41:00 -0400
Date: Tue, 25 Jun 2013 09:40:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Peng Tao <bergwolf@gmail.com>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (staging tree related)
Message-Id: <20130625094051.b9cf8f8950eeeeed0dd266b2@canb.auug.org.au>
In-Reply-To: <20130624224035.GD24099@kroah.com>
References: <20130619181031.8b53acc44466ba70a47e1fcd@canb.auug.org.au>
	<CA+a=Yy4z-ufq2GEtzC17TBbrNGWv6ZUzuVe=VLBH48Df=3HZxA@mail.gmail.com>
	<20130624224035.GD24099@kroah.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Jun_2013_09_40_51_+1000_kwEhSuMHj_gi3Q4M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Jun_2013_09_40_51_+1000_kwEhSuMHj_gi3Q4M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 24 Jun 2013 15:40:35 -0700 Greg KH <greg@kroah.com> wrote:
>
> We are running out of time, my tree is pretty much closed for 3.11 now,
> should I just disable the build of this module for 3.11?

That's what I've been doing - it has never been enabled in a final
linux-next release.  So, it should probably just be disabled properly.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Jun_2013_09_40_51_+1000_kwEhSuMHj_gi3Q4M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRyNkHAAoJEECxmPOUX5FELywP/RoXUr9Kj0vf587TPzgUxeFk
fJOy740UUs0MGZ7tqQclzIKCataAd0Tyx/u/c7fMJM1d01r80iPZDTZaaV1p6Ew0
WNerHdbfaHEcT0ihsT4XPzFoN7ggUBLb4OaA2hhOQa+SaAr5y/zz9CqFw3c3PYrg
VtT2s241alvgqkPAf3vt1RkuIeWcXL7nKyp01Gfw+s5bghyZ8z+YxwHigmnwkrrL
nS+VbZAVTgykUZfiBFeckpFBUxCWxygCHJkPuvQvbWrwu53mAwo4Atkv4l013RNC
5uHlNTlFhYOn2kh02u4vnSeMvWji36tlnze+2tusM4Z96ZWV4iHZnesDUeeYEGUd
p0l+ysCl/t0ESyLFySEM38XMCACzJbyZAv+ckx4Xnk820nfwj4WkKRYMeLbG9qQF
I3X9OB5WFW8MLshUl9g0V1A8+xDgW8b57WfCu7rWh3rO1zfhUPkv6qJbNmJdcypR
1KiuonqvD+lNlGmcWQ8MTNtsG5x9uOUQPe4wVL4e10okj8+mgZalMY8mJH/BL0F2
gf2PBMxwt7opWpoLEVLEBXrbebrqeEeovjJPopJoLsZmeS4cHibNpcAfWn6mf2Wz
wcr0d17xPFtI3sKYbp/Z/tLQpxMpsAuQMc5doCmykUD9fU24E5uaEaGTcr6aODke
pFUbIqdFwDCRHSl7dgiv
=I1XW
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Jun_2013_09_40_51_+1000_kwEhSuMHj_gi3Q4M--
