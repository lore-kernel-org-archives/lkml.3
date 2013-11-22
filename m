Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3KVW73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:59:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3KVW72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:59:28 -0500
Date: Fri, 22 Nov 2013 14:59:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] mm, memory-failure: fix the typo in
 me_pagecache_dirty()
Message-Id: <20131122145927.f3745790b1332c231087fd60@linux-foundation.org>
In-Reply-To: <1383914858-14533-3-git-send-email-zwu.kernel@gmail.com>
References: <1383914858-14533-1-git-send-email-zwu.kernel@gmail.com>
	<1383914858-14533-3-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Nov 2013 20:47:38 +0800 Zhi Yong Wu <zwu.kernel@gmail.com> wrote:

> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -611,7 +611,7 @@ static int me_pagecache_clean(struct page *p, unsigned long pfn)
>  }
>  
>  /*
> - * Dirty cache page page
> + * Dirty cache page
>   * Issues: when the error hit a hole page the error is not properly
>   * propagated.
>   */

The accurate and complete description of this page is actually
"pagecache page", so...

--- a/mm/memory-failure.c~mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix
+++ a/mm/memory-failure.c
@@ -611,7 +611,7 @@ static int me_pagecache_clean(struct pag
 }
 
 /*
- * Dirty cache page
+ * Dirty pagecache page
  * Issues: when the error hit a hole page the error is not properly
  * propagated.
  */
_

