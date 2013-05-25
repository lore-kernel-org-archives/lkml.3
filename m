Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab3EYXVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 19:21:22 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55081 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177Ab3EYXVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 19:21:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        davej@redhat.com
References: <51A02E50.5020507@gmail.com> <51A02F59.8000103@gmail.com>
Date: Sat, 25 May 2013 16:20:31 -0700
In-Reply-To: <51A02F59.8000103@gmail.com> (Zhang Yanfei's message of "Sat, 25
	May 2013 11:26:17 +0800")
Message-ID: <87vc668x4w.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1///AN/RyLXVUd0FhbInNEH/HqUXQVnsNk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Zhang Yanfei <zhangyanfei.yes@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/7] Documentation/devices.txt: Remove /dev/oldmem description
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Yanfei <zhangyanfei.yes@gmail.com> writes:

> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Won't we want to keep this reservation around to so that this number
doesn't get reused, and cause people confusion when
upgrading/downgrading kernels?

> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Cc: Dave Jones <davej@redhat.com>
> ---
>  Documentation/devices.txt |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> index 08f01e7..4f85739 100644
> --- a/Documentation/devices.txt
> +++ b/Documentation/devices.txt
> @@ -100,8 +100,6 @@ Your cooperation is appreciated.
>  		 10 = /dev/aio		Asynchronous I/O notification interface
>  		 11 = /dev/kmsg		Writes to this come out as printk's, reads
>  					export the buffered printk records.
> -		 12 = /dev/oldmem	Used by crashdump kernels to access
> -					the memory of the kernel that crashed.
>  
>    1 block	RAM disk
>  		  0 = /dev/ram0		First RAM disk
