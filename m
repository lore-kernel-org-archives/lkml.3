Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3FJKvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:51:19 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:59354 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab3FJKvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:51:18 -0400
Date: Mon, 10 Jun 2013 12:51:14 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pwm: devm: alloc correct pointer size
Message-ID: <20130610105114.GA2572@manwe>
References: <1370291306-3276-1-git-send-email-wsa@the-dreams.de>
 <CAHp75Vcvhz892D4gytneptB4wLWPjfKmf5OXgnChXw338nLBAA@mail.gmail.com>
 <20130610000446.GA2928@katana>
 <CAHp75Vfb7Evhf6yMNd4nzcL9TM5Svu6Z1_MPPAWkmBjhgeDJ8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <CAHp75Vfb7Evhf6yMNd4nzcL9TM5Svu6Z1_MPPAWkmBjhgeDJ8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2013 at 09:41:52AM +0300, Andy Shevchenko wrote:
> On Mon, Jun 10, 2013 at 3:04 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> > On Thu, Jun 06, 2013 at 10:43:41PM +0300, Andy Shevchenko wrote:
> >> On Mon, Jun 3, 2013 at 11:27 PM, Wolfram Sang <wsa@the-dreams.de> wrot=
e:
> >> > The allocated object should be the size of what the pointer is point=
ing
> >> > to and not the size of the pointer itself.
> >>
> >> All devm_* functions in this module use **ptr as a parameter (except
> >> allocation).
> >> May be we first should understand why it so?
> >
> > Huh? **ptr is already created on the stack, but assigned the alloced
> > memory. Later, the mem it points to is set to 'pwm' which is then added
> > to devres. So, the alloced memory must be able to contain '*ptr' (or
> > *pwm which would be more readable IMO, but other subsystems also stick
> > to *ptr), no?
>=20
> Yes, you right.
> Take my Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

Applied, thanks.

Thierry

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRta+iAAoJEN0jrNd/PrOhnVwQAKlWnlkzKSN0iIal4qnTXcOc
zYJHA6b6Scwiox9aNrFpH0I8nO5iYfmfc5ycL3hEX3vxvqfXUVv7MKNm5ReFj3Ek
4GHWaLKYRBUAo9F+lv0KXiH7XA7w03t5CBLSkNc4vXfrSVF0i2+AgAbsnXbL5Z1P
W9ngVQLuzf5m+sh+ILfQdW/bptrCl8+lWx6Ac3D2VNhA7VXrhFnzdAJ/UJgS39rq
DlYIT/XdpYinSA6ubPC4X1Mz6md1c1CmtAHBzGf/uAaBfKBO+Dye1H25ITWMuQsn
a1O3QGygB2Z3U47q1ZEig5nxTEVvdXHEv0WZEyA2GWwZq2lPHC5xOvSWvXaIRdPn
X4lEk4LcQ8LpEzehBAsDAs5cI+JnkBCGWtJTLRtNqZ4N3Omg4XiIITtWC5eNQ+Ws
ZF/z0bgPvllYfmE7QBwdXm+M0GaH0XW9hktME6EF8eKmEtmKVL99QWag9IWUF5o7
MifF0lvjzuVKwgp8XuNnhhOZT7mjl5SufxYStL5/JZKLMgwoWHnxO6JgpIMNcvmq
H8yegFZab5bv8ogKyrLVBbC/hA93LZXYtAMqDQjRyCF527XZ/Gc6e7g7glnwxSQh
qdjfvVKPDMrLNu8IjKa+ekGDq0zjVqULHIOLGFodrYDB1Am0yz7J4B1ukY/2aJB0
ZiOFv8F3H68C5zk4YTx7
=EaWI
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
