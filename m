Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3CEKuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:50:19 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50633 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab3CEKuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:50:15 -0500
Date: Tue, 5 Mar 2013 12:49:44 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: <linux-usb@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] usb/gadget: initialize gadget functions helper befor
 functions & gadgets
Message-ID: <20130305104944.GE7899@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130206020424.GB1175@localhost>
 <1362432489-6325-1-git-send-email-sebastian@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tMbDGjvJuJijemkf"
Content-Disposition: inline
In-Reply-To: <1362432489-6325-1-git-send-email-sebastian@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 04, 2013 at 10:28:09PM +0100, Sebastian Andrzej Siewior wrote:
> Fengguang Wu run into a kernel ops after he complied dummy_hcd and g_cdc
> into the kernel. The problem was that u_serial was used by g_cdc before
> u_serial was initialized. In the module case eveything is initialized in
> the correct order but if we compile it into the kernel we rely on
> Makefile order which I did wrong and now I correct this.
>=20
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> ---
> I kinda assumed that this was already fixed (i.e. a patch like this was s=
ent)
> but it seems not to be that case.

already in Greg's queue, cheers

--=20
balbi

--tMbDGjvJuJijemkf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNc3IAAoJEIaOsuA1yqREcVsQAKfXYP8nPOwDFozKSTi76o19
GGjVaa9Y/gPuisrwlrUGrm8tCXOhvJxbIQpyVx41jgSiMrQDHa7PHpSNCL+X2uRw
uG5fyIlpdgKtVQK7Ot3min2iFkd9Ay31hva7wEzIxUCg+1197/jbPk//LXp3oZWg
lLBaMFrcvHFwZ0l+70ZOnjhXunQphUKZyxOVzUq7B3TmANRdbB8mgF/aCxrXiXPo
iPX64cFY130CUgDv8HnQ0hz0X3h1DLk9Dq0YKP1LwqMZazQnR7YTZle5+ndsdNLk
BwqKfo4oP+2q6YjqJ731EDV1zLT8C/FSdvuLJuydlY+OJhdjLvvjqD1wUCZeC3nF
o3IadeWBEKFxsQUTV7fFExIRPB+n9HmchdLHczB4CSORqwyRaPHJvq6fvBWZbREe
c0yjf559EdZBeEcEqz31S9sC5eBrMkoQ+xGLGFnpIYFiBDJcyi8+Pwy+CbRl7gP5
egy2HFq6N4Z5Bdc19YqvMM/uvLR+3TFfijMGk67o2yi/+ZOjzW04Qv4ct2ga4cOw
QedrMuGExEAUUhH71E8xY3SpQaIaQBphCcgMk402tDpfWzAS15lwpA3kNIEyKs0M
weEKGvxbeF5Qd6VrTlXMLkCS2PycKbcmmY3fCw50w0nw39yMz9Qts+jC9s5HEyY+
FlZEbHtLuHWAsotDbebh
=Z5F/
-----END PGP SIGNATURE-----

--tMbDGjvJuJijemkf--
