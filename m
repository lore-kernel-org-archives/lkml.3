Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab3GPDu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 23:50:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48485 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521Ab3GPDu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 23:50:28 -0400
Date: Tue, 16 Jul 2013 13:50:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rob Landley <rob@landley.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Documentation: update references to v2.6.x in
 development-process
Message-Id: <20130716135015.62f64a255f3de76946651222@canb.auug.org.au>
In-Reply-To: <20130716021349.GA26761@windriver.com>
References: <1373931284-26333-1-git-send-email-paul.gortmaker@windriver.com>
	<20130716101543.b458d507331c4ac32fe6686e@canb.auug.org.au>
	<20130716021349.GA26761@windriver.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Jul_2013_13_50_15_+1000_89g9TtDsz33823Mq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Jul_2013_13_50_15_+1000_89g9TtDsz33823Mq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Mon, 15 Jul 2013 22:13:50 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> On a similar note, I was thinking about the recent thread on linux-next
> where we were indicating that people shouldn't rebase linux-next content
> on a whim, and that new devel (vs. bugfix) content shouldn't appear in
> the linux-next content during the merge window.  There is no question
> that the linux-next process is integral to the main flow of patches to
> mainline, so I think Documentation/development-process/2.Process (the
> same file) should also capture those points in the linux-next section.
> Do you have some pre-canned text we can insert there, or should I draft
> something up for you to review?

The latter would be certainly easier for me :-)  If that is not easy, let
me know and I will write something (even without swearing ;-)).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__16_Jul_2013_13_50_15_+1000_89g9TtDsz33823Mq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR5ML8AAoJEECxmPOUX5FEWaoP/RXLdyRUyrDJkjGniBs65vY6
PPIKxzWnxaMGtzzU2lv1jM8HipsjEwGHdMcx0X9aVx+OkL9ITob4CxV6mDNMxt/e
fWybLdl6J+PPfBP8NR/vZzKv+PDGK02Fxl+fLShS0w1BzuUegBbyvORFhSlLFeCQ
1W4yD+8xd6Pu4qyKtkzTrNVYxR3Zh+4FpdaUdKJREKqWzJdDTJhZw2NESrkB3QzM
GY1YUSXy3E67o6zoCVTxYFqyTxucIF0RFssB7YRRR0ycEhDHh9rB3dRauQQAloCi
n7En9FvMsAW0asM4anpc6HYp2h936rRGgktILAXmwjAHTYJaJZvYKJ7Jaap7vlFr
lpM/QmHCN2drukkAi7LR8YNoIDQ2oifRFW9bUsntdnGzLVMD2UjKqi3akHKHFVH/
49MGjZUbdMNw2od5MRCDONRCD764wwJPcD5Y0wguugWE8inqZ/h/AbbovgrlwiR4
1+RHSNkCFSsHvBNoZKKkQHbDXsApH12pUoocj6Lj+Mny/7s6d6tbPZEDunmJ/KYg
dO533ERPyBGtM8xmrq1mbQCRHl3xmySRdKW/AlbPc12HNJoinGSNsOLTjC4tyD8c
nEKlB23CYlmLSZJ0NgUoVl0TRbEkuZd/9J2Lw/D3qwzh09F674W7ONqigirvdEqi
eCWVGw3Art+ITc+eN7kP
=BvlC
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Jul_2013_13_50_15_+1000_89g9TtDsz33823Mq--
