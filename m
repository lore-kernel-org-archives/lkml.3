Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934844AbaGPSaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:30:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36000 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934637AbaGPSa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:30:27 -0400
Date: Wed, 16 Jul 2014 13:29:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: <balbi@ti.com>, <will.deacon@arm.com>, <mingo@redhat.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: Function Profiler broken on today's linux-next
Message-ID: <20140716182944.GK3016@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140716162328.GJ1365@saruman.home>
 <20140716122921.71b118a9@gandalf.local.home>
 <20140716164141.GA3016@saruman.home>
 <20140716132413.1ede8e1d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qyHYMwAXsHLOQihY"
Content-Disposition: inline
In-Reply-To: <20140716132413.1ede8e1d@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qyHYMwAXsHLOQihY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 16, 2014 at 01:24:13PM -0400, Steven Rostedt wrote:
> On Wed, 16 Jul 2014 11:41:42 -0500
> Felipe Balbi <balbi@ti.com> wrote:
>=20
>=20
> > .config attached. It's actually an ARM platform, I can help out with
> > testing anything you need.
>=20
> In that case, can you see if it works under my repo?
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> branch: ftrace/core

works fine, thanks. FWIW

Tested-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--qyHYMwAXsHLOQihY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxsSYAAoJEIaOsuA1yqREmvcP/R65TWd1kl4bG2/pZAHcs8Wz
VZYfeYPtnu/dtrnoww1jWk1jwqAJYLUoCqJIeGv2qn7S8PlBE3rG9xZ9K6vVNPmA
O24DRRT1JP8j1/HK2Pzf/7fYyW3HSufwjIDr30ZyOEN1Pyus2/ofwyBjIjGR5NO9
wUN7ETvNHmcje+tTjZtqCDt+Ajh9ah0ekAMgvcloQjRY1JKLHbWt7iLvxkK/OlYm
gkfSF4Y52IYnp06DnpYEnfzYOc541L+N2yWzBE2rOGi2QkcEYYXWEdjVcYc0pgPl
+aC0zsYA6VGRtIH6/0Bxd5zgRS0BoR0tRLTFn7+CTGiI8Fsf8alQNjFnUPqv/bw2
grgJTmQ4DJVyDTyHLyEd7+dr8LGKiBIICswd/U8rLrHtxH6s3elow2Sith58ESEA
RzMICKdSNB+HLdXcBCR4dPf8XPEnRX2oJT9GL+w0ojBUOnYihAJq7W3j1GSSZ5X7
ioJQMx2vAWOuOc2CTFnr0gcIBRsy3rmrhpiy52Nv8D/06+TOew79bL4i79YXM1eE
Oyjadypo4Zpvj8jrWs97/+Ki2edm7O84rImbaJgweYsAVbLe5Zs+Lc1fbSE0tsfY
ShhhjtHcLzs76pzPJfxs3tqtoXNx+wXAN/E1oTVcr5J7StkzmD8I5k9J56sMSBdf
PavcTljI4NTtBYiRiTog
=y5CI
-----END PGP SIGNATURE-----

--qyHYMwAXsHLOQihY--
