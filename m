Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaINRU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:20:29 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40822 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaINRU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:20:28 -0400
Date: Sun, 14 Sep 2014 22:49:57 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Amitabha Yin <angelo.yin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Set EXTRAVERSION to -eudyptula of Makefile
Message-ID: <20140914171957.GA2157@fool>
References: <1410699283.5595.1.camel@centos.angelo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410699283.5595.1.camel@centos.angelo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 08:54:43PM +0800, Amitabha Yin wrote:
> Hello all,
> 
> Set EXTRAVERSION to -eudyptula in Makefile for 
> Task 03 of the Eudyptula Challenge.
> 

i think you are supposed to send the patch to little and not here.

thanks
sudip

> Signed-off-by: Ping Yin <angelo.yin@gmail.com>
> --
> diff --git a/Makefile b/Makefile
> index 1a60bdd..c6e6859 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>  VERSION = 3
>  PATCHLEVEL = 17
>  SUBLEVEL = 0
> -EXTRAVERSION = -rc4
> +EXTRAVERSION = -eudyptula
>  NAME = Shuffling Zombie Juror
>  
>  # *DOCUMENTATION*
> --
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
