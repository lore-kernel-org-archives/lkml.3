Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3ISNMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:12:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58230 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3ISNME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:12:04 -0400
Date: Thu, 19 Sep 2013 08:10:59 -0500
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
Message-ID: <20130919131059.GD26101@radagast>
Reply-To: <balbi@ti.com>
References: <20130917190732.GD15645@radagast>
 <CACRpkdYn8yaTyFJMaC3vK4kGrQsaZpAX=pyn5y33ers7QhQ_pg@mail.gmail.com>
 <2356541.62QktiIBr5@avalon>
 <20130918173636.GT21559@radagast>
 <523AB235.1000808@ti.com>
 <20130919124457.GB26101@radagast>
 <523AF73D.5010106@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NklN7DEeGtkPCoo3"
Content-Disposition: inline
In-Reply-To: <523AF73D.5010106@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 19, 2013 at 06:38:13PM +0530, George Cherian wrote:
> On 9/19/2013 6:14 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Thu, Sep 19, 2013 at 01:43:41PM +0530, George Cherian wrote:
> >>On 9/18/2013 11:06 PM, Felipe Balbi wrote:
> >>>Hi,
> >>>
> >>>On Wed, Sep 18, 2013 at 07:18:04PM +0200, Laurent Pinchart wrote:
> >>>>On Wednesday 18 September 2013 13:16:27 Linus Walleij wrote:
> >>>>>On Tue, Sep 17, 2013 at 9:07 PM, Felipe Balbi <balbi@ti.com> wrote:
> >>>>>>has anyone ever successfully using gpio-pcf857x.c driver with 16-bit
> >>>>>>gpio expanders ? We're having some issues here where toggling the l=
ast
> >>>>>>gpio pin (gpio 15) on a PCF8575 device causes platform to hang and I
> >>>>>>can't come up with any explanation of why would it hang...
> >>>>>Bouncing the question to George, Laurent and Kuninori...
> >>>>I've got a board with a PCF8575 chip, but it uses I/Os 8 to 14 only a=
s far as
> >>>>I know.
> >>>>
> >>>>I can try toggling I/O 15, but that will need to wait until next week=
 as I'm
> >>>>currently travelling without access to the hardware.
> >>>alright, that'd help me a lot :-) Just want to make sure if we're havi=
ng
> >>>a board issue, or PCF8575 is a bit screwy ;-)
> >>Is it on dra7x-evm if so which pcf device (i2c address)?
> >0x21 IIRC, it's pin 15 on that goes to a discrete mux. I want to toggle
> >the mux ;-)
> >
> I am able to toggle the same via sysfs(pcf8575 @ 0x21gpio15(p17)) and
> it does not hang the board.
> I am using Rev D1 board.
>=20
> Log :-
> # cat /sys/kernel/debug/gpio
> .
> ...
>  GPIOs 480-495, i2c/0-0021, pcf8575, can sleep:
>  gpio-481 (id_gpio             ) in  hi
>  gpio-482 (id_gpio             ) in  hi
>  gpio-495 (sysfs               ) out hi
> # echo 0 > /sys/class/gpio/gpio495/value
> # cat /sys/kernel/debug/gpio
> .
> ...
> GPIOs 480-495, i2c/0-0021, pcf8575, can sleep:
>  gpio-481 (id_gpio             ) in  hi
>  gpio-482 (id_gpio             ) in  hi
>  gpio-495 (sysfs               ) out lo

weird... I'll debug here and see if I can still reproduce with
v3.12-rc1. Thanks anyway :-)

cheers

--=20
balbi

--NklN7DEeGtkPCoo3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOvfjAAoJEIaOsuA1yqREX+IQAJXGFuDpv5afY/RMLij/nh7k
GF3gGW4GQGB9dpL1WFMcV+jNNPyzjBlf0UDIWCjA4+0mM7uc4akc0Flx/w8kfjbN
JBoyivHpZlP7tjEHQine9aFU60yUYcRh9qz+6+Aaek6tBCz5dI1o7zPPmlYcCZPK
LuXhFXN3BjNTUv2fBPGBhI77/eW9ZfbQVcPYrjPLbNFdpdK5BR1/cofFcWLQ5hs1
Ai07Q1aC3BEGaYFf+2C+R1cc9+rZvtbMVwczUQCs/SuiTI9b+ilsoQMUmqjkNxJr
5No3jC9TjrFX28xiH3NcPMyov9oHvBkJ/Jb4TkcVs81OdJhDsySSFkkOzCKredbm
LlXIpR9/uTSXEd2ONHdIVT+oX/ykNzYfJ3X2NZXL/D4HTsB9K0ZNV/b0M4UeMBPE
mpOAtJfKUn+mD9TjPzJEbLjnlg2A41ubOdha5VwNVntWTdKkGHfzZ/cpQKKDl7qY
y/IkyzaWmc5j3hapoySuUBuUXyKyVXfd6Ht28m1TVCQdpn5LbzaTTXC6NwvS5GM8
jlrmvSfm6t2OlQDnVppqqa5DzpVPPMZC9GTRlSR5yxfcWfgDq+tl2cceViBX2ebq
zlXFoq+yjCWx+klOvfyZmUkZp/LlN0yXFqgsGqvEHpnFDFANhGut+/aW6bYcqLMZ
m4NAecIYGrZN1d+OSHHs
=qdWM
-----END PGP SIGNATURE-----

--NklN7DEeGtkPCoo3--
