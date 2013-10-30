Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3J3KyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:54:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33423 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab3J3KyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:54:11 -0400
Message-ID: <5270E548.5040708@ti.com>
Date: Wed, 30 Oct 2013 12:54:00 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Tom Gundersen <teg@jklm.no>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] simplefb: use write-combined remapping
References: <1380725919-1961-1-git-send-email-dh.herrmann@gmail.com>	<1380725919-1961-2-git-send-email-dh.herrmann@gmail.com> <CANq1E4SRWsKf4uqF01Rju-uSNF-gj9zL9_+0zAqsgPMjv8Q3Uw@mail.gmail.com>
In-Reply-To: <CANq1E4SRWsKf4uqF01Rju-uSNF-gj9zL9_+0zAqsgPMjv8Q3Uw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="lvbK1TotXabPBf0lnwUjs9e1LP4xAw7XE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lvbK1TotXabPBf0lnwUjs9e1LP4xAw7XE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-10-30 09:49, David Herrmann wrote:
> Hi Tomi
>=20
> Ping?

Thanks, queued this and the 1/2 patch for 3.13.

 Tomi

>=20
> Thanks
> David
>=20
> On Wed, Oct 2, 2013 at 4:58 PM, David Herrmann <dh.herrmann@gmail.com> =
wrote:
>> Framebuffers shouldn't be cached and it is usually very uncommon to re=
ad
>> them. Therefore, use ioremap_wc() to get significant speed improvement=
s on
>> systems which provide it. On all other systems it's aliased to
>> ioremap_nocache() which is also fine.
>>
>> Reported-by: Tom Gundersen <teg@jklm.no>
>> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>> Tested-by: Tom Gundersen <teg@jklm.no>
>> Tested-by: Alexandre Courbot <acourbot@nvidia.com>
>> Tested-by: Stephen Warren <swarren@wwwdotorg.org>
>> ---
>>  drivers/video/simplefb.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
>> index 74b016c..64db54a 100644
>> --- a/drivers/video/simplefb.c
>> +++ b/drivers/video/simplefb.c
>> @@ -219,8 +219,8 @@ static int simplefb_probe(struct platform_device *=
pdev)
>>
>>         info->fbops =3D &simplefb_ops;
>>         info->flags =3D FBINFO_DEFAULT | FBINFO_MISC_FIRMWARE;
>> -       info->screen_base =3D ioremap(info->fix.smem_start,
>> -                                   info->fix.smem_len);
>> +       info->screen_base =3D ioremap_wc(info->fix.smem_start,
>> +                                      info->fix.smem_len);
>>         if (!info->screen_base) {
>>                 framebuffer_release(info);
>>                 return -ENODEV;
>> --
>> 1.8.4
>>



--lvbK1TotXabPBf0lnwUjs9e1LP4xAw7XE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJScOVIAAoJEPo9qoy8lh71ORMP+wePtkwwfwuPKQQPGo3XCoMG
TZ1YEc4s/t2DB+Bmc5FcUddCxYS2IbciPxIFv4ZIRcgWXvT+jva4rXMQ03U+8yYv
5Is8b8IR6+AGJkuR409vV3hXfXgv0EqEDu7jr63jo/1eTOO7v1qessEgD+cm0bFi
Xt3FjIx8gLC4DK8Md1rvwosaqGhFGaDUC4Ml9pAu+qI9CTGKjt4ovNbYh1Vi7hHw
BQGHwd2xeXu0bsvJV0lC5loa8Krz0VVbYOziRmwspeIjdiFZ28eZ/o4tfKBLSN1S
Qd/yk50aCOF0yK92v6dh+lHcD40Hcw9yPH+xWM1zV5aqPqh4ISPs/yavCsUsp+R4
ZvRD2pGFi2oOdDgJSFaCe57/pl0eOBQZ/eRuIwIVPgeEFYNVvUhCFOSM2lQ+zCM5
49B9DZ9NJQO0Al4nY1HCTxohPx+ph5P5wBcTC+l1w8oWGL5hEfkaPbg8Imgg96cs
brTFtG5l25awhBt6uemwiMHLrBrBNw8gQewm39xNYor6MV1TgF+XlwbsnOsNcJXa
AbFDiW8xNLuvvNT/mDRwxU0tTV8sgVpJuVIT+bOxHlLyf9c8t3lgdg6oBqy4tR9Y
vwG57mMgsJT6FyqG5c5lUtglhezj+uhDf8mXAtSB3Z5nYOWk8frU9jjppYHoYRc/
YI23YMUFFx3itEz/IIyW
=Enpa
-----END PGP SIGNATURE-----

--lvbK1TotXabPBf0lnwUjs9e1LP4xAw7XE--
