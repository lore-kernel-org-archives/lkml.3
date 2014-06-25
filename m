Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaFYBk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:40:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45231 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaFYBky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:40:54 -0400
Date: Tue, 24 Jun 2014 20:40:16 -0500
From: Felipe Balbi <balbi@ti.com>
To: Rob Herring <robherring2@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Benoit Cousson <bcousson@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, Nishanth Menon <nm@ti.com>,
        Sricharan R <r.sricharan@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/2] arm: dts: am4372: let boards access all nodes
 through phandles
Message-ID: <20140625014016.GA21616@saruman.home>
Reply-To: <balbi@ti.com>
References: <1403547659-24558-1-git-send-email-balbi@ti.com>
 <1403547659-24558-2-git-send-email-balbi@ti.com>
 <CAL_JsqJx_DJqxpEJebi0Etfv5g7=eYje_53vd_44GykreA-rkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <CAL_JsqJx_DJqxpEJebi0Etfv5g7=eYje_53vd_44GykreA-rkQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 24, 2014 at 04:11:48PM -0500, Rob Herring wrote:
> On Mon, Jun 23, 2014 at 1:20 PM, Felipe Balbi <balbi@ti.com> wrote:
> > by providing phandles to rtc, wdt, cpu and dispc nodes,
> > boards can access them to add board-specific data.
>=20
> Strictly speaking, you are adding labels, not phandles. You can do

heh, fair point. Easily editable when applying, though (?)

> phandles without using labels, but the syntax is not so obvious. I'd
> tell you what it is but offhand I don't remember. :)

something along the lines of using the full path ?

--=20
balbi

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJTqih/AAoJEIaOsuA1yqREs7EP+KmPRAojfoBCwguTIiGQh4AJ
0uUI1HD7WBWm3xrqIzsrz5leFhbytxsLmevLAxi1uWAuI+HNokwx6Kma4Nyha8RE
Mv9rY9/ZJNtRFT2+zej8awlL0wTiKOVg6vHiSJVh4yh3lRkLLA12fpmipSOYRwDK
mXkPtt+sSeV/EqLxU5MKN7kq7Vy19oYKTXGn57wHKlLnWI0xucJQMJR4JG2bFaka
5ZWJSmyz3KgqsA4YNVOdxbXlUmzqCewgqvJij624oT/kPO5EGmd3pMXtKncOeGfl
v9+2deuTGqQXzuErTULorcNjJuEY57WmdBRLHicunRYyZPqisjgS6keKSmlb2nnR
z1qeitHYgocAXFScXl+j/I/jcswMR5pVYqoa86trPSiqCbZorQJh4U4oQKZFKpRZ
i/jUQw9Q5ObG/en+yiBdGRed6zct41fDws0mJqLjNMXZUpKv2f2+21odtWU3Fg2P
z95rDmd1tHWRuEgpqWTo7LE1VRf89dBShhUJPhPAKKt96XgDRLvO7q/9yevZPB5q
cgH4/kgyZpH+mWq0njWWVFYF0pdEqLC3PjQw4pmnZGSQmQjB7L3ppX3HRGHJ6Wdh
KQbh2cxBb+axGmGhsaGDSuxArD3CRkWGT/FZn3Tsm++/f/CRKAXMyhVZnFuTAhAW
q8LOz2GdIcSMnFuXTEM=
=+L+D
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
