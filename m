Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbaIKOxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:53:03 -0400
Received: from mout.gmx.net ([212.227.17.21]:49740 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbaIKOw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:52:58 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean Delvare <jdelvare@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Andrey Danin <danindrey@mail.ru>, devicetree@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC 4/4] ARM: shmobile: r8a7790: adapt DTS for I2C slave support
Date: Thu, 11 Sep 2014 16:52:22 +0200
Message-ID: <1591383.Xdy91rktuP@fb07-iapwap2>
User-Agent: KMail/4.13.3 (Linux/3.16.1-46.g90bc0f1-desktop; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140911144003.GD5149@katana>
References: <1410274470-12712-1-git-send-email-wsa@the-dreams.de> <20140911141257.GC5149@katana> <20140911144003.GD5149@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6151357.4VKUoaRBI6"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:nT/2KIkPyvx0PHdDuUWYkcYQeLGWVIfM+VNyNGF7NMqcH9CYU9h
 Hp/QjRCH5f3bEERbkWkXbC/NjSaxBqIYhh2yRez6jG/CVg8+0iDgHh156X6V+1qxYb4Sfro
 Jry5leWMZ/fGKk5lDGfU2/H7A5VTYgTUXo9dtWGhnrNcxuIYRTEkVzwSJ1UmbyCCDahtKh/
 0EToN78KY+T3vJKaCqWzg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart6151357.4VKUoaRBI6
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Am Donnerstag, 11. September 2014, 16:40:04 schrieb Wolfram Sang:
> > b) could be seen as a configuration thing since the functionality
> > backend could be changed at runtime even.
> 
> Come to think of it, not only the functionality, also the address can be
> changed at runtime. This makes me think it should really not be in DT
> after all.

even worse, there can be multiple masters and slaves changing their role on 
the fly AFAIK. So the best dt can do is to provide an initial configuration, 
so all drivers know where they are and where to start. Everything else can be 
changed during runtime.

> People will probably find out that it is possible to put it in DT, but
> it should not be encouraged and they should do it on their own risk.

--nextPart6151357.4VKUoaRBI6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAABAgAGBQJUEbcmAAoJEKyeR39HFBtoUJAH/2VkYCMJ+aDlPXoWbktY2AHP
xHbstyCIzfj7kdVl8G4BRmuAbkSzoSGtm/apwz6zQOv0YjwaxUw32gaO6/E3srVT
qEzCTqg7gyvvhenOQY2OWXJvM9inwBPQzuB8DRVtRTbO8kJtyk7YCBhaKURc6xyf
pqyhLjuJrwRuAxxF1hd3fur3uvtop11LFNbv5hxybGWyRRosO38h0vaHfLpKSqSD
RjqV7NfjxoQ8sk25IAghwRquO+YeaItJ1fWcmcaOLGj/ID27X54SHq2vYGVkqMN2
n9+CZ6n795dxd1tj1WQnIVl3CCd/0xcS5QAfmMgVKQ7sgfJB6AX/ElX6BxJf3u0=
=3/oV
-----END PGP SIGNATURE-----

--nextPart6151357.4VKUoaRBI6--

