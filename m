Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967541Ab3E3FwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 01:52:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:13740 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S966267Ab3E3FwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 01:52:06 -0400
X-IronPort-AV: E=Sophos;i="4.87,768,1363104000"; 
   d="scan'208";a="7409698"
Message-ID: <51A6E85F.5000300@cn.fujitsu.com>
Date: Thu, 30 May 2013 13:49:19 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, "H. Peter Anvin" <hpa@zytor.com>,
        davej@redhat.com, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/7] Documentation/devices.txt: Remove /dev/oldmem description
References: <51A02E50.5020507@gmail.com> <51A02F59.8000103@gmail.com> <87vc668x4w.fsf@xmission.com> <51A15E2F.7010308@gmail.com> <51A2B693.7000701@jp.fujitsu.com> <51A2B68E.4060605@cn.fujitsu.com> <20130529152007.893940a04d95fa1e38e851d4@linux-foundation.org>
In-Reply-To: <20130529152007.893940a04d95fa1e38e851d4@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 13:50:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 13:50:31,
	Serialize complete at 2013/05/30 13:50:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 06:20 AM, Andrew Morton wrote:
> On Mon, 27 May 2013 09:27:42 +0800 Zhang Yanfei <zhangyanfei@cn.fujitsu.com> wrote:
> 

snip

>>
>> I've sent the v2 version and actually did what you said.
> 
> I can't find any v2 version of this patchset.
> 
> I did this:
> 
> --- a/Documentation/devices.txt~dev-oldmem-remove-the-interface-fix
> +++ a/Documentation/devices.txt
> @@ -102,6 +102,7 @@ Your cooperation is appreciated.
>  					export the buffered printk records.
>  		 12 = /dev/oldmem	Used by crashdump kernels to access
>  					the memory of the kernel that crashed.
> +					(obsolete)
>  
>    1 block	RAM disk
>  		  0 = /dev/ram0		First RAM disk
> _
> 
> 

v1 is the same with v2 except this patch. I attach it below:

-----------------------------------
>From d2f7baf2aba86069f941f32669a22dbd99082614 Mon Sep 17 00:00:00 2001
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Date: Wed, 29 May 2013 15:44:09 +0800
Subject: [PATCH] Documentation/devices.txt: Mark /dev/oldmem obsolete

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 Documentation/devices.txt |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 08f01e7..315455a 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -100,8 +100,7 @@ Your cooperation is appreciated.
 		 10 = /dev/aio		Asynchronous I/O notification interface
 		 11 = /dev/kmsg		Writes to this come out as printk's, reads
 					export the buffered printk records.
-		 12 = /dev/oldmem	Used by crashdump kernels to access
-					the memory of the kernel that crashed.
+		 12 = /dev/oldmem	OBSOLETE - replaced by /proc/vmcore
 
   1 block	RAM disk
 		  0 = /dev/ram0		First RAM disk
-- 
1.7.1
