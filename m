Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaC2BUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 21:20:39 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54864 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaC2BUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 21:20:38 -0400
Date: Sat, 29 Mar 2014 09:20:21 +0800
From: Kevin Hao <haokexin@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dongsheng Wang <dongsheng.wang@freescale.com>, fweisbec@gmail.com,
        James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Helge Deller <deller@gmx.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@au1.ibm.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        jason.jin@freescale.com, scottwood@freescale.com,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] powerpc/irq: Remove HAVE_IRQ_EXIT_ON_IRQ_STACK feature
 at powerpc platform
Message-ID: <20140329012020.GA29172@pek-khao-d1.corp.ad.wrs.com>
References: <1395992312-23035-1-git-send-email-dongsheng.wang@freescale.com>
 <20140328081827.GB2176@pek-khao-d1.corp.ad.wrs.com>
 <1396042027.11529.24.camel@pasglop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <1396042027.11529.24.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 29, 2014 at 08:27:07AM +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2014-03-28 at 16:18 +0800, Kevin Hao wrote:
>=20
> >     powerpc: Set the correct ksp_limit on ppc32 when switching to irq s=
tack
> >   =20
>=20
> Kevin. It looks like it was applied to 3.14 and sent to 3.12 stable but
> not 3.13 ... can you fix that up ?

It was already merged into 3.13 stable since 3.13.6:
  https://lkml.org/lkml/2014/3/4/787

I guess that Dongsheng didn't use the latest 3.13 stable tree.

Thanks,
Kevin

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJTNh/UAAoJEJNY7TDerrFxhLQH/10fMDmiShY7Kqgz2DV+GiJa
FyVtaoVPpdbylfH+rEaCZYfInCIxeShMsuj9OWo4e8fBOyvBDV/SSNY6/eIDs3aA
a8/BZgaIaGko8aFi5SYr1tatfOpOEXc7ki0Eu4doKvcldmD974v7BBhDMOusLwek
+9x2WaM+n1GWKiRwiOxkplka4enelBZ9N32eSUKVX/t9wKka4mWV+OzBeXmi9R0+
tBVade7RphMJy2k63YC6WSDdp1gFq9CV0ZXz2FUy+lw8JJrwJll4Uy7TwI2O+N6p
IWA5lRhesuwihZOpqE/QlmO+YUCru1ZCl7bTHhfeR2sahsM8+XQ4LVuJUvp+btM=
=tler
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
