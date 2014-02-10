Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaBJEYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:24:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaBJEYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:24:47 -0500
Date: Sun, 9 Feb 2014 20:26:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: john.stultz@linaro.org, ohaugan@codeaurora.org, romlem@google.com,
        devel@driverdev.osuosl.org, konkers@android.com,
        linux-kernel@vger.kernel.org, ccross@android.com, rebecca@android.com,
        prtvar.b@gmail.com
Subject: Re: [PATCH] staging : android : fix checkpatch issues
Message-ID: <20140210042646.GA10320@kroah.com>
References: <2067517.LR5DRBeXLF@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2067517.LR5DRBeXLF@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 10:59:14AM +0900, Daeseok Youn wrote:
> >From 1348300b03697d0499eddba6035a851d1278abd1 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Mon, 10 Feb 2014 10:45:30 +0900
> Subject: [PATCH] staging : android : fix checkpatch issues
> 
> drivers/staging/android/
> ion/ion.c :
>  - WARNNING: Unnecessary space after function pointer name
>  - ERROR: return is not a function, parentheses are not required
>  - WARNNING: Prefer seq_puts to seq_printf
>  - WARNING: quoted string split across lines
> 
> ion/ion_priv.h :
>  - WARNING: Unnecessary space after function pointer name
> 
> sync.h :
>  - WARNING: missing space after return type
> 
> timed_output.h :
>  - WARNING: Multiple spaces after return type

You are doing multiple things in different files, please break this up
into smaller patches...

thanks,

greg k-h
