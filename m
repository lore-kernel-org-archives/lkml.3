Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbbAYSZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:25:17 -0500
Received: from down.free-electrons.com ([37.187.137.238]:59184 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756079AbbAYSZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:25:14 -0500
Date: Sun, 25 Jan 2015 19:23:12 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] power/reset: Remove sun6i reboot driver
Message-ID: <20150125182312.GO8470@lukather>
References: <1422209622-31994-1-git-send-email-linux@roeck-us.net>
 <1422209622-31994-3-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mvuFargmsA+C2jC8"
Content-Disposition: inline
In-Reply-To: <1422209622-31994-3-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mvuFargmsA+C2jC8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 25, 2015 at 10:13:39AM -0800, Guenter Roeck wrote:
> sun6i restart is now handled by its watchdog driver directly,
> so this driver is no longer needed.
>=20
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--mvuFargmsA+C2jC8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxTSQAAoJEBx+YmzsjxAgulMP/AomM9n0VJvYPsrwfrQ1g7sg
pO7WE/lZB484IIrjrYYdLghx+GLGjRfuTjYngz2JU+T3sSJ103fWK0svWqO8ofvY
CwBvwuYnbiGkL+eFB3c9alQ5V1segKu3TpCvflzpSRU3VUwQbnftdZZMAuTCV+mM
T+BqPz0WjJMsIW1oDLu/IO6HbBC80oP14PZtPVv4DIvqfMFb1+gdtW/f9mOInyz4
KBUwA6Q1RSICg7bHXNLLE3OnWAY9fSPzQbG+YXKxqwDNhaf7L2WEjuc3IFF8tTHb
Ex9zUT4SIZHeY30RE4w7smS3lrjEs3+nzg/gosSOhqUI/pdo/vP6NMGseHC11LkB
xIyVFWvGf6aJt5ngCfXw8VOok6yBwpeX3rs+GBM/aCWj8bjHZV27Ht+WdjAUT6ay
9CND1UA2HB2WCu5aRGy/tn6fUUfzpfir5WU2E9HY+gk1b0560CrOJK+Ur2BkZKVa
Pj2zzs4a3m7Kj8xKqZrzGZuXaltv3vXl5tIbzw09IvZcmptAY+zY9hSbUlqWzdSb
P/RysN6FkG0S90tvIm5FKSHJ/ckISiRM77Ub9idJZ2IlqcYwW4l8tSA+EJcO4XMn
LjjHt5lghrnczeWWtnhl6z2JC9u6k0MNr1end5UIZfR5BJ2LfBxsxFw0VtseRd1X
9ZSEJQaMnddwLMNsoCSQ
=qmpU
-----END PGP SIGNATURE-----

--mvuFargmsA+C2jC8--
