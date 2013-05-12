Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab3ELXwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 19:52:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59786 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3ELXwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 19:52:46 -0400
Date: Mon, 13 May 2013 09:52:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: comment on the xen-two tree
Message-Id: <20130513095244.60176cad5e302c1156788096@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_May_2013_09_52_44_+1000_AcCS_/Zh0bLNmKKm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_May_2013_09_52_44_+1000_AcCS_/Zh0bLNmKKm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

Since the xen-two tree
(git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
linux-next) seems to only consist of merges commits and some old (pre
v3.9) stuff, it might be a good time to reset it to be just v3.10-rc1 (or
rebase onto that) so you can start with a nice clean tree again.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__13_May_2013_09_52_44_+1000_AcCS_/Zh0bLNmKKm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRkCtMAAoJEECxmPOUX5FEBlwP/Rx8WXgiEJ5PuTMu7GoSOAiq
f+oProzOFF4jpXk1jsfKkE9tXRc0YWHaAoXsB8exr/7E4eELMIC6D/ArhNlnWpXF
azeXxKcFcxokCO4d9qWPEREpsiUzobZlfyumdW9ujoo5miQj5ZivODYvrXJAhe5L
3hd7RaPUg2Hu/+0I7u+7mgtsduU4sd/0rN/awwNgQ9jJD+hlSPijRs9fgLqEpmZR
vu2khY/ZGLV9wsJOt5rrwD0Ofc5WxuBYbSB1FF4LCkk35h4SR5v2n7LvgNTzP2FE
C8piaDIiRtZpzUzoxkwIgmHXWOKeyfwdOGTSafoJv0OS62Z3e5XBwhxXdhoGNubZ
BHrfwzzleOEImvoSX+PAcqlqs0W6ty0OoVYbiGXZuj3zgKQYzQtGnPN7zh1u6eFi
5SBfPKeM7tCOqTLgaQR9lYTwppACe6dq1BSEoTHOSinfwYdCOHNfHyDjbDpkjZ43
DJDUK9ZvXww5z5d9vt+IkJSevQLg7DEgwf22IzbwfFI/EACaLrJQLT966YdDH/tm
jqHVux8SfFYV6e0jDEm2xgmV8cFERWTaLOak+VLCDdA6DBv9Aavr86RWrNYSKMWH
twUVUqYEVgO2stY4IE73dd6g+VvQ4v3IWanZlPsXjlB7pSDGWcNXhSctJiErLBUW
okC/SpSknhHGmPCQeXM4
=lifl
-----END PGP SIGNATURE-----

--Signature=_Mon__13_May_2013_09_52_44_+1000_AcCS_/Zh0bLNmKKm--
