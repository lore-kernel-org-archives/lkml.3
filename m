Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423155Ab3FUGl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:41:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58354 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab3FUGl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:41:58 -0400
Date: Fri, 21 Jun 2013 16:41:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suman Anna <s-anna@ti.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the mailbox
 tree
Message-Id: <20130621164149.598b39bb78b6015057d03f6f@canb.auug.org.au>
In-Reply-To: <20130621162656.bb94e0fa8b6813781b804a73@canb.auug.org.au>
References: <20130621162656.bb94e0fa8b6813781b804a73@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Jun_2013_16_41_49_+1000_2UTvt5ohb1/YhHi0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jun_2013_16_41_49_+1000_2UTvt5ohb1/YhHi0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 21 Jun 2013 16:26:56 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/mailbox/Kconfig between commit a1824eaab70f ("mailbox: OMAP:
> introduce mailbox framework") from the mailbox tree and commit
> c869c75c16b3 ("mailbox/omap: move the OMAP mailbox framework to drivers")
> from the arm-soc tree.
>=20
> I fixed it up (I suspect not properly - see below) and can carry the fix
> as necessary (no action is required).
>=20
> It looks like we have two different versions of these changes in
> linux-next now, so please clean it all up.  i.e. can I just drop the
> mailbox tree now?

OK, things went steeply downhill from here, so I went back and removed
the mailbox tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__21_Jun_2013_16_41_49_+1000_2UTvt5ohb1/YhHi0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRw/WxAAoJEECxmPOUX5FEGYcQAIfAiYgXs8kRCeIxM3csbjE5
XGBWxdpbM1FYH1+4fWndOhPv4wp5UgyHvolwzwO52lh84Dm86p+pOVEJ5XmaVn38
5kVyLcEDpPPTeAuVJiq0wdr27c+3cp8qXVMKmpZ3TYiHfMfrMKoPsCoUngXSvNUJ
ScBgX4GfPS8OQLfRRCMrEpFxa6uS1CAk2JK+xsK4ATNYx+3yN9uR3RNVf1Q1Es5v
kY/AaFp5JYcN7+KvFugHvSleNFOHQ8np0fdZxatwxAxBfIO9dJp+jiDHx5cqY58R
g6pDN7RxINfILZnojc7NSnf6LeeYecMd86plaVADwkb0cReye7TLTbHTRMk9UvFD
LBxS2VK8DAZraqaYZ1UYSGPI/EHp4OnuXJGAZClvI5lCTmTs1wZv+n4S0sdMej+C
fg/6h7c1ywL5h1LR7iQah7UPkMdcmIDIWLkFDB80SgGNzjh7PEqXIQt25SFFzsJz
B576Slng/8gDxVMAvvDu7fqWnIT7b36xJcsAmc6/J5UbkT4B8wz36voFcBfFCSco
Igf58zUFw3Lidkmx+V9Z4ImxzKdrkHX7PO+tMHxFIVnw+UkoUyNF7CdGNaOxhl5r
fNwpDc/SmSG1SWSOUoK/iS6LlpEkofYsU9uXC7KMPgdtQZUCLffDH0AaYzIbl6R+
SDjfcklyjjPzDj253K20
=y53m
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jun_2013_16_41_49_+1000_2UTvt5ohb1/YhHi0--
