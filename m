Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaHKQPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 12:15:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55705 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbaHKQPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:15:52 -0400
Date: Mon, 11 Aug 2014 11:15:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: Richard Leitner <richard.leitner@skidata.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] usb: gadget: serial: remove PREFIX macro
Message-ID: <20140811161511.GH20177@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140718113946.0e70c0cb@lxbuild.skidata.net>
 <20140811150435.6235fbf6@lxbuild.skidata.net>
 <20140811135033.GD20177@saruman.home>
 <20140811165238.1957ec69@lxbuild.skidata.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82evfD9Ogz2JrdWZ"
Content-Disposition: inline
In-Reply-To: <20140811165238.1957ec69@lxbuild.skidata.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--82evfD9Ogz2JrdWZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 11, 2014 at 04:52:38PM +0200, Richard Leitner wrote:
> On Mon, 11 Aug 2014 08:50:34 -0500
> Felipe Balbi <balbi@ti.com> wrote:
>=20
> > On Mon, Aug 11, 2014 at 03:04:35PM +0200, Richard Leitner wrote:
> > > Hi,
> > > this patch was lying around for some time...
> > > are there any comments or objections on this?
> >=20
> > you realise we're still in the middle of the merge window, right ?
> >=20
>=20
> yeah I know, but I didn't knew that I shouldn't ask for the status of
> my patches during merge windows...

well, usually during merge windows most maintainers take a "break", if
you will. For many, it's the only time we have to sit back and enjoy the
show.

> Sorry for that, this was one of my first patches submitted, so I hope
> you'll be clement with beginners like me ;-)

hehe, no problem.

> I'll come back to you when the merge window is closed.

sure thing. Once v3.17-rc1 is tagged, I'll start queueing patches. Once
they are in my final branches (fixes or next) you'll get an automated
email. Until then you can, if you wish, poll my testing branches
(testing/fixes and testing/next) to check the status of your patches.

cheers

--=20
balbi

--82evfD9Ogz2JrdWZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT6OwPAAoJEIaOsuA1yqREB+AP/Rva97SWdLZUiBIdWxqcPZBb
2KvbYprIuwJTuH/vpkaqPzxMpIi3fG5b6qlsYL+SOzCAFA7QXw1jXDOMPq6IT5j/
3rH4B5C/uVpfhMsO0bbJ4/xiPGzxC03zN89RKGhlJAx9GhQ89OWbHE9hXCvljKbj
w98jlV6MpjPkVb2+CgQlfTACpwJ+LpHW0BaHhj4NjfqhTw0tTUZlHiLJi0RBb2hb
ZWZl4XZigO0cbR5i4ITuQfBt849TV9llXC7jN9lktJd4M6n8PtP3j2bgE33NRnWW
XkA6/1mNEmJJ5gFIitxZJLug8qKILrtWppDwK8t8DRM3FqhoJYA90k/0acANQi43
6iOpzotS9p9K8M3ZfFmg62WaIWpFyInACn8cTIS8gijTcfDKoacDwA9tEHNq4qwY
ahqp7/YDROpnP2eGfMQAFzKHhKDm5tey5RFL3fKmaCgTCtiHQnkhoEAmr7OqBI6I
rDwm0tYR5bt2icnaE1p3/jIrgpeQKAN2un+VsoKQ/fp/+pknVlLYB2hirJhcX6WE
6kNSuznaHFpy3g4bWjsIL9kSst4AWTqqHD6bzaI3Czo0zQ8g83TjqCABJVvUaN0A
uAuDztKPVltchWd7DmY5Vj6O5obzFj5MVbHK5LWfKqNq5wvYZCEPRTvCmbcoMW2y
F2E0oU+iX1c/eZOQQAck
=w2nH
-----END PGP SIGNATURE-----

--82evfD9Ogz2JrdWZ--
