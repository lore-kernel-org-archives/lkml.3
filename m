Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602AbaDJFu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 01:50:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42630 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461AbaDJFuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 01:50:54 -0400
Message-ID: <5346312E.30305@ti.com>
Date: Thu, 10 Apr 2014 08:50:38 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [GIT PULL] fbdev reorder for 3.15
References: <5345258C.1070308@ti.com> <CA+55aFytXaTBE6Uf2H=C-XX01Pk1-QArF6u7+yhditk-cJLVQw@mail.gmail.com>
In-Reply-To: <CA+55aFytXaTBE6Uf2H=C-XX01Pk1-QArF6u7+yhditk-cJLVQw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="BKwiaivupBcWHT0wksX953OdGSthO4sTF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--BKwiaivupBcWHT0wksX953OdGSthO4sTF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/04/14 22:23, Linus Torvalds wrote:

> Are there other things pending in this area? Because if there are, I
> think I'll take you up on your "or we can rebase on top of -rc1" offer
> instead.

Nothing from me, and as Stephen said, linux-next doesn't contain
anything either. So I think we're pretty safe here, but maybe you can
wait until you're ready to tag the -rc1, and merge this only then. If
something conflicting has popped up, I can then do a rebase on top of
-rc1 instead.

 Tomi



--BKwiaivupBcWHT0wksX953OdGSthO4sTF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRjExAAoJEPo9qoy8lh71B4AP/i8wl35Ph82u5EATWZa7aXsF
L5NYkL9tCxNspLXELSOPh5h7xzas1VQ1LYGEa43ih+s5rQ1f/zNA1BkIvrU65Hww
yIrR6XvQKfOQpN9D7Oy/42Bkkd5olA+8Bg3ZzdBAlfS2iGd++ebOgBEA+J6dHD3l
ucMLfnsxuO4gexzPvTVZjtI1JwWce94rd7utvqOatYzDp0hyvKFRiGhVJwkyXZ6P
M0msz1QuyI4kMs5rH3ZYy1vI8HAIdjXs0htSKKP3k8kSpr7WKNvHnVXwSSdGA/zR
0dE/N58LBgHA86eXYq9w9jrWHx7PbPQgIaKHkbo97fkiUPSUcK/791VfRsMuGXaw
AzF1KLKZiJhxNslW418HiV+3Rwym7nfShN9qfy3Uqe7bHaND1p8hWTcSzghrCIGE
BgzdlcDBHBn7PLD8AxLvOjhD3gt6wqIiQCDOOP9sKry9SqvjJElWow2DGCWyCCgO
5avCcSFs8ePCXOqzJCR0TZMPWTrzVqBItqZ6/Fmx2u/BqJF2NlFlsowvOUXub0FK
ddVdfvrgaTYQb778QQ7g9TW1QqejVPM6wuKLQ8lePhbb/SSa8E9dbl0pLTeEh7rK
x5wfhMiRkoFy4kzRsiAc9DPuoPv/yKqqfv8ySZUKOwHyGE5e9h9CB1myyoNiUpFv
+DYGvFeW3fcg5SAOenRC
=houD
-----END PGP SIGNATURE-----

--BKwiaivupBcWHT0wksX953OdGSthO4sTF--
