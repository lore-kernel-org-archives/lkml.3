Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaFMJpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:45:00 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:44496 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaFMJo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:44:56 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Wei.Yang@windriver.com, stern@rowland.harvard.edu
Cc: balbi@ti.com, andrzej.p@samsung.com, wei.yang@windriver.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] USB:gadget: Fix a warning while loading g_mass_storage
In-Reply-To: <1402294798-27401-1-git-send-email-Wei.Yang@windriver.com>
Organization: http://mina86.com/
References: <1401856367-12553-1-git-send-email-Wei.Yang@windriver.com> <1402294798-27401-1-git-send-email-Wei.Yang@windriver.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140613:linux-kernel@vger.kernel.org::riIdXdGskuMK8m2O:0000000000000000000000000000000000lRl
X-Hashcash: 1:20:140613:wei.yang@windriver.com::0/yObPK5upxCTfxH:0000000000000000000000000000000000000000uG6
X-Hashcash: 1:20:140613:balbi@ti.com::lw2rZ5OJI3IS8j2y:000002duq
X-Hashcash: 1:20:140613:wei.yang@windriver.com::r0X9XV99L51wKv6d:0000000000000000000000000000000000000003mJz
X-Hashcash: 1:20:140613:linux-usb@vger.kernel.org::mexOlE89vCdYb1EJ:0000000000000000000000000000000000003EPL
X-Hashcash: 1:20:140613:andrzej.p@samsung.com::kHIqGRuBYk5LnqUZ:00000000000000000000000000000000000000006i/L
X-Hashcash: 1:20:140613:stern@rowland.harvard.edu::hfcsmIsa3krJOeIb:0000000000000000000000000000000000008NHj
Date: Fri, 13 Jun 2014 11:44:51 +0200
Message-ID: <xa1td2ednnxo.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09 2014, Wei.Yang@windriver.com wrote:
> From: Yang Wei <Wei.Yang@windriver.com>
>
> While loading g_mass_storage module, the following warning
> is triggered.
>
> WARNING: at drivers/usb/gadget/composite.c:
> usb_composite_setup_continue: Unexpected call
> Modules linked in: fat vfat minix nls_cp437 nls_iso8859_1 g_mass_storage
> [<800179cc>] (unwind_backtrace+0x0/0x104) from [<80619608>] (dump_stack+0x20/0x24)
> [<80619608>] (dump_stack+0x20/0x24) from [<80025100>] (warn_slowpath_common+0x64/0x74)
> [<80025100>] (warn_slowpath_common+0x64/0x74) from [<800251cc>] (warn_slowpath_fmt+0x40/0x48)
> [<800251cc>] (warn_slowpath_fmt+0x40/0x48) from [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage])
> [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage]) from [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage])
> [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage]) from [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage])
> [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage]) from [<8004bc90>] (kthread+0x98/0x9c)
> [<8004bc90>] (kthread+0x98/0x9c) from [<8000faec>] (kernel_thread_exit+0x0/0x8)
>
> The root cause is that the existing code fails to take into
> account the possibility that common->new_fsg can change while
> do_set_interface() is running, because the spinlock isn't held
> at this point.

common->new_fsg is not protected by common->lock so this justification
is not valid.

>
> Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>  drivers/usb/gadget/f_mass_storage.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> Hi Alan,
>
> Thanks for your review, there are a few changes in v3:
>
> 1) Fix a coding style issue.
> 2) Refine the commit log
>
> Regards
> Wei
>
> diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
> index b963939..0cd8f21 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -2342,6 +2342,7 @@ static void handle_exception(struct fsg_common *common)
>  	struct fsg_buffhd	*bh;
>  	enum fsg_state		old_state;
>  	struct fsg_lun		*curlun;
> +	struct fsg_dev		*new_fsg;
>  	unsigned int		exception_req_tag;
>  
>  	/*
> @@ -2421,6 +2422,7 @@ static void handle_exception(struct fsg_common *common)
>  		}
>  		common->state = FSG_STATE_IDLE;
>  	}
> +	new_fsg = common->new_fsg;

Also, because common->new_fsg is not protected by common->lock, doing
this under a lock is kinda pointless.

>  	spin_unlock_irq(&common->lock);
>  
>  	/* Carry out any extra actions required for the exception */
> @@ -2460,8 +2462,8 @@ static void handle_exception(struct fsg_common *common)
>  		break;
>  
>  	case FSG_STATE_CONFIG_CHANGE:
> -		do_set_interface(common, common->new_fsg);
> -		if (common->new_fsg)
> +		do_set_interface(common, new_fsg);
> +		if (new_fsg)
>  			usb_composite_setup_continue(common->cdev);

As far as I can tell, it's safe to move the assignment to new_fsg here,
e.g.:

		new_fsg = common->new_fsg;
		do_set_interface(common, new_fsg);
		if (new_fsg)
			usb_composite_setup_continue(common->cdev);

>  		break;

But perhaps new_fsg should be protected by the lock.  I think valid fix
(which I did not test in *any* way) will be this:

-------------- >8 ------------------------------------------------------------

>From 1d0b638fab05489dfb52a96556b73e2670ab52ee Mon Sep 17 00:00:00 2001
From: Michal Nazarewicz <mina86@mina86.com>
Date: Fri, 13 Jun 2014 11:40:45 +0200
Subject: [PATCH] usb: gadget: f_mass_storage: Fix a warning while loading
 g_mass_storage

While loading g_mass_storage module, the following warning can
trigger:

