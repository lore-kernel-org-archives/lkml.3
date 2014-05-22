Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaEVOKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 10:10:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45862 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaEVOKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 10:10:07 -0400
Date: Thu, 22 May 2014 09:09:48 -0500
From: Felipe Balbi <balbi@ti.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
CC: <linux-kernel@vger.kernel.org>, <mingo@kernel.org>, <tglx@linutronix.de>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>
Subject: Re: [PATCH v2] PREEMPT_RT: USB serial gadget: Fix locking issue
Message-ID: <20140522140948.GB11707@saruman.home>
Reply-To: <balbi@ti.com>
References: <1400752728-9495-1-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Content-Disposition: inline
In-Reply-To: <1400752728-9495-1-git-send-email-jjhiblot@traphandler.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 22, 2014 at 11:58:48AM +0200, Jean-Jacques Hiblot wrote:
> With CONFIG_PREEMPT_RT_FULL the tty_flip_buffer_push(..) actions are exec=
uted
> immeditely (same behaviour as if low_latency flag was set). We thus have =
to
> release port_lock before callng tty_flip_buffer_push().
>=20
> This issue resultst of commits:
> 44a0c019: USB: g_serial: don't set low_latency flag
> dc0cbd1b: serial: 8250: Call flush_to_ldisc when the irq is threaded
>=20
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

can you please resend with linux-usb in copy ?

--=20
balbi

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTfgUsAAoJEIaOsuA1yqREKYYP+wRsL1g3xs3IARlanYieLkyD
ExG7OhhN21daA4hsDKmhPj4CqT0bpUNov9l7ORcD8TYh3waDMtZYXnEm9cBurGw/
x2k29rylVO2OI1HcnwbTxGko9R7RYG4bpjqf5cKXGdnMY0cFTSROxfNQN6bU71rS
Pyltv+ZcQXefMwhGGtghutvsOE/gh8nQ6MIRlGYUc2/tWwQ82abw/4IjC1CXg3vI
GegQHJpxts3hb5h/J0DnGhwZVAst62OYmpzbErzh55/SX/gfyrRnmcQpiRZiSYuv
q1pvwsFqKB28PV8n0janXwNvxNf9WWFieQXjHJHcOca/haYJ1AxxHhkLpgky24Qh
91yVEqqHyDQSe8SEYQifVsi+MoYBTHhKlmNdQtV93EnuJmPrmlvYLRseQ+pdDaSR
tJDU8QzfGX+wBJvlNRmjDKheQ5r5iMPlrMRjhrPrywYLtDURiAdnyjGollXL/BbD
LXHw3OHsFVo4fV7ikNMxNIuR2AvtnM8CSk/ObDtLrMpzYqzsl/wL7nPtPq0skQ6Q
dj2PZ6vPvYgn2bvNZoeFhsosFPBp1batUCXMb9wrgVYtNySCO4t8dC/hDjIv+Gzf
Hku3Lamf1yQUr1S7AYkbkWkXfZEAzoXJSuDNxtclN6r0uofSSqxAl+x6zLa74r4J
cBUcWOsEfQWiRGstsW5f
=VXeI
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
