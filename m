Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab3HSRD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:03:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37442 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3HSRDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:03:25 -0400
Message-ID: <52124FD4.9090608@infradead.org>
Date: Mon, 19 Aug 2013 10:03:16 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: rob@landley.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] doc: Fix typo "is is" in Documentations
References: <1376921446-24653-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1376921446-24653-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/13 07:10, Masanari Iida wrote:
> Fix double words "is is" in Documentations.
> 
> diff --git a/Documentation/mtd/nand_ecc.txt b/Documentation/mtd/nand_ecc.txt
> index 990efd7..e129b24 100644
> --- a/Documentation/mtd/nand_ecc.txt
> +++ b/Documentation/mtd/nand_ecc.txt
> @@ -543,7 +543,7 @@ THe code within the for loop was changed to:
>      }
>  
>  As you can see tmppar is used to accumulate the parity within a for
> -iteration. In the last 3 statements is is added to par and, if needed,
> +iteration. In the last 3 statements is added to par and, if needed,

I think that this should be:
                                       it is added

>  to rp12 and rp14.
>  
>  While making the changes I also found that I could exploit that tmppar


-- 
~Randy
