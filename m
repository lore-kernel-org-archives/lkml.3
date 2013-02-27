Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab3B0Ktv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:49:51 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57436 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab3B0Ktu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:49:50 -0500
Date: Wed, 27 Feb 2013 12:49:35 +0200
From: Felipe Balbi <balbi@ti.com>
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [usb gadget] WARNING: at kernel/mutex.c:198 __mutex_lock_common()
Message-ID: <20130227104935.GZ8016@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130206020424.GB1175@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GrZJL/A7LJaW37J8"
Content-Disposition: inline
In-Reply-To: <20130206020424.GB1175@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GrZJL/A7LJaW37J8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Feb 06, 2013 at 10:04:24AM +0800, Fengguang Wu wrote:
> Greetings,
>=20
> I got the below warning and the first bad commit is

can you send a fixup patch ?

--=20
balbi

--GrZJL/A7LJaW37J8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRLeS/AAoJEIaOsuA1yqREnQ0P/RgS115OTrPsGZxvJgV0MPAJ
iBHrXsHzMLOAd1wksP7fBhxzPNrjxQTON32mGJb73K4QDgWDkXEID8EnP3LiX4Tk
0qbrTZ54bKkU6I5E2h6viWlAEXRGlUcJHdpod3uny2UcWNPh+HkBiFBK2Vx3+TlY
iMsshTMRhddZoEFLkboFcV5dUlucJ7dnZc33V61VUThKRXxhSQoUN8FkXYnqBjIa
9mc1Wn2NBPEbm5zNoFQn2luQF2JV1VGx21TkpJ8GGayZmMJKXCVarqykoWbtPOtl
3AnV1RD6l9H3DX8R40TSLNtYw85MbN46xQt+3lGEkuEQt91h3R3qeY1qUUlkbBSG
UcBzhdSpCg85OJ94wV2FKhovDpm//3MZGIau5p5t+1gQ9Y5segLPMzk6dEoESdSC
BtKAXZ8EAAJe4MZqMwwUHbvlZWqUSaJUlvns3PaXHu97IG9osyG+GxWNnFZBiYys
XkCu1vdVjHVMnsmcZGVeZgwwwbkGC7o4xe7teQVX+BaGXb5VxG0IP3nahEpMgH4v
QUjCRymS7YxlleDUcIDjwkmKq7DMO8x0JzJvIv50dXw50AaiF7h+OMbyCoc9Vc3y
NqvSL3Kyhu2cUqds9u9MgTMXOeNtAYWwdKXNSCBu5AR29TGrDTCA/9vPxmfS1gCU
eJkMhFvfcAtL5BXQgExB
=q9tS
-----END PGP SIGNATURE-----

--GrZJL/A7LJaW37J8--
