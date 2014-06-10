Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaFJBEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:04:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45460 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426AbaFJBEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:04:53 -0400
Message-ID: <1402362280.23860.98.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.4 65/88] mpt2sas: Fix for issue Missing delay not
 getting set during system bootup
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Rui Xiang <rui.xiang@huawei.com>
Date: Tue, 10 Jun 2014 02:04:40 +0100
In-Reply-To: <20140610002426.647354389@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
	 <20140610002426.647354389@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ylSij0fwVnx3B+popDiU"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ylSij0fwVnx3B+popDiU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-06-09 at 17:25 -0700, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
>=20
> commit 93cfcb8c998e3fe2c075fa61ab28f7b018e5049a upstream.

The hash above is for 3.2.y, so you should delete it.

> commit b0df96a0068daee4f9c2189c29b9053eb6e46b17 upstream.
[...]

This is the real upstream hash.

Ben.

--=20
Ben Hutchings
DNRC Motto:  I can please only one person per day.
Today is not your day.  Tomorrow isn't looking good either.

--=-ylSij0fwVnx3B+popDiU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU5ZZree/yOyVhhEJAQos0Q//bwuLosc8OuujPkGzMwBSDCo7TTieYP43
Ytf4sWlIjyCi6gfPs/IO3Yk/fnkcFvi3E62B1JdxS2heMvKTa8WbV4l/INLs7SLf
6cfx2dTT2q0w8Z5jzamwZz/33Vn8Fjhjte+s1r3jUbvsPXehLDCe+EPa8SGGkM1m
9D3kLQau52w8URlYI6L4ra9+AkybpIzNLiIvNNatKiPh0C6JNDz37K3gvaqYqWdk
x5mz0t+6hQMY1/Tc7PSq9cRdtGm3aokK436Q60bFeaGyWmks7mDgkJHxN8PlghhX
rFeJ8t1FUjokCsI2+Bt5cSIfYtEiWunT2LhKqcCWkinPHMikaLEH0daZlde+evvi
Z47vw4uRzcL4N9E9+rUZraWhqM6Rp8VinEjns6lzKdxlaAZhSV4IX3r4r2Y/YfCS
aj4mbDsFO/FlA1ifCKMV0BWCjbmfq6lCYUQ6gwPIVUp2dFzS02YcJAVupa8kUkLD
8+zlhmwFfUvLomLigC01dfFsiVKJ8zQuCCe3zTNo8c2hPcMBtNJNy/fKsk5mMKVu
DCrVXxSyLBG4TW3TxQjOF/kZwjC4TJGKZ+VNJ0/rCzO311whH0FKQ3kFM890QVLv
PIk4a2X/DwBNqyifEe+UQzzuAzSrl1YopdYFc6K37CnhU5GZOQd8BidnifFL34cd
yLNvg4gGz3E=
=JrZt
-----END PGP SIGNATURE-----

--=-ylSij0fwVnx3B+popDiU--
