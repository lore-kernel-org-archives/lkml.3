Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3BANuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:50:35 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:58095 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3BANue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:50:34 -0500
Subject: Re: [PATCH] [Watchdog][Trivial] Added comments to explain
 watchdog_disabled variable
From: anish kumar <anish198519851985@gmail.com>
To: akpm@linux-foundation.org
Cc: dzickus@redhat.com, tglx@linutronix.de, mingo@kernel.org,
        chuansheng.liu@intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <1359725603-20471-1-git-send-email-anish198519851985@gmail.com>
References: <1359725603-20471-1-git-send-email-anish198519851985@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Feb 2013 19:20:18 +0530
Message-ID: <1359726618.1666.2.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this patch.
On Fri, 2013-02-01 at 19:03 +0530, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> This watchdog_disabled flag is bit of cryptic.Howerver it's usefullnes is multifold.
> Uses are:
> 1. Check if smpboot_register_percpu_thread function passed.
> 2. Makes sure that user enables and disables the watchdog in sequence
>    i.e. enable watchdog->disable watchdog->enable watchdog
>    Unlike enable watchdog->enable watchdog which is wrong.
> 
> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> ---
>  kernel/watchdog.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 75a2ab3..6ef638b 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -155,6 +155,7 @@ void touch_all_softlockup_watchdogs(void)
>  	for_each_online_cpu(cpu)
>  		per_cpu(watchdog_touch_ts, cpu) = 0;
>  }
> +EXPORT_SYMBOL(touch_all_softlockup_watchdogs);
>  
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>  void touch_nmi_watchdog(void)


