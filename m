Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab3DDBEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 21:04:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47875 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab3DDBEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 21:04:05 -0400
Date: Thu, 4 Apr 2013 12:04:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: linux-next: build warning after merge of the wireless-next tree
Message-Id: <20130404120402.2384c71a6e1850ebe76d62e2@canb.auug.org.au>
In-Reply-To: <20130404120043.794afc7dd061dcd3adac0fdb@canb.auug.org.au>
References: <20130404120043.794afc7dd061dcd3adac0fdb@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__4_Apr_2013_12_04_02_+1100_hHmGi2WUYcA3A8Gq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Apr_2013_12_04_02_+1100_hHmGi2WUYcA3A8Gq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Thu, 4 Apr 2013 12:00:43 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the wireless-next tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
>=20
> x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input fil=
e unused because linking not done
> x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input fil=
e unused because linking not done
> x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input fil=
e unused because linking not done
> x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input fil=
e unused because linking not done
> x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input fil=
e unused because linking not done
> x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input fil=
e unused because linking not done
> x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input fil=
e unused because linking not done
> x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input fil=
e unused because linking not done
> x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input fil=
e unused because linking not done
> x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input fil=
e unused because linking not done
> x86_64-linux-gcc: warning: drivers/net/wireless/rtlwifi: linker input fil=
e unused because linking not done
>=20
> I have no idea what caused that.

Though I suspect commit 8b138d4898a0 ("rtlwifi: rtl8188ee: Enable build
of new driver") - I wonder if the gap between the "-I" and
"drivers/net/wireless/rtlwifi" added to ccflags-y is the cause?

I am using gcc 4.6.3 if that matters.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__4_Apr_2013_12_04_02_+1100_hHmGi2WUYcA3A8Gq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXNGCAAoJEECxmPOUX5FEY1kP/R35HVl/sai+s8wFFY+T0giI
E7TacSGxAkIJ+zf+ZSeUtj3UGSU/2IhgFRO3N7NGl9YjvkBqoQesvKHKzJl+ktqo
FAQeb78pTK8Yh0/6yBvF9UsMn/UGilJBqufDvqrkJqDQ/DWjydWYrRVL0empSUUz
xfl5NqoRaZlj0c//FyPZ7+1qHU8LydFynba9VGd8jTF6HH30c1gKbOxCB05SE4D7
dwrZBqqcPCsRkarUtAMssFB8JBSmi+3w2twaoeCNEk0+baTTMdMnNMlqS9cGH0c8
eWlqbLy2I2kd7j5Z+chDzDgISGTqVNiNwAOChqIOCwG6CaTX+c9MWyELqScTv/4r
s9SYerPOiNeBWruh0vB8tjMRemxI4A+8Z112G450LFDiRCM3OegQkShES8ABcHIh
1r0/PKARkGUxP5wXMxG4PIZ7zUEQb8quvJ8Mm/zos3GxEb2nmC46nir2ck5Y2XtP
UMjrxtNsAPjfYEhQjDAE5+bbG1kaf9qaoKd+eloIWvPtY5BWQDnswWIXglOvsmdS
STdwCuCFPFHeXgMC/s857LbhT3CHZmt6gIwvMffXBqMx/3BgQh/3wmTcJnYMSjNW
838TZBITDcp1u2xxY4iTCuJrm8nQYzWQ1dS1/memztsWeWCMIzPtR8UGKeJgKLvL
fNT+IAQePTgfkmJlPdes
=v5zX
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Apr_2013_12_04_02_+1100_hHmGi2WUYcA3A8Gq--
