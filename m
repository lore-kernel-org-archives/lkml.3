Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbaGVPwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:52:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47534 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbaGVPv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:51:58 -0400
Date: Tue, 22 Jul 2014 10:51:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <maxime.coquelin@st.com>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <peppe.cavallaro@st.com>
Subject: Re: [PATCH v2 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3
 HC
Message-ID: <20140722155117.GF20588@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404541530-27856-1-git-send-email-peter.griffin@linaro.org>
 <1404541530-27856-2-git-send-email-peter.griffin@linaro.org>
 <20140707124627.GG6407@lee--X1>
 <20140722091800.GB8233@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140722145711.GC20588@saruman.home>
 <20140722154503.GC23210@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vA66WO2vHvL/CRSR"
Content-Disposition: inline
In-Reply-To: <20140722154503.GC23210@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vA66WO2vHvL/CRSR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2014 at 04:45:03PM +0100, Lee Jones wrote:
> > > > > +static void st_dwc3_init(struct st_dwc3 *dwc3_data)
> > > > > +{
> > > > > +	u32 reg =3D st_dwc3_readl(dwc3_data->glue_base, USB2_CLKRST_CTR=
L);
> > > > > +
> > > > > +	reg |=3D aux_clk_en(1) | ext_cfg_reset_n(1) | xhci_revision(1);
> > > > > +	reg &=3D ~sw_pipew_reset_n(1);
> > > >=20
> > > > 1?  Better to add defines for these magic numbers.  What is 1 anywa=
y?
> > >=20
> > > They are just bit setting macros, I've converted them over to use BIT=
 macro now,
> > > so it no longer takes a parameter.
> >=20
> > the macros are better, but make them upper case as everybody else.
>=20
> When you say that the macros are better, what do you mean?
>=20
> Defines do the job in a manner which is a great deal cleaner:
>=20
> #define AUX_CLK_EN        BIT(0)
> #define SW_PIPEW_RESET_N  BIT(4)
> #define EXT_CFG_RESET_N   BIT(8)
> #define XHCI_REVISION     BIT(12)
>=20
> reg =3D AUX_CLK_EN | SW_PIPEW_RESET_N | XHCI_REVISION;
> reg &=3D ~SW_PIPEW_RESET_N

this is what I meant ;-) I see what I wrote can be very ambiguous :-p

cheers

--=20
balbi

--vA66WO2vHvL/CRSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTzoh1AAoJEIaOsuA1yqREtz4P/3ScKyYl6vnxnQ0NIxwSFk/v
hwbn9UHaqtxuNFnj1PwcuEVneUJ5y0VdRcHaWFr8NRA7aucpvRFstnXeDO7n2oD5
t+RXCAFlFQfbmatDyoBqcQBKYX41LSgr/5N+vZBoDepIZ6NBh7+sW9rbB8cApOEY
wxDNBYBXfLBq5bCl3j8S75k2VkViWXEO/Ohd3Yc9/kYO9HYyXMoR/wSkf++CSnyF
c3TtyYi/XtI3BCboI6258Da7p1LAEeiK5KfOFmiEi3kW0jGn1kz6c6/83JLnNJb+
wdAu3b3JhlNue5764j8IIORk/+ub82exk7fzRr2pxDL95IH46ytD/xu4F4Bi6A8r
1XD/eo+B7VWU2DigGJ0jG6sTDuQafmbZFaVJp5ajzTAe3b/yoIbWdd743w1Cp7Vt
D9aeKa0DxAmZhAsqngNDlz+yE2n1lRlWfbJXyskIrUVZqSCxVQUYm6vRD/fCRb21
TBWPGAyIVv2vwsi+SWxVsYxInnJLRYPKt9FV3pnyrsRMoy0R9T1jQs40pKuS6BdA
h0pgKM68BnogKp9yZKZ+j/jscRQFhCVsloDw5vzzrxut5Qwhk3gBpNiSQ01AGyvd
CpQ7miShfeyD1zAfbgBd268ZlyNOnVqUkI0YkQiFPJxUNNqTIRh+LwwIQdV4s9nx
boE8wGpoVg78eRVfpVkS
=MN54
-----END PGP SIGNATURE-----

--vA66WO2vHvL/CRSR--
