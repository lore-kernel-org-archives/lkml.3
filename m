Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab3F1AjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 20:39:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43851 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3F1Ai6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 20:38:58 -0400
Date: Fri, 28 Jun 2013 10:38:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: monstr@monstr.eu
Cc: Vincent =?UTF-8?B?U3RlaGzDqQ==?= <vincent.stehle@freescale.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Robin Holt <holt@sgi.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, trivial@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH linux-next] arm: zynq: fix compilation warning
Message-Id: <20130628103855.c4a89a6f1c6ef425fee34bc6@canb.auug.org.au>
In-Reply-To: <51CC37BF.8030309@monstr.eu>
References: <1372336962-6459-1-git-send-email-vincent.stehle@freescale.com>
	<51CC37BF.8030309@monstr.eu>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Jun_2013_10_38_55_+1000_kU80yy/uyxKCg/2/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Jun_2013_10_38_55_+1000_kU80yy/uyxKCg/2/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Jun 2013 15:01:51 +0200 Michal Simek <monstr@monstr.eu> wrote:
>
> Arnd asked in this post
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg454947.html
> to fold his small patch to that larger one.
>=20
> Not sure why it is not there.
> Arnd, Robin?

Should have asked Andrew :-)

I have added (most of) Arnd's patch to the end of the akpm tree today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__28_Jun_2013_10_38_55_+1000_kU80yy/uyxKCg/2/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRzNsfAAoJEECxmPOUX5FEH1QQAJJbcuM/neyTjv3oZoUl4zfn
x//yJBgupXe1Y7a0BSRuqMzFj84DXamvg7P1ULFYR12Sg5OxD47uHsw0xjy2yO/W
vzVod1q51naeNEq82UGZXlWV392IfxOEsFMuF3Ckakpuq2yA+GY75JyVyBXuWCkw
TduS1pdU4v8l2+F1Gr/riAsrKEb5pMfgDawg6S5hJrubzmLHcv8SltBJ63fnD/o1
tU5lFsRh1NdtdeDyI2ByKye6EGmuFPk9dSRV3pZioI1H01uA99Y0M1dZ13alFUbP
alLWHBKAegXNELRi4p+HE9ZBVLhs7XGtXIv/x1/m80bnNhxPlNRCpoS7MxZXoL1B
MxLQKirIJ+BxqvfcDlF//k2X1mvXHqsUMTXVOfrk9OWjaMf8WsYZ+MgCFn4z6FVu
LGAizv+iyO+0BtUqKeNxKeTCvMLNE78RpmCpgJi1J0o3on4sa0FK5VzdIOLusaRn
uObqfPlga7SWyIIY6GbR9EAoMwjFFZAzyzPglSFWdQPlhal7cBi0cSLQpfzemqsz
272WIeJ6MajZlNf9gQEyXw7jWq1m0IaeRcQEYwedK3HVyydOhJ/WHin2Dx3Ns6RB
td0ahxZ/9wO6Xv+/IKp9WY7wC3x60HXtUhUtZhOsjl119QmmSF4tCKiM7fuDOwy/
OQi1Ku5CtuVtQ0XgYo3S
=EtSs
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Jun_2013_10_38_55_+1000_kU80yy/uyxKCg/2/--
