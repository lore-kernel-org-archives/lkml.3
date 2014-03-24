Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaCXMHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:07:16 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:51088 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaCXMHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:07:14 -0400
Message-ID: <53301FE2.4080705@monstr.eu>
Date: Mon, 24 Mar 2014 13:06:58 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jassi Brar <jassisinghbrar@gmail.com>
CC: monstr@monstr.eu, Jassi Brar <jaswinder.singh@linaro.org>,
        Srikanth Thokala <sthokal@xilinx.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Levente Kurusa <levex@linux.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dmaengine@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 2/2] dma: Add Xilinx AXI Video Direct Memory Access
 Engine driver support
References: <1395083192-3224-1-git-send-email-sthokal@xilinx.com> <1395083192-3224-3-git-send-email-sthokal@xilinx.com> <CABb+yY1z1Rr-EyJaeHQDb+thmKZVk5V93avokx6Z_EEuQFHyrw@mail.gmail.com> <CA+mB=1Lwq=Z3E+K7KTCgDKdmEQ8s5DMsAQVLVijdNPknNzx+SA@mail.gmail.com> <CAJe_Zhdnz+bdFiAqPgdH5hOTfzYUsoMyd0qpoWkeDAqqU+itSQ@mail.gmail.com> <53301023.8080301@monstr.eu> <CABb+yY13sheOvhVUkYNAO7t16egnPdf5x_fSvNuXVsU4E=W1Eg@mail.gmail.com>
In-Reply-To: <CABb+yY13sheOvhVUkYNAO7t16egnPdf5x_fSvNuXVsU4E=W1Eg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="uXdEDlFXgHCa7hXFKr2jJN8qHpi0UU5OM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uXdEDlFXgHCa7hXFKr2jJN8qHpi0UU5OM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03/24/2014 12:02 PM, Jassi Brar wrote:
> On Mon, Mar 24, 2014 at 4:29 PM, Michal Simek <monstr@monstr.eu> wrote:=

>> Hi Vinod,
>>
>> sorry for top posting.
>>
>> is there any chance to get this driver to the 3.15?
>> Or have you already closed your dma repo for new drivers?
>>
>> The driver should be in pretty good shape after long review.
>> From email below Srikanth got ACK from Jassi
>> and there should be a small fix which Srikanth will send in v7
>> which I hope will be the last version.
>>
> +1  Any change may come incrementally.
>=20
> Btw, here's the ack
>    Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
>=20

Ok. That's even better. The reason why I am asking for finishing
this is that we would like to start to pushing changes to
the media tree which depends on this driver.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--uXdEDlFXgHCa7hXFKr2jJN8qHpi0UU5OM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMwH+IACgkQykllyylKDCH/2QCdFb5y7R3djChP3GJs+PMi6+xm
sJsAoJauLEBZ2RQQWaT2tPA8ah4iEJkt
=jXLV
-----END PGP SIGNATURE-----

--uXdEDlFXgHCa7hXFKr2jJN8qHpi0UU5OM--
