Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaHSTPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 15:15:45 -0400
Received: from sauhun.de ([89.238.76.85]:39981 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbaHSTPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 15:15:43 -0400
Date: Tue, 19 Aug 2014 14:15:21 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: atull@opensource.altera.com
Cc: baruch@tkos.co.il, mika.westerberg@linux.intel.com,
        grant.likely@linaro.org, robh+dt@kernel.org, skuribay@pobox.com,
        Romain.Baeriswyl@abilis.com, rafael.j.wysocki@intel.com,
        alan@linux.intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH 1/2] i2c: designware: device tree bindings for i2c speed
 mode
Message-ID: <20140819191521.GA7306@katana>
References: <1408473276-10847-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <1408473276-10847-1-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2014 at 01:34:35PM -0500, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
>=20
> Add "speed-mode" Device Tree property to select between
> standard and fast i2c mode.  Previously, driver was hardwired
> as fast mode.  Default to fast mode if property is not
> present.

NACK. This should be deduced from the clock-frequency setting...

>=20
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> ---
>  .../devicetree/bindings/i2c/i2c-designware.txt     |    3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-designware.txt b/D=
ocumentation/devicetree/bindings/i2c/i2c-designware.txt
> index 5199b0c..0e4cd21 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
> @@ -9,6 +9,8 @@ Required properties :
>  Recommended properties :
> =20
>   - clock-frequency : desired I2C bus clock frequency in Hz.

=2E.. which is described here, but surprisingly not supported in the
driver yet :(

Check i2c-riic for an example.

> + - speed-mode      : 0 =3D standard (0 - 100Kb/s)
> +                   : 1 =3D fast (<=3D 400Kb/s) <=3D=3D default
> =20
>  Optional properties :
>   - i2c-sda-hold-time-ns : should contain the SDA hold time in nanosecond=
s.
> @@ -29,6 +31,7 @@ Example :
>  		reg =3D <0xf0000 0x1000>;
>  		interrupts =3D <11>;
>  		clock-frequency =3D <400000>;
> +		speed-mode =3D <0>;
>  	};
> =20
>  	i2c@1120000 {
> --=20
> 1.7.9.5
>=20

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT86JJAAoJEBQN5MwUoCm2J1sP/3+Y/hrvVBddzW/1to/LO57V
Ym+0fB4XobbMWLYnnX+I2ow3RfKBT4u/Vovmc1D2mvEXnh7f7bq2Cb1wIndhJz2x
EvR0Ife/+ynIy2wdkiLujtfPIIYXvDQs5cEEU5MKRH2FfMpg0C0H4R5x+qYztPgC
aLuOCpevp3oj4EJubhf0AKhvpGSBgf4D3RtTMbgPGFCUSSdlHuiXUA0Ux9hqU0cE
A0Wkz9aQ7hJg5uh31hrFBTCnuUGgZuiQVL+9vWSCINpypFIDq1GUaknYr9YEYx8f
2EXQ8Rj4Pnd/58zp7xoKkduL9Mvv+STba/UUyyvdkzeXHrThVX0Ul+mvdv24gWob
5grlwiNb95NnPjJOLpkQH9qp5pB/BnW104iC/RBQ7RokTKCM8QNGA1UT6Iepk0p6
/rqJu2qGmWuaMlJDKyiRtTjLpE9uLNhg+iAJnFhWK1XSgig7GrUKo3kfpoax7DvO
yoxswfT3B4BumsBwAWIqERpobR5boiUq/y3LV/zez+Vna8VmFVtxXKoW140gFGI7
Bgk882mKUjplvKfugzEODY2hHSpqiDWSBX/qOablxbYBhbTuVsBGjalucsxu6AqY
7ipdXovlqOd5xIoeypdFrMpHeeBGc1NNVfGA9AtwwclZnsTHbaQr5YYtPnYTNdHx
LUFUkF2x2m0vYGEpOA5r
=I12S
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
