Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3HLSGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:06:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54402 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab3HLSGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:06:13 -0400
Date: Mon, 12 Aug 2013 13:05:53 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kumar Gala <galak@codeaurora.org>
CC: Mark Rutland <mark.rutland@arm.com>, "balbi@ti.com" <balbi@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: core: clarify usb-phy array binding
Message-ID: <20130812180553.GD27954@radagast>
Reply-To: <balbi@ti.com>
References: <1376062832-23288-1-git-send-email-galak@codeaurora.org>
 <20130809162848.GW27325@e106331-lin.cambridge.arm.com>
 <1A03353A-9299-4D73-9786-4ECBC1DD4E05@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sXc4Kmr5FA7axrvy"
Content-Disposition: inline
In-Reply-To: <1A03353A-9299-4D73-9786-4ECBC1DD4E05@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sXc4Kmr5FA7axrvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 09, 2013 at 01:42:15PM -0500, Kumar Gala wrote:
>=20
> On Aug 9, 2013, at 11:28 AM, Mark Rutland wrote:
>=20
> > On Fri, Aug 09, 2013 at 04:40:32PM +0100, Kumar Gala wrote:
> >> The binding spec wasn't clear that the order of the phandles in the
> >> usb-phy array has meaning.  Clarify this point in the binding that
> >> it should be <USB2-HS-PHY, USB3-SS-PHY>.
> >>=20
> >> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> >> ---
> >> Documentation/devicetree/bindings/usb/dwc3.txt | 4 +++-
> >> 1 file changed, 3 insertions(+), 1 deletion(-)
> >>=20
> >> diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Document=
ation/devicetree/bindings/usb/dwc3.txt
> >> index 7a95c65..8a9770b 100644
> >> --- a/Documentation/devicetree/bindings/usb/dwc3.txt
> >> +++ b/Documentation/devicetree/bindings/usb/dwc3.txt
> >> @@ -6,7 +6,9 @@ Required properties:
> >>  - compatible: must be "synopsys,dwc3"
> >>  - reg : Address and length of the register set for the device
> >>  - interrupts: Interrupts used by the dwc3 controller.
> >> - - usb-phy : array of phandle for the PHY device
> >> + - usb-phy : array of phandle for the PHY device.  The first element
> >> +   in the array is expected to be a handle to the USB2/HS PHY and
> >> +   the second element is expected to be a handle to the USB3/SS PHY
> >=20
> > Just to check - it's not valid to have a USB3 phy without a USB2 phy?
>=20
> Don't know, hopefully Felipe will chime in on that.

that'd be a really non-standard implementation. Per-spec, USB3 is
*always* backwards compatible with USB2.

--=20
balbi

--sXc4Kmr5FA7axrvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCSQAAAoJEIaOsuA1yqREuE4P/jUycln6LwcQWIP6Woju+AKp
BLTY5U7oWEUkFTS9et6+8rgcIRkeLaax061JE/oZ8J7+oAV+2awYRgsQ2MWdwzXy
NNOg3iNhtZMxg1gdz9ZxZPPEvOZDpldcIGVczgfCWqqxRU/Yh2PUPqizknk1XZFD
uYU+DSQgg7V+fdlm/0g4gMsHvM2hTWYfNGdV7Ht2QEQMH9kXmyIu2graweYGAJxF
aa15eaxsk/USv+u8jN8urCtzi8bf/rzVUtdQoKmY4zfifpUOhfjnDN5TGFcOY1HJ
TK3jom5PPXfLIdTFXYEyD4T0aqAxa5k/p9a+QoWGrx06hNsAZHwCOCONZmNDx0fw
z1DIK/7PHanlGFoof60KX+LlVkTGvZxUltSfUTY5gFoyOgBYbeGpLe6ZjKxJIpQv
Iz8gErPt5lrQm7DoBNblCp9bl1dM+OykeuBeRqpyIgjLyNkum4kv79VYJG2YVeRs
2qyurYKBmjk7nbyWuPe/6t336LGnJ1oLLHO8ooXSWm/CU+zKvuXZQ4mGxucENPjn
GtBd4Tz/2JJdE+gLeriI6fvNDS6fQ0WUpTn5DsN13OoC46bRUc9yx03edWaajRx4
e2r/DzCfEbNIyy56B5V56ARbD2uIUedFMlPaa6k+F7n/GeZyelttWUG0akMsvNnK
aBSPqZaTPy+CL1noGyP/
=i7U/
-----END PGP SIGNATURE-----

--sXc4Kmr5FA7axrvy--
