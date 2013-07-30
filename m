Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab3G3IQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:16:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34798 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758079Ab3G3IQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:16:08 -0400
Date: Tue, 30 Jul 2013 11:15:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm: omap: remove *.auto* from device names given in
 usb_bind_phy
Message-ID: <20130730081520.GH16441@radagast>
Reply-To: <balbi@ti.com>
References: <20130729175413.GC4964@radagast>
 <51F74BC8.7020903@ti.com>
 <20130730060134.GD9155@radagast>
 <51F7590B.4020705@ti.com>
 <20130730061830.GE9155@radagast>
 <51F75C40.4060406@ti.com>
 <20130730062844.GH9155@radagast>
 <51F7613C.5070803@ti.com>
 <20130730071611.GD16441@radagast>
 <51F7752B.8050804@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dMyqICaxQaaUjrCL"
Content-Disposition: inline
In-Reply-To: <51F7752B.8050804@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dMyqICaxQaaUjrCL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 30, 2013 at 01:41:23PM +0530, Kishon Vijay Abraham I wrote:
> On Tuesday 30 July 2013 12:46 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Jul 30, 2013 at 12:16:20PM +0530, Kishon Vijay Abraham I wrote:
> >>>>>> the list of controller device (names) it can support (PHY framewor=
k does not
> >>>>>> maintain a separate list for binding like how we had in USB PHY li=
brary). e.g.
> >>>>>> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg92817.ht=
ml. In such
> >>>>>
> >>>>> this has nothing to do with $subject though. We talk about generic =
PHY
> >>>>> framework once all these PHY drivers are moved there :-)
> >>>>>
> >>>>>> cases how do we pass the device names. Also will the MUSB core dev=
ice be
> >>>>>> created before twl4030-usb PHY device?
> >>>>>
> >>>>> and why would that be a problem ? We're telling the framework that =
the
> >>>>> musb device will use a phy with a name of 'twl4030'. If musb calls
> >>>>> usb_get_phy_dev() and doesn't find a phy, it'll return -EPROBE_DEFE=
R and
> >>>>> try again later.
> >>>>
> >>>> I think we are talking about different problems here ;-) I'm trying =
to tell
> >>>> using idr in MUSB core is needed for Generic PHY Framework. So in a =
way, the
> >>>> Generic PHY Framework series depends on this patch series or else MU=
SB in OMAP3
> >>>> platforms wont work after Generic PHY framework gets merged.
> >>>
> >>> then you just found a limitation in your framework, right ? :-) I mea=
n,
> >>> imagine if now we have to add an IDR to every single user of your
> >>> framework because they could end up in systems with multiple instances
> >>> of the same IP ?
> >>
> >> I raised a similar concern in the PHY framework discussion [1] :-) And=
 since
> >> it's used everywhere else regulators, clkdev, etc.. it's agreed to be =
used in
> >> PHY as well. Btw if PLATFORM_DEVID_AUTO is used even regulator, clk_ge=
t should
> >> fail IMO.
> >>
> >> [1] -> http://lkml.indiana.edu/hypermail/linux/kernel/1307.2/03573.html
> >=20
> > look at Greg's and my reply to that email.
>=20
> but finally Greg agreed to what Tomasz proposed no?

that's not what I see in the thread. I see Greg agreed to regulator's
own IDs being sequentially created, but he mentions device names can
change.

--=20
balbi

--dMyqICaxQaaUjrCL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR93YXAAoJEIaOsuA1yqRE2dgP/1ub6lcQOcC0FymtHYNtY0UM
iw5h7oeHKB+R09SmfF3Z5iEGv9gwPSp32gspFeFSy4mvtvQfjQlwNjEeUZQEsZhX
yZ3DHYkkAyOVXIr6IWZp2lvVVOuimj0W58ddUFQqEeV4L6SlP7GVKrYpENdwGz4o
CuG7ykx3GfGiscJFgWT8SlMCmo6PosLT6yf+eXo6Ta+YNPlqvmQmwgbeJqmZjWF/
D/1F/GoMviBKGW/wifsf0phUCfpHP8lkc6WTb0fDOXkdJtmq6DKnuiqJr7woeZZr
bCz85DhKIOCrRcMbNtoqFqStJ/BYvJwebTL3rolNRggM8zmQV3M9RspkqW/2QP3B
RSPEsLMhOdyJrhcheqCHZF4CjgT9amPKlQ/5lAjGiBMykfN9p73xfk0JmmILk6MK
WKDbj3Lh2jQvSLnFSLdDizun5RkuO+F1t1oLx4PeKfAeBaKpCWseEctlnJR/iBAR
vu7DLOsrDfLN11Ot5D4dGxiBToBQFhhDhxiOuMzQ24ajV83fyjmI2Pqan11LVVwh
NhApUt3nYWkYP+D+7Wgpzq6kE/5DK0IhRvyXVMHG49pYxFCqv21paoo9NgFr2bYx
2sA15RBNgEoDQdKDgKZC6VMPg8wWVZ71uBdnVXFyB6gRh4eCHaLCYECLlsySKZax
q2sWhY4fzN4sxbcuAXlK
=XK1L
-----END PGP SIGNATURE-----

--dMyqICaxQaaUjrCL--
