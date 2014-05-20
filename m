Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaETSET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:04:19 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:53685 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaETSER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:04:17 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-doc@vger.kernel.org,
        Sonal Santan <sonal.santan@gmail.com>
Subject: Re: [PATCH 1/2] platform: x86: dell-smo8800: Dell Latitude freefall driver (ACPI SMO8800/SMO8810)
In-Reply-To: Your message of "Tue, 20 May 2014 10:56:47 +0200."
             <201405201056.47726@pali>
From: Valdis.Kletnieks@vt.edu
References: <1399114077-19314-1-git-send-email-pali.rohar@gmail.com> <1399114077-19314-2-git-send-email-pali.rohar@gmail.com> <20135.1400569205@turing-police.cc.vt.edu>
            <201405201056.47726@pali>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1400608961_1987P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 20 May 2014 14:02:41 -0400
Message-ID: <20424.1400608961@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1400608961_1987P
Content-Type: text/plain; charset="UTF-8"
Content-Id: <20406.1400608951.1@turing-police.cc.vt.edu>
Content-Transfer-Encoding: 8bit

On Tue, 20 May 2014 10:56:47 +0200, Pali Rohár said:

> Hm? Which errors? Here is output from checkpacth:
>
> total: 0 errors, 0 warnings, 276 lines checked
>
> 0001-platform-x86-dell-smo8800-Dell-Latitude-freefall-dri.patch
> has no obvious style problems and is ready for submission.
>
> total: 0 errors, 0 warnings, 181 lines checked
>
> 0002-Documentation-Rename-hpfall.c-freefall.c-fixes-for-D.patch
> has no obvious style problems and is ready for submission.

Hmm.. what tree are you building against?  I wonder if your checkpatch is
a different version than mine (next-20140519).  What I see:

[/usr/src/linux-next] scripts/checkpatch.pl patches/freefall.1
WARNING: Missing a blank line after declarations
#135: FILE: drivers/platform/x86/dell-smo8800.c:41:
+       struct smo8800_device *smo8800 = data;
+       atomic_inc(&smo8800->count);

WARNING: Missing a blank line after declarations
#143: FILE: drivers/platform/x86/dell-smo8800.c:49:
+       struct smo8800_device *smo8800 = data;
+       dev_info(smo8800->dev, "detected free fall\n");

WARNING: Missing a blank line after declarations
#318: FILE: drivers/platform/x86/dell-smo8800.c:224:
+       struct smo8800_device *smo8800 = device->driver_data;
+       free_irq(smo8800->irq, smo8800);

total: 0 errors, 3 warnings, 276 lines checked

patches/freefall.1 has style problems, please review.

[/usr/src/linux-next] scripts/checkpatch.pl patches/freefall.2
WARNING: Missing a blank line after declarations
#126: FILE: Documentation/laptops/freefall.c:47:
+       int fd = open(unload_heads_path, O_RDONLY);
+       if (fd < 0) {

WARNING: Missing a blank line after declarations
#139: FILE: Documentation/laptops/freefall.c:60:
+       int fd = open(path, O_RDWR);
+       if (fd < 0) {

WARNING: Missing a blank line after declarations
#161: FILE: Documentation/laptops/freefall.c:82:
+       const char *str = (seconds == 0) ? "Unparked" : "Parked";
+       write_int(unload_heads_path, seconds*1000);

total: 0 errors, 3 warnings, 181 lines checked



--==_Exmh_1400608961_1987P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU3uYwAdmEQWDXROgAQKavw//Vkuz/l3x2frgWgZBNVFL03RQ1KQKK8y1
EvdsavwUViKaHBRTdkLnhJpZ6bJBaOCdLM3G+8bwBQaBF7pjLx5kAhKuI27jKqGJ
pLozWBW4EXhryX1bwX7R4BWU9m/qBoDJapEeqbkfhi3C2gSTX1Jsx5rpUN7drnj8
ljQi+qd/wWgW5Ru+DEfqW87Be2PNhwve2HUeYn+9Df/yHE87+Kw45PMULAGPx5Dq
oQwl1TzQm8duDFwno2EqGAfoSrcdr8/gppT1+gM4Htfodt+QxzfqXeRDGvvkUuR4
7x1fON0CmCDMrefoTUvpeTZr4kJCRYFDAlS+6eJvnPDvpPclDBwVkSimI8Sa0Q7M
CKJ3VGGSthaIlku89z3KJwq8a7g0x5wBGVrUCUoLS/BXebxqDBbccCI3UJEpCfWu
MD8WZSczHEPyYlkmwsRKd9NmqHgdOHG0FtAfAWjaAcd4HUTIGZEc/10U0NFMawQz
u6FclN3HvYgYCINhXJ57fxp0LiYNxX/35fGWhrzNs4pyqb+FBZHmFtTmo6lqYW6m
fiwAwEYPLCevFUM1BrpFm3XVlG7s/S0DS6S/FH/VnmAEBVdAzsSI4B/lx9MUyd/G
axQPTErqMoDqp8yH6mBKq7GJy85M8I5S+F0LSwr0IJZmF8yWHo3X8FKCS/SI99P5
WfVwKKEUBog=
=9Hwt
-----END PGP SIGNATURE-----

--==_Exmh_1400608961_1987P--
