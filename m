Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbbAVOOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:14:41 -0500
Received: from sauhun.de ([89.238.76.85]:41401 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbbAVOOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:14:39 -0500
Date: Thu, 22 Jan 2015 15:14:27 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/1] i2c: i2c-st: Rename clock reference to something
 that exists
Message-ID: <20150122141427.GA3413@katana>
References: <1409234523-20240-1-git-send-email-lee.jones@linaro.org>
 <20150122121819.GC9129@x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20150122121819.GC9129@x1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2015 at 12:18:19PM +0000, Lee Jones wrote:
> Wolfram,
>=20
> This patch has been on the list since forever.

For reasons :)

a) It was not CCed to the i2c list, so it doesn't show up in patchwork
which does the patch tracking for me.

b) I was always under the impression that Maxime is going to take it?
He said so.

> I have Acks from the driver author, so I'm going to take this through
> the MFD tree.  If you perk up later and decide to take it though the
> I2C tree instead, let me know and I'll remove it from MFD.

Well, I2C makes more sense than MFD, so I'll pick it up right now.
ST-tree would have also been fine.


--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUwQXDAAoJEBQN5MwUoCm2y3UP/j8zJXGW5FvZ5veK9BUL2YGg
teOOqCY16yanQEdSsnGsjkPcgBnqBVULva6ByvxuQEIk/MVT7TIjy8wuYZen+FTK
rvaI7jUJGUXn/BgVYpDGFeXTPaLInZYVYxCDo/d3L5ozzwMhhNpm4fzLy8ONujpx
hwTCUw7CP0lCd/3OqqZkGlgceio7GdJhOQ1HIdyzMnvafAzaTAbyyGx7JOxMvPWI
Gv8vnNc+9Dpi3dZoq1mrrVArELOpuvu4OOpxuz3XGYoJ6NmqXoZC6tyBDcdvh+3L
6Uz1j86wSt4vC34kn0L7aMSovZYWtBelKidIiXvEvmbGLmJK2pYO7AJsGc1RY24V
fQTf/8oHupykp8rlWVc3CXYjNg12b/DnbS5m679ZzHcHAVrn6jSkeug21DpETDGi
gUN0L/AMl4qkSz1CvPmPqQOTbv3VVn3gV4i76panUjkFrDYGkDHgbGZCrkdBxLSL
xC2PuzaPQGS5AxIx33/viT5C+hYwUNLRKOy++hWPKD/mzkBKztvnkVI4xcKZGsjI
7n30eJdZt1C6gJ7oy7sFJPZUnLKZMLkOXDC/izziOkmoPj11CY5nwogI8ntlTzHl
NEE09ipyzwIaQwAIXWgIlav4RE1bM83QEsp00LjYKd/EnaPVI5Qtt3Ky0XSD+cIa
LEkXmF2wc3lUlUkJd8i5
=u/P0
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
