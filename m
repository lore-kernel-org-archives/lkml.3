Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaICUQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:16:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44479 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbaICUQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:16:22 -0400
Date: Wed, 3 Sep 2014 15:15:49 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Griffin <peter.griffin@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <maxime.coquelin@st.com>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>, <devicetree@vger.kernel.org>,
        <lee.jones@linaro.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <peppe.cavallaro@st.com>
Subject: Re: [PATCH v5 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3
 HC
Message-ID: <20140903201549.GJ31855@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409677729-6922-1-git-send-email-peter.griffin@linaro.org>
 <1409677729-6922-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9aCKuHbn5v2q3RVc"
Content-Disposition: inline
In-Reply-To: <1409677729-6922-2-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9aCKuHbn5v2q3RVc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 02, 2014 at 06:08:47PM +0100, Peter Griffin wrote:
> +static int st_dwc3_remove(struct platform_device *pdev)
> +{
> +	struct st_dwc3 *dwc3_data =3D platform_get_drvdata(pdev);
> +
> +	device_for_each_child(&pdev->dev, NULL, st_dwc3_remove_child);

you might want to use of_platform_depopulate() instead :-) Sorry I
didn't notice this earlier.

cheers

--=20
balbi

--9aCKuHbn5v2q3RVc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUB3b1AAoJEIaOsuA1yqRE/+UP/AnPsc+pruNisjSsb8g8F8oL
lDLGUsYtcNn7c/TwtTlkkUiAjAptL13CuhJgBccj9pVpW9sCWJfx3Um826hxh8Ii
rYK8jFzl4GnePb1sYxGaLisD5Kq05QP+4RLi9Ef0+DGpOI/BoSCstKD82svmA5t6
LyWXCPxfDXqr7srCuN5LWsWz7VAkrJBqFPWRVBhLxm7RoB6DyK110HQ/eVl7XRCX
5yloHaI69XbKQbGQyaWMY/20HY1SCHlzSItRLc/d/SCV25asMncb46MZ1DuFB4sA
NDfaERixsuV/bAqY0rzloZfVFvfasJPfnA5OvI1IZ9j9ip9FxKj+UAP8LCz8hFDq
fQ0b8kgB+08C1kHreD2xueT/98XEx6lunJkp2K0Za95Ll4T3b1+DVaFh7B9AhRxM
lJNBg1QNOmt+N+XxG5WpzP9b7CFO8g5CIaKHaCTHL7kIiJYnZm/ey4hcYupjEj2X
nlKGFYOqz2OIUIhLBpUpxXsxedzgfrW4/7d5+DwcSV9WEeBmhlf3pEBjhgZzoRq5
ha2Pw4Z6HMTrAZyZLWde14Bl48eMNJBgu7+tFU2xYmftFqg/owYH1bq3/Njwvy68
yA1l0Ngi2+MjB7/z5VRA/zVOTQOeIBtomJqIH+YHoI/GdQe4UIRdYhd65G1UnXIm
CzYDvWQ6tvH2tSOzOV+T
=kPQu
-----END PGP SIGNATURE-----

--9aCKuHbn5v2q3RVc--
