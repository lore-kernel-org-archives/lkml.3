Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaDDFiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 01:38:52 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44515 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaDDFiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 01:38:07 -0400
Message-ID: <533E4538.70107@monstr.eu>
Date: Fri, 04 Apr 2014 07:38:00 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Harini Katakam <harinikatakamlinux@gmail.com>
CC: Mark Brown <broonie@kernel.org>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Punnaiah Choudary <kpc528@gmail.com>,
        punnaiah choudary kalluri <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: Re: [PATCH 1/2] devicetree: Add devicetree bindings documentation
 for Zynq Quad SPI
References: <ee057d8c-50d9-4d4b-ac86-d7c5fc44b1b0@TX2EHSMHS034.ehs.local> <20140403210135.GX14763@sirena.org.uk> <CAFcVEC+sqB9VQUEgiFN_MwHcvYFqEifh6EuHPLAkKZOnBiaQ9A@mail.gmail.com>
In-Reply-To: <CAFcVEC+sqB9VQUEgiFN_MwHcvYFqEifh6EuHPLAkKZOnBiaQ9A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="StdWMl9Q0AaEu5jNiAqw8S3odGLnk4Rfx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--StdWMl9Q0AaEu5jNiAqw8S3odGLnk4Rfx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Mark and Harini,

On 04/04/2014 05:01 AM, Harini Katakam wrote:
> Hi Mark,
>=20
> On Fri, Apr 4, 2014 at 2:31 AM, Mark Brown <broonie@kernel.org> wrote:
>> On Thu, Apr 03, 2014 at 10:33:06PM +0530, Punnaiah Choudary Kalluri wr=
ote:
>>
>>> +Optional properties:
>>> +- num-cs             : Number of chip selects used.
>>
>> What does this translate into?
>>
>>> +             num-cs =3D /bits/ 16 <1>;
>>
>> Why the odd specification in the example - why not just specify it as =
a
>> number?
>=20
> Same as discussed on SPI cadence thread.

I have discussed this briefly with Rob and it is more up to Mark
if he wants to have this with 16bit width or not. I expect that
"num-cs" is getting to be shared across spi drivers
and maybe in near future you will move "num-cs" of probe to spi core
that's why it should stay 32bit for easier integration.

I have asked Harini some weeks ago to try to do it just with
of_property_read_u16 because you can directly setup
master->num_chipselect and you don't need to read it as u32
and saving to u16.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--StdWMl9Q0AaEu5jNiAqw8S3odGLnk4Rfx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM+RTgACgkQykllyylKDCFYHACfRnVIuDYW4iKWeGhw3YWDRwAu
jsEAniwyjNmI2fVlwuieSK+osHzM8dR2
=lwtq
-----END PGP SIGNATURE-----

--StdWMl9Q0AaEu5jNiAqw8S3odGLnk4Rfx--
