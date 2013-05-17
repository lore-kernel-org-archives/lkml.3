Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3EQNHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:07:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab3EQNHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:07:21 -0400
Date: Fri, 17 May 2013 09:07:13 -0400
From: Don Zickus <dzickus@redhat.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] watchdog: Remove softlockup_thresh from Documentation
Message-ID: <20130517130713.GH78758@redhat.com>
References: <51959668.9040106@huawei.com>
 <51959687.9090305@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51959687.9090305@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 10:31:35AM +0800, Li Zefan wrote:
> The old softlockup detector has been replaced with new lockup
> detector long ago.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: Don Zickus <dzickus@redhat.com>

> ---
>  Documentation/sysctl/kernel.txt | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index e8fabd6..bcff3f9 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -70,7 +70,6 @@ show up in /proc/sys/kernel:
>  - shmall
>  - shmmax                      [ sysv ipc ]
>  - shmmni
> -- softlockup_thresh
>  - stop-a                      [ SPARC only ]
>  - sysrq                       ==> Documentation/sysrq.txt
>  - tainted
> @@ -605,15 +604,6 @@ without users and with a dead originative process will be destroyed.
>  
>  ==============================================================
>  
> -softlockup_thresh:
> -
> -This value can be used to lower the softlockup tolerance threshold.  The
> -default threshold is 60 seconds.  If a cpu is locked up for 60 seconds,
> -the kernel complains.  Valid values are 1-60 seconds.  Setting this
> -tunable to zero will disable the softlockup detection altogether.
> -
> -==============================================================
> -
>  tainted:
>  
>  Non-zero if the kernel has been tainted.  Numeric values, which
> -- 
> 1.8.0.2
