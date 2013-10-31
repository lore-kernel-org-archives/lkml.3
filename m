Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3JaXc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:32:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42489 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3JaXcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:32:23 -0400
Date: Fri, 1 Nov 2013 10:32:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@akamai.com>, paulmck@linux.vnet.ibm.com,
        normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        nelhage@nelhage.com, davidel@xmailserver.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] epoll: remove the on_list check for 'struct epitem'
Message-Id: <20131101103215.da103389a8bed6fce98f8f68@canb.auug.org.au>
In-Reply-To: <20131031162019.aeb38873819cbbc78f7e8948@linux-foundation.org>
References: <20131030183241.AE8201FF9@prod-mail-relay06.akamai.com>
	<20131101100912.1d83667289bcca24c882b109@canb.auug.org.au>
	<20131031162019.aeb38873819cbbc78f7e8948@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Nov_2013_10_32_15_+1100_mHHBfApe0WHvdCDq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Nov_2013_10_32_15_+1100_mHHBfApe0WHvdCDq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 31 Oct 2013 16:20:19 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> Sure.  Here's my epoll-optimize-epoll_ctl_del-using-rcu-fix.patch:
>=20
> From: Jason Baron <jbaron@akamai.com>
> Subject: epoll: remove the on_list check for 'struct epitem'

OK, that will go in today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__1_Nov_2013_10_32_15_+1100_mHHBfApe0WHvdCDq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJScuiDAAoJEMDTa8Ir7ZwVme8P/R06aagH7ILlk4LsvbeiP8HU
SDxulfSL1TYfYyfD777LV97aL6VPaAYoPgYMTJpFjbnjEf9bM6tfHufbsAGmi0Pd
cFUAOBgCpTcdbyrvmc/Jouyv7Rn6s1Echsdk1E4oEqFp1onBsgV0mjo1jcu3CwrO
vce/O8W+rV11pVRbhdfSchZ4U8W9eEsWTsNyHFEZHe873YrtMKCVzOQLtpG/MOKx
AUV1aOLltsgAc15mdzO1MBeoNPVnmaFnFTpNUxCHaD24UZgxbVxFGJ1zFD8wzQwf
vA4eaaeMrJDu1jdhLAHLKmPxVN5tJ7CYLq34gBpqBreY514BSIdOYQe1iGaZvwFm
ty82AjroUQHzACjBvr2ys0A9zazHpD2ssIB4fI5aAXcJ6cbDQ5nDCIcF7G84bF1S
voA2KK1Gr/rDKRGLgOhudUwJ6GRsrP8k33SKh2vNMHP1XO7fmgGaYlH3uqsC5PiE
BYU94sxxnAFvIUarG3bMaDQIw28u6PmgTvmaZEhFBtAPcZIJYl2puvpizitREBnm
a+cmgVuhPRaGd6Nhm/d0IO9uBsNl6Tkw9YklL+URITYaB/qDV9ixklOvjvfoRRrE
dbfuVN14DsJJ1l/2u4CLiWQrN8ojVzHdEuTXn0enbYes+kQ9LaS8tgyRad/Fp4Rz
WCDmOedxDl5OJpvPczKD
=BREP
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Nov_2013_10_32_15_+1100_mHHBfApe0WHvdCDq--
