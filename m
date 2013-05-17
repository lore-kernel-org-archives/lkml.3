Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab3EQNHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:07:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab3EQNHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:07:07 -0400
Date: Fri, 17 May 2013 09:07:00 -0400
From: Don Zickus <dzickus@redhat.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] watchdog: Document watchdog_thresh sysctl
Message-ID: <20130517130700.GG78758@redhat.com>
References: <51959668.9040106@huawei.com>
 <51959678.6000802@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51959678.6000802@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 10:31:20AM +0800, Li Zefan wrote:
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: Don Zickus <dzickus@redhat.com>

> ---
>  Documentation/sysctl/kernel.txt | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index ccd4258..e8fabd6 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -76,6 +76,7 @@ show up in /proc/sys/kernel:
>  - tainted
>  - threads-max
>  - unknown_nmi_panic
> +- watchdog_thresh
>  - version
>  
>  ==============================================================
> @@ -648,3 +649,16 @@ that time, kernel debugging information is displayed on console.
>  
>  NMI switch that most IA32 servers have fires unknown NMI up, for
>  example.  If a system hangs up, try pressing the NMI switch.
> +
> +==============================================================
> +
> +watchdog_thresh:
> +
> +This value can be used to control the frequency of hrtimer and NMI
> +events and the soft and hard lockup thresholds. The default threshold
> +is 10 seconds.
> +
> +The softlockup threshold is (2 * watchdog_thresh). Setting this
> +tunable to zero will disable lockup detection altogether.
> +
> +==============================================================
> -- 
> 1.8.0.2
