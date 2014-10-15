Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaJOOuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:50:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45487 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaJOOus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:50:48 -0400
Date: Wed, 15 Oct 2014 09:50:31 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: Felipe Balbi <balbi@ti.com>, Anton Tikhomirov <av.tikhomirov@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        robh+dt <robh+dt@kernel.org>, kishon <kishon@ti.com>
Subject: Re: [PATCH v2 1/4] dwc3: exynos: Add support for SCLK present on
 Exynos7
Message-ID: <20141015145031.GA11511@saruman>
Reply-To: <balbi@ti.com>
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
 <1412677176-3850-2-git-send-email-gautam.vivek@samsung.com>
 <00f101cfe6a1$d772c5a0$865850e0$%tikhomirov@samsung.com>
 <20141013224409.GB1496@saruman>
 <CAFp+6iEKkHxJNzkf+LOWJHtOhtZMe7HG_Vg97_NLfhJw11SQpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <CAFp+6iEKkHxJNzkf+LOWJHtOhtZMe7HG_Vg97_NLfhJw11SQpA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 14, 2014 at 10:25:00AM +0530, Vivek Gautam wrote:
> Hi Felipe,
>=20
>=20
> On Tue, Oct 14, 2014 at 4:14 AM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Mon, Oct 13, 2014 at 01:54:59PM +0900, Anton Tikhomirov wrote:
> >> Hi Vivek,
> >>
> >> > Exynos7 also has a separate special gate clock going to the IP
> >> > apart from the usual AHB clock. So add support for the same.
> >>
> >> As we discussed before, Exynos7 SoCs have 7 clocks to be controlled
> >> by the driver. Adding only sclk is not enough.
> >>
> >> >
> >> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> > ---
> >> >  drivers/usb/dwc3/dwc3-exynos.c |   16 ++++++++++++++++
> >> >  1 file changed, 16 insertions(+)
> >> >
> >> > diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-
> >> > exynos.c
> >> > index 3951a65..7dc6a98 100644
> >> > --- a/drivers/usb/dwc3/dwc3-exynos.c
> >> > +++ b/drivers/usb/dwc3/dwc3-exynos.c
> >> > @@ -35,6 +35,7 @@ struct dwc3_exynos {
> >> >     struct device           *dev;
> >> >
> >> >     struct clk              *clk;
> >>
> >> The clock "clk" in Exynos5 just gated all that above 7 clocks, which
> >> we should control separately now in Exynos7.
> >>
> >
> > should I drop this patch for now ?
>=20
> Yes, better to hold this for some time till we get more clarity
> from our h/w team.

now dropped. Please a new one if needed.

--=20
balbi

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPom3AAoJEIaOsuA1yqREa7wP/Albssa+SpegQ4V4/1z6k/sB
klRtejJ8nTp0PVhF0R3JIdrMCqlzYgct29hzj1pShFhye9aD9OqZVixETNE2eEif
FX5JFZ/9XojyqlH4ejliL43pVz8aabG2Bqw6MKv2xgW06tRMM2OeFAubVGFLK+H9
Ibb+P640tXwpKxa1+Ys1BhJWciGsp9a40JOjMX/k8LD4tDWpErFsvUwlj6qqlNb+
JOVtLGsku8Fi1ByVFogiqOX2sVzPpm0h5gGrYEK1qm97RKBgWTgZw12dMxWoUXoV
wUhmutXn+7GPJr/FslTt8v8raKDU+p+g7usHoxh/lgdnhQ6+W4U47Ezth+rfZYwi
fbbPJIqVRSUml/tmDN42lin5PvO+revYJ1KbycLCTWOUb/18VLGbXkusmy+a3hVl
k+6SbGNa99NysEAGpGKx6mbzpXOdOqYWfnpP3+i82+NRQslIEWzTs9lGP7cnPG66
dpPSxEPmT1+MJlGB1uaz3v5/LZkbOrzJAK88aLHg7jMefQAFhJlKq7XhFUhINfdr
LcLtkwRWI3P6BkcvlKrGAvqU5kWeVS6AsbbqXp6OyQ6WF8Vw9k1aiut3iA0YhP2p
VaH3mKrcSFHJmVl/sWtP/8eY1Cta0x1CsXWbXHC2K49EigicbPYd3f7o7LxUMoiN
GL4Zo8Fs7tDtoqLfeQ7l
=9djE
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
