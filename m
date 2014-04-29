Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965136AbaD2Uip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 16:38:45 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52524 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933837AbaD2Uin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 16:38:43 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bug: acpi ata_bay dock reminds undocked
Date: Tue, 29 Apr 2014 22:55:07 +0200
Message-ID: <2146960.E8Lje2UBps@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <201404292216.41256@pali>
References: <201404292216.41256@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3466449.zvxKlzqO1L"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart3466449.zvxKlzqO1L
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday, April 29, 2014 10:16:41 PM Pali Roh=C3=A1r wrote:
> Hello,

Hi,

> I have problem with sysfs entry docked
>=20
> /sys/bus/platform/devices/dock.0/docked
>=20
> for my media bay DVD drive on notebook Dell Latitude E6440.
>=20
> After booting linux kernel docked is set to 1 (which is correct,=20
> DVD hw is inserted into sata dock). When I undock it via sysfs=20
> entry
>=20
> /sys/bus/platform/devices/dock.0/undock
>=20
> then kernel remove DVD device from system (no /dev/sr0 anymore)=20
> and docked sysfs entry is set to 0.
>=20
> When I press eject button on DVD drive, I hear some spin up and=20
> kernel detect DVD device again (also udev create /dev/sr0). But=20
> docked sysfs entry remains set to 0. It will never be set back to=20
> 1 - only after reboot.
>=20
> So this looks like bug somewhere and probably in linux acpi dock=20
> driver... Do you know to solve this problem? More applications=20
> checking docked sysfs entry for dock presence and returning 0=20
> will mislead them.
>=20
> Here is some info from sysfs about dock:
>=20
> $ grep "" /sys/bus/platform/devices/dock.0/*
> /sys/bus/platform/devices/dock.0/docked:0
> /sys/bus/platform/devices/dock.0/flags:32
> /sys/bus/platform/devices/dock.0/modalias:acpi:LNXIOBAY:
> /sys/bus/platform/devices/dock.0/type:ata_bay
> /sys/bus/platform/devices/dock.0/uevent:MODALIAS=3Dacpi:LNXIOBAY:
>=20
> If you need some more info let me know. I would be happy to have=20
> working docked sysfs entry.

Which kernel version(s) have you tried?


=2D-=20
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--nextPart3466449.zvxKlzqO1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJTYBGwAAoJEILEb/54YlRxhA8P/0gWehTXbcK3dPOCJ19saRCq
HrX7zl77Kw9R74Gzc7LQguEFXxT0DkXbEGVE40UCfTxPpjfJhM2mvb2WPZk1pbwM
UwWbAVPH3T7wbFDwICgo3GPt22cOtOhLHBoIV5YbrIVTGRTXSj7k+DhlEDL4ths8
YVKxUKLpVos3Xlejq1getGTkc2T9oAkoO4sgJBegbpRCIx+uwEAvuX/DBS7Uu8Nk
F1mxcVL6ps5sXCFjfuL4fP6Bbkhc60UyN2NpCoulqRtED5IEN8THWvvEJVUkv3g6
mPdYV69w/mdXW/mf64hGPGFs+veE+iSzYjKrBQHJShZtyqtYrRJftVuebYFGv4z/
xONm5JCWqpZqm4OG0AkIgyFxxs9v5TxUGkCrBd9XGzEpPlYJ1t2W6YkxMZyTyo1W
RruvcFgbhCa5XZ7GVBk0fhQgSeaaS62Y7xIVbJvzbgH8HzkOYGQJfoC47BfEhdaq
LOy3V4h1OtRMDQnZ0OEdqd4CSQoU0m32UwGJnAiAWWLfv6o2NOuIgwSaVTsjtYCq
as+uwUfnCgbUwRCTPaatR+9yJqhWLYyBC/w0HF3vcJd48Tx3kK8VTl4yL27BPE05
OhW18YRJFUdXN5IGlenGh3zYEOpwGoTNLaH+oe5KoSvVyqzNVDlCDCLlHnTrC6gk
ECX9ENXVHxU76SnrfjI3
=RhLV
-----END PGP SIGNATURE-----

--nextPart3466449.zvxKlzqO1L--

