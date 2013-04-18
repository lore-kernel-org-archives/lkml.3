Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366Ab3DRD63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 23:58:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40193 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab3DRD61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 23:58:27 -0400
Date: Thu, 18 Apr 2013 06:58:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] driver: serial: omap: add prepare/complete callback
 for "no_console_suspend" case
Message-ID: <20130418035801.GB18349@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>
 <1366198467-6757-4-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <1366198467-6757-4-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 17, 2013 at 05:04:24PM +0530, Sourav Poddar wrote:
> @@ -1632,6 +1650,8 @@ static const struct dev_pm_ops serial_omap_dev_pm_o=
ps =3D {
>  	SET_SYSTEM_SLEEP_PM_OPS(serial_omap_suspend, serial_omap_resume)
>  	SET_RUNTIME_PM_OPS(serial_omap_runtime_suspend,
>  				serial_omap_runtime_resume, NULL)
> +	.prepare        =3D serial_omap_prepare,
> +	.complete       =3D serial_omap_complete,

if CONFIG_PM_SLEEP isn't defined, this will break compilation.

--=20
balbi

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRb29JAAoJEIaOsuA1yqREK7MQAJ2RjscGfXHHi+jV9Fhx93Fq
YHYUF7fvTYiEf36aEhTRQs97r3nsJzIJeNRxqsDRvfiNHIYFnStQI/Q8Ihcly9/L
fHEVWleSt6FFTH0etqw/NnFSKj2F9OM95W3N5clK8U19iRUp4+oNbjit0DqNx3QU
h8F76xrPDNzViXxh3zwxLUbtNDQNKGdrixQGL7b5goZw0x0e3RLgjAOFID87FBex
OcyZa7jvayVPf3+4Ji1P1wP3qotj5e18DqtR0nJZqG0CL3ToQJDlsLJrxEWuW5P3
jdK76LpsZjLNG6pAGJpsDPgt0b7bS18cn7KjLWOMLCLQEB621YUCCCpBLFi98PRT
SNJhDWGVhy2qLDrFRqlMO8QQTi5mydox3VCk6RwR8Vp6qxsU6xVQcPgfeCXC7q7r
+fsvwsu+JSa6RHFn4+vzqG0uTR/dtKuqvtI3+TJThjIr0Ep9YPGt3N2VEEa3XGPh
3688KCG3L5WkRfwX6Jark8FqH7cMrqwy16rCJVScrcZx6xCnvNm29fYsLEpvu8WG
aDGX0dw4iSp1KuL5R3loB0oeANW+nJsV5xfJKZbbsbEsDuEpw3heUgruHb601qMY
v23RFmcTQ+mbUl+xMa8p8ukBvv9Cy38s87gqwavRWNTfGQdSze1FuHgbX/ppSsFj
KZh/P8hfkzuwl1N0HaZY
=fsvf
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
