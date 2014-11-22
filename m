Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaKVSBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 13:01:07 -0500
Received: from sauhun.de ([89.238.76.85]:34458 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaKVSBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 13:01:05 -0500
Date: Sat, 22 Nov 2014 19:02:22 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 2/4] i2c: omap: implement workaround for handling invalid
 BB-bit values
Message-ID: <20141122180222.GA9698@katana>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416518925-20679-3-git-send-email-al.kochet@gmail.com>
 <20141121160808.GM7508@saruman>
 <20141122132309.GC2679@katana>
 <B6D9B4D7-25CB-456F-88B4-EB6A53E33A9D@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <B6D9B4D7-25CB-456F-88B4-EB6A53E33A9D@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 22, 2014 at 05:06:10PM +0300, Alexander Kochetkov wrote:
>=20
> 22 =D0=BD=D0=BE=D1=8F=D0=B1. 2014 =D0=B3., =D0=B2 16:23, Wolfram Sang <ws=
a@the-dreams.de> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>=20
> > Huh, I can't apply this one? Which kernel version is this based on?
>=20
> v.3.13-rc8

Wow, that's old. Can you please rebase the series on top of 3.18-rc4? Or
my i2c/for-next? Or at the very least 3.17?

@Felipe: With which kernel did you test the series? Also, 3.13?


--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUcM+uAAoJEBQN5MwUoCm2zk4P/iC6x0VMW9PO1tfCbnatApUl
aO0WzWx1XnqyNt9qo+L7EZjGiDXo9iRfh9Doo39S0Frm3LBnq7NI9N/SlkRWZFcS
txS/579BmuqHSw0+0Sjp/V0B7l5mgpSNXpZjdSKgB6EO/rkC1tN4OurvPJyl5bwh
t1Csu0JHehwpYW4fCJBpa//3VbZ9aepl7rUWj70n2ETBWPQaGmxEKvWY2Ztku4/Y
5Rxf2dcM9nQ68LzRPj5A4HVXPugKOOYWo+Turd51t4DQEamX+aAj3M9hRfdMovwL
GANh2RHLSJ+O3Iy2iwnLvdeUd7yL19EhhjeE5V9T8ZvIzHtoHQCcA+yu6XKMhwXi
+o9wYqC8aZGUEPdhoVtUFSJYwfHCiltzPFz6jqlHVJRM4rnYaPjwilQmRYFtVTGz
Pqc0NIted7naIbj+FN8D5cmL4jeUa3yKuyDbW5MHsPY3BIpxQ/cqMTLT9BZ0uvq0
e5VUcIG3ywTcnSvnAWRLJlxY7BYvXyrjX+CK6TY5v2kLFwd+FHDtlxnL+dDV/Ieg
iiojNHQsd6suJ/lmANh22KZFSZEPbxVMlyz03E5/NG2bUK1nTgTQg19bJ8E309C/
BCVo5rl/4Kbc7+AgzkQ2y1O3cHbkL64Z9I/CaSTCvHQiQFZ5IfI04vYT9d/g5DDg
PcsAqhFcSAEiQ74UehGA
=Z2hb
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
