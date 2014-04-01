Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbaDAJz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:55:27 -0400
Received: from sauhun.de ([89.238.76.85]:38641 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaDAJz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:55:26 -0400
Date: Tue, 1 Apr 2014 11:55:22 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        kbuild-all@01.org, daniel.lezcano@linaro.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH] avr32: remove cpu_data macro to fix compiles
Message-ID: <20140401095521.GA3326@katana>
References: <53060d5d.XcmAdOiLt1MCo6Y5%fengguang.wu@intel.com>
 <1393057709-17925-1-git-send-email-wsa@the-dreams.de>
 <20140224072820.GA9069@samfundet.no>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20140224072820.GA9069@samfundet.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2014 at 08:28:20AM +0100, Hans-Christian Egtvedt wrote:
> Around Sat 22 Feb 2014 09:28:27 +0100 or thereabout, Wolfram Sang wrote:
> > Having cpu_data as a parameterless macro can easily cause build failures
> > because it can be a variable name like in linux/pm_domain.h [1]. So,
> > remove the macro and convert its only user. Because this architecture
> > cannot do SMP, remove the whole SMP block, too. Only compile tested due
> > to no hardware.
>=20
> Looks sane, AVR32 doesn't support SMP, so this change should be fine.
>=20
> > Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> >=20
>=20
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
>=20
> > [1] https://lists.01.org/pipermail/kbuild-all/2014-February/003252.html
> >
>=20
> clockevents/3.15 branch, mens what you have queued up for 3.15?
>=20
> I can queue this in my linux-next, and send Linus an early pull request t=
he
> moment 3.14 is released.

Have you done this already? I can't find it, yet I see the pull request
for the clocks is already out.


--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTOo0JAAoJEBQN5MwUoCm2b4wP/ismeZ66ZObhabBDXqgEYRh1
nyj/4xQ0HTcvwnZDMRjGyYe67Z0VlWf5f3tbBd+7qJpGrJskPXGTwnY/8JLiaOXG
ZD937jGkd3M7ingW3vM/Wrjt7bwKCbeM1bKp7T1lPr+aqSKLMj/PEVVdlPCxrK4/
wjzVx7n4cv5ba+miOufbSK+/1z4OIew/r05Id6ZfGQhgGtW4qcyHYysFAiXauKUX
Y0J87f6rcBElp0W2zENqLTQC5pNTaHZxSuxPcSFXDayxhTdakqGxJ0Yoa9aVlY0c
Aq1MyDya7FqbPF1vg6jP2w12AkuYLfZfamjGV38rAV9pR62YggKg3QMGksVtu6rB
F3jSg2xV2Ccvfb/c9rRE0aa+qK1XVtTPWuRJyUD68Qf2tPsG+hQrsJhgdrTy5oEN
rIkFYAX6wn6GFptNuz+fXGOTu2ccEkge9ubLSL5BCqNqFMkbN4vsm1nPxW5t3Ruv
JiLdE3YeGo7bPOexnS7HKI3jKlqWD5FFcgnNfnDftICBQxU7km2TkYIFAqrxlQYz
UnF/PoJWNbHd85SkqoU0gKQRdOLl+g2yiVY+COUkPwLVNCoMGsJrttiKD9iQropG
p+l2ArA0AJKd/gAQIKKELICaAx+ZY0uT7sfCD4MoI8LAZsil1BSBQmw6/2/iwdeD
o5+FvD+4nv8PmNc4hsAK
=KeKQ
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
