Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3KHMg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 07:36:28 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:50292 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3KHMg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 07:36:26 -0500
Date: Fri, 8 Nov 2013 13:36:20 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/12] pwm-backlight: Add GPIO and power supply support
Message-ID: <20131108123619.GC31551@ulmo.nvidia.com>
References: <1381145866-445-1-git-send-email-treding@nvidia.com>
 <CAH9NwWfDRiQ3FegMyx1YBQ5jUgPvc7h2cxd3KgyeDdnsq6UgMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Ek0hoCL9XbhcSqy"
Content-Disposition: inline
In-Reply-To: <CAH9NwWfDRiQ3FegMyx1YBQ5jUgPvc7h2cxd3KgyeDdnsq6UgMw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 07, 2013 at 01:00:04PM +0100, Christian Gmeiner wrote:
> Hi Thierry
>=20
>=20
> This series adds the ability to specify a GPIO and a power supply to
> > enable a backlight.
> >
>=20
> Whats the state of this patch set? I am looking for this kind of
> functionality for a pwm based
> backlight on a devicetree only imx6 device.

Those patches (except the one that adds the backlight-boot-off property)
will be part of my pull request for 3.13.

Thierry

--9Ek0hoCL9XbhcSqy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSfNrDAAoJEN0jrNd/PrOhH1UQAL7jttcTfVnZ9RxshEnCGtCw
D1jrRKm8Tw/Hq95+SB6z+Oc/fk8yZN+RNyjYIqiARW9yjqD8xJfMtAuJcEVoa0wQ
vOb2zcRmHRKeBH7257M6iGns6e26LcrZbyHmlnbFWVBmjfTuOdXjLu2A9BXCQAwO
pO3Q7N5oRC4uEAU+5CCnFOZvPHjczGjctbKLkr2U6jzbGQNhT7gGBIKZyL2z6aq/
Sy6ybFU0dqXAqjUNMxMmBGP8CtS5k1tc7VEpHvXNlWW+GLW8EISSN881ibBwNXPG
Ll4uEhxBvdPXz6XowkYQNh1xFwlqGYR9BWhlag1Cn2k5zYMbplfBTONda3zw1EIn
Fouj+DRCuqcBLyY2F7frypIms6f1K2z8425SOxJEbDpiCgIE0qDqwB/kFx2mfW9+
noz9hJiMUWj/MofXdjvzaU0N+8Yp0SZwnltYTX87E8vQOYIhXrHMafx0NuCDI41M
EzUIhyaY0DkcnAJTeydf2225VwlrQTrE+Rt7znYQyjTtvsMg+ErnNWCrz+6hhqVJ
N+w56L7W5dV/Ak1ws43tLLY5bz1rrqA+mf63JE4n8FzqE5GSTTTsbUq1v1qFKhXW
MeJbYPc7PgcOfE+btJ+dQIZxyuqM12X0HhHzEepx6L4ARZi6KlGlC99uVlLr3bcG
SrB7eBmJswyzLW3/BaXw
=NWQy
-----END PGP SIGNATURE-----

--9Ek0hoCL9XbhcSqy--
