Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaHUOK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:10:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45484 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbaHUOKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:10:54 -0400
Date: Thu, 21 Aug 2014 09:10:23 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Griffin <peter.griffin@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <maxime.coquelin@st.com>,
        <patrice.chotard@st.com>, <srinivas.kandagatla@gmail.com>,
        <devicetree@vger.kernel.org>, <lee.jones@linaro.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <peppe.cavallaro@st.com>
Subject: Re: [PATCH v4 2/3] usb: dwc3: dwc3-st: Add st-dwc3 devicetree
 bindings documentation
Message-ID: <20140821141023.GA11146@saruman.home>
Reply-To: <balbi@ti.com>
References: <1406734091-16202-1-git-send-email-peter.griffin@linaro.org>
 <1406734091-16202-3-git-send-email-peter.griffin@linaro.org>
 <20140820180005.GU24500@saruman.home>
 <20140821133340.GC17487@griffinp-ThinkPad-X1-Carbon-2nd>
 <20140821135620.GD9608@saruman.home>
 <20140821140347.GA21073@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20140821140347.GA21073@griffinp-ThinkPad-X1-Carbon-2nd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Peter,

On Thu, Aug 21, 2014 at 03:03:47PM +0100, Peter Griffin wrote:
> Hi Felipe,
>=20
> On Thu, 21 Aug 2014, Felipe Balbi wrote:
>=20
> > > Currently (in the vendor tree) one of the phys lives in
> > > drivers/usb/phy and the other in drivers/phy.
> > > I believe that is because one is only a usb phy and the other is a
> > > multi function phy which can drive PCI-E or USB3.
> >=20
> > right, but for mainline, we can have both PHYs in drivers/phy only.
>=20
> Ah ok, I didn't know that, so thanks for that info.
> >=20
> > > So to make that work, when dwc3/core.c gets the PHYS in
> > > dwc3_core_get_phy() we need to use the different bindings.
> > >=20
> > > I think we are the only platform using "one of each", but luckily
> > > dwc3_core_get_phy() has been written generically enough that it "just
> > > works" :-).
> >=20
> > true, but I want to drop support for the legacy drivers/usb/phy layer
> > from dwc3. I'll try to move all PHYs to drivers/phy for v3.18.
>=20
> Ok, so for the next re-spin I will change this to just use the generic
> phy binding for both usb2 & usb3 phys.
>=20
> In parallel I will also migrate over the drivers/usb/phy driver to be
> just a generic phy before I attempt to upstream it.

Thank you for understanding :-)

--=20
balbi

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9f3PAAoJEIaOsuA1yqREOMkP/1OdwRZgIUGTlm2APVRI9tpa
CkUJ9r1X+KpUUOoXP+4n9v87ors/Wjch9TlY69QrDUThsogr5P5Df4trztR+pDXu
lczQljFyH6ck4tkDXRCHi8m9CIX0EEoeim28n0zax4yFqA7k/S7nl+yHvN08hOeQ
nowjRx5ko44TjfRGRYHYoVO1SLNoNg5JmJrlWqxJGX+JYebQtRp3nM2mLlHixJOu
gb5EB5gYGHw66kcmfQFL3+fcRR05XRThlIFNiT+j9rMy9u04spyBZvciaQmYC/QU
o0s7sEfPQRO6y5M1z2Id6HNTVWA/ddNs8HKlBOlBWVj22CRmuDRXuEh3lv7e+0bp
JdjO3EgKC7lmu7Hc3YhWI+zBb6eHapgABpNKP9BQt2g9vOdt8KjE83V0Eyl039Pw
a7I3nmJLAjPb7vytZlIYJfY9oap996M3GZsyFUNq3m3u+zjg/15MERz2xHGYt5pZ
YA8/a1fw+BROnEVNSwTjEuKu5G1fTc9H9uH6EkpXd3yQfHEC/CH+ssJK1yiYVHQS
r2LLULKv/2NkrLbBblHGFLmUsTm44dUjdPlsXkN+KuCPyd9F3o5SBMIC6OwKLklN
NcjqgHcJR00/5MhFvQHaRhBCnygj92uSy3bY9o9iPtTSO7uEVOM4AJR+qhPvjQMX
BqVA10vMAO8ay5wzLdTj
=sqUb
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
