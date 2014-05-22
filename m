Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaEVMAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:00:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45409 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754674AbaEVMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:00:05 -0400
Date: Thu, 22 May 2014 13:58:05 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, andriy.shevchenko@intel.com,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        zhuzhenhua@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, dmaengine@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 0/2] Add support for the Allwinner A31 DMA Controller
Message-ID: <20140522115805.GC27329@lukather>
References: <1400685357-508-1-git-send-email-maxime.ripard@free-electrons.com>
 <4828893.NoTbcUXQEt@wuerfel>
 <20140521155551.GV27329@lukather>
 <5291281.0OW8pVdbhQ@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ynll37MX3Fmyj3VY"
Content-Disposition: inline
In-Reply-To: <5291281.0OW8pVdbhQ@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ynll37MX3Fmyj3VY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2014 at 06:04:43PM +0200, Arnd Bergmann wrote:
> On Wednesday 21 May 2014 17:55:51 Maxime Ripard wrote:
> > On Wed, May 21, 2014 at 05:23:41PM +0200, Arnd Bergmann wrote:
> > > On Wednesday 21 May 2014 17:15:54 Maxime Ripard wrote:
> > > > Changes from v7:
> > > >   - select DMA_OF, since we're only relying on DT
> > > >=20
> > >=20
> > > I missed the discussion about this issue, but it seems wrong to me.
> > > DMA_OF is currently enabled if we have both DMAENGINE and OF turned o=
n.
> > >=20
> > > If OF is disabled but DMA_OF gets selected by DMA_SUN6I, what happens?
> >=20
> > Is that even possible with a multiplatform-based platform?
>=20
> It's not possible for ARCH_SUNXI or any other that depends on
> ARCH_MULTIPLATFORM. I just noticed that you have 'depends on ARCH_SUNXI',
> so the 'select DMA_OF' statement is just redundant, not wrong.
>=20
> However, if the driver was 'depends on ARCH_SUNXI || COMPILE_TEST' as many
> others are nowadays, it would be a bug.

Ah, yes, I forgot about COMPILE_TEST.

I'll change this to remove the select, and add a dependency on
COMPILE_TEST.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ynll37MX3Fmyj3VY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTfeZNAAoJEBx+YmzsjxAgmuUP/3ajKvld+AlL18U2BQRlb4Il
vN2HkqOkJbZqqKA8w5qrWXsM/0Q1Idzb6Wpm3qH3vKtDCI8B3B9zofeeYUUmmLBX
nJqFPqhVIrEgryI2jXrBZyCqaWJD1Bq3yimUuic5He00L4cArljYVZA4NkVP4b1L
Bqi3Tvke+4B3w8Wm68o0UauctCHY77rnzn1m/e27VT5lwPPb3sHcvd9V3tK3+Cyz
kfZiXROeRIpRjV3hDHM1YiYCpgqNswAXI/NUPKrSl/kxBr/DxFZXFVq5KCokyWO9
d9GROmVuoZm05kJn828IJFqhMIgo4atDB5IKGdekixrX0X5Esn3W26urDzRyWk0k
MxtovFWg7MhLhzUCtwy8SlBXiO6mlC3FBMVKu10Z4NhjDsfAol6tJ6UscnpTCDiP
AeSfUDq9XuTL18SYBpB5fVI2rWXa3LqNw14uHGmGPUiTPfk7MMyU3h2oAhv/U8pd
n/rM4RjTGw7qvf87pKE2z6LuBPxj48etBCDMc+/Oc+s3gKUffJ1ixObXYoPQUb6p
Tv+ABhXX6DKVkUWbfzJoQFuk0Px1dY8elgpBeKtHUKfrIz3zw0Rc7tP8VW/LDzpP
a9xZLO92XplUKHSHI7yDJPE8EonYaHVCqvekT3bdbBtpyCj/+7lHku6Ampclsd+C
F/DNjMX6apxpozVBOe5t
=cdyN
-----END PGP SIGNATURE-----

--ynll37MX3Fmyj3VY--
