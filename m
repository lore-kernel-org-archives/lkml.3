Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaDGVak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 17:30:40 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:42301 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaDGVaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 17:30:39 -0400
Message-ID: <534318FA.7030209@archlinux.org>
Date: Mon, 07 Apr 2014 23:30:34 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Fleming, Matt" <matt.fleming@intel.com>, Andi Kleen <ak@linux.intel.com>
CC: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tpowa@archlinux.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
References: <52E4CF03.8030208@archlinux.org>	<5339F739.2060207@archlinux.org>	<20140331233450.GI32556@tassilo.jf.intel.com>	<5339FC62.8060207@archlinux.org>	<20140405011332.GR32556@tassilo.jf.intel.com>	<5340134B.4010705@archlinux.org>	<20140407173016.GU32556@tassilo.jf.intel.com>	<5342E46B.4080603@archlinux.org>	<53430646.40507@archlinux.org>	<20140407204221.GW32556@tassilo.jf.intel.com> <CAL01qpvjZz-XnVT+S3E5E2XGcuFoetE5cwnArYfW-TwYZVKtKw@mail.gmail.com>
In-Reply-To: <CAL01qpvjZz-XnVT+S3E5E2XGcuFoetE5cwnArYfW-TwYZVKtKw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="R125uWB9QMliu0DpjADW0CDVcg0H5O96A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--R125uWB9QMliu0DpjADW0CDVcg0H5O96A
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 07.04.2014 23:25, schrieb Fleming, Matt:
> On 7 April 2014 21:42, Andi Kleen <ak@linux.intel.com> wrote:
>>
>> This sounds like the UEFI boot corrupts some memory?
>=20
> Hmpf, yeah. I'll take a look in the morning.
>=20
> Thomas, you mention you're running in a 32-bit vm earlier in this
> thread. Any chance you're using ovmf because that would make it much
> easier to track this down?

Yes, the virtual machine is running OVMF svn 15280 (which is the last
version I built).

qemu-system-x86_64 -enable-kvm -watchdog i6300esb -device
virtio-net-pci,netdev=3Dn1,mac=3D1a:2b:3c:4d:8e:2f -netdev
vde,sock=3D/run/vde/qemu.ctl,id=3Dn1 -device virtio-scsi-pci,id=3Dscsi -d=
rive
file=3D./vm32-uefi.img,if=3Dnone,id=3Dhd -device scsi-hd,drive=3Dhd -enab=
le-kvm
-m 2G -cpu kvm32 -smp 4,cores=3D4 -k de -balloon virtio -name vm32-uefi
-usb -nodefaults -vga cirrus -monitor vc -pflash ./vm32-uefi-ovmf.img


--R125uWB9QMliu0DpjADW0CDVcg0H5O96A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTQxj6AAoJEChPw0yOSxolElsP/1aFCOVnpH1J/7WMZ9t2h/vG
R3qtyu9JZ6dM2NpmUMrXADVE8e4v7xG+l2xQWLtddQm4KZO8uZ2CJhYZOv0G1KUG
1ZxBOMdnMh+HHa0hnVtEK5C+/huHCmsTjAdqAw6JBn+/COf04CN6MkoGrRhUNj9v
I/R4/SgPh688psBi4wJZ36npDdSDh1MtyV1wC7aR2wQzgltVTfASac5eoy1qwxbR
pklFq9Zap8zlnQ6NobEjDE1m9x3eOBxVW2lkUJgXhDBdL+o/BsHHbGj5mpIHNN7Q
kheMn7Y+oAvFNRMZTf9BhNdPB+HRnuKhB1Uezg4k+SgesbjHYPChaPb+tQbMXnrp
BtMp27mdea/Fd/9/WVnLSFqRvdUQDJDh2gPpYc6JRpCdOYcUkspYAKn83Jj3tsQx
OSbIbBLGpqI1s49RH8cIH/yK4REkNfl8fQCgBsWSVZSi1S+pXr8E9yMdeVaHtFrn
2bB8k6joinaoP457x8OT7sylm3p+E9EXQVsq/4q2jr5e0KJK0377ZAKAYAURWD7i
ExeYsITNW85igAi+hpg+crtlR1mdkX+GWgxirXi9ie8C2D4rXrjmml0bXxUuKBL6
H0moQbY1f62rrXGfEqZTqU4MLWxhkHgk7xEUma6onfIqIxmVWWJPGs12HCvGqSP6
yqU6F/bPl4VCrjfaQG6+
=n+Ae
-----END PGP SIGNATURE-----

--R125uWB9QMliu0DpjADW0CDVcg0H5O96A--
