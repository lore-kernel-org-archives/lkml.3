Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaJPM5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:57:36 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:47383 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaJPM5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:57:35 -0400
Date: Thu, 16 Oct 2014 18:27:24 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Ionut Alexa <ionut.m.alexa@gmail.com>, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel:module Fix coding style errors and warnings.
Message-ID: <20141016125724.GA5244@sudip-PC>
References: <1413452213-27450-1-git-send-email-ionut.m.alexa@gmail.com>
 <1413452333.6702.1.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413452333.6702.1.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 02:38:53AM -0700, Joe Perches wrote:
> On Thu, 2014-10-16 at 12:36 +0300, Ionut Alexa wrote:
> > Fixed codin style errors and warnings. Changes printk with
> > print_debug/warn. Changed seq_printf to seq_puts.
> 
> If you are going to do style cleanups, please make
> sure you check your patches with scripts/checkpatch.pl
> before sending them.
> 
> WARNING: missing space after struct definition
> #104: FILE: kernel/module.c:743:
> +struct stopref{
> 
> WARNING: line over 80 characters
> #190: FILE: kernel/module.c:1550:
> +			error = sysfs_create_file(&mod->mkobj.kobj, &temp_attr->attr);
> 
> total: 0 errors, 2 warnings, 187 lines checked
> 
hi joe,
should we be doing style cleanups in the kernel files ?
previously i saw comments discouraging it as it pollutes the git blame.


> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
