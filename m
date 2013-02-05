Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3BEPuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:50:17 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:53895 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab3BEPuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:50:14 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Minchan Kim <minchan@kernel.org>
Cc: Shaohua Li <shli@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: next-20130128 lockdep whinge in sys_swapon()
In-Reply-To: Your message of "Mon, 04 Feb 2013 10:46:38 +0900."
             <20130204014638.GC2688@blaptop>
From: Valdis.Kletnieks@vt.edu
References: <5595.1359657914@turing-police.cc.vt.edu>
            <20130204014638.GC2688@blaptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1360079362_2221P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Feb 2013 10:49:22 -0500
Message-ID: <2701.1360079362@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.51112A0A.0059,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1360079362_2221P
Content-Type: text/plain; charset=us-ascii

On Mon, 04 Feb 2013 10:46:38 +0900, Minchan Kim said:

> Could you test this patch?
>
> From 81cae17c55ade897a7e06b01c864f1c250b40f8b Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan@kernel.org>
> Date: Mon, 4 Feb 2013 10:43:32 +0900
> Subject: [PATCH] mm: Get rid of lockdep whinge on sys_swapon
>
> [1] forgot to initialize spin_lock so lockdep is whingeing
> about it. This patch fixes it.
>
> [1] 0f181e0e4, swap: add per-partition lock for swapfile
>
> Cc: Shaohua Li <shli@kernel.org>
> Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

I applied this to a next-20130128, and lockdep doesn't complain about
swapon().  Feel free to add a 'Tested-By:' to the patch and push it
upstream...


--==_Exmh_1360079362_2221P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUREqAgdmEQWDXROgAQLx1g//dMZEwUI5NfWAyQRe4rasOMqWH2qCyWhj
AJzgeK9JD4eA24QME56slToXIpLbud0YKEVjcvokG8QRwe8rb0rhj5lvuDYWAy1v
65JXi2+ass61BoqT++uEf2z0x5v/8CLI/s+Ckc00uuJB69q51s+vmHz7zDx/MjQW
OhMij6YW0FKoUjVoymGJnXoFB8c/xT87zp4Ti36Mjr1ihlIHPryxwMWttO/P54eE
d9HRqHWbprBMhcLDqM4UjioekNFC7e0kF/HrUFZ2nFr4/sTjlX5Tt7qX3Mvh+yrY
KCtlPYQhYhK8Lu1xfhHHJLN2MMbd2jurftwkkfUWEXki2GNh1+QQjdqKedsQ9Cp+
9XY1Vtn+5855CF7I8eFvJF0ZMbt5UIW1rQLW6Ue00a311k5rqiFpwO/iIXoaclQq
ynKU3ym7OlvZMT4iAlsgKvjz3ypRzpaIjvXoPXDJ6ktzaOztI3hzHyCPRNsBhUCu
czyKOXflhICxZOMs5kL4kHXUY1/d9BaCjadbkO5drWTvJ4m4G4id6P7Fj5xjN7PU
lD/mN/uXzmHLzCzEbrD51MV9yh3/GeWShf5BjxOrvCZuRDyUz6bP99XkCNSuZva8
4xKEx/zi/NBS9fhVz4GTfzmUIl+EXyXlEzImbRe82fXNdHAXg5tmaPErLPvFH9T6
csZb5NhgQW0=
=XVIS
-----END PGP SIGNATURE-----

--==_Exmh_1360079362_2221P--

