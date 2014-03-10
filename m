Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaCJL7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 07:59:11 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53794 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaCJL7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:07 -0400
Message-ID: <531DA900.5060202@monstr.eu>
Date: Mon, 10 Mar 2014 12:58:56 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "kpc528@gmail.com" <kpc528@gmail.com>,
        "kalluripunnaiahchoudary@gmail.com" 
	<kalluripunnaiahchoudary@gmail.com>,
        "punnaia@xilinx.com" <punnaia@xilinx.com>
Subject: Re: [RFC PATCH] edac: zynq: Added EDAC support for zynq ddr ecc controller
References: <4adb2b4b-2ad6-42b9-929e-cc062f817245@TX2EHSMHS021.ehs.local> <20140310105655.GH14999@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140310105655.GH14999@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oDbPVhl1X1dX8MJdBfDsuSDlbxsSGQFq8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oDbPVhl1X1dX8MJdBfDsuSDlbxsSGQFq8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/10/2014 11:56 AM, Mark Rutland wrote:
> On Sun, Mar 09, 2014 at 02:57:16AM +0000, Punnaiah Choudary Kalluri wro=
te:
>> Added EDAC support for reporting the ecc errors of zynq ddr controller=
=2E
>> The ddr ecc controller corrects single bit errors and detects double b=
it
>> errors
>>
>> Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
>> ---
>>  .../devicetree/bindings/edac/zynq_edac.txt         |   18 +
>>  drivers/edac/Kconfig                               |    7 +
>>  drivers/edac/Makefile                              |    1 +
>>  drivers/edac/zynq_edac.c                           |  613 +++++++++++=
+++++++++
>>  4 files changed, 639 insertions(+), 0 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/edac/zynq_edac.t=
xt
>>  create mode 100644 drivers/edac/zynq_edac.c
>>
>> diff --git a/Documentation/devicetree/bindings/edac/zynq_edac.txt b/Do=
cumentation/devicetree/bindings/edac/zynq_edac.txt
>> new file mode 100644
>> index 0000000..c21ff83
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/edac/zynq_edac.txt
>> @@ -0,0 +1,18 @@
>> +Zynq EDAC driver, it does reports the DDR ECC single bit errors that =
are
>> +corrected and double bit ecc errors that are detected by the DDR ECC =
controller.
>> +ECC support for DDR is available in half-bus width(16 bit) configurat=
ion only.
>> +
>> +Required properties:
>> +- compatible: Should be "xlnx,ps7-ddrc" or "xlnx,ps7-ddrc-1.00.a"
>=20
> Is this an or or a xor?

Compatible string should be just xlnx,zynq-ddrc-1.00.a.
Nothing with ps7.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--oDbPVhl1X1dX8MJdBfDsuSDlbxsSGQFq8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMdqQAACgkQykllyylKDCG/5gCfS7ef2Z11eN5l+5C5L1LZERTk
N8EAoJqsvEm9i4ZuhRxjBCZDZraaJCze
=GHMX
-----END PGP SIGNATURE-----

--oDbPVhl1X1dX8MJdBfDsuSDlbxsSGQFq8--
