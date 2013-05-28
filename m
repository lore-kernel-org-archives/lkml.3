Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934361Ab3E1Oad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:30:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47071 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934279Ab3E1Oac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:30:32 -0400
Message-ID: <51A4BF7F.4010705@ti.com>
Date: Tue, 28 May 2013 10:30:23 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <gregkh@linuxfoundation.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>
Subject: Re: [PATCH 0/2] staging -> thermal: move ti-soc-thermal to drivers/thermal
References: <1368632761-10528-1-git-send-email-eduardo.valentin@ti.com> <1369708896.1913.5.camel@rzhang1-mobl4>
In-Reply-To: <1369708896.1913.5.camel@rzhang1-mobl4>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2QQGEWGQFANADHFKJIDIV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2QQGEWGQFANADHFKJIDIV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 27-05-2013 22:41, Zhang Rui wrote:
> On Wed, 2013-05-15 at 11:45 -0400, Eduardo Valentin wrote:
>> Hello Greg and Rui,
>>
>> I am proposing to move the ti-soc-thermal driver from drivers/stating/=

>> to drivers/thermal. It has been some time that we have been fixing and=

>> improving the code under staging tree.
>>
>> I believe it is time to move on. The driver now has a better code
>> organization (split between code and data), DT support, better coding
>> style, it supports TI OMAP chips 4430, 4460, 4470 and 5430, and it is
>> ready for easy addition of other SoC chips containing the bandgap IP.
>> Besides, this driver required some major changes in the thermal framew=
ork,
>> before it could provide basic functionality using the device capabilit=
y.
>> These changes have been already merged in previous merge windows,
>> so there is no pending dependencies.
>>
>> The remaining items in the TODO list are actually not a blocker for th=
is
>> move, IMO. The PM support is not fully completed on all supported OMAP=
 chips.
>> The locking so far has not caused any issues, and I believe that most =
of
>> the interesting data is protected by the thermal framework.
>>
>> I am sending this patch for your appreciation and also to get wider re=
view.
>>
>=20
> patch applied to thermal -next tree and targeted for 3.11.


Thanks Rui,

I am going to send the usual ti soc thermal fixes patch set to you now.
I ve been sending it anyway to linux-pm. Only thing is that it should go
via your tree now.

Next set should contain some fixes identified during internal testing.

>=20
> thanks,
> rui
>> All best,
>>
>> Eduardo Valentin (2):
>>   thermal: introduce TI SoC thermal driver
>>   MAINTAINERS: update TI SoC thermal driver entry
>>
>>  .../devicetree/bindings/thermal}/ti_soc_thermal.txt                  =
 | 0
>>  MAINTAINERS                                                          =
 | 4 ++--
>>  drivers/staging/Kconfig                                              =
 | 2 --
>>  drivers/staging/Makefile                                             =
 | 1 -
>>  drivers/thermal/Kconfig                                              =
 | 3 +++
>>  drivers/thermal/Makefile                                             =
 | 2 +-
>>  drivers/{staging =3D> thermal}/ti-soc-thermal/Kconfig                =
   | 0
>>  drivers/{staging =3D> thermal}/ti-soc-thermal/Makefile               =
   | 0
>>  drivers/{staging =3D> thermal}/ti-soc-thermal/TODO                   =
   | 0
>>  drivers/{staging =3D> thermal}/ti-soc-thermal/omap4-thermal-data.c   =
   | 0
>>  drivers/{staging =3D> thermal}/ti-soc-thermal/omap4xxx-bandgap.h     =
   | 0
>>  drivers/{staging =3D> thermal}/ti-soc-thermal/omap5-thermal-data.c   =
   | 0
>>  drivers/{staging =3D> thermal}/ti-soc-thermal/omap5xxx-bandgap.h     =
   | 0
>>  drivers/{staging =3D> thermal}/ti-soc-thermal/ti-bandgap.c           =
   | 0
>>  drivers/{staging =3D> thermal}/ti-soc-thermal/ti-bandgap.h           =
   | 0
>>  drivers/{staging =3D> thermal}/ti-soc-thermal/ti-thermal-common.c    =
   | 0
>>  drivers/{staging =3D> thermal}/ti-soc-thermal/ti-thermal.h           =
   | 0
>>  17 files changed, 6 insertions(+), 6 deletions(-)
>>  rename {drivers/staging/ti-soc-thermal =3D> Documentation/devicetree/=
bindings/thermal}/ti_soc_thermal.txt (100%)
>>  rename drivers/{staging =3D> thermal}/ti-soc-thermal/Kconfig (100%)
>>  rename drivers/{staging =3D> thermal}/ti-soc-thermal/Makefile (100%)
>>  rename drivers/{staging =3D> thermal}/ti-soc-thermal/TODO (100%)
>>  rename drivers/{staging =3D> thermal}/ti-soc-thermal/omap4-thermal-da=
ta.c (100%)
>>  rename drivers/{staging =3D> thermal}/ti-soc-thermal/omap4xxx-bandgap=
=2Eh (100%)
>>  rename drivers/{staging =3D> thermal}/ti-soc-thermal/omap5-thermal-da=
ta.c (100%)
>>  rename drivers/{staging =3D> thermal}/ti-soc-thermal/omap5xxx-bandgap=
=2Eh (100%)
>>  rename drivers/{staging =3D> thermal}/ti-soc-thermal/ti-bandgap.c (10=
0%)
>>  rename drivers/{staging =3D> thermal}/ti-soc-thermal/ti-bandgap.h (10=
0%)
>>  rename drivers/{staging =3D> thermal}/ti-soc-thermal/ti-thermal-commo=
n.c (100%)
>>  rename drivers/{staging =3D> thermal}/ti-soc-thermal/ti-thermal.h (10=
0%)
>>
>=20
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2QQGEWGQFANADHFKJIDIV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGkv38ACgkQCXcVR3XQvP2dhgEAlmEDiidoxF8jcUNCWakEjp9Q
5rPVqPIuksXoh7BbFdgA+wSgTzP9w+c7Bg/kHC1lcABd9QJE72J4xp/H8lbQgdQS
=of1p
-----END PGP SIGNATURE-----

------enig2QQGEWGQFANADHFKJIDIV--
