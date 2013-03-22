Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab3CVTFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:05:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43031 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab3CVTFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:05:16 -0400
Date: Sat, 23 Mar 2013 06:04:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org,
        linux-watchdog@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        swarren@wwwdotorg.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, rob.herring@calxeda.com,
        rob@landley.net, mturquette@linaro.org, linus.walleij@linaro.org,
        cooloney@gmail.com, rpurdie@rpsys.net, akpm@linux-foundation.org,
        sameo@linux.intel.com, wim@iguana.be, lgirdwood@gmail.com,
        gg@slimlogic.co.uk, j-keerthy@ti.com, ldewangan@nvidia.com,
        t-kristo@ti.com
Subject: Re: [PATCH v10 0/12] Palmas updates
Message-Id: <20130323060455.78a4c90c3f1e028434818fd1@canb.auug.org.au>
In-Reply-To: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__23_Mar_2013_06_04_55_+1100_7Olw5O_=bY6EnJIk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__23_Mar_2013_06_04_55_+1100_7Olw5O_=bY6EnJIk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ian,

On Fri, 22 Mar 2013 14:55:10 +0000 Ian Lartey <ian@slimlogic.co.uk> wrote:
>
> This patchset adds to the support for the Palmas series of PMIC chips.
>=20
> Some of the patches have previously been submitted individually.
> The DT bindings doc has been added first due to comments that it was miss=
ing.
>=20
> Patches based on linux-next-20130319

I can't really comment on the patch set except to say that you should not
base on linux-next, you should base on the tree to which you expect the
patch set to be applied.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__23_Mar_2013_06_04_55_+1100_7Olw5O_=bY6EnJIk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRTKtXAAoJEECxmPOUX5FE0UQP/0KeuAdMIeoUJESYzR52cQRt
aykiOFX+2bqP4WysLpghKuqJJKMPtVvVyIiCKtl6KimXgheucQGcAlmYcmHnwIo6
v3sg+B8wPWBNQOpA+wR8dsly10arpqdQQJ43dyTIpG+4zWD83sSaClKBhj9KuaIn
Ib8DzbwDOaO3PTyiz8AOWvI4GgqxBhzfzZ2y7heojGPOqvHKy3cMgQMync6vgx7C
1hTIbOq54KY7OsCBvkZoshGhqRD0DxYrDb3EJFt9ogpGQZx0pLIoUy9AqWgpgHN3
CXBsy0+QKRjNImOu6za3T1d/vH/SVoupRlvzWxaNeKm285/JnZ9JrCJBKq7uR66i
4ekE7kpVih0nrN7AGAOFIaSYVYJOroXzrbKBmFqhgTSch0xUTSkYqB6OgOrCbyzg
cZ3E6kFwEv8tkvFsUEmvFHUnShs9ig8vY4Ria0/UG/IooswCMzxzzyb4Oe1MBi6J
DEMcjZMUgPhvkwiIx0K4fZVUOg8ejg5Dsm85LPW8vCH9+IWxZkToOxt5dqGWOZNY
I/RsZa6KiCrPIDn/b0kzsCiW4R1eDgAYG9esZJtD24FjAxy4hz23bIhBGCnyQSGy
XCNKg7Y7dTldlE3b0NeymXKmCSqB1oVzhYvfsYwTkBEM9Ndn8Xcx3PLkUJuCz+04
flX7Y1oRx47xFh6o8Ajm
=vdaI
-----END PGP SIGNATURE-----

--Signature=_Sat__23_Mar_2013_06_04_55_+1100_7Olw5O_=bY6EnJIk--
