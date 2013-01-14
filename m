Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab3ANBuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 20:50:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62025 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab3ANBux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 20:50:53 -0500
X-AuditID: cbfee61b-b7f616d00000319b-c3-50f3647b7b57
Message-id: <1358128249.23942.6.camel@kjgkr>
Subject: Re: [PATCH 4/4] f2fs: add blk plugging support in f2fs
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Mon, 14 Jan 2013 10:50:49 +0900
In-reply-to: <1357969323-9396-1-git-send-email-linkinjeon@gmail.com>
References: <1357969323-9396-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-Ud5sqitMRq1M5gNnGBA5"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+ZgW51yucAg+5mc4s9e0+yWFzeNYfN
	gcnj8ya5AMYoLpuU1JzMstQifbsEroy2la8YC77wVHx5rN7AeIK7i5GDQ0LARGLufZ0uRk4g
	U0ziwr31bF2MXBxCAssYJSY0TmCGSJhIvDo9DSqxiFHi99X/zBDOa0aJzQ8Pg1XxCuhIHH54
	iBVkqrCAvcS6W1UgJpuAtsTm/QYgFUICihJv998FqxARUJOY8CwVZAqzwC5GiWNHl7CA1LAI
	qEp09t4Gq+EUcJFoaRGHaHWWuNF5ihHE5hcQlTjZ+gnMZhaokrg54SojxJlKErvbO9khjhGU
	+DH5HtRIAYlvkw+xQLwrK7HpANjxEgK32CX2nd/MAtErKXFwxQ2WCYzis5CMnYVkFERcU6J1
	+292CFtbYtnC18wQtq3EunXvoWpsJDZdXcAIYctLbH87h3kBI/sqRtHUguSC4qT0XCO94sTc
	4tK8dL3k/NxNjJBolN7BuKrB4hCjAAejEg/vpIjPAUKsiWXFlbmHGFWA5jzasPoCoxRLXn5e
	qpII73djoDRvSmJlVWpRfnxRaU5q8SHGZKBPJzJLiSbnAxNIXkm8obGxiZmJqYm5pam5KWnC
	SuK8jKeeBAgJpCeWpGanphakFsFsYeLglGpglJ6ffq7Ny+we/3b2O9+cmc4ytLnqekjd97rx
	9+DrNRd/vwi8+MLwXpRXo5dm0zcJ3SxXrhNtrYxVGaWq+xsvmPz/umIPl8VCUSH9y5NnSOX3
	7aszcO05oX+3Ss5m2ueYVfmuHAFx61b08cuXOb7dkPxF2WFp+byItp2T6iV1vA3Eua+vS3RQ
	YinOSDTUYi4qTgQAt1bVdBYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd3qlM8BBgfPGVjs2XuSxeLyrjls
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmtK18xVjwhafi
	y2P1BsYT3F2MnBwSAiYSr05PY4OwxSQu3FsPZHNxCAksYpT4ffU/M4TzmlFi88PDzCBVvAI6
	EocfHmLtYuTgEBawl1h3qwrEZBPQlti83wCkQkhAUeLt/rtgFSICahITnqWCTGEW2MUocezo
	EhaQGhYBVYnO3ttgNZwCLhItLeIQrc4SNzpPMYLY/AKiEidbP4HZzAJVEjcnXGWEOFNJYnd7
	JzvEMYISPybfY5nAKDgLSdksJCmIuKZE6/bf7BC2tsSyha+ZIWxbiXXr3kPV2EhsurqAEcKW
	l9j+dg7zAkb2VYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB0f5MegfjqgaLQ4wCHIxKPLyT
	Ij4HCLEmlhVX5h5iVAGa82jD6guMUix5+XmpSiK8342B0rwpiZVVqUX58UWlOanFhxiTgYEx
	kVlKNDkfmKDySuINjU3MjCyNzCyMTMzNSRNWEudlPPUkQEggPbEkNTs1tSC1CGYLEwenVAOj
	i+ls7jzpyZu3JGqs7Z5zTeWpOa8d87s3fBlL5n1MkGLx8rh57ufyYP1Hn2r5vp/I7r0lGjXf
	6ZT1H9tQf64Nr5S9XqU2zfo8R5erz+bTHD9Rr039hpmHXU2O3Dwxf2VwTN/j9skcS619DFUW
	aqVNFagPKDHp93D/3uKgGDUhbR2PMIeyU6kSS3FGoqEWc1FxIgA4G4+PRgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ud5sqitMRq1M5gNnGBA5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2013-01-12 (=ED=86=A0), 14:42 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> With f2fs having different writepages support for data, node and metapage=
s.
> It will not be covered under the generic blk plug support.

Could you show any improvement points with this patch?

Currently, there is no reason to use blk plugging, since f2fs itself
gathers bios and then submit one big bio.

Thanks,

--=20
Jaegeuk Kim
Samsung

--=-Ud5sqitMRq1M5gNnGBA5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQ82R5AAoJEEAUqH6CSFDS4+kP/2JLltGr603GSb/8cwJAZXos
Sf6voqbZ77kMBFEFFXxc3/48J3uOYI3OTdZcL8B0+MwytSbgJspeQ+BY4zH0gNzO
BDfuuvQs/CdC0H/xhE2tmm752Ij0on92ldzVF7tW24MktBqGas5IghcVhF7lsVxs
SKJ1V3j8k5H3is6evNyBc59sTvKuDay82p6Lp10AuEo2LxH71ZOfpmIZ/oNimCZa
pCGnG+enU8bIieNt8pqRVhqwLppP80Md6T9CLyRbfSFFCR3xE6C6vGmywA29atpz
Mbc1sSyfJJu1A5N0HvPXof2sjTvwTJhBc/MwSBc5yk6lRPWy/t11m3QLDWeRGHR0
9bRtVW52vkwp4lfhFIFLbPcrCY/5dXSr5kEis96NDeo8XqjFYGVWmI8DLt+snBds
NwzC6JMyuJJrcEIjEXyI/KHIq3xio+VTkcFzQ4DgEN+LtAWl7y1iXVufyo398peW
tvEAcTXJMFrcA0gRkFrRaPguvL+XVYSMdETuOY/0jJHJtAhv045oq+N4HEqqhhCz
a63H/Za0EfEOpMhS9w0UX/3eSX7AGq2ojN9r66Wk/ai/MQLqD5g+ZYGKZ7Be+q53
G+Cnw4P5LA2RNKGhUIYfZExtzo8Opj0RZPv4M2ccVdg5UwAgv7kf7Mj0L/vaw618
/RIqk5iEelUnEQVuXfwx
=tGDK
-----END PGP SIGNATURE-----

--=-Ud5sqitMRq1M5gNnGBA5--

