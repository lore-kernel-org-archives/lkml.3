Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbbALRwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:52:16 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55870 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbbALRwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:52:13 -0500
Date: Mon, 12 Jan 2015 11:50:47 -0600
From: Felipe Balbi <balbi@ti.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: <balbi@ti.com>, Pawel Moll <pawel.moll@arm.com>,
        Sneeker Yeh <sneeker.yeh@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>,
        Paul Zimmerman <paul.zimmerman@synopsys.com>
Subject: Re: [PATCH 3/3] usb: dwc3: add a quirk for device disconnection
 issue in Synopsis dwc3 core
Message-ID: <20150112175047.GE6525@saruman>
Reply-To: <balbi@ti.com>
References: <1418695828-605-4-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <20141222153730.GA12815@saruman>
 <CAJ1gpc3jVpz=5ME4+wCJDW5NKihvB4xYzwi0co=UuPtG9Ubmjg@mail.gmail.com>
 <CAJ1gpc3-Wjtm54WOhO6RXjZft9BMngzyYC0-S-XnTacV-qKgMg@mail.gmail.com>
 <20141229160641.GD29379@saruman>
 <CAJ1gpc0Uu4vS2iA_o_W5NaE_QBWDYFZJio7yKvhpaR5f=qWcGA@mail.gmail.com>
 <20150105170921.GH19336@saruman>
 <CAJ1gpc3RZnqizhiasrwS8uy1H_wQAi_T0mPcS8LAK4FhmBRJ6A@mail.gmail.com>
 <20150112172032.GD6525@saruman>
 <1421083783.22660.69.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GxcwvYAGnODwn7V8"
Content-Disposition: inline
In-Reply-To: <1421083783.22660.69.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GxcwvYAGnODwn7V8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2015 at 06:29:43PM +0100, Paul Bolle wrote:
> On Mon, 2015-01-12 at 11:20 -0600, Felipe Balbi wrote:
> > On Sun, Jan 11, 2015 at 11:19:55PM +0800, Sneeker Yeh wrote:
> > > in case i express unclearly i also put a pdf:
> > > https://drive.google.com/file/d/0B18MmcvvKjNNbDF6eEdHSzZCazA/view
> > >=20
> > > This issue is defined by a two-way race at disconnect, between
> > > 1) class driver interrupt endpoint resheduling attempts if the ISR ga=
ve an
> > > ep error event due to device detach (it would try 3 times)
> > > 2) Disconnect interrupt on PORTSC_CSC, which is cleared by hub thread
> > > asynchronously
> > > 3) The hardware IP was configured in silicon with
> > >        - DWC_USB3_SUSPEND_ON_DISCONNECT_EN=3D1 (this is an IP configu=
ration
> >=20
> > yeah, aparently this is another configuration which is not exposed on
> > HWPARAMS registers. Paul, can you confirm for us ? I couldn't find it on
> > Databook on any of the HWPARAMS registers.
>=20
> I guess you meant to ask Pawel, because I know nothing at all about all
> that!=20

No, it was Paul Zimmerman :-)

--=20
balbi

--GxcwvYAGnODwn7V8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtAl3AAoJEIaOsuA1yqREig0P/RG9Il8bjoVJQuWb51562MH1
XgXqZWDT7b7p/WGUtDbC423JXUoQilktOvofCdO5tq3UBqO6I+RGpxb1E5BfJKCP
vWEvH3q+kIrpNsUw7R9mIoD52ouzqJAfhuH3XldnsrBGX7nl7wEB7LhDdHEnpKCz
Fr53LJ/AFLWiQYl+LMJ59e11kYeJSRQMuyaw6lzFoo+bvrNDm2P6PUrd4j/CpV5H
EfpUb1x+7H8WhWVx3i7DKhSIrb/i6QiZkA1bK8Rt3OpiDVYQDC5wHYUYqSn1P82Z
ugLsFm4ajvBUEbuqWubyl2Et1I4u9doVeXEzehHJmtdWcUPZLax7LitG0D8MkPY9
Q8O/Puq7PLjnYETMGidLP8qNrTBWmUVwuBpU4bxJYktoeoR96xL8DB9nOhHVFoNt
CH7dFl9XzjaSTxBXgQmcvOaez7J0tkeOih4EmKiZaN/XDKWArIu3i7M7FuDYocHr
Z+VTW+GoP7oa9/1RoX2auHnlhhWvanqkCuHxWHUzEZb+2RxHCUJWcGGMMy4erWcw
3BucbtvfYCojcXFnaZI+N06idAzK3BeMEUsoo4OcuyeT7nuJXMmyKSSVJ1DSulHu
gSe4e5n3zCM2109TAGQzlhcXioIgKg004xYoWLarEJDmQ+TeVAstV8/mm86+aLsR
CUXQ8MUchR7WtQ4b9ke1
=aa/l
-----END PGP SIGNATURE-----

--GxcwvYAGnODwn7V8--
