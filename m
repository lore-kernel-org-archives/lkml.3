Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaGNVs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:48:29 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43949 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375AbaGNVrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:47:15 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Nicholas Krause <xerofoify@gmail.com>
Cc: ben-linux@fluff.org, kgene.kim@samsung.com, linux@arm.linux.org.uk,
        tomasz.figa@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mach-s3c64xx: Remove all defintions not related to regs-clocks
In-Reply-To: Your message of "Mon, 14 Jul 2014 14:14:24 -0400."
             <1405361664-5210-1-git-send-email-xerofoify@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1405361664-5210-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1405374230_3151P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 14 Jul 2014 17:43:50 -0400
Message-ID: <36350.1405374230@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1405374230_3151P
Content-Type: text/plain; charset=us-ascii

On Mon, 14 Jul 2014 14:14:24 -0400, Nicholas Krause said:
> This patch addresses the fix me message in this file that states to
> remove all definitions not related to reg-clocks in this header
> file.
>
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  arch/arm/mach-s3c64xx/include/mach/regs-clock.h | 22 +---------------------
>  1 file changed, 1 insertion(+), 21 deletions(-)

> -#endif /* _PLAT_REGS_CLOCK_H */
> +/#endif /* _PLAT_REGS_CLOCK_H */

You're kidding us, right? Given that this was obviously *not* compile
tested at all, why should we believe that in fact all those #defines
are in fact no longer used?

Hint: There's a very high chance that somebody stuck that FIXME in there rather
than just cleaning it up themselves precisely *because* it was still in use in
an inconvenient to fix place in the tree..


--==_Exmh_1405374230_3151P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU8RPFgdmEQWDXROgAQKE2BAAiNEw+m4GvURrYCxBkYGaobYQYeMe8Kp6
fG9WrLClGjiLNr4817Hgaa7tjJsffHwOeGaEno5hk/DBx0i7Cv6+vz9xopNDxPRc
fN4sUPUbziM9LMfos2hEgXAmGHQjWh+LGL87O7n9o8RD4FM4V7xDKwBfDn8z4pFL
ImHyP1d+IkeW94go23khXhnksIK42le8gkMB2GvNa2jPdfHqr8SGh58GqL/nHBNI
ebqWP9SuN8nu/DDW6vqO/O1m4p3akYqH7vuaw1J9qBpUKSTPKAdGi1Mpwh1huI72
RIn+ikPWCI3cfSmoMFFPUb9ws7yxlj5BSdn8QK1A8bmjGM/oF83lC6rY44WCdJtB
uBaOdJ5/7DiHsWcZAIEjsX6G/WXGMVgGxv7YLKaJy/BbrmTsui3KfGu3u4CN6JUZ
2WvZ6mIH+ovagCoZfUyd4YUT2sF20pXvhCKGGqRE4PiZraJdZ9fk5vt0gwCiqh7O
7eL3NiWNsl6TbntQwbOX5J73uuuCVU9XsMOxcXp3FfJtOBpTgo7ifyhLlz+/tBFT
xDA6fQ2sszq1x82hc3+AVxWVZywHjoOBU9deiOTn03Nl5k5Kk6gr1U5eUJ40BaJ3
i/SZFMWnGWVT3i3s4HFXQMMwe4aO/JM+9AE4MFyZ+bCwMneKUTRAJdXWTly4b8ZK
uuZfJtoC4zs=
=tNnF
-----END PGP SIGNATURE-----

--==_Exmh_1405374230_3151P--
