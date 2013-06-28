Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3F1AXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 20:23:21 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39969 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab3F1AXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 20:23:20 -0400
Date: Fri, 28 Jun 2013 10:23:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vincent =?UTF-8?B?U3RlaGzDqQ==?= <vincent.stehle@freescale.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Robin Holt <holt@sgi.com>,
        Russell King <linux@arm.linux.org.uk>, <trivial@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH linux-next] ARM: keystone: fix compilation warning
Message-Id: <20130628102308.d338543da54faccf9bdfe2a5@canb.auug.org.au>
In-Reply-To: <1372337367-6708-1-git-send-email-vincent.stehle@freescale.com>
References: <1372337367-6708-1-git-send-email-vincent.stehle@freescale.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Jun_2013_10_23_08_+1000_iLVHBAmW65N.b2mC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Jun_2013_10_23_08_+1000_iLVHBAmW65N.b2mC
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vincent,

On Thu, 27 Jun 2013 14:49:27 +0200 Vincent Stehl=C3=A9 <vincent.stehle@free=
scale.com> wrote:
>
> Fix the following compilation warning:
>=20
>   arch/arm/mach-keystone/keystone.c:74:2: warning: initialization from in=
compatible pointer type [enabled by default]
>   arch/arm/mach-keystone/keystone.c:74:2: warning: (near initialization f=
or =E2=80=98__mach_desc_KEYSTONE.restart=E2=80=99) [enabled by default]
>=20
> Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@freescale.com>
> Cc: Robin Holt <holt@sgi.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: trivial@kernel.org
> ---
>=20
>=20
> Hi,
>=20
> This warning was seen on linux-next tag next-20130627, with config ARM
> multi_v7_defconfig.

This is only needed after the merge of the akpm tree, so I will add it
there for today.

> Best regards,
>=20
> V.
>=20
>=20
>  arch/arm/mach-keystone/keystone.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/mach-keystone/keystone.c b/arch/arm/mach-keystone/k=
eystone.c
> index fe4d9ff..b661c5c 100644
> --- a/arch/arm/mach-keystone/keystone.c
> +++ b/arch/arm/mach-keystone/keystone.c
> @@ -49,7 +49,7 @@ static const char *keystone_match[] __initconst =3D {
>  	NULL,
>  };
> =20
> -void keystone_restart(char mode, const char *cmd)
> +void keystone_restart(enum reboot_mode mode, const char *cmd)
>  {
>  	u32 val;
> =20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__28_Jun_2013_10_23_08_+1000_iLVHBAmW65N.b2mC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRzNdxAAoJEECxmPOUX5FEi18P/RkuJfgfcJny6IPlqDW1DtsT
KtW/hTLNrXJLWfWMpBbXYy9Bmi21Xlx98GF36TJtT3XpxlkzULySSyAS6wATHrwS
xwWqiESUn842uGq5V2kaXkoEvp0XxeRSK/JulnoUqLXHs8MHTM/2lidvRlrN7gfT
1yr+eFeRavDPZ8w+2/2Ssl6l74mo268RmMYjY+m+eaoYrLqm5kYV4UhDTC2ZtV3T
4NPMTkFvyeQKIBxMvSuCCK9W8RoDQeFsNvjxGjqM94iS5zpzqYgBFgNP1fldYsr5
4GVpP0i3KmfvhVMr9IOgxey2iOfkDuUo3r8ju243eebHuFc0cQ1f+9CSvtiVcSzk
1yZceBGvTtZroBW/r8VlvGZEzwXSuTFybpDafyTpHrNBGYuGMSkyPJm1m5UeyZhP
gREkXw7T2ZhBKOX7PExwEcz9MNkY3LHgxcizsGaIp8yxVTpo463WUPqsm9Fk1fAg
jcMcWWSLpxfQ8QJdXWtj/rnY7lj1AcGAP8jSHMR8IcBGEv5igzA6D8Zvah/liD91
ydPcD1f85bGpisUPPzMhst5lmEZp6+JCj7lP0ThBS/uhZMpo9R9QvDF7HzOtyIv9
SiaZm1WkOKrHmosngLXgJUeOQX/8FFIDtyfAEM5jjxAVrkPhW6CvOqAodd0CAcJf
T8R1SXKKaae6CqJQ+I/K
=keTA
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Jun_2013_10_23_08_+1000_iLVHBAmW65N.b2mC--
