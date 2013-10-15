Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab3JOQos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:44:48 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:23815 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab3JOQor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:44:47 -0400
Message-ID: <1381855484.2354.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc/sem.c: fix small codingstyle
From: Davidlohr Bueso <davidlohr@hp.com>
To: Libin <huawei.libin@huawei.com>
Cc: akpm@linux-foundation.org, manfred@colorfullife.com,
        linux-kernel@vger.kernel.org, guohanjun@huawei.com,
        xiexiuqi@huawei.com
Date: Tue, 15 Oct 2013 09:44:44 -0700
In-Reply-To: <1381825183-49576-1-git-send-email-huawei.libin@huawei.com>
References: <1381825183-49576-1-git-send-email-huawei.libin@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 16:19 +0800, Libin wrote:
> From: Li Bin <huawei.libin@huawei.com>
> 
> small codingstyle fix: '*' should be adjacent to the data name.

There are *tons* of these, go crazy.

> 
> Signed-off-by: Li Bin <huawei.libin@huawei.com>
> ---
>  ipc/sem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 8c4f59b..7583fe8 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -2077,7 +2077,7 @@ void exit_sem(struct task_struct *tsk)
>  
>  		/* perform adjustments registered in un */
>  		for (i = 0; i < sma->sem_nsems; i++) {
> -			struct sem * semaphore = &sma->sem_base[i];
> +			struct sem *semaphore = &sma->sem_base[i];
>  			if (un->semadj[i]) {
>  				semaphore->semval += un->semadj[i];
>  				/*


