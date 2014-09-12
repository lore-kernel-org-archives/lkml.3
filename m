Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaILTPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:15:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56963 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751927AbaILTPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:15:08 -0400
Date: Fri, 12 Sep 2014 17:18:24 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH v3 0/5] Initial support for XPowers AXP288 PMIC
Message-ID: <20140912151824.GU31276@lukather>
References: <1410477357-6407-1-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K6Vt3zCKtaqyTnPU"
Content-Disposition: inline
In-Reply-To: <1410477357-6407-1-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K6Vt3zCKtaqyTnPU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2014 at 04:15:52PM -0700, Jacob Pan wrote:
> XPowers AXP288 is a customized PMIC found on some Intel Baytrail-CR platf=
orms.
> It comes with sub-functions such as USB charging, fuel gauge, ADC, and ma=
ny LDO
> and BUCK channels.
>=20
> By extending the existing AXP20x driver, this patchset adds basic support
> for AXP288 PMIC with GPADC as one MFD cell device driver. It also adds ho=
oks
> for ACPI opregion handler driver which can be used to handle ACPI request=
s.
>=20
> Currently, the PMIC driver in this patchset does not support platform data
> enumeration. But when ACPI _DSD and unified device properties become avai=
lable,
> cell devices with platform data will be added.
>=20
> This patch does not use intel_soc_pmic core for i2c and regmap handling i=
n that
> axp288 shares similar programming interface with other Xpower PMICs suppo=
rted in
> axp20x.c. Therefore, extending axp20x.c to include axp288 makes more sens=
e.
>=20
> Changes
>  v3:	- put all file rename changes in 1/5

The variables renaming are still not in 1/5....

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--K6Vt3zCKtaqyTnPU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEw7AAAoJEBx+YmzsjxAgYi4P/3ns+5+YnbGJGUxtQECppx2c
UV+PkBjF5Z/5EXr2WbsAv2pnqr0KoT0YYY41HyNeq3qvlFcvpteaTVvT08uj2z2m
F91dSWuTKkjkLCYorhlldhA7YakBKNCzgGHHNkyRP/sFimcxkexOvr9s1PMha7mC
bV655aqhnD6kvgyNlUwJabeNPt9af3QSrTTTpuKcwqu/qFsKJs2JhxuvncJLWQYc
jt0thJbaEq8C98PgXDOOHztGo7PqMq3sPRkp6D8jaqpRiY+ixAN8z5+2ZQnceh34
z2xaoMAlMRvp51Leb0QLnfDDd6l9QHB19FVchqMb2RnJ9ykrMKmRavxtojKKiCj7
jo/DdraQFHv89IzcWGGzIBFl76rl6KSNsMHZryqrnb0ocEO+2qjLkL/rMSt0wuad
lugZZfP9oLJDlT+KbQ3A0oLpr3qyxdnvWQLZgqdkSUCzD5kNuKL9/8hj+w4AdkwD
M4DgOyPsMIQVuh77TaIPEuQ5PhWtDfYpfB1PH1MeCkb3nL/ZgpIiVdo4gRD0UbRa
EauVIhBzZQKfip9FmTzEG/W8HsSD7cpDH3xFXrkn9OTIINp6E9cW7hQfrjqsPFct
n/ruVIevK8LZRtH1sgiamPl1bzejg649J5QVaIvfhHZIqgtmZOZ7jWCROoqtM6j0
stKgyUJUrKy/xqsuSHZd
=HkLt
-----END PGP SIGNATURE-----

--K6Vt3zCKtaqyTnPU--
