Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3ISMqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:46:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57025 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3ISMqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:46:03 -0400
Date: Thu, 19 Sep 2013 07:44:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <balbi@ti.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: PCF857x and 16-bit GPIO expanders
Message-ID: <20130919124457.GB26101@radagast>
Reply-To: <balbi@ti.com>
References: <20130917190732.GD15645@radagast>
 <CACRpkdYn8yaTyFJMaC3vK4kGrQsaZpAX=pyn5y33ers7QhQ_pg@mail.gmail.com>
 <2356541.62QktiIBr5@avalon>
 <20130918173636.GT21559@radagast>
 <523AB235.1000808@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2B/JsCI69OhZNC5r"
Content-Disposition: inline
In-Reply-To: <523AB235.1000808@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2B/JsCI69OhZNC5r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 19, 2013 at 01:43:41PM +0530, George Cherian wrote:
> On 9/18/2013 11:06 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Wed, Sep 18, 2013 at 07:18:04PM +0200, Laurent Pinchart wrote:
> >>On Wednesday 18 September 2013 13:16:27 Linus Walleij wrote:
> >>>On Tue, Sep 17, 2013 at 9:07 PM, Felipe Balbi <balbi@ti.com> wrote:
> >>>>has anyone ever successfully using gpio-pcf857x.c driver with 16-bit
> >>>>gpio expanders ? We're having some issues here where toggling the last
> >>>>gpio pin (gpio 15) on a PCF8575 device causes platform to hang and I
> >>>>can't come up with any explanation of why would it hang...
> >>>Bouncing the question to George, Laurent and Kuninori...
> >>I've got a board with a PCF8575 chip, but it uses I/Os 8 to 14 only as =
far as
> >>I know.
> >>
> >>I can try toggling I/O 15, but that will need to wait until next week a=
s I'm
> >>currently travelling without access to the hardware.
> >alright, that'd help me a lot :-) Just want to make sure if we're having
> >a board issue, or PCF8575 is a bit screwy ;-)
> Is it on dra7x-evm if so which pcf device (i2c address)?

0x21 IIRC, it's pin 15 on that goes to a discrete mux. I want to toggle
the mux ;-)

--=20
balbi

--2B/JsCI69OhZNC5r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOvHIAAoJEIaOsuA1yqREHAcP/0wD7i2/nHKvkGCE/Vin+zpF
w7sNneqGPgKpf6pZyUIxjDkmVZIeAvgiQcNpn2xzeOIdBXZbDKtmpnT2x7cuwl/j
3ViPvRNb05ci0VBWgydy4xalGBoL7YPxuW6EELvBfnfWSuEKOfmxDnJovsRlIb0E
ixqZhVVTOeJb+XzyzV5BivfHii/kHbq0r7lCqqjQK6qi9U4bHhwT2Oltk3BgLiAA
Zy/y4/rVyT7gJKEDstQmkB4S/w8YTDDrMX4rx2esYViQMipiZbah0V8Mdnt3q75T
5qAueB2O6c6g68IW8l7y9OkFtJkdi7NaDN37NdNSa3wHKKHGyEgK5x8XsMSJtuYE
Ma0r+oXN83Ymb513Yzdybe+Ln+7JYia6iUrsZue7R7tG34d/Y1v/xCUVAB4xfCcS
45AiRgrwDpVwWa+XVgCHxrQIf5JQz3kn55f+5lj0yNWvJ2mY4ENlx7jqAYPxNRqv
uswNo09AAoeuNQYH5BhjyweAtr4mrko1CwCEl1OS1htnuh3WlglEA6IHohlcDsdt
3QLBF/Hfmj8ilu36Qr7Vqvlu7izbXc7CUtsm45kIgal7aQVfa79XsTYE4PAmZrVS
pziiEk9Ya28apy2RmNT2BGCKTSbdWOLDR/TSFBfs86SjU8kjNyeSn3jKuR1iwMGC
AdwoXjP7BYt8Yz1u2lpR
=BBA6
-----END PGP SIGNATURE-----

--2B/JsCI69OhZNC5r--
