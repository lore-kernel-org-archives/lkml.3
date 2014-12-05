Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaLEGjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 01:39:46 -0500
Received: from smtprelay0035.hostedemail.com ([216.40.44.35]:59951 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751782AbaLEGjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:39:45 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3873:4321:5007:6261:6691:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12679:12740:13069:13163:13229:13311:13357:14039:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hand00_54fd419ba2c3b
X-Filterd-Recvd-Size: 1603
Message-ID: <1417761582.2721.35.camel@perches.com>
Subject: Re: [PATCH] staging: kernel: fixed style errors in pid.c
From: Joe Perches <joe@perches.com>
To: "Joshua I. James" <joshua@cybercrimetech.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 04 Dec 2014 22:39:42 -0800
In-Reply-To: <1417760858-26831-1-git-send-email-Joshua@cybercrimetech.com>
References: <1417760858-26831-1-git-send-email-Joshua@cybercrimetech.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 15:27 +0900, Joshua I. James wrote:
> Fixed style errors identified by checkpatch.

Your subject is not correct.

This is not staging.

Please submit patches only for drivers/staging until
until you are _very_ familiar with kernel style.

And most whitespace only changes to kernel/... are not
particularly welcomed by the most experienced kernel
developers.

> diff --git a/kernel/pid.c b/kernel/pid.c
[]
> @@ -471,8 +478,10 @@ EXPORT_SYMBOL_GPL(get_task_pid);
>  struct task_struct *get_pid_task(struct pid *pid, enum pid_type type)
>  {
>  	struct task_struct *result;
> +
>  	rcu_read_lock();
>  	result = pid_task(pid, type);
> +

Unnecessary blank line added here.

btw: using scripts/checkpatch.pl --fix-inplace --strict
would have been better.

