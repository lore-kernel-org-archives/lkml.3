Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab3GOA1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 20:27:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40892 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab3GOA1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 20:27:12 -0400
Date: Mon, 15 Jul 2013 10:27:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, abbotti@mev.co.uk, oliver@schinagl.nl,
        linux@roeck-us.net
Subject: Re: [PATCH v3 01/10] Driver core and sysfs changes for attribute
 groups
Message-Id: <20130715102700.33e848c5dba966d49e530bda@canb.auug.org.au>
In-Reply-To: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
References: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__15_Jul_2013_10_27_00_+1000_uO_WIaCFKjbQti1H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Jul_2013_10_27_00_+1000_uO_WIaCFKjbQti1H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Sun, 14 Jul 2013 16:05:50 -0700 Greg Kroah-Hartman <gregkh@linuxfoundati=
on.org> wrote:
>
> Anyone else have a better name for this macro:
> 	#define DEVICE_PATTR(_name)	&dev_attr_##_name.attr
> that they can think of?  It will cut down on the typing done for
> attribute lists.

Just one small peeve I have about all these places we do symbol pasting,
is that it makes it impossible to find some things because grep complete
fails us.  We type them once (often by cutting and pasting), but try to
find them who knows how many times?

Just saying ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__15_Jul_2013_10_27_00_+1000_uO_WIaCFKjbQti1H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR40HaAAoJEECxmPOUX5FEfE8P/3mcw56ZCaBAnY3M0SaiVtob
WkBD8Hbjj4kKxa5qSzzBn8jtK7Y7lgvdz9d+LJmITTBfqd7wRNEgDTylw9vkrAMz
Tp7j1Ib7uSDlSTZyE4CGYfQLaR8GxQ97XVHI5I8rsIa7ZZx6HdaXe+TwaalqHM2x
dL6s0hlXUVx5WnV/Jd9XARP8crDvdWXFRca3RLntCd/6HcMCFZC1YFsHKKLKF5Vm
VLM/S6QV6tGEKqfBbjQ9yDVr0JOp15YGlDdPvVS/7Zsv8YCi4Q3el+9F5KuXXv6Z
qMISUTqcX8UCYKEiPhUtzo0won34dzZv+pagx8LvQrUVLluJ0XBADRszfmrE5GRZ
UtVbzQJePpJhnaJg00bf3/QXV8yN8wk94MnGKrb88GTEa2fdYvwLkREi0JZQS/k2
F04SinjoBWfr7mOogL52Xjo7WPiQjwVxSiQLCQzQWgpyMuSEwGWRPk901QAzk90K
0ZvXdgowi1yet7577hP4nQhPmvliuG2TSaatjHeiODLFZyYIbCwryeRY+n6H0f/r
EaQRDOJ5Hc33sZihwWPabzbdnIsUU0OU2/gZiGoyGojoiMusBQGbnwiNOW5HSKzj
inW5B/THlvnupN4H8XeQ8mQoZju4aa0uwy/dDWJn8UGisI8OgiHsnJ3BXgDo9isQ
S/JfdgdDn3qusjl15MiL
=QOTW
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Jul_2013_10_27_00_+1000_uO_WIaCFKjbQti1H--
