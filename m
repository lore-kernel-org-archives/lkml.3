Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab3EWOjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:39:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758967Ab3EWOjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:39:03 -0400
Date: Thu, 23 May 2013 10:35:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: hbabu@us.ibm.com, rob@landley.net,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/kdump: Remove TODO in this document
Message-ID: <20130523143555.GI2779@redhat.com>
References: <519DD397.6060301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519DD397.6060301@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 04:30:15PM +0800, Zhang Yanfei wrote:
> We have already had the relocatable kernel, so just remove
> the TODO in the kdump document.
> 
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  Documentation/kdump/kdump.txt |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
> index 9c7fd98..a8b291d 100644
> --- a/Documentation/kdump/kdump.txt
> +++ b/Documentation/kdump/kdump.txt
> @@ -461,14 +461,6 @@ format. Crash is available on Dave Anderson's site at the following URL:
>     http://people.redhat.com/~anderson/
>  
>  
> -To Do
> -=====
> -
> -1) Provide relocatable kernels for all architectures to help in maintaining
> -   multiple kernels for crash_dump, and the same kernel as the system kernel
> -   can be used to capture the dump.
> -
> -
>  Contact
>  =======
>  
> -- 
> 1.7.1
