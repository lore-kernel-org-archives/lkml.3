Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab3KZSLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:11:17 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46714 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223Ab3KZSLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:11:14 -0500
Date: Tue, 26 Nov 2013 12:10:24 -0600
From: Felipe Balbi <balbi@ti.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, <freemangordon@abv.bg>
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
Message-ID: <20131126181024.GA24310@saruman.home>
Reply-To: <balbi@ti.com>
References: <201311191151.17153@pali>
 <201311261810.22885@pali>
 <20131126171748.GA26429@earth.universe>
 <20131126180643.GA32057@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZCk4OG7a+AFlaik7"
Content-Disposition: inline
In-Reply-To: <20131126180643.GA32057@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZCk4OG7a+AFlaik7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 26, 2013 at 07:06:43PM +0100, Pavel Machek wrote:
> > > > For a long time (since 3.5 or 3.8? - I do not remember) obex
> > > > subdriver in g_nokia usb gadget module causing kernel panic
> > > > after module is loaded on Nokia N900. I do not know where is
> > > > problem and due to immediatelly kernel crash when loading
> > > > driver I was not able to see any dmesg output. Now I was able
> > > > to store something into mtd log and here is crash backtrace:
> > > > [...]
> > >=20
> > > Hi! can you look at this problem?
> >=20
> > So it worked at some time?
> > Have you tried to git bisect the problem?
>=20
> You are a cruel person :-). N900 historically boots about half of the
> time, trying to do git bisect there is a nice weekend project... for
> about next century or so.

heh, I'll agree to that :-)

--=20
balbi

--ZCk4OG7a+AFlaik7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlOQQAAoJEIaOsuA1yqREUdQQAI6fmxnsiNPEoqofgCCQ/mhi
gpNlOCymY1tevYoN4O7s+2m4F1UCDwFnEBAyd/k8OA13AOo9u/gg760C9wNBXwAc
s8thog4iDYDlel65VfhIvN30Biu+6A/g1u/d5cIl6QH8xvrBUDbfaGhNwd16p9Bo
2/0+4Ef3XpzrCu/R7exwhakHyh/uIAn6ooIUS5z0MG8RME2cAQee0VYoJiOwpBgQ
xriJuCwDBhVDbrH/I5NUAM2U5Zq5ixRH1SLiR2iiQLarR9CP1QmCSlQtzcOMODzZ
+GCM+UykhY7eLHudQMHdcAFFT7bdZXAoCKBt6I82CjNrtuvXZ9ElFYu1fk6tdfgQ
DXzrvcYdW9G21crGXQ9Yz7vjkJaN7BwHmRjEMSHvDMUMDtcS2zjJWPYwwYVcGyeX
JG72t+DeYjZ3PAjofJLNoAnS1J9OiT0eRlwAczbLIDpBWfsQdvDoHS1ZhXDfFK0v
cl5rDPIv2e6I7bT0BaDkdp2LQKNLvylOG/WVLahiNorrpvxB3Oiucd0oQj0JXI1w
cWHx4fuArVZdTGiT6jK97j0PB32/hMNxgU197El7X+qp/qbb9A4ejrv4sXQnuhRg
K5vV+8bFbkQ3SuHxBRrmCY0bc0R/DFhC3m36pqT8R0lVp3uaZ3XV8cRpAyhvDoj0
1XhsXNiynSyfrAVpwPir
=7B7j
-----END PGP SIGNATURE-----

--ZCk4OG7a+AFlaik7--
