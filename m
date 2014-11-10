Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaKJFFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:05:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:59487 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaKJFF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:05:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,350,1413270000"; 
   d="asc'?scan'208";a="605104268"
Date: Mon, 10 Nov 2014 10:36:16 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: linux-next: build failure after merge of the slave-dma tree
Message-ID: <20141110050616.GA18555@intel.com>
References: <20141110115846.390ce45e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20141110115846.390ce45e@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2014 at 11:58:46AM +1100, Stephen Rothwell wrote:
> Hi Vinod,
>=20
> After merging the slave-dma tree, today's linux-next build (x86_64 allmod=
config)
> failed like this:
>=20
> drivers/dma/at_xdmac.c: In function 'at_xdmac_off':
> drivers/dma/at_xdmac.c:317:2: error: implicit declaration of function 'wr=
itel_relaxed' [-Werror=3Dimplicit-function-declaration]
>   at_xdmac_write(atxdmac, AT_XDMAC_GD, -1L);
>   ^
>=20
> Caused by commit e1f7c9eee707 ("dmaengine: at_xdmac: creation of the
> atmel eXtended DMA Controller driver").
Thanks Stephen,

I have fixed this error and warning, the tree is updated now

--=20
~Vinod

>=20
> Also, lots of warnings like:
>=20
> drivers/dma/at_xdmac.c: In function 'at_xdmac_prep_slave_sg':
> include/linux/dynamic_debug.h:64:16: warning: format '%x' expects argumen=
t of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=3D]
>   static struct _ddebug  __aligned(8)   \
>                 ^
> include/linux/dynamic_debug.h:84:2: note: in expansion of macro 'DEFINE_D=
YNAMIC_DEBUG_METADATA'
>   DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
>   ^
> include/linux/device.h:1107:2: note: in expansion of macro 'dynamic_dev_d=
bg'
>   dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
>   ^
> drivers/dma/at_xdmac.c:621:3: note: in expansion of macro 'dev_dbg'
>    dev_dbg(chan2dev(chan),
>    ^
>=20
> I have used the slave-dma tree from next-20141106 for today.
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



--=20

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJUYEfIAAoJEHwUBw8lI4NHQmYP/RhmGGLqUGVYAGdbNntQwvnE
HTDZ11muOkvRGv4B0ndcQlR7M1gFEAEuIDAdzVd9xyRko7/RWzOLB8/3eBtAk5T6
GLMU36w0PPrH/YRRnAArHOjXgNyx2pYUPBANIoS26on0TNu68fphFveuI57zG7Re
uzuN/mJXhW7IDGJktgaWpoGycapxs7IVqu6ruPvt5wBav6lgr2D1vRlpVpW3lVUi
CB7ctIdywveCik1tSi4qlR/Gs2Xi9GANpCiep0pdQThzlb6/ToHKx/KLOOUfDq+G
DUDD6E2dp1kJyglElYObBtcDm52rkEzVRP8Pyyu1e7m88nOC76y3GuFn5VVGSZ/1
CMZJiWgHKbXknT0UYwz4iHD80kpoggWe4bBsukEutBTPKeeCjV8yieXTgRX2Hh8m
FzXb/JTM63cpHmHhLBqQ9Wt4d7bycr1amYHgjsbdXPsweU91RtVhV00DSU9DZ5tl
KQhTERiNKEEiSlwwDCxAxfzgJJ4MJ5JWCAdC03iRFQE7hTqKbwu4iS27CPqbzvOD
oIP23e96+ZenZeZw30Tkv1hJOb7Rq6MxnKI/FL82wpr9lLKLDRe9Ti59S4auxK3j
BMBvv2440cMeq86NyafPb94NFJPOdzujnfyabvMSp4yXx8CPalGtOr3adxitnahI
snpH5VvYQm5mbeLy1k/+
=kdkT
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
