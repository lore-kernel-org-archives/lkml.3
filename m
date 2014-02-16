Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaBPRok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 12:44:40 -0500
Received: from ring0.de ([5.45.105.125]:39785 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbaBPRoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 12:44:38 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
	*  0.0 T_DKIM_INVALID DKIM-Signature header exists but is not valid
Date: Sun, 16 Feb 2014 18:44:30 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Belisko Marek <marek.belisko@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "jdelvare@suse.de" <jdelvare@suse.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "hns@goldelico.com" <hns@goldelico.com>
Subject: Re: [PATCH] hwmon: twl4030-madc-hwmon: Add device tree support.
Message-ID: <20140216174430.GA26036@earth.universe>
References: <1392384058-14240-1-git-send-email-marek@goldelico.com>
 <20140214133101.GA17796@e106331-lin.cambridge.arm.com>
 <CAAfyv36Eo578K1LAdFJdKKjs800Gz2_kfJqvEcdD_U1qRCKY6w@mail.gmail.com>
 <5300E9DA.501@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <5300E9DA.501@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 16, 2014 at 08:39:54AM -0800, Guenter Roeck wrote:
> On 02/14/2014 06:08 AM, Belisko Marek wrote:
> >On Fri, Feb 14, 2014 at 2:31 PM, Mark Rutland <mark.rutland@arm.com> wro=
te:
> >>On Fri, Feb 14, 2014 at 01:20:58PM +0000, Marek Belisko wrote:
> >>>Signed-off-by: Marek Belisko <marek@goldelico.com>
> >>>---
> >>>  Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt |  9 =
+++++++++
> >>>  drivers/hwmon/twl4030-madc-hwmon.c                             | 10 =
++++++++++
> >>>  2 files changed, 19 insertions(+)
> >>>  create mode 100644 Documentation/devicetree/bindings/hwmon/twl4030-m=
adc-hwmon.txt
> >>>
> >>>diff --git a/Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmo=
n.txt b/Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt
> >>>new file mode 100644
> >>>index 0000000..e8016d1
> >>>--- /dev/null
> >>>+++ b/Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt
> >>>@@ -0,0 +1,9 @@
> >>>+TWL4030 MADC hwmon.
> >>>+
> >>>+Required properties:
> >>>+- compatible: "ti,twl4030-madc-hwmon"
> >>>+
> >>>+Example:
> >>>+madc-hwmon {
> >>>+     compatible =3D "ti,twl4030-madc-hwmon";
> >>>+};
> >>
> >>Huh?
> >>
> >>What is this a binding for? From a look at the driver in mainline this
> >>just calls into functions from the twl4030 madc driver (which doesn't
> >>seem to have a binding).
> >I post bindings for twl4030-madc [1]. Without probing this driver
> >other things will not work (twl4030-madc-battery e.g.).
> >Is there better way to handle this situation?
>=20
> Since you are converting twl4030-madc to be an iio driver,
> can't you simply use the iio_hwmon bridge and declare this driver
> obsolete ?

He didn't convert the driver, I did. That's why he included this
change.

I was thinking of using the iio_hwmon bridge and deprecating the
madc-hwmon driver. I have not tested this, though (lack of time).

-- Sebastian

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTAPj+AAoJENju1/PIO/qaZ2gP/0HkoPV5LMsxd7qqkPwQ6Kh7
k9eXjV1w7sGKQGAZtIS24sMYC/txeAbvv8ohQ77LKVFPqm8ybY3IoET7wNKj2NN7
RGEXcLFbOQqgytvdIg5Y63Vm7pBXJxA18j3p5esV6B58Rzh6pxax4zdkcu56IyVU
WIYhJE38fxATiZOGopE85T2YkK74fmekAz7VGQrcM9JbDco1jGs69GBCP9mv8bBm
GYsH+nxxpcneMokW4Lb8uU3OIk3aoOVg6K39Y5dBnbc9kgdLqlW4yezt0UaKHL83
6mg5j7tJGGDNWXi9FfgsVEjublNQb6c2xeavZYbaLiUZPFfew7eiEAbS7oueY8KR
UZcVBEn36zNn4oZ3jsYHQ1rR2L6Id1IOizfs5QeQ0y5YutR8wUVP/brs38hbe5SR
Au6LLTfZV/clGU6r6vk74gB47c1lwkxs7JRTVb/lyJQq2KkrKT3uWvoW+PoZSP9e
HCFrUUCMOdhVp0IkJRb2knntpdv1SXBVGhY6gA93PLdMmf7hHEmkM8dArB6TTaa0
1gqIHS9HGdMKu8W954/Jbj5Vv08WgH5/v7NBDCpUcsGrsfRXiQOo9NS8yzjj15RM
ruaYLvfX7RU2BmM+truiA/Yqz+ymn+io72cYu83q8yur7A5RfFV6+6vaGyVmg0k8
S+PwNBUzF3xyullLu2hJ
=LdOI
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
