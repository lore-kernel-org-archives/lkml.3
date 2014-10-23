Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbaJWS4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:56:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36140 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbaJWS41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:56:27 -0400
Date: Thu, 23 Oct 2014 13:55:13 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] rtc: omap: fixes and power-off feature
Message-ID: <20141023185513.GD21407@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <20141015165452.GB15770@saruman>
 <20141015170628.GA13824@localhost>
 <20141015170832.GD15770@saruman>
 <20141022102305.GM2113@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DrWhICOqskFTAXiy"
Content-Disposition: inline
In-Reply-To: <20141022102305.GM2113@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DrWhICOqskFTAXiy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2014 at 12:23:05PM +0200, Johan Hovold wrote:
> On Wed, Oct 15, 2014 at 12:08:32PM -0500, Felipe Balbi wrote:
> > On Wed, Oct 15, 2014 at 07:06:28PM +0200, Johan Hovold wrote:
> > > On Wed, Oct 15, 2014 at 11:55:02AM -0500, Felipe Balbi wrote:
>=20
> > > > BTW, how do you test this series ?
> > >=20
> > > Set a 30 second wakealarm using the sysfs attribute of the rtc class
> > > device and power off the BBB:
> > >=20
> > > 	echo +30 >wakealarm; poweroff
> >=20
> > sweet!!!! It worked just fine :-)
>=20
> :)
>=20
> > Too bad there's yet another DRM bug:
> >=20
> > [  271.150158] Kernel panic - not syncing: Attempted to kill init! exit=
code=3D0x00000000
> > [  271.150158]=20
> > [  271.159725] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 3.17.0-0=
8392-g7fe2269-dirty #326
> > [  271.168567] [<c00175a4>] (unwind_backtrace) from [<c00132f0>] (show_=
stack+0x20/0x24)
> > [  271.176668] [<c00132f0>] (show_stack) from [<c06573a4>] (dump_stack+=
0x8c/0xa4)
> > [  271.184215] [<c06573a4>] (dump_stack) from [<c0654f10>] (panic+0xa0/=
0x220)
> > [  271.191405] [<c0654f10>] (panic) from [<c0049e54>] (do_exit+0x974/0x=
9d0)
> > [  271.198410] [<c0049e54>] (do_exit) from [<c0067694>] (SyS_reboot+0x1=
4c/0x1e8)
> > [  271.205870] [<c0067694>] (SyS_reboot) from [<c000f080>] (ret_fast_sy=
scall+0x0/0x48)
> > [  271.214023] drm_kms_helper: panic occurred, switching back to text c=
onsole
> > [  271.221312] ---[ end Kernel panic - not syncing: Attempted to kill i=
nit! exitcode=3D0x00000000
> >=20
> > In any case, board still powered up after 30 seconds(-ish). So this gets
> > a:
> >=20
> > Tested-by: Felipe Balbi <balbi@ti.com>
>=20
> Thanks for testing. I didn't include your Tested-by in v2 due to the
> invasiveness of the new device-abstraction patch. Still works fine on BBB
> here though.

alright, if I have time I'll test again, but not this week.

--=20
balbi

--DrWhICOqskFTAXiy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSU8RAAoJEIaOsuA1yqREJhgP/jD6sXPiaAZsND1tKsxZBcXB
eeE0aw96cpntMCmbaSsZHyuj1odDv9eHsctNlDnBm27qU9vlUrjl9skiOZQL+dZq
xVRnvqOOF0YOeei0KQWSGNQdXv5v4Q12amLhWNy8cu26t/5e1eVDeiwtNQNBt6Rk
XzNVw/2wg/GFbn/3Belz0HSxHvgA4xrH2AABCG93a83YfgOxR9ZFjg6BHVMIO6bz
vKojss1WTY6KfoIleK2Sy+LnhmMmyUm0lbphCF0MtcVv6ab9d4GmMHPkgPlXru7o
XKbJeWd4SWLCuBGnnzkjFMoj/MiJ+pchJ3PUIB6IxPsKZGGPNVM+Yg+WaO15pBUS
NPbtkYf+0/P8ZTkGuaRfpfM2xuBIWcWBDZQcWIMGQ3x1dbUNq0Zlcyxi/Tc9GvhU
d8ZGfm0Rc9xyaDXdfmoy+nBmAjobqJkKULvZXZ30+nwE0UjQh9BaTpQ4XxZHDj7/
o4GKDFoPikrUrdtPNqS4pnSfjUkRmLMT/LwUvRIdFKEGGv1dHAADK6+opftnuZf2
MCo1RrYi4DVfs9ED9X7Ym0KcVxc0hAwwkgqeEqMpMG8ioL6W/r8wEI+QUeJdlULd
4qGlD0d2Y3K1xEncMUdvgIOhpb9ANTX/MnEww3NgAtl5FnrP/9pKN3hLG0fX+umU
q+g0lgk5FS9GeEllXPSH
=9mAo
-----END PGP SIGNATURE-----

--DrWhICOqskFTAXiy--
