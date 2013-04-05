Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161577Ab3DEF6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:58:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57609 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3DEF6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:58:13 -0400
Date: Fri, 5 Apr 2013 16:58:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Simek <monstr@monstr.eu>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        John Linn <John.Linn@xilinx.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the xilinx
 tree
Message-Id: <20130405165804.c4def5754d316e5da691ceee@canb.auug.org.au>
In-Reply-To: <CAHTX3d++6JWTKWkGOfgJj10z1Xtx325YXNQ6eMJjM8HO4q1diw@mail.gmail.com>
References: <20130405153335.baf29606a97b1bee415f3546@canb.auug.org.au>
	<20130405153453.75b76d68fe9adc6e981e02fb@canb.auug.org.au>
	<CAHTX3d++6JWTKWkGOfgJj10z1Xtx325YXNQ6eMJjM8HO4q1diw@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Apr_2013_16_58_04_+1100_PSA9.uqS3v4U.d_7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Apr_2013_16_58_04_+1100_PSA9.uqS3v4U.d_7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Fri, 5 Apr 2013 07:52:34 +0200 Michal Simek <monstr@monstr.eu> wrote:
>
> 2013/4/5 Stephen Rothwell <sfr@canb.auug.org.au>
> >
> > BTW, that xilinx tree commit has no "Signed-off-by" for the committer .=
..
>=20
> Interesting that you can't see Rob's Signed-off-by line.

Rob was the author, you were the committer ...

$ git cat-file -p c79e33b3e828c79cfedf858ef7d4df96df5fece7
tree 1e5e352eb501a2afa173989415a8b4896d4999a5
parent ab8a98cff21aedb787934e8d366c9879ad0e824c
author Rob Herring <rob.herring@calxeda.com> 1360207067 -0600
committer Michal Simek <michal.simek@xilinx.com> 1365060716 +0200

ARM: smp_twd: convert to use CLKSRC_OF init

Now that we have OF based init with CLKSRC_OF, convert smp_twd init
function to use it and covert all callers of
twd_local_timer_of_register.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-omap@vger.kernel.org
Cc: spear-devel@list.st.com
Reviewed-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__5_Apr_2013_16_58_04_+1100_PSA9.uqS3v4U.d_7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXmfsAAoJEECxmPOUX5FE+z0P/iBV3aDF3zA6AV7IzUTLBwGr
ikTZOPCSRNJsqMfqp8t7jHyGHc1q6IL7sM7MkdidzGFIoET7HtJwiQAIkkaiFZxp
Nlh7Cm8VEDU0wR27ol5R1IgcR5wBJ03x/hINa0riQ4N6jhG7uPnGl8qjwh34HGhp
1cV9aro4pCfKxYojCITfIg67C1odfEGHtI4TwBLdbr6VvoYRstn9VqYGeuFhaOs6
GiJ3Ksuaq4j3069JaxuAU4zZCmW3jOpMgzm50gHa3NJ8b4Ad5OmrbjgIYECPkbnb
MZ3OwPhRn9VrlpWKEAGiI1pyJ8Q7EVobGpaSUceYpxwztPdGyp1zfzWsTJOYQMrm
/N2F6AgxUYQK/3AGYxYtvqtxM1FF3f7utXy3DqFusI2kKwccoEokN/rVGGMlM8ez
zfkf/fZV7ZAFkgsLDDkOO7XFVS39EplVadnkfoLkgiMn4mlYHPW3Y9TKEEX84YoM
RlZshs024kgtIsGmq2niZ2To1DsUWIsStD1ObAJk2NnpEuHNYaOUVQtcpEGyXWAM
HuQANc6QPAy6VlWzE4fd3y3qHK2u4gQuKUMz+YrhTEawasaV9t4j8Qm2i/l7h07b
73+z+Z8X1AGIGH5QIUHNOoa5C6buBooT0uBZjCl4UGjGKb0pEowiGmp7i5XoS4DI
jq9WHVIRZ2rpCk6yXXK0
=kRVf
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Apr_2013_16_58_04_+1100_PSA9.uqS3v4U.d_7--
