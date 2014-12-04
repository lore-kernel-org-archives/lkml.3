Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaLDJJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:09:48 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44232 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbaLDJJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:09:44 -0500
Message-ID: <548024C7.3060004@ti.com>
Date: Thu, 4 Dec 2014 11:09:27 +0200
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
References: <1417598162-40433-1-git-send-email-Li.Xiubo@freescale.com> <4810522.t9QFQYHtHI@wuerfel> <BY2PR0301MB06131C2C901351E8592ED3D89B780@BY2PR0301MB0613.namprd03.prod.outlook.com> <548016D9.6030006@ti.com> <BY2PR0301MB0613ABEA1410C04CF07C1C7C9B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
In-Reply-To: <BY2PR0301MB0613ABEA1410C04CF07C1C7C9B780@BY2PR0301MB0613.namprd03.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="mL5BEnnrNRXb4R5hjrHE155ThGAeTR2rP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mL5BEnnrNRXb4R5hjrHE155ThGAeTR2rP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/12/14 10:30, Li.Xiubo@freescale.com wrote:

> Sorry for confusing, it was delayed for other reasons internal.
>=20
> I am not familiar about the DRM, and I'd like to know if the DRM driver=
 will be
> support, should I also develop the libdrm too ? Or just coding in kerne=
l level ?

For simple drm drivers (this looks like it would be a simple one), I
don't think there's any need for libdrm support. The generic DRM
interfaces should be enough, so just kernel level coding needed.

> Is there any Document about how to have /dev/fbX device to use ?

There's DRM documentation here:

https://www.kernel.org/doc/htmldocs/drm/index.html

And many existing drivers to use as examples. The dri-devel list
(http://lists.freedesktop.org/mailman/listinfo/dri-devel), which is the
mailing list used for DRM development, is active and you probably can
get more support from there than from the fbdev list.

It should not be a huge effort to write a drm driver for a simple LCD
controller like this. I would bet that you can write a working driver in
a week.

> If possible, I'd like this could be accept for this time. And I will ad=
d the DRM
> Version later(for developing and testing will take a long time).

I'm sorry but "it was delayed for internal reasons" and "our customer
needs this driver" are not very good reasons for getting a driver merged
to mainline Linux.

You can provide your driver to your customer as a separate patch series
which they can apply. There should be no conflicts or other issues
there, so it should be simple.

 Tomi



--mL5BEnnrNRXb4R5hjrHE155ThGAeTR2rP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgCTHAAoJEPo9qoy8lh71epsP/3qOMkBzesv84dMaRyVqJi8R
GAhluShgPWDoYoCEmsKnbNAr6nCptqxPhrMlQxd+2zn98Ybsnl6Cw19Ofsz6knm5
WDMIzGK0UPWGPziyNpWXoDmQZ6V86790dKbbcxsD7nQUK1AIXBh/pNA8n+yt4wU/
hjyog+JYg+Jb+eLNGSwxGkwoiA6yBhtqOMbaHrk7p+5KsGjeJczUao48N1o+iyn2
fDVwlWt4zrEQBf4xa937v1gOTBJ03esl7tMpNoHys5vaQZocCr01UiGADpMsJWXf
ylD4bO6YsJxvovcECDJ5dzOb1gQGJRKr9lFDFqSX7XUq35kjTdD9cyzYedgG6RvD
cZBeGr7ksEq7E74lKSgn3xP2yvkSKCVLDzSSpW7chxxLOnIUKPTwWQwIdrPnanc9
S3STM+vtBr5j1CMo1xaragNmFXBH6lbAfnVbrUb1JVGAwEXLdYVlEBZH8hwtG+1A
5VkSkJu9WM+2JO58vcHvGF3Y2GrtgK+emROcwDiqFDh4Mcf5bUJuabjDQBX7slKD
z8fhFRKGHlOXLp5nXsMTuvddjoOc3oCNuAAMv46x7jZrzpLTyyOMQyWkxd2QAfWv
Nm2jPbMrR3n43sKZ6T075/NkPRA0IzF7UOiQlFk3lPBwTa5hNJsMIIQDibuEuniz
yiRqPtRAkF1cxfH51hFa
=s4Y2
-----END PGP SIGNATURE-----

--mL5BEnnrNRXb4R5hjrHE155ThGAeTR2rP--
