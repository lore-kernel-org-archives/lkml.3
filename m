Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaHEXLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:11:18 -0400
Received: from ozlabs.org ([103.22.144.67]:60506 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaHEXLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:11:17 -0400
Date: Wed, 6 Aug 2014 09:11:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim.vansebroeck@linux-watchdog.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        George Cherian <george.cherian@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sangjung Woo <sangjung.woo@samsung.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: Re: [GIT PULL REQUEST] watchdog - v3.17-rc1 merge window
Message-ID: <20140806091107.447325c4@canb.auug.org.au>
In-Reply-To: <20140805205547.GK11710@spo001.leaseweb.com>
References: <20140805205547.GK11710@spo001.leaseweb.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/CJF5ebCdSeZjjl6Imell0j_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CJF5ebCdSeZjjl6Imell0j_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Aug 2014 22:55:47 +0200 Wim Van Sebroeck <wim.vansebroeck@linux-w=
atchdog.org> wrote:
>
> Please pull from 'master' branch of
> 	git://www.linux-watchdog.org/linux-watchdog.git

This has been rebased onto v3.16, but none of the patches changed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/CJF5ebCdSeZjjl6Imell0j_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4WSSAAoJEMDTa8Ir7ZwVhjwP/jB25S8mYKdGKVzPKaOyGUAv
M+1cqiUtMogiJhOC2IGZYILrVByNkxsPvFVJdShgdk1HKCYiAcjzrUNv+EswKTZ6
E2+Zw/aVI7psfxbwqMw/LGEnKGrh80Ald/qbM+iaKeRxeFlwCuV6emJk6HfW0wYE
8I9LCUymhjwrthrr8/QmSmYoDKUdOplYSD1c3J78O6MTHl2NKpMsGVyPYopPr5WE
ZJRx6P1o1bds41c9LSZZtG7CmsGRpzC+BUfYkL6jKI4f1M00PAtGgk2vvz809VBo
EIORQbz5cYGrVQPT5zt7tArdaCcaFiFzgmJRhEZ8oe/qdOZ4uGSrNICjsEPWP0Og
MoWopTPxbPNnXeF2vYbjMZkqNB2fnN55DWTHc90v/sUHjmJCfbZjPtVmYuh3Mcsa
WIP2ki72QusFgJXmZZ46fjW+20bRJxlRQuSN4tlDYRAuILQTmDEaTzAsK+nYmKGn
/LV3hy3TXFMQIHOrlZqOdFFQjboRBwupXv/cuq/N3O21dbk8YKibgmk48O+c6EzO
IFFJ/NJOl9opDx60X9TPJVybzqlnlHWm8AG5JPElJYeD16Zwwb+iRTov2k+ketO2
cL2QhCc0oK1UwudQAnq8yu7HNcxYSxWtOgN8pwjdwO4UGVZB07U8oCJcFwO0EFge
/JeFeYqfq3kR69ZChVPF
=fKaw
-----END PGP SIGNATURE-----

--Sig_/CJF5ebCdSeZjjl6Imell0j_--
