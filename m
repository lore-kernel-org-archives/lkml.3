Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3AKEq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 23:46:29 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42259 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3AKEq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 23:46:27 -0500
Date: Fri, 11 Jan 2013 15:46:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: linux-next: manual merge of the signal tree with the arm64 tree
Message-Id: <20130111154617.cab6a8d1ff13a4f200969b9d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Jan_2013_15_46_17_+1100_YsgaXwqVxz4zO5cR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Jan_2013_15_46_17_+1100_YsgaXwqVxz4zO5cR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/arm64/kernel/signal32.c between commits 068f1bb36cf1 ("arm64:
compat: include sa_restorer in old action from rt_sigaction") and
efed4d52e39f ("arm64: compat: ensure access_ok checks are performed on
user structures") from the arm64 tree and various commits from the signal
tree.

The latter removes the code modified by the former, so I did that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__11_Jan_2013_15_46_17_+1100_YsgaXwqVxz4zO5cR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ75kZAAoJEECxmPOUX5FENK4P/AgPCicn861IXyPtPUEF2lWw
Js8OBupzhiy8wqGAteLU20OpSL8GfAYnlSHC+akIy6MTHCN53XlX2ozBT5JZNzQx
3eEfXEtd7Fc+B4wsf27oKdJCVtTcPR6HAnR58Qb5btqkB348h7XWemMWM7M5dY2s
MFZJP+vpXod+cL7nhjY1wAkE6157eMIW9DWZ1OF+U5i6GsRmpGZcP0aFG7saFk3z
Z3TzUexaht/2cwD7ptNY6WOPJt920TyO5Hcn+EuwmzC4hRTQ9QKMs3RngH0uDCdw
ywNYpipTd0UEk8ho3HIG3lmWTGgfDXyiLjha5z5EdpmvxJnU2xn/S3zaXMyIqC9+
paNP5RHE028erUjAh5C/KlfuYRpM5nBs/rIm1orxxEo0hFm2kRm4uINUtfWoITsm
Iw3lCJbKWyMttDV4xuEn3tQfeBtGCbDgaRfyErOUtWh7O5nQ00BIQ8b5TnybBvFr
KiF88kbqrOzDTGf3x69Kmsmm4L9toYM23+tZ7M/bF5LRhBO8cbhljlx2FK1xieTL
heWPULmzn/Jc99z4tsykNYFv74n34/SWLoANwwINZytua37+jlyo4A741Hu9ql7s
K0YNcd/3p54K8IOD4Z1q7ixrRuY8JMa4n57CX2m0kPJCOQtDGDsVNfPO3JHZ007o
BCce+hwsEE7mbYCKOszv
=w7hE
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Jan_2013_15_46_17_+1100_YsgaXwqVxz4zO5cR--
