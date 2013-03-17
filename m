Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab3CQXpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 19:45:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37630 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768Ab3CQXpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 19:45:31 -0400
Date: Mon, 18 Mar 2013 10:45:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: New MFD tree for linux-next
Message-Id: <20130318104520.06b6a22c577be324880a4d06@canb.auug.org.au>
In-Reply-To: <20130317233907.GB4809@zurbaran>
References: <20130314000201.GA4425@zurbaran>
	<20130315164625.GA29531@zurbaran>
	<20130316132753.591db4c078d06db297ba46a8@canb.auug.org.au>
	<20130317233907.GB4809@zurbaran>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Mar_2013_10_45_20_+1100_V0cyH=C=D=WQsG8N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Mar_2013_10_45_20_+1100_V0cyH=C=D=WQsG8N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

On Mon, 18 Mar 2013 00:39:07 +0100 Samuel Ortiz <sameo@linux.intel.com> wro=
te:
>
> > I assume that you are still using the for-next branch?
> I will update for-next branch to be in sync with mfd-next until the 3.10 =
merge
> window closes. After that I'll probably delete the mfd-2.6.git tree.

I meant "I assume that I should still fetch the for-next branch
of ...sameo/mfd-next.git".  If that has changed, please let me know.

> > What branch should I use of that?
> Ah, I didn't see that the remote tree still carries the mfd-2.6 branches,=
 I'll
> remove them.
> Please use master.

OK.  I will do that from tomorrow.

> > BTW, those two trees look very similar (in fact "diff -u <(git ls-remote
> > mfd) <(git ls-remote mfd-fixes)" only shows a couple of differences in
> > all the refs).  You do realise that I can use 2 different branches of o=
ne
> > tree, right (as can others)?
> I understand that :) But using 2 trees rather than 2 separate branches is=
 more
> convenient to my personal workflow.

No worries.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__18_Mar_2013_10_45_20_+1100_V0cyH=C=D=WQsG8N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRRlWQAAoJEECxmPOUX5FEwIsP/1nQPiPIOdayPOhDUaPs5ODR
O0ATYi+KM9zjD+cEWUpkavdNpr52E1ydLZiAKnPmB/kqq7aqcDAlhGZX3OCQdkhB
s2QjCc5hmC7fjV8KX4QinwhyuAh/ofoGFiPLAaIBnuVAPYYEpiKnn1eUHSS9uxaf
3TchN3dmwkZe30uCjYlgmjIlbKX/kjQNK1mQryEBWJA1L0dlPumNCtPZgyZOAtbQ
us6g4rphRQYWNEmg7CuM3yESOA/SZTILhBmjm8fvLBtKFrPMaGQI6IyfcQd/V4Ol
Jrj1G/oeTih/IBmBeNgliUtj9P1wUd75kvhdF1uw7E86pYMpDnidlFQuOjZtYYqF
3iwB5plDaNGU0zC4AzVE2G/L1J+yYU04vMuzbykOemfs4LZXswcQukRrk9ks2bOM
ACVGr2+F/MkKv4HrCI7UZ1RJRzuvdOQDfBysh1xuINnHxMwyhbhSbVfUkdk1nuA1
Kr0BA2GY+MyDPctXZ/ahlZ2WZVqB8D1IzAkX3NPXnEZOUdNzszQF5WyMwl9jrnlK
P3j8ItZbNWj9A+oJo0dNvZFovrGlfrCx+CcgBePAwHfYv+KY8WvkCwrA23lP2a+f
wNjwSyvXRdbwGLXZnHhOOsww3Tb3SH6hxmB5Li8Tg8OrD+qyP2nWryO2swrCvSyZ
pGODFigFzvsQchEvp51x
=viGK
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Mar_2013_10_45_20_+1100_V0cyH=C=D=WQsG8N--
