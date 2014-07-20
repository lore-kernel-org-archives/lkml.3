Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaGTPxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 11:53:00 -0400
Received: from smtprelay0223.hostedemail.com ([216.40.44.223]:51389 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750756AbaGTPw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 11:52:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3872:3874:4321:5007:6996:7652:10004:10400:10482:10848:11232:11473:11658:11914:12043:12517:12519:12740:13161:13229:14096:14097:19901:19997:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: honey24_53dac91ca8d06
X-Filterd-Recvd-Size: 2932
Message-ID: <1405871574.5135.24.camel@joe-AO725>
Subject: Re: [PATCH] staging: input: sunkbd.c: Fix coding style
From: Joe Perches <joe@perches.com>
To: Bivolaru Catalin <bivolaru.catalin@gmail.com>
Cc: kernel-janitors@vger.kernel.org, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com
Date: Sun, 20 Jul 2014 08:52:54 -0700
In-Reply-To: <20140720120103.GA5294@kalio-PC>
References: <20140720120103.GA5294@kalio-PC>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-20 at 15:01 +0300, Bivolaru Catalin wrote:
> Fix coding style with regard to missing spaces after , and the column limit
> that was violated after the first change.

Some checkpatch errors should be ignored.

These are some of them.

This change doesn't make it easier to read
or to find any array entry.

It's currently in groups of 16 (0x10).

This change would make it very difficult
to find any particular entry.

It might make some sense to change the last
line to add a trailing "  0,  0" entry as
the compiler does to make it a bit clearer
the table has 128 entries.

> diff --git a/drivers/input/keyboard/sunkbd.c b/drivers/input/keyboard/sunkbd.c
[]
> @@ -42,14 +42,15 @@ MODULE_DESCRIPTION(DRIVER_DESC);
>  MODULE_LICENSE("GPL");
>  
>  static unsigned char sunkbd_keycode[128] = {
> -	  0,128,114,129,115, 59, 60, 68, 61, 87, 62, 88, 63,100, 64,112,
> -	 65, 66, 67, 56,103,119, 99, 70,105,130,131,108,106,  1,  2,  3,
> -	  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 41, 14,110,113, 98, 55,
> -	116,132, 83,133,102, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
> -	 26, 27,111,127, 71, 72, 73, 74,134,135,107,  0, 29, 30, 31, 32,
> -	 33, 34, 35, 36, 37, 38, 39, 40, 43, 28, 96, 75, 76, 77, 82,136,
> -	104,137, 69, 42, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54,101,
> -	 79, 80, 81,  0,  0,  0,138, 58,125, 57,126,109, 86, 78
> +	  0, 128, 114, 129, 115,  59,  60,  68,  61,  87,  62,  88,  63, 100,
> +	 64, 112,  65,  66,  67,  56, 103, 119,  99,  70, 105, 130, 131, 108,
> +	106,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,
> +	 41,  14, 110, 113,  98,  55, 116, 132,  83, 133, 102,  15,  16,  17,
> +	 18,  19,  20,  21,  22,  23,  24,  25,  26,  27, 111, 127,  71,  72,
> +	 73,  74, 134, 135, 107,   0,  29,  30,  31,  32,  33,  34,  35,  36,
> +	 37,  38,  39,  40,  43,  28,  96,  75,  76,  77,  82, 136, 104, 137,
> +	 69,  42,  44,  45,  46,  47,  48,  49,  50,  51,  52,  53,  54, 101,
> +	 79,  80,  81,   0,   0,   0, 138,  58, 125,  57, 126, 109,  86,  78
>  };


