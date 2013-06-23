Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3FWMlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 08:41:20 -0400
Received: from sauhun.de ([89.238.76.85]:49655 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab3FWMlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 08:41:18 -0400
Date: Sun, 23 Jun 2013 14:43:18 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Bin Gao <bin_gao@linux.intel.com>
Cc: Bin Gao <bin.gao@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: i2c: introduce i2c helper i2c_find_client_by_name()
Message-ID: <20130623124316.GA3025@katana>
References: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
 <CAHp75VcYgpUVpOnKOzkYoZXbEPO_0QG7=WUXza55wpOyRwcKCA@mail.gmail.com>
 <20130606212620.GA13620@bingao-desk1.fm.intel.com>
 <CAHp75VcGUtWyPHrvYDW59-4g8F2m58-Us3CrbJ2bnYJdxnd1Sg@mail.gmail.com>
 <20130611171119.GA35135@bingao-desk1.fm.intel.com>
 <CAHp75VdZA_gouZohD1J+o9ybpXVLLQH=D7QDo9OznW93iBDZpQ@mail.gmail.com>
 <20130614190003.GA19617@bingao-desk1.fm.intel.com>
 <20130619101348.GE2950@katana>
 <51C4EF85.7010607@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <51C4EF85.7010607@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >I also wonder about the need to unregister. I have to admit I don't know
> >much about I2C handling in v4l2. But if it requires unregistering from
> >i2c core and registering to v4l2 core, then it sounds to me like we
> >could check if there is a more fundamential cleanup needed? Deferring
> >for now, looks like an issue worth looking at, yet there are other
> >things in the queue first.
> >
>=20
> Platform codes are supposed to call i2c_register_board_info() or
> i2c_new_device() to register devices, we don't want to change this.

Exactly.

> Not sure v4l2 can still take over the devices without
> unregistering/registering. Need look deeply into the v4l2 code...

That would help, I currently don't have time for that.

Thanks,

   Wolfram

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRxu1kAAoJEBQN5MwUoCm21S8P/2T2mBgsZrfKaki7bZaOrlWV
oC+mr/hD3yQMjeDvMgASxNr9e3JclzDNISNNu3YXmXGmzEBP+YcgmT4prgnU/C20
M6fe2Bx2XYplp3AuoQF7LCC0351vobhquT6Jx/NTcR2jHzCCd8wtpsO2QaW3pKS2
74nVQ9iLdOV2PNrxNE4P8agZomhWTCyRX3dloZWifhJik5sLJSpqgSBdAouFM2at
5Upy+9Q6aIeQEX6kwkulDYTpiHDBqafgOqG/Lo9Cn4Op4qBJ7mDmYxqhhG+rAe9X
uZJ0mMzSpnMFG04onwvZ+514hJb5VIpdv8TNb1KXY8GQk0pUHyrJs44KnrRLEovb
rDe/IjsRcTjQ+B1Vfdx3zqqGNh+rekcOGOiwpuUwDRhPQePtpYK4BOamjKc3xQXD
zoxh7ed7m+b4lts6VuHCse/4qhQ3OveDp1zZY7nmAzxC/iSroWa8thlHkKQgYvnE
4D7EOtTkl2xscHikLK3Vb1EmT/sd0Ozxae+b7lbXgp11v/qci3Bqqs9YuXeVvEry
Wmq3RTOPb7P+ww31FYu/RTRhotRmT7Mky0MzafdtcxpIPd7vGVL7422k6SO23qgA
TuVN/kD494GdCgCW/gk+rT9QH9z/JkndPse4bBpUnQ6wvvH4hObum5BxsQRxgAA1
/aZYATxbebTZd4CroAMH
=4OBp
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
