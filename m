Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab3G2AOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 20:14:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38579 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab3G2AOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 20:14:49 -0400
Date: Mon, 29 Jul 2013 10:14:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@linux.ie>
Subject: Re: linux-next: problem fetching the drm-intel-fixes tree
Message-Id: <20130729101446.2c1b0ae22d4986d584c63be1@canb.auug.org.au>
In-Reply-To: <20130729100843.8d129b9953ed39e55e1d5a31@canb.auug.org.au>
References: <20130729100843.8d129b9953ed39e55e1d5a31@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Jul_2013_10_14_46_+1000_CIPH23DacuiGFIzL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Jul_2013_10_14_46_+1000_CIPH23DacuiGFIzL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Jul 2013 10:08:43 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi all,
>=20
> Trying to fetch the drm-intel-fixes tree
> (git://people.freedesktop.org/~danvet/drm-intel#drm-intel-fixes) this
> morning produced this error:
>=20
> fatal: remote error: access denied or repository not exported: ~danvet/dr=
m-intel

The same is true for the drm and drm-intel trees
(git://people.freedesktop.org/~airlied/linux.git#drm-next and
git://people.freedesktop.org/~danvet/drm-intel#for-linux-next)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Jul_2013_10_14_46_+1000_CIPH23DacuiGFIzL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR9bP2AAoJEECxmPOUX5FEYwEQAJGBFWFXeed8RvlLxkCsqIOv
kCSczGZhyEexYQpols4MQGpXWwrNxWzwgGdQVvCK2KlQ4ZltMs/Cm4j3Ylg+2Tah
peEjluS9mErYT4iaf0yDV1a1Sg7DkX65wDXOoPUA3drdm6StyoyhcYE9LWDVwwCk
FU3B4BU+w9gA3/7hmcXRu+Kei/fTxQ/SDlpzqsqG2+Mrtu2oDlyukWnVTJ4/44J6
MksuCk5nl/fmuEntyhmT+mNDItdiKc23vUfix+BmZoDgBU+mtY3OHArxtx6Ihnb4
gHlQyjXuv5oxUCgbj7o9jHIVmS/fE8nQhKkhzjge3iwMOTrqC+iUCQC2X9gInchr
PLuQOmoJN6G9Vqn32VqI5KXobnQvjL2PJSZDg9e7bHq8icawUBamMkH2WHjfyJU1
+0AahsvEeWDQSDJY4ype/ni8suUTtVc9u+TkifLOiPFgr86M2tjIJj+StBPI0oCJ
Bx36HZsq+Qf/F1lGQSXb1WsA8dBrZPucCC32KCW0vpPkV+OS0awikD0tlYEIRg2d
Mc6j7/zal+uvpQfwN8+Gq61IPrBCkI3UtM2bPKTtvC1I71k9XT1GxLKCxW8Fk4u0
MRBeTBusZWdA0YXbC7UNcXENDtrlUijjnF/QHQHckMZjZTSrvSqF47MFLX76JXaN
TSNNnX+D+VhhZlH9RTJr
=oxJt
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Jul_2013_10_14_46_+1000_CIPH23DacuiGFIzL--
