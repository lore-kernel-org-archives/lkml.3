Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaDGNZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:25:42 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:53394 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbaDGNZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:25:39 -0400
Date: Mon, 7 Apr 2014 15:25:30 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: 3.0 -> 3.10 regression? poweroff instead of reboot?
Message-ID: <20140407132530.GF3339@pcnci.linuxbox.cz>
References: <20140310145530.GA27230@pcnci.linuxbox.cz>
 <20140329121550.GA5878@nik-comp.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAD3D0@HASMSX106.ger.corp.intel.com>
 <20140331120102.GY3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAE58E@HASMSX106.ger.corp.intel.com>
 <20140402135812.GI3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB112D@HASMSX106.ger.corp.intel.com>
 <20140402143635.GA4410@nik-comp.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB7151@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lJyeR2ag8/NQ+I8N"
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AFB7151@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on proxybox by F-Secure antivirus, database version 2014-04-07_02
X-Milter-Copy-Status: I
X-Milter-Copy-Status: I
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lJyeR2ag8/NQ+I8N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomas,

yes, I just checked source rpm and it's applied..

here are the dumps:

[root@k310test ~]# hexdump -s 0x48 -n 4 /proc/bus/pci/00/16.0
0000048 a301 3900                             =20
000004c
[root@k310test ~]# hexdump -s 0x40 -n 4 /proc/bus/pci/00/16.0
0000040 0345 000f                             =20
0000044

BR

nik


> Are use you have the patch applied, because the driver just should not lo=
ad.=20
> If any case  you dump the firmware status registers"
> At offset 0x40 and 0x48 in PCI config space=20
> sudo hexdump -s 0x48 -n 4 /proc/bus/pci/00/16.0
> sudo hexdump -s 0x40 -n 4 /proc/bus/pci/00/16.0
>=20
> Thanks
> Tomas
>=20
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--lJyeR2ag8/NQ+I8N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlNCp0oACgkQ3xdJJrLygV5CdgCfeDsOcWWz1A2kbXq0IAKTopvf
LJIAnizUeo1BlqlE+BpJr/I+sv6N8tLX
=xqeM
-----END PGP SIGNATURE-----

--lJyeR2ag8/NQ+I8N--
