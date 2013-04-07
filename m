Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934394Ab3DGVRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 17:17:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45289 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762413Ab3DGVRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 17:17:15 -0400
Message-ID: <1365369424.2840.115.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket
 is NULL
From: Ben Hutchings <ben@decadent.org.uk>
To: David Miller <davem@davemloft.net>
Cc: svenjoac@gmx.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, dingtianhong@huawei.com, edumazet@google.com
Date: Sun, 07 Apr 2013 22:17:04 +0100
In-Reply-To: <20130405.004715.1638901359632228839.davem@davemloft.net>
References: <20130402221104.163133110@linuxfoundation.org>
	 <20130402221116.307254752@linuxfoundation.org>
	 <87vc833kpf.fsf@turtle.gmx.de>
	 <20130405.004715.1638901359632228839.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-yondcfY4OA+DThx2J8R/"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yondcfY4OA+DThx2J8R/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-04-05 at 00:47 -0400, David Miller wrote:
> From: Sven Joachim <svenjoac@gmx.de>
> Date: Wed, 03 Apr 2013 13:41:32 +0200
>=20
> > On 2013-04-03 00:11 +0200, Greg Kroah-Hartman wrote:
> >=20
> >> 3.8-stable review patch.  If anyone has any objections, please let me =
know.
> >=20
> > I'm seeing several complaints from udevd at boot in both 3.8.6-rc1 and
> > 3.9-rc5: "udevd[56]: sender uid=3D65534, message ignored".  Reverting t=
he
> > patch below on top of 3.8.6-rc1 fixes that.  I'm using udev version 175
> > here, and 65534 is the uid of user "nobody".
>=20
> Greg and Ben, please stop this patch from all of the -stable trees.
>=20
> I'm going to revert it and use Eric Biederman's fix instead.
>=20
> Thanks!

OK, dropped it.

Ben.

--=20
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your sig.

--=-yondcfY4OA+DThx2J8R/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUWHiUOe/yOyVhhEJAQpZOhAAkJx4Zo62noTx6v+oU8rqeb4IN2dYdPC9
jZan4CeRhXleMiBetUHz9fzd0RCWOMhcckjMclqy+ZulRO0s4ZwNZXesKtCipB1g
7p28HUjv4t0MktWfk4aJw1RnU9KlxP7+xb5KmGdhl9+bwR+UxmceH3t52noKFuWq
fU3JhKB1IAazF5kyLRfjTLdqxVt07F9Dhpv585nNUPzfPloSSwtedhEyyiKTzj/o
KVQpxI2S4zv3+8gNdJ3FzTkrtTDP7tPiaSGModyWFjny0lw1/oWXXizUJwGZ4ik5
Ut8WCk2LKg9dYG0RJZUDw536qHZwIo4PbV+Rtkmp5VybVTzyKhB3UeEmfQUNyzJp
+FNpra1MLtMMqCTs9T1EqNJn/Ek8OzMfj0Yzy0xG+sJ/+oLH/P5JTzOvy2p/fCHW
R6eOcLtjtbFtJ8op1cZApB6515Wu5b9bKy1Mf/vEOgUPsczRjBmsmKOh0XYTLOSJ
y+dMzxnkTSq0F9NOCaSX1nco/MO5SbJBI4m8434hD9/oS9T1SgfDNCKAG6ODLQA6
aGwXOLWnMWzBlCsndSGwKndzY0rgrLzbppVaC7gitt0TScK6hj/oTL9hyuezVAHE
ROt1hyxwQady2602PAvLl3qJTzJo25kA+7VkSnVdEhTqc8yFOyxCThMBvBVa+kzW
ntY+NR3RUX0=
=XsHf
-----END PGP SIGNATURE-----

--=-yondcfY4OA+DThx2J8R/--
