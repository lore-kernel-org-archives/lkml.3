Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaATDve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 22:51:34 -0500
Received: from ozlabs.org ([203.10.76.45]:47019 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbaATDvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 22:51:32 -0500
Date: Mon, 20 Jan 2014 14:51:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Galbraith <bitbucket@online.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Message-Id: <20140120145122.a95b3e3a17d20117214098ca@canb.auug.org.au>
In-Reply-To: <1390038366.5676.10.camel@marge.simpson.net>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
	<20140116121955.GQ31570@twins.programming.kicks-ass.net>
	<20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
	<20140116222536.GX30183@twins.programming.kicks-ass.net>
	<20140117093426.ee8e3d1bb2e95c9f67ec625b@canb.auug.org.au>
	<52D8625C.1000902@zytor.com>
	<20140117144518.231fa4bccb16a8d7edd36662@canb.auug.org.au>
	<1390038366.5676.10.camel@marge.simpson.net>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_Jan_2014_14_51_22_+1100_5CvgZpkNG=6+aFBy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Jan_2014_14_51_22_+1100_5CvgZpkNG=6+aFBy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 18 Jan 2014 10:46:06 +0100 Mike Galbraith <bitbucket@online.de> wro=
te:
>
> I hope it doesn't look quite like that, next-20140117 is -ENOBOOT on
> Q6600 box.  See below for an alternative.
>=20
> idle: kill unnecessary mwait_idle() resched IPIs

OK, so despite even further discussion, I have applied this as a merge
fix patch for today.  Let me know when it is all sorted out.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__20_Jan_2014_14_51_22_+1100_5CvgZpkNG=6+aFBy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3J1CAAoJEMDTa8Ir7ZwV3NwP/0SHXUcoYXWAqfIEYKfUSPck
rQjRXuJlXK+FJgE1HPcEq6yOsZ0PKC6kdmWi9ZkBGdUud1THWQxebkW6r3QMGMBq
jAbeCDMXH6l8kSDobu3u0Yekckm1yg5qQDTSuXM1xSo2AcG4yo3PXB3/NtiQCCj0
urMFp5UADlLPkUIrS1X4EClNuGTwStkibMEfw5/2VsCiTJWBMxNRzvM0CqHdeMI9
L0qWo/kYPGiZvGOaq4ol+TImEDFJsdcri3YWYflHjHzE/PTUg2Kt8j71kqr0Zg6F
7uiJlCmcmGLpxt/puU8LVBSAwziqSqQL5WAWuLCU+vsDH/mH7Ynm8xe0/2fsY/8c
Re4YN6MLFFcghBTyORwUkAoyin6QGEkrPO6eBtqW+89t/luE2r2yCaYmZSiXNvKe
dFjFCBRZKmFDj1o3+iyF4zIWLXStcALqxbYLHO9CtytvBg6SpOhOx2exbf81ZQ1m
4hNhxe9dMjhT851KXGuFd/O11+ph0AkhTC7zdlCA3BCiWlbF/atfw0spkh7Q5KCN
oiCXrtnNsFIP3JkldAVejd5+jJVkAHhZQgDIeA1ELKSVOgiHO1+nNUMB1rV8ddUU
szuTPP7J3yw15mpJ8j9BYCzDo60n4PvJSOgBJUvOzPG7gZ3wxAgbWPyr3wy1RfPL
O6SNRjaxV4VN8aSOiXYC
=hzEF
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Jan_2014_14_51_22_+1100_5CvgZpkNG=6+aFBy--
