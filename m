Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab3E1WaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 18:30:01 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58847 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444Ab3E1WaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 18:30:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>
References: <51A1AC4A.60506@gmail.com> <51A1AD67.4030800@gmail.com>
Date: Tue, 28 May 2013 15:29:36 -0700
In-Reply-To: <51A1AD67.4030800@gmail.com> (Zhang Yanfei's message of "Sun, 26
	May 2013 14:36:23 +0800")
Message-ID: <87wqqi7n73.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18Z+yocb0TJEtnS4fcKMo2ZEzkij/6CLdY=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Zhang Yanfei <zhangyanfei.yes@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2 2/7] Documentation/devices.txt: Mark /dev/oldmem obsolete
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Yanfei <zhangyanfei.yes@gmail.com> writes:

> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Cc: Dave Jones <davej@redhat.com>
> ---
>  Documentation/devices.txt |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> index 08f01e7..c8e4002 100644
> --- a/Documentation/devices.txt
> +++ b/Documentation/devices.txt
> @@ -100,8 +100,7 @@ Your cooperation is appreciated.
>  		 10 = /dev/aio		Asynchronous I/O notification interface
>  		 11 = /dev/kmsg		Writes to this come out as printk's, reads
>  					export the buffered printk records.
> -		 12 = /dev/oldmem	Used by crashdump kernels to access
> -					the memory of the kernel that crashed.
> +		 12 = /dev/oldmem	OBSOLETE

Let me suggest the slightly better.

 +		12 = /dev/oldmem	OBSOLETE - replaced by /proc/vmcore

Pointing to people to /proc/vmcore should help anyone who is trying to
understand what is going on.

>    1 block	RAM disk
>  		  0 = /dev/ram0		First RAM disk
