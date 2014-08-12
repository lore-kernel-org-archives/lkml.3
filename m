Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbaHLJhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:37:35 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44891 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbaHLJhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:37:31 -0400
Message-ID: <53E9E052.3070308@monstr.eu>
Date: Tue, 12 Aug 2014 11:37:22 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Srikanth Thokala <sthokal@xilinx.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        svemula@xilinx.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>, anirudh@xilinx.com
Subject: Re: [PATCH v5] pcie: Add Xilinx PCIe Host Bridge IP driver
References: <1406131381-25577-1-git-send-email-sthokal@xilinx.com>	<CA+mB=1JhDF=BBXcyTbgVB8S7qH=Mb1JH78HLL4pA9OBH19hQvA@mail.gmail.com>	<8258903.Rn4s07GKGV@wuerfel> <CA+mB=1LeZn1k2VHNby2TRBcb1xuFFTQio=C845_xe2A=ZciYqg@mail.gmail.com>
In-Reply-To: <CA+mB=1LeZn1k2VHNby2TRBcb1xuFFTQio=C845_xe2A=ZciYqg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="q6kIRpcKTBjkk9TCMqwk5g6kquBLV1CXU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q6kIRpcKTBjkk9TCMqwk5g6kquBLV1CXU
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

On 07/30/2014 01:24 PM, Srikanth Thokala wrote:
> Hi Arnd,
>=20
> On Mon, Jul 28, 2014 at 6:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Monday 28 July 2014 18:04:34 Srikanth Thokala wrote:
>>> Hi Arnd and Rob,
>>>
>>> I discussed with Bjorn and we believe this patch is in good shape to
>>> apply.  And Bjorn requires ACKs to apply this patch.  So, could you
>>> guys please review this patch and provided your ACKs to this patch.
>>
>> Looks great for the most part. I've looked through the whole driver
>> again, and I have two small issues remaining:
>>
>> a) Please clarify in the changeset description why there is no support=

>>    for PCI I/O space.
>=20
> Sure, I will add to my changeset.
>=20
>>
>> b) I think you should use the 'msi-parent' property, and the
>>    of_pci_find_msi_chip_by_node() to find the msi_chip for the
>>    PCI controller. This will make it possible to forward MSIs
>>    to the main interrupt controller in the system, which is more
>>    efficient. See the pcie-mvebu driver for an example of this.
>=20
> Ok, I need to look into this and I will plan to implement on top of thi=
s patch.
>=20
>>
>> Other than these:
>>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>=20
> Thanks Arnd for the Ack.

What's the status on this one?

Srikanth:
Isn't pcie-xilinx.c better name if this is just pcie host bridge?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--q6kIRpcKTBjkk9TCMqwk5g6kquBLV1CXU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlPp4FYACgkQykllyylKDCHy1ACfQqu74eitbokR7l/BnmFHNqzZ
cIUAnR96rLi4FehQknsDgvflZSHGx00K
=fxph
-----END PGP SIGNATURE-----

--q6kIRpcKTBjkk9TCMqwk5g6kquBLV1CXU--
