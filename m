Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab3BSOUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:20:52 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36059 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932914Ab3BSOUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:20:49 -0500
Date: Tue, 19 Feb 2013 16:19:39 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hannes Reinecke <hare@suse.de>, Borislav Petkov <bp@alien8.de>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, Doug Thompson <dougthompson@xmission.com>,
        <linux-edac@vger.kernel.org>, <rjw@sisk.pl>,
        <linux-pm@vger.kernel.org>
Subject: Re: SYSFS "errors"
Message-ID: <20130219141939.GD4390@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130219091610.2b746a30@redhat.com>
 <20130219123502.GD26623@pd.tnic>
 <20130219094640.2abf1a66@redhat.com>
 <20130219130626.GE26623@pd.tnic>
 <20130219131500.GW23197@arwen.pp.htv.fi>
 <20130219132853.GG26623@pd.tnic>
 <20130219133809.GA4390@arwen.pp.htv.fi>
 <20130219135056.GH26623@pd.tnic>
 <512384EF.9020602@suse.de>
 <20130219111440.2b4b2e95@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IMjqdzrDRly81ofr"
Content-Disposition: inline
In-Reply-To: <20130219111440.2b4b2e95@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IMjqdzrDRly81ofr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Feb 19, 2013 at 11:14:40AM -0300, Mauro Carvalho Chehab wrote:
> > Please consider adding a default attribute which return '-EINVAL' or=20
> > somesuch when the function pointers are not set.
> > But _not_ adding it via device_create_file(). That's evil.
>=20
> This thread started with Felipe's complain about it returning -ENOSYS ;)
> when this feature is not supported.

I was complaining about a file with read permission not being really
readable which is a fair bug IMHO.

--=20
balbi

--IMjqdzrDRly81ofr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRI4n7AAoJEIaOsuA1yqREaL4P/17Cs0UKjEbT9u0PKToOQjRQ
AIIRWs4MlccRV+7K//Ajlp/hGbWPIGSVygqQps9KyOsqKr0XjBBh//XCT/rcqcai
RMGfVbHkni8cCfICYywMQGVFK+exidQvcT3vI7heoOCGtcZsXYKmjhNcsuNgfYU5
9TNAIE3Aq8c0JqStAKeuGX9i/O+nm2HiDZMUOC49cQ7McbBZs0UOtWD5R9+aIdzY
Kcz2ivgfIQ+SYkb9Q9UDxkxuAvT2i+hzORBQMmcCXZFAJBuKXklmaJnrjVqS0ZZF
aGFClx3O2n0z4r/UxJM3XdW0BAWPJ/7SBkQJj2Xw4XAhHV6CJl4v+7pVafVXphnv
7qZs70f6u4Wf6xmzCEomlHg92IhsWaCoOfJnIhkIEM4bj9zvmdQFwkTR+hV+YvlV
3pNYer6sq7MXXJyav7nUjOWXQW62nge/ULzYqAidLucoBe3fOwJ7iZ5HH7Mqqicp
Jz/4sQlpgbTLiaFoHGAYpX02s7OELakk4trVWVYXlYP+uu5kRYID/IfcvFL+ZAf5
ST631Ko210qCi49cVn86MJFGwe7RW+kCb/roQIEs6EMvvMsGFaOF4wCAJm0zpXoA
qYfjB1wIgGlsDdQ+A4WyVV04qNn173XQMLqH2+s5rlBSBd9KTnJZ8ipN9WgTcoCy
hS7IGiyiSJMFZBKnB4y/
=ranP
-----END PGP SIGNATURE-----

--IMjqdzrDRly81ofr--
