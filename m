Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaE0IfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:35:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41790 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751658AbaE0IfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:35:06 -0400
Date: Tue, 27 May 2014 10:32:01 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 03/22] clk: sunxi: add "pll6" to sun6i protected clock
 list
Message-ID: <20140527083201.GF4730@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-4-git-send-email-wens@csie.org>
 <20140525184808.GP10768@lukather>
 <CAGb2v643UmK6GfuDVfywVUeo_g7FpdZC_7SgeY-UMZ_k_-2N9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E7i4zwmWs5DOuDSH"
Content-Disposition: inline
In-Reply-To: <CAGb2v643UmK6GfuDVfywVUeo_g7FpdZC_7SgeY-UMZ_k_-2N9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E7i4zwmWs5DOuDSH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2014 at 12:47:30PM +0800, Chen-Yu Tsai wrote:
> On Mon, May 26, 2014 at 2:48 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Fri, May 23, 2014 at 03:51:06PM +0800, Chen-Yu Tsai wrote:
> >> PLL6 is used by some important but undocumented module, most likely
> >> memory related, such as mbus or the actual memory controller. As we
> >> do not have a driver for that, add pll6 to the list of protected
> >> clocks, so that it won't be disabled and leave us with a non-responsive
> >> system.
> >
> > What issue have you seen?
>=20
> Completely unresponsive after PLL6 is gated (on the A23).
>=20
> > The system actually works pretty great on the A31.
>=20
> Does it work when there aren't any other PLL6 consumers?

Yes.

> Maybe the boot0 on A31 and A23 setup some DRAM-related modules differentl=
y.
>=20
> If the A31 works without protecting PLL6, I'll add a separate list
> for the A23.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--E7i4zwmWs5DOuDSH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJThE2BAAoJEBx+YmzsjxAg+y0P/jrK8t/KVps0omNNRHN/Cqr7
17LCuGScPMDQXDywyMlysR9Ndb2WvKjmHIDKDfvylgfvAxmARXYLYb8ifDZoaWZd
w4WiXXvw5YHs/+0GBXlH+/I04TE3/SVJiLtbcHGak0HzmP65SkIhWMKB7dl5zRnq
bkiKrBQs2NA7ot3BZpp0mcVGy4RIdaUChy//S+Hfi/mWVNBCGzqVJ6dFMhDjpSj7
fqZ2xiE2k+zryLZM3XEm2Vi2E1GE/gSOb+5dD8K+6HA2miapfmL5afVUfLZZPIRI
NeENCztft8JzxkhB/BaaBK8Bq1aOZo0Txh4voU40opZFRdwRRZbJGS4coC3IAZQv
qHRQ4iyou3EchtZi0ggOroGZXAvfZlWdsFst2XWa1MYDANB9LL8nV+PKongmCGft
SVHxfi9KRcZUFtneoX7TkQGwT6iHU5LAv+2xJTAceGRz76tc9TLlbCEoaunzZobp
cbEh9mLPfABWTDdHUCN9OlfrhfOiIDN4ve3iBv58y1gFx95ztQDjlDGuc1vhjcsV
p9iTMIbUiR6DZEMhVjIFC93DbQD4wBYoI/NaxSxwTXP9MA5vzBYM6Ye6Vg4equQ2
yiCXQkqQ12dTT0Y29JxZ/RJbxCAMGukDclZPvLYOqXji8VQYxo78RuTbnWe3djDe
/klXg6kVmbbperVCc2nZ
=eu7F
-----END PGP SIGNATURE-----

--E7i4zwmWs5DOuDSH--
