Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaLDKAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:00:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42058 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbaLDJ76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:59:58 -0500
Message-ID: <5480308F.6070607@ti.com>
Date: Thu, 4 Dec 2014 11:59:43 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "alexander.stein@systec-electronic.com" 
	<alexander.stein@systec-electronic.com>
Subject: Re: [PATCHv2 0/4] LS1021A: Add dcfb framebuffer driver support.
References: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com> <4810522.t9QFQYHtHI@wuerfel> <BY2PR0301MB06131C2C901351E8592ED3D89B780@BY2PR0301MB0613.namprd03.prod.outlook.com> <548016D9.6030006@ti.com> <BY2PR0301MB0613ABEA1410C04CF07C1C7C9B780@BY2PR0301MB0613.namprd03.prod.outlook.com> <548024C7.3060004@ti.com> <BY2PR0301MB061372E00518F169BCF2FFFA9B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
In-Reply-To: <BY2PR0301MB061372E00518F169BCF2FFFA9B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="v3vJbD6ricPu0Nex7CWVcae8Bu9VAiSAG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--v3vJbD6ricPu0Nex7CWVcae8Bu9VAiSAG
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/12/14 11:54, Li.Xiubo@freescale.com wrote:
> Hi Tomi,
>=20
> Thanks for your information very much.
>=20
>>> Sorry for confusing, it was delayed for other reasons internal.
>>>
>>> I am not familiar about the DRM, and I'd like to know if the DRM driv=
er will
>> be
>>> support, should I also develop the libdrm too ? Or just coding in ker=
nel
>> level ?
>>
>> For simple drm drivers (this looks like it would be a simple one), I
>> don't think there's any need for libdrm support. The generic DRM
>> interfaces should be enough, so just kernel level coding needed.
>>
>=20
> That's to say, if I am using the X11 server without any code in usrspac=
e,
> If the DRM driver will support /dev/fbX, it could work correctly ?

Yes. DRM offers helper code to add /dev/fbX with not too many lines. You
can look at the docs and drm_fb_helper.c.

And X11 should work fine on top of that, using the X11 fbdev support.

 Tomi



--v3vJbD6ricPu0Nex7CWVcae8Bu9VAiSAG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgDCPAAoJEPo9qoy8lh71C6oP/2j/ewerlhm3Ed0f92cLNHSV
PQOZtAwAkFeCi7nbqEmKQfLTSilK89lxcEcDVH6YSUPp5Mstaaya+meNlJwUazVg
tglLuqamgIwRSSBd8nqlPn4uOr5yfrHFvtawYgy+yPoUaOGZpoviAn75dENOTXor
5ouQ4bUiPz6SlbRPnWWWzkgvZZaZ/S1w1KCEh1XPr+7f5z9fBWTTGhtERaHps3rd
iw/gnnBteavHz7h1RZnV7CKELWa5fePMTz6jhTgsiQtDwnEmTHAGHWgOFxpJOisv
6qtxf5hCc0cu8SGndvRDuSwcp17F70Wc/1fBhwLIH2/6hviIZa5bPtkmt7fK8cUe
n59FrxeiNvxXQ4ERKPUOPp9fNL5fZuFHgivh0XFFf7WOX1MGC/phFZ1C4g3e1JgG
KxROKMVPiZouYQO/T6cvmK57RZX3+l51EklS5sm7ZuniLTH7fgX8kblTYyAZziVW
z+sV9WVPKZwmoVasnC0T6HzBejvsCw3AvtIqBwp7gKXsKmkFRkjuclYDQVjMjsBD
f01YytLU4Awv2fIKVrkiYyvlueAJU9JVzY+5X7uasQDjngdf4/3a1nOU18dpEIKf
Oc/QNVzyBBrpYS8Tp1rXpniuwbzACb2dqd0LEvd4eSDTF37LvphGRMmGByiTPX+L
sZFNd9mlk6zcoGMFUkhT
=nziE
-----END PGP SIGNATURE-----

--v3vJbD6ricPu0Nex7CWVcae8Bu9VAiSAG--
