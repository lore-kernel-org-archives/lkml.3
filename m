Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758899AbaEMHxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:53:53 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:37698 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaEMHxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:53:52 -0400
Date: Tue, 13 May 2014 09:51:50 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] drm/panel: add simple-panel description using DT
Message-ID: <20140513075148.GF6754@ulmo>
References: <1399645002-18000-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b8GWCKCLzrXbuNet"
Content-Disposition: inline
In-Reply-To: <1399645002-18000-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b8GWCKCLzrXbuNet
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 04:16:40PM +0200, Boris BREZILLON wrote:
> Hello Thierry,
>=20
> I noticed you're describing each new panel with a new entry in the
> of_platform_match table and a new compatible string.
> I guess you have a good reason to do it this way, because retrieving
> panel description from DT would be pretty easy (see this series ;-)).
>=20
> Could tell me why you chose this approach ?

The reason is that devicetree mandates that a device be identified using
a compatible value and that compatible value should be as specific as
possible. That compatible value should give the device driver enough
information to know everything it needs (resolution, timings, physical
dimension).

Having all of that data in the device tree is redundant.

Thierry

--b8GWCKCLzrXbuNet
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTcc8UAAoJEN0jrNd/PrOhiZMQAIoGWc2IIgvBGMoZpjoIDsyv
NOlEVgH6+ytY1HUJAffHcqhMGit44xD2xoxE09i/DQYmemJOXFUNDJhk9KBT8VpM
9FrB3u0HNi5HeZZ55G/ZunS7dO3A00rzjsNZY0OD5dUPncVkmmE5VKpxncwTZH27
57RjL7x6XtYf/EiGLdaOZdkdEUGyKLvPUPJBY3+/TREcbr0MmeMx0nkaXUOYGicU
0uJNso/v0cuZAXRfMXMMusBuZEUmh5Xu83DnHg/qr3sK0GuDwn7qMIzE1ouHee89
ZTVikewTA+TEpzkguhPjjyXuFhFHs+Vx4hD1idQ/baeIXXsmVs3yYVyiENU9gxyB
usCkVNXyhBLsxKPhLcZlSU+VE518Jxx4K5ObVz+ZZAQyepVKVMzFHf0e70f6iUas
0ulWXRJNhCBg1Ud/VAcnjk1zY4HyEmCmVmdNAAlkSmRoVlZrZHP6w7R0KuI8uFuz
dbj7liOtbjzxvJwOriJHJZ60ZkLEUdpwNOsHuqmLNAdjHb+3QUhCGp2gZwlB8xOS
rkP2J2MaxVHAY/uvuPEvkM0rgBMbUdxuVsEwKWw9ThtOlMoYIB0npTretwsq0GOX
7575RB2t+1t50zLjH2pekFKVbqTW5PL5G03cJO0ZrEs+A/HTWaMOvE1/vgynPFOm
y7qncQqVc3bUokSqA/l/
=ggt9
-----END PGP SIGNATURE-----

--b8GWCKCLzrXbuNet--
