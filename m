Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3LSO3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:29:41 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52055 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3LSO3j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:29:39 -0500
X-Originating-IP: 50.43.14.201
Date: Thu, 19 Dec 2013 06:29:31 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] drivers: base: Add prototype declaration to the
 header file
Message-ID: <20131219142930.GB20678@leaf>
References: <20131218063953.GA3180@rashika>
 <1387452297-28836-1-git-send-email-rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1387452297-28836-1-git-send-email-rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:54:57PM +0530, Rashika Kheria wrote:
> Add prototype declaration of function memory_block_size_bytes() to
> the header file include/linux/memory.h.
> 
> This eliminates the following warning in memory.c:
> drivers/base/memory.c:87:1: warning: no previous prototype for ‘memory_block_size_bytes’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  include/linux/memory.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index 9a6bbf7..8c8f51c 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -35,6 +35,7 @@ struct memory_block {
>  };
>  
>  int arch_get_memory_phys_device(unsigned long start_pfn);
> +unsigned long __weak memory_block_size_bytes(void);	
>  
>  /* These states are exposed to userspace as text strings in sysfs */
>  #define	MEM_ONLINE		(1<<0) /* exposed to userspace */
> -- 
> 1.7.9.5
> 
