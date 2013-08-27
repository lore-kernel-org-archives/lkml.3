Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3H0Srm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 14:47:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58876 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3H0Srj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 14:47:39 -0400
Date: Tue, 27 Aug 2013 13:46:58 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <balbi@ti.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [RFC 2/2] usb: dwc3: Add Qualcomm DWC3 glue layer driver
Message-ID: <20130827184658.GS3005@radagast>
Reply-To: <balbi@ti.com>
References: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
 <1375789991-30041-3-git-send-email-iivanov@mm-sol.com>
 <20130809132349.GC12041@radagast>
 <1376064558.7709.31.camel@iivanov-dev.int.mm-sol.com>
 <20130812182439.GG27954@radagast>
 <1376472497.2132.6.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2KGcTUzwJ+J1jnia"
Content-Disposition: inline
In-Reply-To: <1376472497.2132.6.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2KGcTUzwJ+J1jnia
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2013 at 12:28:17PM +0300, Ivan T. Ivanov wrote:
>=20
> Hi,=20
>=20
> On Mon, 2013-08-12 at 13:24 -0500, Felipe Balbi wrote:=20
> > On Fri, Aug 09, 2013 at 07:09:18PM +0300, Ivan T. Ivanov wrote:
> > > Hi,=20
> > >=20
> > > On Fri, 2013-08-09 at 16:23 +0300, Felipe Balbi wrote:
> > > > Hi,
> > > >=20
> > > > On Tue, Aug 06, 2013 at 02:53:11PM +0300, Ivan T. Ivanov wrote:
> > > > > diff --git a/drivers/usb/dwc3/dwc3-msm.c b/drivers/usb/dwc3/dwc3-=
msm.c
> > > > > new file mode 100644
> > > > > index 0000000..e509abc
> > > > > --- /dev/null
> > > > > +++ b/drivers/usb/dwc3/dwc3-msm.c
> > > > > @@ -0,0 +1,175 @@
> > > > > +#undef CONFIG_REGULATOR
> > > >=20
> > > > why ??????
> > > >=20
> > >=20
> > > 1. This shows that driver is still not fully tested=20
> > >    Regulators support is still missing in the MSM
> > > 2. Helps me to load driver successfully.=20
> >=20
> > Then remove all the regulator-related code from this.
>=20
> I would like to keep them. I will just remove #undef line.=20
> Code will continue to build fine. And once regulators drivers=20
> are upstreamed this driver 'will not' require further
> modifications.

fair enough.

--=20
balbi

--2KGcTUzwJ+J1jnia
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHPQiAAoJEIaOsuA1yqREzzgP/1xZM/lS8jUehIde9h9hoptE
G2E9c8fhLtBGdktTWIO53BxzkWpc2yAXePzdwh3EM/bIbtaVtgL7Yih9NxlszRXf
Qzgf3IwcWy0LricvG5/diKAOFrdqgSYqZiLq6pDDpsh2vt0flWTHjQXFrGXjn2gx
NK6AgWPhuenwtJrg8GRNOV/I9u+WzknxDM4hh/ft9uiEOk3vaXbVRWVcWaCB2KTm
DN/tuTxqqYEO5glVCRQK2GhYqrjAiOKXkbNv12/3A20c7jLN4SnUJtFP5iUD0+BP
BHcK3xD28GvojNibSA1ZBOLCTqbuHhoHAKPd54Szt7TmbofgD+9ykWxmFEPyg+JL
4xk+UXd03iQVjVFFgtLDRZ/WubutmryNDNob6gxCFJDbxTOum41KW9SsDp7lVZc7
3MecSBH11K7lDskl3l8d4wxt13KWNEOuWr0yxlXepVVbrpEQWPSpJq/vRxuGN3Ci
3pVTcLYSiczJfgF0d3PpzqMgNK16z0gxFPJ0DFJVPyYk2JSUL7HXAQIz3X9AnxCM
XaAgU32bV6++r2KX6TMQzyXdQjf85/hi1axl0HbRLYTbFJHXekqT2j7LyjCFRUmZ
+aLB+fKZg+Y5bpQsv5vvABqAmebsLZ0StWoOcwRd2/Bgsj5j/+DaOcQylxsj4rIM
zvrdbxSpmBu3j0wSL0Th
=+AaF
-----END PGP SIGNATURE-----

--2KGcTUzwJ+J1jnia--
