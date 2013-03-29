Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3C2EFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 00:05:16 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:60386 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3C2EFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 00:05:14 -0400
Date: Fri, 29 Mar 2013 13:05:11 +0900
From: Simon Horman <horms@verge.net.au>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, vgoyal@redhat.com,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Documentation: Add ABI entry for crash_notes and
 crash_notes_size
Message-ID: <20130329040511.GI13429@verge.net.au>
References: <5153FC27.70001@cn.fujitsu.com>
 <5153FC6D.5020801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5153FC6D.5020801@cn.fujitsu.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 04:16:45PM +0800, Zhang Yanfei wrote:
> Add an Documentation/ABI entry for /sys/devices/system/cpu/cpu0/crash_notes
> and /sys/devices/system/cpu/cpu0/crash_notes_size.
> 
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Assuming that patch 1 of this series is accepted:

Acked-by: Simon Horman <horms@verge.net.au>

> ---
>  Documentation/ABI/testing/sysfs-devices-system-cpu |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index 9c978dc..2447698 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -173,3 +173,15 @@ Description:	Processor frequency boosting control
>  		Boosting allows the CPU and the firmware to run at a frequency
>  		beyound it's nominal limit.
>  		More details can be found in Documentation/cpu-freq/boost.txt
> +
> +
> +What:		/sys/devices/system/cpu/cpu#/crash_notes
> +		/sys/devices/system/cpu/cpu#/crash_notes_size
> +Date:		April 2013
> +Contact:	kexec@lists.infradead.org
> +Description:	address and size of the percpu note.
> +
> +		crash_notes: the physical address of the memory that holds the
> +		note of cpu#.
> +
> +		crash_notes_size: size of the note of cpu#.
> -- 
> 1.7.1
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