WARNING: at drivers/usb/gadget/composite.c:
usb_composite_setup_continue: Unexpected call
Modules linked in: fat vfat minix nls_cp437 nls_iso8859_1 g_mass_storage
[<800179cc>] (unwind_backtrace+0x0/0x104) from [<80619608>] (dump_stack+0x20/0x24)
[<80619608>] (dump_stack+0x20/0x24) from [<80025100>] (warn_slowpath_common+0x64/0x74)
[<80025100>] (warn_slowpath_common+0x64/0x74) from [<800251cc>] (warn_slowpath_fmt+0x40/0x48)
[<800251cc>] (warn_slowpath_fmt+0x40/0x48) from [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage])
[<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage]) from [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage])
[<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage]) from [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage])
[<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage]) from [<8004bc90>] (kthread+0x98/0x9c)
[<8004bc90>] (kthread+0x98/0x9c) from [<8000faec>] (kernel_thread_exit+0x0/0x8)

The root cause is that the existing code fails to take into account
the possibility that common->new_fsg can change while
do_set_interface() is running, because the spinlock does not protect
it.

Change the code so that the common->new_fsg field is protected by the
common->lock spin lock.

Reported-By: Yang Wei <Wei.Yang@windriver.com>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c | 54 +++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index b963939..bd663c2 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -264,7 +264,7 @@ struct fsg_common {
 	/* filesem protects: backing files in use */
 	struct rw_semaphore	filesem;
 
-	/* lock protects: state, all the req_busy's */
+	/* lock protects: state, all the req_busy's, and new_fsg */
 	spinlock_t		lock;
 
 	struct usb_ep		*ep0;		/* Copy of gadget->ep0 */
@@ -407,23 +407,39 @@ static void wakeup_thread(struct fsg_common *common)
 		wake_up_process(common->thread_task);
 }
 
-static void raise_exception(struct fsg_common *common, enum fsg_state new_state)
+static void __raise_exception(struct fsg_common *common,
+			      enum fsg_state new_state)
 {
-	unsigned long		flags;
-
 	/*
 	 * Do nothing if a higher-priority exception is already in progress.
 	 * If a lower-or-equal priority exception is in progress, preempt it
 	 * and notify the main thread by sending it a signal.
 	 */
+	if (common->state > new_state)
+		return;
+
+	common->exception_req_tag = common->ep0_req_tag;
+	common->state = new_state;
+	if (common->thread_task)
+		send_sig_info(SIGUSR1, SEND_SIG_FORCED, common->thread_task);
+}
+
+static void raise_exception(struct fsg_common *common, enum fsg_state new_state)
+{
+	unsigned long		flags;
 	spin_lock_irqsave(&common->lock, flags);
-	if (common->state <= new_state) {
-		common->exception_req_tag = common->ep0_req_tag;
-		common->state = new_state;
-		if (common->thread_task)
-			send_sig_info(SIGUSR1, SEND_SIG_FORCED,
-				      common->thread_task);
-	}
+	__raise_exception(common, new_state);
+	spin_unlock_irqrestore(&common->lock, flags);
+}
+
+static void raise_config_change_exception(struct fsg_common *common,
+					  struct fsg_dev *new_fsg)
+{
+	unsigned long		flags;
+
+	spin_lock_irqsave(&common->lock, flags);
+	common->new_fsg = new_fsg;
+	__raise_exception(common, FSG_STATE_CONFIG_CHANGE);
 	spin_unlock_irqrestore(&common->lock, flags);
 }
 
@@ -2320,16 +2336,14 @@ reset:
 static int fsg_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 {
 	struct fsg_dev *fsg = fsg_from_func(f);
-	fsg->common->new_fsg = fsg;
-	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
+	raise_config_change_exception(fsg->common, fsg);
 	return USB_GADGET_DELAYED_STATUS;
 }
 
 static void fsg_disable(struct usb_function *f)
 {
 	struct fsg_dev *fsg = fsg_from_func(f);
-	fsg->common->new_fsg = NULL;
-	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
+	raise_config_change_exception(fsg->common, NULL);
 }
 
 
@@ -2342,6 +2356,7 @@ static void handle_exception(struct fsg_common *common)
 	struct fsg_buffhd	*bh;
 	enum fsg_state		old_state;
 	struct fsg_lun		*curlun;
+	struct fsg_dev		*new_fsg;
 	unsigned int		exception_req_tag;
 
 	/*
@@ -2405,6 +2420,7 @@ static void handle_exception(struct fsg_common *common)
 	common->next_buffhd_to_drain = &common->buffhds[0];
 	exception_req_tag = common->exception_req_tag;
 	old_state = common->state;
+	new_fsg = common->new_fsg;
 
 	if (old_state == FSG_STATE_ABORT_BULK_OUT)
 		common->state = FSG_STATE_STATUS_PHASE;
@@ -2460,8 +2476,8 @@ static void handle_exception(struct fsg_common *common)
 		break;
 
 	case FSG_STATE_CONFIG_CHANGE:
-		do_set_interface(common, common->new_fsg);
-		if (common->new_fsg)
+		do_set_interface(common, new_fsg);
+		if (new_fsg)
 			usb_composite_setup_continue(common->cdev);
 		break;
 
@@ -3178,8 +3194,7 @@ static void fsg_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	DBG(fsg, "unbind\n");
 	if (fsg->common->fsg == fsg) {
-		fsg->common->new_fsg = NULL;
-		raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
+		raise_config_change_exception(fsg->common, NULL);
 		/* FIXME: make interruptible or killable somehow? */
 		wait_event(common->fsg_wait, common->fsg != fsg);
 	}
@@ -3665,4 +3680,3 @@ void fsg_config_from_params(struct fsg_config *cfg,
 	cfg->fsg_num_buffers = fsg_num_buffers;
 }
 EXPORT_SYMBOL_GPL(fsg_config_from_params);
-
-- 
2.0.0.526.g5318336

