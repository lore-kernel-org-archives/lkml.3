Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaCaK5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:57:54 -0400
Received: from ozlabs.org ([203.10.76.45]:36057 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbaCaK5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:57:52 -0400
Date: Mon, 31 Mar 2014 21:57:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-Id: <20140331215743.a357aa685a63c06ea303dbba@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.02.1403311140180.14882@ionos.tec.linutronix.de>
References: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au>
	<20140306150010.e873f440ac5a22d8812268a4@canb.auug.org.au>
	<20140328165238.7d9e0804a2781eaaa88a4fa5@canb.auug.org.au>
	<alpine.DEB.2.02.1403311140180.14882@ionos.tec.linutronix.de>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__31_Mar_2014_21_57_43_+1100_BceNixUCjzmq_68a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Mar_2014_21_57_43_+1100_BceNixUCjzmq_68a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,


On Mon, 31 Mar 2014 11:45:24 +0200 (CEST) Thomas Gleixner <tglx@linutronix.=
de> wrote:
>
> commit 8783dd3a37a5853689e1a8fa728827a50905b912
> Author: Stephen Boyd <sboyd@codeaurora.org>
> Date:   Tue Mar 4 16:40:30 2014 -0800
>=20
>     irqchip: Remove asmlinkage from static functions
>=20
> which is in the tip tree since March 12th.

Thanks for that.

An i386_defconfig produces this:

arch/x86/kernel/syscall_32.c:14:1: warning: 'externally_visible' attribute =
ignored [-Wattributes]
arch/x86/kernel/machine_kexec_32.c: In function 'machine_kexec':
arch/x86/kernel/machine_kexec_32.c:191:12: warning: 'externally_visible' at=
tribute have effect only on public objects [-Wattributes]

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__31_Mar_2014_21_57_43_+1100_BceNixUCjzmq_68a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTOUotAAoJEMDTa8Ir7ZwVZxQP/28RWX/GKCoIWuDnDipOx5nF
6cpSnnEfz61Qg5OZAOmV0L0DWh/LrBSF4cgEYTVxC3VX7apOTHyjkXMHoBNABD6U
EC3xQoYfrMbDyCIhobXB5uD1OVWJGmkeOiI3PdGKAQi0qk6dDiSx1VSfPO4Heshq
d0G0HrdozCf6mxRmGH8JY8eHSjgON4PYHD7C+gUfeaER21m2kWOyDU9sBn/wBRol
MO+jHqmkmcsYKF+ZOls1ow/m7XHTxKqbtCQtrpjkZLxI63iaRJ8j/Z+Us8zBjGOP
e/fKD8E78RIwGIrLtZtiPXO06QlmQVopbz5vsPHSgW0gASHS+DvEMjUDSK4nzL1W
P3My9E8xt5682GcOP2IGZW60mIA1ZAhpdeUKXO0I6Ny5S/Si5k/2QD/DzEQXsElw
GXMun0RXSmZkLKHml0C5pAF8htBbuei+B67qUbDEz8mbXdb/qDn0N6zpFdDvB5D8
LeEzS1CY98CjCL2ZBQwk1ncdtusmO9BVysOuUfuLwsqG+Y5ae9jwJuL9SfyJ77mh
wrOlLZfvlxHfi1KN0B9FRMfV0rHmVEI2b+0YQJ+tepiEMyKBoPp+L8LsPTkfdpwq
48DZ9uIt1VWcK2rdf/YRPnZK+vrYuCQEq5cCiB48AuxbpSDVuywj2Zoox7bM0O/h
2Ky+/L1pt6QLYKWPbgUF
=xKZO
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Mar_2014_21_57_43_+1100_BceNixUCjzmq_68a--
