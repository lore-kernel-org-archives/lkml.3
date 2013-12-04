Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3LDItm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:49:42 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44545 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab3LDItl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:49:41 -0500
Message-ID: <529EEC9E.8020302@ti.com>
Date: Wed, 4 Dec 2013 10:49:34 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>, Johan Hovold <jhovold@gmail.com>,
        <linux-fbdev@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] atmel_lcdfb: fix module autoload
References: <1382459817-26990-1-git-send-email-jhovold@gmail.com> <529CD0B5.600@atmel.com>
In-Reply-To: <529CD0B5.600@atmel.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="8lf1qHBVARG1F16uq0je2hCQErvFHa21O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8lf1qHBVARG1F16uq0je2hCQErvFHa21O
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-12-02 20:25, Nicolas Ferre wrote:
> On 22/10/2013 18:36, Johan Hovold :
>> Add missing module device table which is needed for module autoloading=
=2E
>>
>> Signed-off-by: Johan Hovold <jhovold@gmail.com>
>=20
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>=20
> Jean-Christophe, Tomi,
>=20
> Can you please take this patch?
>=20
> Best regards,
>=20
>=20
>> ---
>>   drivers/video/atmel_lcdfb.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c=

>> index 088511a..67b339c 100644
>> --- a/drivers/video/atmel_lcdfb.c
>> +++ b/drivers/video/atmel_lcdfb.c
>> @@ -94,6 +94,7 @@ static const struct platform_device_id
>> atmel_lcdfb_devtypes[] =3D {
>>           /* terminator */
>>       }
>>   };
>> +MODULE_DEVICE_TABLE(platform, atmel_lcdfb_devtypes);
>>
>>   static struct atmel_lcdfb_config *
>>   atmel_lcdfb_get_config(struct platform_device *pdev)
>>


Thanks, queued for 3.13 fbdev fixes.

 Tomi



--8lf1qHBVARG1F16uq0je2hCQErvFHa21O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSnuyeAAoJEPo9qoy8lh71WB4P/12WljcUTuIjBqzdrrMOchB1
l/3qszvE7jVxsAUXX8FMb7KmVilQCGlffUz7angvUOEyLh2DWl+Ef37N6zzr5ufX
XRa85EoLG9U9iSfWDtV74UQrfUphNCdPqBkN2VOVZJIr+ohGEhbkIuxLSdfWAT81
/qoPPbR8+yJX3YwD4BC5AbQUmpifT724KbDN/qdNU4G2N74t8n1Q4/btPYx5Hzdh
VKtnVStyCG10I0nYIAveQW/qES+isTApPIKWusggsnHk1075vkJ4XtWjpZMSAHyL
VINL77L8JZz/J0HJAnAnjVghVXbTtHYKgLgEF0q0yR9n+4w7eFFldVQtz+x28G0V
eIeXqiY80+BxYE7db6R4POCEOCdy6uq3b0L135VBBO2U9iFZ0gEWboWEAZ3kD3KM
heOZ4//F2vZX/HTo5+1kF4GkBRgGaUddTCSKqLqtZAS7ii3yunQCVAMK2dVySnaC
wxL+kErO0IwyZW5kvw9/JDcmbg7GD3rFQrriCmK5nsbPMMczAV6qfAP1ntfCi8sk
m45qgLE+Ug5sLlkm1rSzAm2y+W0pRMO+uq2nuXqkR6UyTZyn8bHDfmWwz+hE1Nl3
5t7GWcAjmBXEPg0Y+kFFVHOEz7MBdFOKfgolOZ3hFIVP/whIz+/BP6396y/igjap
Lf5hmQbRqvdmqWoqDiT1
=phRV
-----END PGP SIGNATURE-----

--8lf1qHBVARG1F16uq0je2hCQErvFHa21O--
