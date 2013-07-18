Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933376Ab3GRSZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:25:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35135 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932645Ab3GRSZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:25:42 -0400
Date: Thu, 18 Jul 2013 21:25:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sricharan R <r.sricharan@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <nm@ti.com>, <rnayak@ti.com>, <balbi@ti.com>
Subject: Re: [PATCH 1/3] misc: Add crossbar driver
Message-ID: <20130718182504.GA7497@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1374165830-6367-1-git-send-email-r.sricharan@ti.com>
 <1374165830-6367-2-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <1374165830-6367-2-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 18, 2013 at 10:13:48PM +0530, Sricharan R wrote:
> Some socs have a large number of interrupts/dma requests to service
> the needs of its many peripherals and subsystems. All of the
> requests lines from the subsystems are not needed at the same
> time, so they have to be muxed to the controllers appropriately.
> In such places a interrupt/dma controllers are preceded by an
> IRQ/DMA CROSSBAR that provides flexibility in muxing the device
> requests to the controller inputs.
>=20
> The Peripheral irq/dma requests are connected to one crossbar's input
> and the output of the crossbar is connected to controller's input
> line. On POR, there are some mappings which are done by default.
> Those peripherals which do not have a mapping on POR, should be configured
> to route its requests using the crossbar.
>=20
> The drivers identifies every controller's crossbar as individual devices.
> The mappings can be specified from the DT crossbar nodes and those gets m=
apped
> during the crossbar device's probe. The mappings can also be specified by=
 adding
> the crossbar lines to the peripheral device nodes and map it with
> crossbar_map/unmap apis.
>=20
> Signed-off-by: Sricharan R <r.sricharan@ti.com>

why isn't this done under pinctrl ? If all it does is mux DMA and IRQ
request lines, it should be written as a pinctrl driver no ?

--=20
balbi

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR6DMAAAoJEIaOsuA1yqREgo8P/0I6lAle/+b+V/gKoAi+ZUWF
NjNF5+d52UZEEReo7aLygZIqiuOT7ujEFRzCELyO6CGcnrpudep1d9swGIbGkst+
L3epIt5GC1ZG1ohaSBo9fksJUlhsBhAOeXPnGYRFTw+mgSo9Y+lNpekCHQwVydRy
DLY12zYQlbFxVL9eur0p60AWi90NeyzgiCVoS/AJkT7r6tMFJXYJoiCjwqF0P/04
z2ek/HdVeJJpLJv8zW7i9xrlsSqtQwa+FauxHzlXAmkQ7SuTUbApDM431JaT/7fZ
rzTnM/HVix1nW+fL/WQssTn5VJbtBgPb3eud353rvLPZthJJvi0mDuUbH7N0l9VJ
JE/H1Ow0hSz4Ea5hoxXlWqMBL5rzLx4MgGB8d/5zvEYUUM6cHcJpYM2urM2LYgId
HY4nvPuCwzVyb5q1ejMowyOb3YM3THB/ZSDvOXIl7lr7gJIeusqmdQLm2yhilexd
7cLY4DjzRntI0SF1JK+bEjjm8klK4x31neGHRtO+LzE4c3zUD1vr1+Fnlbz88JYK
Txdc3O5df9ULkX6VaXCMKUdOofRfb7cKx9bi99uuw8Nrd7+aAQ7zRfxDMTLZl9JQ
qX5mfCX31Dusf3wCb+xg/kU8i/B4gsd/gPdCe1PzJvtl3dGW9rMEm2YNMA39xV5E
kra5dfRkS/94XqjP1fxO
=NZ5K
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
