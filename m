Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaEZLSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:18:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:15711 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbaEZLSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:18:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,912,1392192000"; 
   d="asc'?scan'208";a="545007125"
Date: Mon, 26 May 2014 16:31:09 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Ball <chris@printf.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Balaji T K <balajitk@ti.com>
Subject: Re: linux-next: manual merge of the mmc tree with the slave-dma
 tree
Message-ID: <20140526110109.GD21128@intel.com>
References: <20140523152310.05323045@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l06SQqiZYCi8rTKz"
Content-Disposition: inline
In-Reply-To: <20140523152310.05323045@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l06SQqiZYCi8rTKz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:23:10PM +1000, Stephen Rothwell wrote:
> Hi Chris,
>=20
> Today's linux-next merge of the mmc tree got a conflict in
> include/linux/omap-dma.h between commit a8246fedacad ("dmaengine: omap:
> hide filter_fn for built-in drivers") from the slave-dma tree and
> commit ee526d515ad1 ("mmc: omap_hsmmc: split omap-dma header file")
> from the mmc tree.
>=20
> I fixed it up (I effectively applied the former commit to the new file)
> and can carry the fix as necessary (no action is required).
Looks fine to me

Thanks
--=20
~Vinod

>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 23 May 2014 15:19:48 +1000
> Subject: [PATCH] dmaengine: omap: fix for code movement
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/omap-dmaengine.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/linux/omap-dmaengine.h b/include/linux/omap-dmaengin=
e.h
> index 2b0b6aa01922..8e6906c72e90 100644
> --- a/include/linux/omap-dmaengine.h
> +++ b/include/linux/omap-dmaengine.h
> @@ -10,7 +10,7 @@
> =20
>  struct dma_chan;
> =20
> -#if defined(CONFIG_DMA_OMAP) || defined(CONFIG_DMA_OMAP_MODULE)
> +#if defined(CONFIG_DMA_OMAP) || (defined(CONFIG_DMA_OMAP_MODULE) && defi=
ned(MODULE))
>  bool omap_dma_filter_fn(struct dma_chan *, void *);
>  #else
>  static inline bool omap_dma_filter_fn(struct dma_chan *c, void *d)
> --=20
> 2.0.0.rc4
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au



--=20

--l06SQqiZYCi8rTKz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJTgx71AAoJEHwUBw8lI4NHQA4P/izzQLTgaH58JTgoGir90X04
AfD/DL1LcESav/Q36bANprAb03QhwG6DQE4sMXmc7R+CNazPzRWfuBnpNRgNXhcF
u/Eg9YldwdB9RNL0ZWp8ov+NVo5/LBUMhVmjf99GGoZNt2zVuS8wpHPf9bhbcQuL
M/FUKaLxlm8ix3xX8rXZ21vb3+77xbJy1+FsgHSktpDSQOe1VT3Ql3OGiqwhTHv+
11RSUmPgABPgBBUEEzaUShg8Io7YZzpWDKI2ZiQN6v/5fetKso2p2/SCUCfUbSGP
7nqeITd7N1nx+B3NObHGV1uWb6CVBSAaQk1tcPXPz16pNjfbmGkSkWvcwqelWXXf
g7X1xdtQKEIiGI50R6PQHw+zsn1yNz6DhNh8Npm6jFvImmwfsE6izREpypPm9Rrw
k4VPTwZqXWk2zqmDxaIWdD8z0f2NsxauOtnRkR9ugZ5E5FxrIA0WF8HWBCVPfpJ7
coLtqPUhPcqJ6LS/MtP8AfM6fJwROtfCme30oSPxFqGrgi3NZ1je1cMouDTQ7FOe
gZY8Wv3zZSvDyZlCnzrqNQNwuyci3lTxF7uGJJWfzIv7gEfLGy4uhUV7tjbLo+tn
NzdqQS2flB7Kt4E0dVufTYmICv/YoCrmefIqbq8iWr5SuNaWr1RtHS6BlY5rSeIu
VmqqhoW0jYQmtxrfpqy1
=XfRf
-----END PGP SIGNATURE-----

--l06SQqiZYCi8rTKz--
