Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaHTP4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:56:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34651 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaHTP4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:56:42 -0400
Date: Wed, 20 Aug 2014 10:56:33 -0500
From: Felipe Balbi <balbi@ti.com>
To: Richard Leitner <richard.leitner@skidata.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: serial: replace {V,}DBG macro with
 dev_{v,}dbg
Message-ID: <20140820155633.GE24500@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140718111121.7a400529@lxbuild.skidata.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XuV1QlJbYrcVoo+x"
Content-Disposition: inline
In-Reply-To: <20140718111121.7a400529@lxbuild.skidata.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XuV1QlJbYrcVoo+x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 18, 2014 at 11:11:21AM +0200, Richard Leitner wrote:
> Replace the VDBG and DBG macro with the kernels "proper" debug macros
> (dev_vdbg and dev_dbg) in f_acm.c, f_obex.c & f_serial.c
>=20
> Signed-off-by: Richard Leitner <richard.leitner@skidata.com>

please rebase this one on top of v3.17-rc1

--=20
balbi

--XuV1QlJbYrcVoo+x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9MUxAAoJEIaOsuA1yqREdTkP/04E/2ObH7IkPlQ1Wm6p2T9L
UoSU8ta4yZOvNjx6gFodtXn/qaYTpNhsdwx7rCYi3HgJTcfe4pFsPOhYKR2VLfsE
bHaJ/xXAHxCfd3Z6oFqJdVp4VhipQ2ds/LoAy0QT6b0Wi8VkPt/gwC0lOmUvqRSd
4IeYU/5lIWRnYrOlAVGgATt77+vfOLsDXJIMyMhDgR81NEVAvWgVt7gBncLkCO9k
v0WiEbeKgwyGEbuoezICxPEl+qmk4QLTRCESqjkBkkZJu586G6nhHVU/sVfHAeAu
MZE5CCDXPWV0bJs6TSp4Q/WksixSycR+hy46rSGe2g2gisKa6XgZLNWnjoejL2xh
sWg5C4ImasQxn2Vwk9S0wYtBD1suWALh7Aq69pxLnG5JJ9RcPJtdM9Q0T2b9fBgR
ICTQIBZd57hTLihOnycHn/F1zjBe08+i9QeD9ytdosiy+YeUJCJ3hBRKosxdg88n
+aBz0+YMr6VhEkxvxTFbJOku29O/B+ebXXWpKxCmLfq5yChMSNYrSUEYpQB/gk1I
52tJ0wmLgRQLzmImnXgiBgRIw1KwgRbg8qMj3uQcYVddGlpxMbGfe9SnCYrfqYVM
Yhd/V1iO48Id9Fo9aiBKgpf7xy6kxVJFo0p36bMfhkv1r4HWuWAOe5zJ0lfbgCiN
ZGtg6reLxd246qgWgboA
=f2ig
-----END PGP SIGNATURE-----

--XuV1QlJbYrcVoo+x--
