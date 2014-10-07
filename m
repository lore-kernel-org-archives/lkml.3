Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaJGUXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:23:37 -0400
Received: from sauhun.de ([89.238.76.85]:51103 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbaJGUXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:23:36 -0400
Date: Tue, 7 Oct 2014 22:24:16 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: fix a potential kmemleak of adapter device
Message-ID: <20141007202406.GA1284@katana>
References: <52B0F7D0.2020506@cn.fujitsu.com>
 <20131220173144.GA9997@katana>
 <52B7961D.2050505@cn.fujitsu.com>
 <20141007173439.GE1577@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20141007173439.GE1577@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Okay, there was another thread about it with more details. Still, this
patch addresses the problem on the wrong level. No driver should mess
with driver core basics.


--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNEvmAAoJEBQN5MwUoCm2CTUP/jWmphJCJhMBCFWwvSlQJ7oO
EePanWFbHpVcbhD96ONs04xhank+aTE3Wj5N75OZEoJ6SRB9Wy5YdWp4aN/vaK8k
EB5YR3ORdbjRc+Lm33aa/0lDK9dGMUYqFN98HDyJqZG33jPwWITmfPDPngdKAXOq
pAl0Vq3ERRxnAqKJtf8paHklBGdEqoVe1ckiRtYTlzZJsaHJDj4BFoKWa2WqmjKy
edlVtgZIHsjQ3d36NWI9NC7/qwn8Mb9Nqj7V9st58S8wMLze+wx5xXVTpdU8tsoj
YeQSekbwbdGt/1Yphv2WtxHo6TbVMt8LCthSkbgjf9oYPqSGvFc9KGbGjRcJLYTx
sGg/pd2ptSUG4mciABdueTERQ4P8vBHNYcqpp1O6BpsaBX9Ld/IMLRkIqbSGyySq
c0mdcCT4miht0KDaFL9bJ2Ae5aMCOrQcWQ3q1DaZfb/6IHcVdYIGSDl65SdT2TbF
RfIEM3rtK6bzW+eMridFOBboxP+4GLU+fg07u1DqXOy22JFJu0MMZGcKAti9cWl/
FaaH7U4PBayaepvFgeUqzZ6J/sME/J0o3XNiQgoY1saQMesXaKm3hWI+bjAlWkNR
sFORRuY/vxaoJNP772gCZBMhVKJYmsh5Na3fpaSwFg3mcZQ/sJbTh0jyW25Eb34s
tVqo6o7jxR1+5zD9Fxn8
=krT0
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
