Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3JaPTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:19:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:44381 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab3JaPTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:19:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="asc'?scan'208";a="427730938"
Date: Thu, 31 Oct 2013 19:55:12 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/9] dma: pl330: Remove unnecessary amba_set_drvdata()
Message-ID: <20131031142512.GL18788@intel.com>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 03, 2013 at 11:46:23AM +0200, Michal Simek wrote:
> Driver core clears the driver data to NULL after device_release
> or on probe failure, so just remove it from here.
>=20
> Driver core change:
> "device-core: Ensure drvdata =3D NULL when no driver is bound"
> (sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)
Applied thanks

--
~Vinod

>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  drivers/dma/pl330.c | 3 ---
>  1 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index a562d24..dfb2931 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -3029,8 +3029,6 @@ pl330_probe(struct amba_device *adev, const struct =
amba_id *id)
>=20
>  	return 0;
>  probe_err3:
> -	amba_set_drvdata(adev, NULL);
> -
>  	/* Idle the DMAC */
>  	list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
>  			chan.device_node) {
> @@ -3064,7 +3062,6 @@ static int pl330_remove(struct amba_device *adev)
>  		of_dma_controller_free(adev->dev.of_node);
>=20
>  	dma_async_device_unregister(&pdmac->ddma);
> -	amba_set_drvdata(adev, NULL);
>=20
>  	/* Idle the DMAC */
>  	list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
> --
> 1.8.2.3
>=20



--=20

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJScmhIAAoJEHwUBw8lI4NH+r8QANXxv4QNTara28vREddF4iof
EChkn9TF38GZ67l8A6zuH4tItAORAQmpLOnVBD1h5lBq8dqVAsSpd/hHz0TVmBxM
krut+qSAGqq0lh/xYb8nOf8gMt/ZsptkwbIPlaIujwO0PxW09jQ/kU0wfzJ/rOi3
1mFadcCHyxDukEYh+uvswqBzH95iWlqv0arfnNIUiWHtI9IwFugEBY6BeZc1fsjI
N24UgXgzh8p6FnusiIwPUbmYSt2Ig5pLY8NtpbSYHjkKMz1BB3Lm3ITWlLzoVLMN
XFJfrLoOQgTyJsyJbxNJMt303YvP5r1q8PaVS1iDrVnUbITy355OSMAdDkMRuaMP
gRUMYvGwFrDZD76qWzH/2KkEc75Cgo1HHn/DfbRl2Cm1FmvmYA+7yei+rclwIzAy
sZVLymWMqDPOVUc5+48mStw3/GCQGi/LsWDTlsco2/HqP7fobBWjDRbel9JbyiOZ
HfAKVv3Lrazj6MuVcn8JqW314OroDu7G03qo7kSaXV4hqi+/OU1Y8+jjZvJnqxCf
s74bUJSDNZsvbqSyuxi8Z70OFdvoenB31slWM4DlIhDP8cWLnouqrhmakYS/+K0q
kbHvLfBP95CIOq2KlJ3sZ2GeAMBhJMwdnJaRK4HutHmVXHZ/vrmKDudpt9tzGD7Z
GMomCSzNuxNLSXgPm0KJ
=Iy/X
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
