Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002Ab3BKUSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:18:53 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33688 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759705Ab3BKUSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:18:52 -0500
Date: Tue, 12 Feb 2013 07:18:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: WARNING: at lib/debugobjects.c:261 debug_print_object()
Message-Id: <20130212071842.399e7ed9597b66df3ca28473@canb.auug.org.au>
In-Reply-To: <20130211132556.GA16137@localhost>
References: <20130208055605.GA7646@localhost>
	<20130211111714.5e6fa4c8dc9c0d99cb1c1de1@canb.auug.org.au>
	<20130211132556.GA16137@localhost>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Feb_2013_07_18_42_+1100_hGnyvNaAJE=0xgYa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Feb_2013_07_18_42_+1100_hGnyvNaAJE=0xgYa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fengguang,

On Mon, 11 Feb 2013 21:25:56 +0800 Fengguang Wu <fengguang.wu@intel.com> wr=
ote:
>
> Stephen, build failed after reverting the commit, however next-20130208
> no longer has the problem. So we may probably forget about it.

OK, thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Feb_2013_07_18_42_+1100_hGnyvNaAJE=0xgYa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGVIiAAoJEECxmPOUX5FEGOYP/3qPYHcbjMXvsyHvPHZuCNZV
wC0xs4YhpgxOA9haCCzKrdHIWOBZP+Dpke1p9mgvWve0hp1XWmRdxRy33qWdJYcl
IEUoCXyE8r99lTYv7MRSklAjzZxfJtt8m85VMdS+HQh/HJliqPSl0io0x5Sz8Szh
HbAVqOAZCdoE1TKMO8bt4lCEYOyYzzh7QXDz0xaM61ppOHnZZrJUZpOHbISuEB9m
BTyvlRbLxBXO7Hro4ETtZP4vTWUyPt4LTmZnSb2gqADTdSA8InRfapft+3hBROOb
mgC1VVNBPV2uN0p1iS+U09z74XvQRqd4iUxIrIQIKQ1J8zN3KDMTTfgfyGuGvmsE
pu6Yd5OzzXQG8OK2GQQ+3pVPXVXsXOs15ie2S0AAuUkAPO+nfe1T9aKFHRc2+mRS
2YMSgJsHja5gJ5PuQ9QU1WIofC9UegBYq618RuwXsIKkCdBxVhSDV0TOs/l+0FkU
633a4XMg971rdy+KmfMEhxTVkBm+8n3OKpw+sHbs3MejajXLS1stJrWnljFQKx5a
qyUTp2LPMG38vQrkJOBxeUIAgurM/n7G3Fcg8+xTa9hjCrEaa0t0oPrqEbZt00/x
UP/P4nJ8b1Eq4G+k0Z4aU0UJGJ5/p8I6yptiSABjJU2sOBBBg7VL1kf5iC2KwshF
fTFdUJySjMjxLO2F3jlg
=5EgG
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Feb_2013_07_18_42_+1100_hGnyvNaAJE=0xgYa--
