Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaEMWIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:08:55 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42466 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbaEMWIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:08:06 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 2/2] FS/CONFIGFS: Use pr_fmt
In-Reply-To: Your message of "Tue, 13 May 2014 13:50:49 -0700."
             <20140513135049.2d160a63d662b3aab6ba3c03@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20140513202428.77c59d530a2c2154a9902cb3@skynet.be>
            <20140513135049.2d160a63d662b3aab6ba3c03@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1400018809_2034P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 May 2014 18:06:50 -0400
Message-ID: <75410.1400018810@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1400018809_2034P
Content-Type: text/plain; charset=us-ascii

On Tue, 13 May 2014 13:50:49 -0700, Andrew Morton said:
> On Tue, 13 May 2014 20:24:28 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> > +#ifdef pr_fmt
> > +#undef pr_fmt
> > +#endif
>
> Why this?
>
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Won't GCC whinge by default about the #define if it doesn't exactly match the
previous definition?

--==_Exmh_1400018809_2034P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU3KXeQdmEQWDXROgAQJWtA/+IzEj9M8S7QEf0hLjoQfwJOziqzdJdKM8
cp3Ssnd4HhowqVkGYpsRmYr8MMzX7OsRCrYZwFzfV+6YrIeMgvc114GPPJVTRTIM
HH3Sn40NpWd7dkyGsJ1+IGtT5pgr9Zdoaw0QpxtfKInUpa4f6KZh00y9r41RW6FG
+G80oanN5g7bwCVt2Ol7HCol2qx0GrC2zVPBXAAvJTyjGI2WFaMdcXnpJjYne7iR
ihCZHkSnrvIH0+Lsj5CZkry0JOR4Wfd/S923NTc7NV3W5o3sy+oH9UxY93N7Xmja
4pAYBG8esbPx3I/QLdasWeGX8JBPO68LhqwCRVKhbG/YFd2XY+klEd/FWTvjCWnC
rKOCCyF68BMN8gEx2tjDDaZu7Z6/2oyzll+306idsA9qPZo9Obr9X0ApMTyDJ4Ed
Gf8JPgpmfZxmr+1bQMek9DUTHOX6Pko3aENQ+Rkh4X5yFAHaujokItu27megUgcm
Vy4VcSyG9qU2BKW+EearQnEI3bRHzRJR5a6D5CFHUnp/fHXuQ0e0Pp7g3U/uas/x
t9IiLzbFNCxucfa9wrcAn22LwIU4vng9bLtfJsCZRorOP5qbpcJ0uhapvBmiKK8h
ybsQnhC0oZCEAL6bQNVyrarN/Gma3K3zcfJ2QQnJaAylrBfyq9/kyWyUD0TQy7Ru
BUXmaQUMhs4=
=6eQH
-----END PGP SIGNATURE-----

--==_Exmh_1400018809_2034P--
