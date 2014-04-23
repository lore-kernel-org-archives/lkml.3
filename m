Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbaDWSSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:18:43 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:62828 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaDWSSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:18:40 -0400
Message-ID: <535803FC.1040605@colorfullife.com>
Date: Wed, 23 Apr 2014 20:18:36 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org
Subject: Re: [PATCH 5/4] ipc,shm: minor cleanups
References: <1398090397-2397-1-git-send-email-manfred@colorfullife.com> <1398221636.6345.9.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1398221636.6345.9.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 04:53 AM, Davidlohr Bueso wrote:
> -  Breakup long function names/args.
> -  Cleaup variable declaration.
s/Cleaup/Cleanup/
> -  s/current->mm/mm
>
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

> @@ -681,7 +679,8 @@ copy_shmid_from_user(struct shmid64_ds *out, void __user *buf, int version)
>   	}
>   }
>   
> -static inline unsigned long copy_shminfo_to_user(void __user *buf, struct shminfo64 *in, int version)
> +static inline unsigned long copy_shminfo_to_user(void __user *buf,
> +						 struct shminfo64 *in, int version)
Checkpatch still complains - does removing one tab help?

--
     Manfred
