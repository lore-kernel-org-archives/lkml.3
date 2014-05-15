Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaEOJKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:10:25 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:42399 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaEOJKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:10:21 -0400
Date: Thu, 15 May 2014 11:08:15 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: stefan@agner.ch, swarren@wwwdotorg.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        marcel@ziswiler.com
Subject: Re: [PATCH v2 2/3] drm/panel: add support for EDT panels
Message-ID: <20140515090814.GB6434@ulmo>
References: <cover.1400103181.git.stefan@agner.ch>
 <35c081171a3d9a9401767601c02a12e266b37dd0.1400103181.git.stefan@agner.ch>
 <20140515075102.GE5952@ulmo>
 <1400142449.4102.16.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
In-Reply-To: <1400142449.4102.16.camel@paszta.hi.pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 10:27:29AM +0200, Philipp Zabel wrote:
> Am Donnerstag, den 15.05.2014, 09:51 +0200 schrieb Thierry Reding:
> > On Wed, May 14, 2014 at 11:45:57PM +0200, stefan@agner.ch wrote:
> > > From: Stefan Agner <stefan@agner.ch>
> > >=20
> > > This panels are sold by Toradex for Colibri T20/T30 and Apalis T30
> > > evaluation kits.
> > >=20
> > > Signed-off-by: Stefan Agner <stefan@agner.ch>
> >=20
> > Panel patches should go to the dri-devel mailing list as well.
> >=20
> > Also a patch was posted only yesterday for a panel that seems to be the
> > exact same one as this, even though the name differs minimally, see:
> >=20
> > 	https://patchwork.kernel.org/patch/4175251/
> >=20
> > Adding Philipp on Cc so you guys can work together whether this is
> > indeed the same panel. The only differences seem to be in the vertical
> > front and back porches, but I suspect that either settings will work on
> > both Tegra and i.MX.
>=20
> The ETM0700G0DH6 Datasheet lists 2 lines as the typical vsync pulse
> width, 525 lines as the vertical period, and 35 lines as the vsync -de
> time, which is vsync len + back porch.
> So vertical timings 480 + 10 + 2 + 33 =3D 525 should be valid for the
> ET0700G0DH6 panel:

Shouldn't that work with 480 + 8 + 2 + 35 too? It seems to me that it
should still be safe for that panel. Similarily I'd expect your timings
to work on the ET070080DH6.

Irrespective of that they both seem to have different capabilities so
two compatible values should be fine. However for the purpose of the
simple panel driver they could be made to share the same timings if it
works for both panels and devices.

As for the touch panel on the ETM0700G0DH6, do you happen to know how
that's usually connected? I suspect it needs external hardware to
capture the YU, XL, YD and XR pins and turn that into raw coordinates
and pen down interrupts.

Thierry

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTdIP+AAoJEN0jrNd/PrOhvfYP/Ak0eBNsBZ7aJA3m9Cqvu2tC
3eVRHbL14V0zQlMEwsrFL9XXIRCcynW55/npevE4S5JsbVVUV7Lv6e5vCupbOpGs
IpJitDjqcN+GXFrXS5YB4Ib7y6syBVk5nce+vvH/DNSi4bjCt1cA4plOzkSx306/
348pFqRNkrI+LyO6DhaUEK6GuBeP1etgKmZnqhof40CWmS4FLpR90Z/qkbqWM3hT
DCuFm5JlLZ9MumQIpP2fd3+YgQEvdd85wyNGt21AF03T4EfNgPmjqRWbOeZjj4e8
m2eXo3Qy6AT06wbGZfCDoeOWTUntz+a73Ts1iHR7mCi5IGNLV+E7I1OBxWa+5nkp
PJIrkcfsHIg3FTnEc4mrf9v8EXgSByGPmWdsDmWXvDOOBJZs/oupXCHsO7DSHVNd
gZqYRme9iJYwpRgC8M2rrkyTtZR3RTBmP+5Ne1u2WndV4IbuEVX5BTtYsdkzqjTs
vxUUoi+SMOu7MgE7w+rw85mL13LRhDNHJGj+xQw1Qe1S7OS28k19bnEShXXoStxT
E3N17O9+6BPcpxYb6f76YLVpd8Yr1qJIlfkgvxnyyV03QsGDQb3QCy2DDtcUi7IW
Cv+iWrBgnMWG1azyLjTZb6gagxtbL7+QoHwFmki0qVOae97ajw4WPjo1RNeEVXTX
DQozTbS2CLKFU6eNplHW
=DE8d
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
