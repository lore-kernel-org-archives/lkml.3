Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaHDO0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:26:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbaHDO0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:26:22 -0400
Date: Mon, 4 Aug 2014 10:26:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: chai wen <chaiw.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH 1/2] watchdog: remove unnecessary head files
Message-ID: <20140804142617.GE87407@redhat.com>
References: <1407137779-19129-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407137779-19129-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 03:36:18PM +0800, chai wen wrote:
> Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>

Seems reasonable.

Acked-by: Don Zickus <dzickus@redhat.com>

> ---
>  kernel/watchdog.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index c3319bd..4c2e11c 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -15,11 +15,6 @@
>  #include <linux/cpu.h>
>  #include <linux/nmi.h>
>  #include <linux/init.h>
> -#include <linux/delay.h>
> -#include <linux/freezer.h>
> -#include <linux/kthread.h>
> -#include <linux/lockdep.h>
> -#include <linux/notifier.h>
>  #include <linux/module.h>
>  #include <linux/sysctl.h>
>  #include <linux/smpboot.h>
> -- 
> 1.7.1
> 
