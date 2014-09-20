Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaITJKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 05:10:44 -0400
Received: from sauhun.de ([89.238.76.85]:58241 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbaITJKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 05:10:42 -0400
Date: Sat, 20 Sep 2014 11:11:07 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: cadence: Remove .owner field for driver
Message-ID: <20140920091106.GB1612@katana>
References: <c076984af7e65c433fdfd3a3b0f8d20da2c18013.1407931005.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <c076984af7e65c433fdfd3a3b0f8d20da2c18013.1407931005.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 01:56:51PM +0200, Michal Simek wrote:
> There is no need to init .owner field.
>=20
> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
> "mmc: remove .owner field for drivers using module_platform_driver"
>=20
> This patch removes the superflous .owner field for drivers which

It says drivers, but does only one...

> use the module_platform_driver API, as this is overriden in
> platform_driver_register anyway."

=2E.. so: any interest in doing this for the whole subsystem? Basically
good catch, though.

>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>=20
>  drivers/i2c/busses/i2c-cadence.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-ca=
dence.c
> index 63f3f03ecc9b..04d0a7e449ef 100644
> --- a/drivers/i2c/busses/i2c-cadence.c
> +++ b/drivers/i2c/busses/i2c-cadence.c
> @@ -890,7 +890,6 @@ MODULE_DEVICE_TABLE(of, cdns_i2c_of_match);
>  static struct platform_driver cdns_i2c_drv =3D {
>  	.driver =3D {
>  		.name  =3D DRIVER_NAME,
> -		.owner =3D THIS_MODULE,
>  		.of_match_table =3D cdns_i2c_of_match,
>  		.pm =3D &cdns_i2c_dev_pm_ops,
>  	},
> --
> 1.8.2.3
>=20



--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUHUSqAAoJEBQN5MwUoCm2RkQP/jXritYoVl775eHAWZMoW/+C
keC9CaGujLilF//CKXBDb6YYyauWfd3GFJIFbT2dc/JuofudT9GsI1J5YBZMBblm
no+KeEk63sIM4xN+/xy6UNNsvdD2CXsIo+RK8f0PfDkyjN39wT0mAgEXb6v2v07T
2U6nIzcopB9trEgfaV3S86KOP/GoQk4noLvn286IOQRo0d+31rc2NRIhtP2v2T+p
4PfV6K8x86TTqyC6JZ0tfaxa/KygudWt1AtraN3kp8nXZAJiPdLnv5eMIFG6tVwU
Uv8/NsxBSopxUdMvqdFHug7Q1Cp7B3mpvGa1k2dpdeS1BgInT2hfHdy2KbXSDYNB
wR7Es8NT+bCX+hQJkoLn7F1kmJn6/H0RAJeTf49ixNZrQOMQAiMBq+hdhrm4oF98
0nnvQxg8bx28KvyQTJGymlV8FRaHy2CfN2BKMzdcbOoOjnZUBwHsIhnL+ANYSGmD
RDnjw1V8R7OR0m/dW0WjihmYOzi8vLUFttnULvRSlGoRCnMBsCg4495xinSey3OP
6jpA/W/yftzcZMepT3upDeJDUr1iaoGg5I6o+v114s5EnNIRyN2q9RPVUKUo3GCg
cDjxe6Q8hAdHSsAFiXYZFsrXSAQXa/HnbM8ZpRQoi2sLPSQQaqMkQF5mp+grdyHw
YmMUDzsVNEsqlmPfQcBx
=p5qd
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
