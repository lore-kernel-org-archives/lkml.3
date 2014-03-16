Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbaCPVWG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 17:22:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46794 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932079AbaCPVWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 17:22:03 -0400
Message-ID: <1395004897.15764.119.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [RESEND v2 PATCH 0/2] Bug fix in aio ring page migration
From: Ben Hutchings <ben@decadent.org.uk>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        viro@zeniv.linux.org.uk, bcrl@kvack.org, jmoyer@redhat.com,
        kosaki.motohiro@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        miaox@cn.fujitsu.com, tangchen <tangchen@cn.fujitsu.com>
Date: Sun, 16 Mar 2014 21:21:37 +0000
In-Reply-To: <53217E46.3060100@cn.fujitsu.com>
References: <1394439334-28523-1-git-send-email-tangchen@cn.fujitsu.com>
	 <53217E46.3060100@cn.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-uxM/xPLsEYMwZhm7us0K"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:2147:ecc:c25a:bcb5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uxM/xPLsEYMwZhm7us0K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-03-13 at 17:45 +0800, Gu Zheng wrote:
> This patchset has been applied to linux-next, and these problems also exi=
st
> in 3.12.y and 3.13.y stable tree.
> So please merge this patchset to 3.12.y and 3.13.y stable tree.

They must be in Linus's tree before they are acceptable for stable.

Ben.

> commit 692c9b8c5ee8d263bb8348171f0bebd3d84eb2c1
> Author: Tang Chen <tangchen@cn.fujitsu.com>
> Date:   Mon Mar 10 16:15:33 2014 +0800
>=20
>     aio, memory-hotplug: Fix confliction when migrating and accessing rin=
g pages.
>=20
> commit e0f5e0add36d2e3c456cf2f4283673ed834b3c24
> Author: Tang Chen <tangchen@cn.fujitsu.com>
> Date:   Mon Mar 10 16:15:34 2014 +0800
>=20
>     aio, mem-hotplug: Add memory barrier to aio ring page migration.
[...]

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-uxM/xPLsEYMwZhm7us0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUyYV4ee/yOyVhhEJAQqUNhAAsEUWT91QFyShrH10io3NWmaA8xmq+0Nu
/3+SbzrBGhIlovUKhQV+rM1oRNu4kOGuubCB9+TmNko2dR22tyH/AOOdtPgagRso
kHpuUWn5D/oKVKo1AiGjI6wVKoDMn6IC4q8Xtcy4RVsl97tp2+6A5hIcOAgU1Gng
x4NAUPwX7FgA0PsPOoXNMXXF2n2m4MKu6Nzit3ZM/Q/VAWMCcT2TxsPKBnB4LqAw
qqzEOGP5gUeeDpdfPztgUXkQ+bD3TSvWxUzg3crPbvvzq62lBDHMhFmi+hFYwmZm
Q9u291+qrEmabAo3IbD3O+7roeYqVhQTMbpQLxMGUZLvh8eFmBOcDqbt9/nj1IOc
uDyABzw5QEI8okwJJO0vGXqBINKnuTDB2+SeVu55RyoqbRnaxP3sEm9aT+Oa23G0
Z5kT/0c025nlKi98znlfTfj7y2/WW6qI0brGZMf+q5Go7RE/0OdvejGgd90uAQVJ
w+z8JJjHzJgMy3mt+qcJGbJ8wt1lIhg01ADkjZJ3B5Xcc5HaC5ZOvXXLEx1xuhxi
Kv68ej64lJkGcPBEJuVdAR1dRxD1TIgzKNmq7PAyW7RssferZGrM69R6be/57eXe
MDaY5a02rRwExLRViYNrOM0RiginCY+YokYETj8mSyHKXSuadyN5beBTCeCbQhCQ
F4P/wrLC+vw=
=7O0r
-----END PGP SIGNATURE-----

--=-uxM/xPLsEYMwZhm7us0K--
