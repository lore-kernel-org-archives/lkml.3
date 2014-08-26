Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbaHZUmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 16:42:08 -0400
Received: from omr1.cc.vt.edu ([198.82.141.52]:53834 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbaHZUmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 16:42:05 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org,
        Sabrina Dubroca <sd@queasysnail.net>,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2][input-led] Defer input led work to workqueue
In-Reply-To: Your message of "Tue, 26 Aug 2014 11:17:25 +0200."
             <20140826091725.GA23293@type.youpi.perso.aquilenet.fr>
From: Valdis.Kletnieks@vt.edu
References: <20140826015453.GA5235@type.youpi.perso.aquilenet.fr>
            <20140826091725.GA23293@type.youpi.perso.aquilenet.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1409085709_3249P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 26 Aug 2014 16:41:49 -0400
Message-ID: <3469.1409085709@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1409085709_3249P
Content-Type: text/plain; charset=us-ascii

On Tue, 26 Aug 2014 11:17:25 +0200, you said:

>
> Difference with v1: uses schedule_work instead of its own workqueue.
>
> --- a/drivers/input/leds.c
> +++ b/drivers/input/leds.c
> @@ -100,13 +100,24 @@ static unsigned long vt_led_registered[B

Same thing for B2 - next-20140826 complains, and no complaints with this patch
on top.

Tested-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1409085709_3249P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU/zxDQdmEQWDXROgAQJ3cg/9Hvx/H5aJwYevd+dj6U81mBSm07bO6RJC
+XhtvhhBEUSFPKmArBlxBY2PyICbnpmtJldvG9E+I2+S1zqPczoIEatQgwR6ttfa
8BiLhoOxsq3O6IEUFsWpgHHcT9EXUSc5tqEnv5xVxBDkNp4pB+2Uca+5f3IsXuFX
DNnfh6o9/pCoRVIlWDykUC7cenDagwCR/i5KHQQRSL+b5/YiGFH1Qt/YCGml+WWK
8McdfW+xbG8Oc28HcIhUw2aoUwsb0wE5TwH/mwuzfl+Ad62XuKZXcuW77VjejzX0
dF4YPhkQ2YkSto1OrOgpaSPgaKcYXsO1hWylEOntzltwovxhn2dDkt2kSwYCGcTc
d1A+e+3YpLi4HB4hyJ8rXlYeuMq0w0u6BKA3MymVDsFJiqO3tjFOaj8sNLwZjaXC
k8AdL2ILirwA4Iovq7FW6YLt3gbwmiBDkAn5O9p3Mk5YMQEZW+cGltLbwUcfgI7e
BZHZ9PCDjwo2omcoSaiiMzSDd5ggv502AlrSUcPBZVposHVq4ZshHjCldRzRHinf
FQCjdJm9SWcTLn9E0/2d79Zy9A7zSZsfM500hOKOYBSoK9WKxwvJe+H8akb6/1sX
/Q+xKnJgFcY6PPXd6atsjMdUFDfK7QZhxrJQCKfXganugNmZhfU9vqt4ouLtdc65
4T4q0W7Icxg=
=d9AD
-----END PGP SIGNATURE-----

--==_Exmh_1409085709_3249P--
