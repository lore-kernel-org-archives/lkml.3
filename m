Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3E0Bqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 21:46:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41149 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab3E0Bqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 21:46:36 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51A2BAE9.40307@jp.fujitsu.com>
Date: Mon, 27 May 2013 10:46:17 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] Documentation/devices.txt: Mark /dev/oldmem obsolete
References: <51A1AC4A.60506@gmail.com> <51A1AD67.4030800@gmail.com>
In-Reply-To: <51A1AD67.4030800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/05/26 15:36), Zhang Yanfei wrote:
> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
>
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Cc: Dave Jones <davej@redhat.com>
> ---
>   Documentation/devices.txt |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> index 08f01e7..c8e4002 100644
> --- a/Documentation/devices.txt
> +++ b/Documentation/devices.txt
> @@ -100,8 +100,7 @@ Your cooperation is appreciated.
>   		 10 = /dev/aio		Asynchronous I/O notification interface
>   		 11 = /dev/kmsg		Writes to this come out as printk's, reads
>   					export the buffered printk records.
> -		 12 = /dev/oldmem	Used by crashdump kernels to access
> -					the memory of the kernel that crashed.
> +		 12 = /dev/oldmem	OBSOLETE
>
>     1 block	RAM disk
>   		  0 = /dev/ram0		First RAM disk
>

This is the new patch. Looking at other parts of devices.txt, obsolete is
sometimes used together with unused. I guess obsolete means this is old interface so
don't use it as much as possible and unused means this is not used at all now.
You remove old memory interface completely in this patch set, so is it better to add
unused, too?

-- 
Thanks.
HATAYAMA, Daisuke

