Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967771Ab3HINZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:25:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37999 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966645Ab3HINZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:25:19 -0400
Date: Fri, 9 Aug 2013 16:24:59 +0300
From: Felipe Balbi <balbi@ti.com>
To: Pawel Moll <pawel.moll@arm.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>, "balbi@ti.com" <balbi@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [RFC 2/2] usb: dwc3: Add Qualcomm DWC3 glue layer driver
Message-ID: <20130809132459.GD12041@radagast>
Reply-To: <balbi@ti.com>
References: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
 <1375789991-30041-3-git-send-email-iivanov@mm-sol.com>
 <1375791698.12043.53.camel@hornet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rqzD5py0kzyFAOWN"
Content-Disposition: inline
In-Reply-To: <1375791698.12043.53.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rqzD5py0kzyFAOWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 06, 2013 at 01:21:38PM +0100, Pawel Moll wrote:
> > @@ -47,3 +64,25 @@ Example device nodes:
> >  		vddcx-supply =3D <&supply>;
> >  		v1p8-supply =3D <&supply>;
> >  	};
> > +
> > +	usb@fd4ab000 {
> > +		compatible =3D "qcom,dwc-usb3-msm";
> > +		#address-cells =3D <1>;
> > +		#size-cells =3D <1>;
> > +		reg =3D <0xfd4ab000 0x4>;
> > +
> > +		clocks =3D <&usb30_master_cxc>, <&sys_noc_usb3_axi_cxc>, <&usb30_sle=
ep_cxc>, <&usb30_mock_utmi_cxc>;
> > +		clock-names =3D "core_clk", "iface_clk", "sleep_clk", "utmi_clk";
> > +
> > +		gdsc-supply =3D <&supply>;
> > +		ranges;
> > +
> > +		dwc3@f9200000 {
> > +			compatible =3D "snps,dwc3";
>=20
> Note that the Documentation/devicetree/bindings/usb/dwc3.txt is
> mentioning "synopsys,dwc3" (which is clearly in opposition to the

I have a patch converting to snps,dwc3.

--=20
balbi

--rqzD5py0kzyFAOWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSBO2rAAoJEIaOsuA1yqREjykP/03Zs/oOvj3EgagOJc8Z18L5
OF+pZpJFrSuSfZGTPTCdRHPSLKuPMSHF1o4yBZzX3Fpx4QKL6gXGlEA1qD954wsw
3MI2g+dvjbugFx9IalMqvx60jwwtBqUiY+75ekiamCzr6kXiyhRcOJ7+2FWKMNMb
1bETiTaInaPtrMQfVTUIVsl+JvqoyxfDAtjkSCptR6FQdH7lW1nNolgruDvX2e4E
oQA/nvumsCJwSkJfGgx83d+EwGp/zsUdiA6eWXkyziMfSsEjdAYyPAHlZxF2pRCY
UPypSraAW0jsHWFuEhJtJGh7yUeVlmxnwUhFHSEQLyAQfkXLh02z0ks21gqCbIuL
B+eTPmv3Tvyu12tCPdvfSqUIiM19LxrWjExwvlC32sqDhTSVwlvjddNd1t9MNu7Y
5TofABmJcgrsSK1AyUz6VuQYlCsJs5YKJR3a7pSsn+7bapHWkRe3XX277tQDJ/lT
l+laR1AVTLp79JMT0HYRp5iVJ2dchMnHkQmYP73Al2hF63k13sKP1HHd53P0f36W
tV3aG1UeJmW7raoqlEM3cL7xk8kcsmH3p30tGOsH7Nua2FJ2dv24GCLDZIk74BxE
H/B0V1zizQ3X3BO5oRjGZAj6QTi0UmszTPZfAkaW5Gtws/aoWXGfuBd5kulQGKVP
kKamDfPwPIF/MsxuVUXR
=qAyD
-----END PGP SIGNATURE-----

--rqzD5py0kzyFAOWN--
